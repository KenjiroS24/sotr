CREATE OR REPLACE FUNCTION sotr_settings.kill_enemy(_enemy_id integer)
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
declare
p_res_drop jsonb;
p_e_name varchar; 
p_e_exp int;
p_e_drop_items int;
p_e_chance_drop float;
p_get_drop_items varchar;
p_hero_lvl_now int;
p_hero_lvl_must int;

begin
	
	delete from sotr_game.g_enemy as ge
		where ge.e_id = _enemy_id
	returning e_name, e_exp, e_drop_items, e_chance_drop into p_e_name, p_e_exp, p_e_drop_items, p_e_chance_drop;

	--Проверка на дроп
	if (select sotr_settings.get_random(p_e_chance_drop)) then
		insert into sotr_game.g_inventory (in_items_id, in_cnt) 
			values 
		(p_e_drop_items, 1)
		on conflict (in_items_id) do update
			set in_cnt = excluded.in_cnt + 1;
		
		p_get_drop_items = (select i_title from sotr_settings.items where i_id = p_e_drop_items);
		p_res_drop = jsonb_build_object('Выбитое оружие: ', p_get_drop_items);
	else
		p_res_drop = jsonb_build_object();
	end if;

	--Добавление EXP
	update sotr_game.g_hero as gh
		set h_exp = h_exp + p_e_exp
	where h_id = 1
	returning h_lvl, h_exp into p_hero_lvl_now, p_e_exp;

	--Обновление статистики
	update sotr_settings.game_statistic 
		set cnt_kill_enemy = cnt_kill_enemy + 1,
			cnt_received_exp = cnt_received_exp + p_e_exp
	where not game_completed;

	--Переменная для проверки соответствия уровня и EXP
	select hsl.lvl_id into p_hero_lvl_must
		from sotr_settings.hero_state_lvl as hsl 
	where hsl.exp <= p_e_exp
	order by hsl.lvl_id desc limit 1;

	--Проверка и повышение ЛВЛа
	if p_hero_lvl_now != p_hero_lvl_must then
		--повысить лвл
		--Вызов функции с передачей лвл на который надо поднять перса p_hero_lvl_must
		p_res_drop = coalesce(p_res_drop, jsonb_build_object()) || jsonb_build_object('Вы перешли на новый уровень: ', p_hero_lvl_must);
	end if;


	p_res_drop = coalesce(p_res_drop, jsonb_build_object()) || jsonb_build_object('Вы убили врага: ', p_e_name);
	
	return p_res_drop;

end;
$function$;
