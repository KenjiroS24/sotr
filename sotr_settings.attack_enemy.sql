CREATE OR REPLACE FUNCTION sotr_settings.attack_enemy(_enemy_id integer, _hero_type_hit integer)
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
declare
p_total_result jsonb;
p_res jsonb;
p_glob_enemy_id int;
p_weakness_enemy varchar;
p_loss_weakness float;

p_info_about_effect jsonb;
p_hero_type_hit varchar;
p_enemy_type_hit varchar;
p_hit_point_hero int;
p_hit_point_enemy int;

p_heal_hero int;


begin

	--Получение эффекта оружия героя
	select jsonb_build_object('weapon_effect', i.effect) || jsonb_build_object('decoration_effect', i2.effect) into p_info_about_effect
		from sotr_game.g_hero as gh
		left join sotr_settings.items as i on i.i_id = gh.h_weapon
		left join sotr_settings.items as i2 on i2.i_id = gh.h_decoration
	where gh.h_id = 1;

	--Получение эффекта слабости врага и его глобальный ID (из листа врагов для передачи в get_hit)
	select el.e_id, el.e_weakness->>'weakness', (el.e_weakness->>'num')::float into p_glob_enemy_id, p_weakness_enemy, p_loss_weakness
		from sotr_game.g_enemy as ge
		join sotr_settings.enemy_list as el on el.e_name = ge.e_name
	where ge.e_id = _enemy_id;

	--Вызов функции, которая вернет тип атаки врага + очки урона героя и врага
	select sotr_settings.get_hit(p_glob_enemy_id,1) into p_res;
	--Распределение по переменным итога вызова функции выше
	select p_res->>'hero_type_hit' into p_hero_type_hit;
	select p_res->>'enemy_type_hit' into p_enemy_type_hit;
	select (p_res->>'hit_point_hero')::int into p_hit_point_hero;
	select (p_res->>'hit_point_enemy')::int into p_hit_point_enemy;

	--Проверка на наличие слабости у врага и наличию эффекта у оружия глав.героя
	if (p_info_about_effect->'weapon_effect'->>'effect' = p_weakness_enemy) or (p_info_about_effect->'decoration_effect'->>'effect' = p_weakness_enemy) then
		p_hit_point_hero = p_hit_point_hero * p_loss_weakness;
--		return jsonb_build_object('Уязвимость найдена. Урон: ', p_hit_point_hero);
	end if;

	--Нанесение урона врагу
	update sotr_game.g_enemy as ge
		set e_heal_points = e_heal_points - p_hit_point_hero
	where ge.e_id = _enemy_id;

	--Проверка на эффект Лечение
	if p_info_about_effect->'decoration_effect'->>'effect' = 'Лечение' then
		--урон, нанесенный врагу 10 процентов забрать в ХП героя
--		return '"Лечить героя"'::jsonb;
		p_heal_hero = (select p_hit_point_hero * (p_info_about_effect->'decoration_effect'->>'num')::float / 100);
	
		update sotr_game.g_hero as gh
			set h_heal_points = h_heal_points + p_heal_hero
		where gh.h_id = 1;
	
		select jsonb_build_object('Сработал эффект [Лечение]. Восстановлено: ', p_heal_hero) into p_total_result; 
	end if;

	--Нанесение урона герою
	update sotr_game.g_hero as gh
		set h_heal_points = h_heal_points - p_hit_point_enemy
	where gh.h_id = 1;

return '"End f"'::jsonb;

end;
$function$;
