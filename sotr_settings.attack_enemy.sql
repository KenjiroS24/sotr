/* Пример вызова
select jsonb_array_elements(sotr_game.attack_enemy(20,1));
Либо
select key as Actions, value->>0 as cnt 
	from jsonb_each
(sotr_game.attack_enemy(39,1))
--order by key
;
*/


CREATE OR REPLACE FUNCTION sotr_game.attack_enemy(_enemy_id integer, _hero_type_hit integer)
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
declare
p_total_result jsonb;
p_res jsonb;
p_request_get_hit jsonb;
p_res_drop jsonb;

p_glob_enemy_id int;
p_weakness_enemy varchar;
p_loss_weakness float;

p_info_about_effect jsonb;
p_hero_type_hit varchar;
p_enemy_type_hit varchar;
p_hit_point_hero int;
p_hit_point_enemy int;

p_h_lvl int;
p_hero_max_hp int;
p_enemy_max_hp int;
p_heal_hero int;

p_heal_points_enemy int;
p_heal_points_hero int;
p_show_heal_points_enemy text;
p_show_heal_points_hero text;

begin

	--Получение эффекта слабости врага и его глобальный ID (из листа врагов для передачи в get_hit)
	select el.e_id, el.e_weakness->>'weakness', (el.e_weakness->>'num')::float, el.e_heal_points into p_glob_enemy_id, p_weakness_enemy, p_loss_weakness, p_enemy_max_hp
		from sotr_game.g_enemy as ge
		join sotr_settings.enemy_list as el on el.e_name = ge.e_name
	where ge.e_id = _enemy_id;
	if not found then
		return jsonb_build_object('ERROR','Врага с таким ID не найдено');
	end if;

	--Получение эффекта оружия героя
	select gh.h_lvl, jsonb_build_object('weapon_effect', i.effect) || jsonb_build_object('decoration_effect', i2.effect) into p_h_lvl, p_info_about_effect
		from sotr_game.g_hero as gh
		left join sotr_settings.items as i on i.i_id = gh.h_weapon
		left join sotr_settings.items as i2 on i2.i_id = gh.h_decoration
	where gh.h_id = 1;

	--назначение пределов ХП для героя
	select heal_points into p_hero_max_hp
		from sotr_settings.hero_state_lvl as hsl where lvl_id = p_h_lvl;

	--Вызов функции, которая вернет тип атаки врага + очки урона героя и врага
	select sotr_settings.get_hit(p_glob_enemy_id, _hero_type_hit) into p_request_get_hit;
	--Распределение по переменным итога вызова функции выше
	select p_request_get_hit->>'hero_type_hit' into p_hero_type_hit;
	select p_request_get_hit->>'enemy_type_hit' into p_enemy_type_hit;
	select (p_request_get_hit->>'hit_point_hero')::int into p_hit_point_hero;
	select (p_request_get_hit->>'hit_point_enemy')::int into p_hit_point_enemy;

	--Проверка на наличие слабости у врага и наличию эффекта у оружия глав.героя
	if (p_info_about_effect->'weapon_effect'->>'effect' = p_weakness_enemy) or (p_info_about_effect->'decoration_effect'->>'effect' = p_weakness_enemy) then
		p_hit_point_hero = p_hit_point_hero * p_loss_weakness;
	
		p_total_result = jsonb_build_object('Сработал эффект [Усиление]:', p_loss_weakness);
	end if;

	--Нанесение урона врагу
	update sotr_game.g_enemy as ge
		set e_heal_points = e_heal_points - p_hit_point_hero
	where ge.e_id = _enemy_id
	returning e_heal_points into p_heal_points_enemy;

	p_hero_type_hit	= 'Вы применили прием: [' || p_hero_type_hit || ']. Урон: ';
	p_res = jsonb_build_object(p_hero_type_hit, p_hit_point_hero);
	
	--вызов функции дропа-убийства, возврат из неё предмета и инфы кого убили, получение exp, повысился ли уровень?
	if p_heal_points_enemy <= 0 then
		select sotr_settings.kill_enemy(_enemy_id) into p_res_drop;
--		p_heal_points_enemy = 0;
		p_res = p_res || p_res_drop;
	else 
		p_show_heal_points_enemy = p_heal_points_enemy::text || '/' || p_enemy_max_hp::text;
		p_res = p_res || jsonb_build_object('Остаток жизни врага: ', p_show_heal_points_enemy);	
	end if;

	--Проверка на эффект Лечение
	if p_info_about_effect->'decoration_effect'->>'effect' = 'Лечение' then
		p_heal_hero = (select p_hit_point_hero * (p_info_about_effect->'decoration_effect'->>'num')::float / 100);
	
		update sotr_game.g_hero as gh
			set h_heal_points = case when (h_heal_points + p_heal_hero) > p_hero_max_hp then p_hero_max_hp else h_heal_points + p_heal_hero end
		where gh.h_id = 1;
	
		p_total_result = coalesce(p_total_result, jsonb_build_object()) || jsonb_build_object('Сработал эффект [Лечение]. Восстановлено HP: ', p_heal_hero);
	end if;

	--Нанесение урона герою
	update sotr_game.g_hero as gh
		set h_heal_points = h_heal_points - p_hit_point_enemy
	where gh.h_id = 1
	returning h_heal_points into p_heal_points_hero;

	p_enemy_type_hit = 'Враг применил прием: [' || p_enemy_type_hit || ']. Урон: ';
	p_res = p_res || jsonb_build_object(p_enemy_type_hit, p_hit_point_enemy);

	--Смерть героя
	if p_heal_points_hero <= 0 then
--		вызов функции убийства глав.героя, возврат к сейвпоинту. Временно прописал обнуление результатов
		truncate sotr_game.g_enemy restart identity;
		truncate sotr_game.g_inventory restart identity;
		truncate sotr_settings.game_statistic restart identity;
	
		insert into sotr_game.g_inventory (in_items_id, in_cnt) values (2, 1);
		update sotr_game.g_hero
			set h_lvl = 1, h_exp = 0, h_heal_points = 200, h_attack = 15, h_agility = 0.01, h_weapon = 2, h_decoration = null
		where h_id = 1;
		insert into sotr_settings.game_statistic (cnt_kill_enemy, cnt_received_exp, game_completed) values (0, 0, false);
		perform sotr_game.start_game();
		return jsonb_build_object('Вам нанесли смертельное ранение.','[Игра вернулась к контрольной точке]');
	else	
		p_show_heal_points_hero = p_heal_points_hero::text || '/' || p_hero_max_hp::text;
		p_res = p_res || jsonb_build_object('У вас осталось HP: ', p_show_heal_points_hero);
	end if;

	p_total_result = coalesce(p_total_result, jsonb_build_object()) || p_res;

	return p_total_result;

end;
$function$
;

COMMENT ON FUNCTION sotr_game.attack_enemy(int4, int4) IS 'Функцию по нанесению урона врагу. В _enemy_id берется враг под номером из таблицы g_enemy.
В _hero_type_hit принимаются 4 аргумента:
1 = Быстрый удар
2 = Уклонение
3 = Парирование
4 = Удар Призрака';
