CREATE OR REPLACE FUNCTION sotr_settings.create_enemy(_enemy_id integer, _cnt integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
begin 

	with en as (
		select generate_series(1,_cnt), e_name, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness 
			from sotr_settings.enemy_list el
		where e_id = _enemy_id
	)
	insert into sotr_game.g_enemy (e_name, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness)
		select e_name, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness 
			from en;

end;
$function$
;

COMMENT ON FUNCTION sotr_settings.create_enemy(int4, int4) IS 'Создание врагов. _enemy_id - Ид врага, _cnt - необходимое кол-во.';
