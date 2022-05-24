--Осталось доработать: сценарии смерти и дропа
--Пример вызова
--select jsonb_array_elements(sotr_game.attack_enemy(20,1));

CREATE OR REPLACE FUNCTION sotr_game.attack_enemy(_enemy_id integer, _hero_type_hit integer)
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

p_h_lvl int;
p_hero_max_hp int;
p_heal_hero int;


begin

	--Получение эффекта оружия героя
	select gh.h_lvl, jsonb_build_object('weapon_effect', i.effect) || jsonb_build_object('decoration_effect', i2.effect) into p_h_lvl, p_info_about_effect
		from sotr_game.g_hero as gh
		left join sotr_settings.items as i on i.i_id = gh.h_weapon
		left join sotr_settings.items as i2 on i2.i_id = gh.h_decoration
	where gh.h_id = 1;

	--Получение эффекта слабости врага и его глобальный ID (из листа врагов для передачи в get_hit)
	select el.e_id, el.e_weakness->>'weakness', (el.e_weakness->>'num')::float into p_glob_enemy_id, p_weakness_enemy, p_loss_weakness
		from sotr_game.g_enemy as ge
		join sotr_settings.enemy_list as el on el.e_name = ge.e_name
	where ge.e_id = _enemy_id;

	--назначение пределов ХП для героя
	select heal_points into p_hero_max_hp
		from sotr_settings.hero_state_lvl as hsl where lvl_id = p_h_lvl;

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
	
		p_total_result = '"Сработал эффект [Усиление]"'::jsonb;
	end if;

	--Нанесение урона врагу
	update sotr_game.g_enemy as ge
		set e_heal_points = e_heal_points - p_hit_point_hero
	where ge.e_id = _enemy_id;

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
	where gh.h_id = 1;

	p_total_result = p_total_result || p_res;

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
