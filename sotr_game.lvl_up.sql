CREATE OR REPLACE FUNCTION sotr_game.lvl_up(_lvl_id integer)
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
declare 
p_state_lvl record;
p_current_exp int;
p_current_lvl int;
p_current_weapon jsonb;
p_current_decoration jsonb;

begin 
		
	--Записываем данные нового уровня
	select hsl.* into p_state_lvl
		from sotr_settings.hero_state_lvl as hsl
	where lvl_id = _lvl_id;

	--Записываем данные героя в текущей сессии
	select gh.h_exp, gh.h_lvl, iwep.effect, idec.effect into p_current_exp, p_current_lvl, p_current_weapon, p_current_decoration
		from sotr_game.g_hero as gh
		join sotr_settings.items as iwep on iwep.i_id = gh.h_weapon
		left join sotr_settings.items as idec on idec.i_id = gh.h_decoration
	where gh.h_id = 1;

	--Если текущий опыт больше или равен необходимому минимуму, тогда обновляем уровень в g_hero 
	if p_current_exp >= p_state_lvl."exp" then 
		update sotr_game.g_hero 
			set h_lvl = _lvl_id,
--				h_heal_points = p_state_lvl.heal_points, --Нужно подумать над частичным восстановление после повышения ХП
				h_attack = p_state_lvl.attack * (p_current_weapon->>'num')::int,
				h_agility = case 
								when p_current_decoration->>'effect' = 'Уклонение' then p_state_lvl.agility + ((p_current_decoration->>'num')::float/100.0)
								else p_state_lvl.agility end
		where h_id = 1;
	
		return jsonb_build_object('Ваш уровень повысился до ', _lvl_id);
	end if;
	return jsonb_build_object('Ошибка: ', 'Недостаточно EXP');

end;
$function$
;
