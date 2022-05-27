CREATE OR REPLACE FUNCTION sotr_game.lvl_up(_lvl_id integer)
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
declare 
p_exp				int4;			--Необходимый опыт для прохождения уровня
p_h_exp				int4;			--Текущий опыт героя	
p_h_weapon			int4;			--Оружие героя
p_h_decoration			int4;			--Украшение героя
p_num_w				numeric;		--Множитель оружия
p_type_w			text;			--Тип оружия
p_effect_w			text;			--Эффект оружия
p_num_d				numeric;		--Множитель украшения
p_effect_d			text;			--Эффект украшения


begin 
		
	--Записываем необходимый опыт для прохождения уровня
	select "exp" into p_exp
		from sotr_settings.hero_state_lvl 
	where lvl_id = _lvl_id;

	--Записываем данные героя в текущей сессии
	select gh.h_exp, gh.h_weapon, (i.effect->> 'num')::numeric  as num_w, (i.effect ->>'type') as "type_w",  (i.effect ->>'effect') as effect_w into p_h_exp, p_h_weapon, p_num_w, p_type_w, p_effect_w
		from sotr_game.g_hero gh 
		join sotr_settings.items i on i.i_id = gh.h_weapon
	where gh.h_id = 1;

	select gh.h_decoration, (i.effect->> 'num')::numeric  as num_d, (i.effect ->>'type') as "type_d",  (i.effect ->>'effect') as effect_d into p_h_decoration, p_num_d, p_effect_d
		from sotr_game.g_hero gh 
		join sotr_settings.items i on i.i_id = gh.h_decoration
	where gh.h_id = 1;

	--Если текущий опыт больше или равен необходимому минимуму, тогда обновляем уровень в g_hero 
	if p_h_exp >= p_exp then 
		update sotr_game.g_hero 
			set h_lvl = _lvl_id
		where h_id = 1;

		--Если тип инвентаря weapon , тогда мы обновляем в таблице g_hero значения h_weapon, h_attack
		if p_type_w = 'weapon' then
			
			with upd as (
				select lvl.attack as att
					from sotr_game.g_hero as h
					join sotr_settings.hero_state_lvl as lvl on lvl.lvl_id = h.h_lvl
				where h.h_id = 1
			)
			update sotr_game.g_hero
				set h_weapon = p_h_weapon,
					h_attack = upd.att * p_num_w
				from upd
			where h_id = 1;

		end if; 
	
			--Если тип инвентаря decoration с эффектом Уклонение, в таблице g_hero обновляем значения h_decoration и h_agility
			if p_h_decoration is not null and p_effect_d = 'Уклонение' then
				with upd as (
					select lvl.agility  as ag
						from sotr_game.g_hero as h
						join sotr_settings.hero_state_lvl as lvl on lvl.lvl_id = h.h_lvl
					where h.h_id = 1
				)
				update sotr_game.g_hero
					set h_decoration = p_h_decoration,
						h_agility = upd.ag  + (p_num_d/100)
					from upd
				where h_id = 1;
			--Если тип инвентаря decoration без эффекта Уклонение или null, в таблице g_hero обновляем значения h_decoration и исходный h_agility в соответствии с уровнем героя
			else 
				with upd as (
					select lvl.agility  as ag
						from sotr_game.g_hero as h
						join sotr_settings.hero_state_lvl as lvl on lvl.lvl_id = h.h_lvl
				where h.h_id = 1
				)
				update sotr_game.g_hero
					set h_decoration = p_h_decoration,
						h_agility = upd.ag
					from upd
				where h_id = 1;
			end if;
	else 
		return '"Недостаточно опыта для прохождения на следующий уровень"'::jsonb;
	end if;

	return jsonb_build_object('lvl', _lvl_id);
	
end;
$function$
;
