--Не очень хороший скрипт по генерации врагов
--Нужно додумать

create or replace function sotr_game.start_new_game(_to_continue bool default true)
returns text
language plpgsql
as $function$
begin
	--Если на вход пришло false - сбрасываем все настройки героя, обнуляем лвл и инвентарь

--	if _to_continue then
--	else
		--Создание состояния главного героя
		create table sotr_game.g_hero as
			select h_name, h_lvl, h_exp, h_heal_points, h_attack, h_agility, h_weapon, h_decoration
				from sotr_settings.hero_condition;
		--Создание списка врагов
		create table sotr_game.g_enemy_list as
		with list_enemy as (
			select generate_series(1,3), e_id, e_name, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness
				from sotr_settings.enemy_list as el
			where e_id = 1
			union all
			select generate_series(1,3), e_id, e_name, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness
				from sotr_settings.enemy_list as el
			where e_id = 2
			union all
			select generate_series(1,2), e_id, e_name, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness
				from sotr_settings.enemy_list as el
			where e_id = 4
			union all
			select generate_series(1,1), e_id, e_name, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness
				from sotr_settings.enemy_list as el
			where e_id = 11
			union all
			select generate_series(1,2), e_id, e_name, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness
				from sotr_settings.enemy_list as el
			where e_id = 3
			union all
			select generate_series(1,3), e_id, e_name, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness
				from sotr_settings.enemy_list as el
			where e_id = 6
			union all
			select generate_series(1,1), e_id, e_name, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness
				from sotr_settings.enemy_list as el
			where e_id = 7
			union all
			select generate_series(1,1), e_id, e_name, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness
				from sotr_settings.enemy_list as el
			where e_id = 12
			union all
			select generate_series(1,3), e_id, e_name, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness
				from sotr_settings.enemy_list as el
			where e_id = 10
			union all
			select generate_series(1,2), e_id, e_name, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness
				from sotr_settings.enemy_list as el
			where e_id = 9
			union all
			select generate_series(1,1), e_id, e_name, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness
				from sotr_settings.enemy_list as el
			where e_id = 8
			union all
			select generate_series(1,1), e_id, e_name, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness
				from sotr_settings.enemy_list as el
			where e_id = 13
		)
		select row_number() over() as e_id, e_name, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness
			from list_enemy;
		--Если в статистике указано: "Пройдено 1 раз" то нужно добавить скрытого босса
		/*if else условие */
--	end if;

	return 'Путешествие в Мир Сна начато.';

end;
$function$;
