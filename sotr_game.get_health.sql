CREATE OR REPLACE FUNCTION sotr_game.get_health()
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare 
p_in_cnt	int4;
p_effect	int4;
p_max_hp	int4;
p_now_hp	int4;

begin
	
	--Проверка наличия инвентаря с heal
	select gi.in_cnt into p_in_cnt 
		from sotr_game.g_inventory as gi 
		join sotr_settings.items as i on i.i_id = gi.in_items_id 
	where in_items_id = 1;
	if not found then 
		return  'У Вас нет Трав в инвентаре';
	end if;

	--Проверка количества Травы в запасе
	if p_in_cnt <= 0 then 
		return 'У Вас закончилась Трава';
	else 
		select (i.effect ->> 'num')::int4 into p_effect
			from sotr_settings.items i
		where i_id = 1;
	end if;
	
	--Проверка предела ХП
	select hsl.heal_points as hhp, gh.h_heal_points as ghhp into p_max_hp, p_now_hp
		from sotr_settings.hero_state_lvl hsl 
		join sotr_game.g_hero gh on hsl.lvl_id = gh.h_lvl;
	
	if p_now_hp = p_max_hp then 
		return 'Персонаж не нуждается в лечении.';
	
	elseif p_now_hp + p_effect >= p_max_hp then 
		update sotr_game.g_hero 
			set h_heal_points = p_max_hp
		where h_id = 1;

		update sotr_game.g_inventory 
			set in_cnt = in_cnt - 1
		where in_items_id = 1
		returning in_cnt into p_in_cnt;
	
		if p_in_cnt <= 0 then 
			delete from sotr_game.g_inventory
			where in_items_id = 1;
		end if;
	
		return 'ХП повысилось до максимального значения. Ваше ХП составляет ' || p_max_hp;
	
	else update sotr_game.g_hero 
			set h_heal_points = h_heal_points + p_effect
		where h_id = 1;
	
		update sotr_game.g_inventory 
			set in_cnt = in_cnt - 1
		where in_items_id = 1
		returning in_cnt into p_in_cnt;
		
		if p_in_cnt <= 0 then 
			delete from sotr_game.g_inventory
			where in_items_id = 1;
		end if;
	
	end if;

	return 'Ваше ХП повысилось на ' || p_effect;

end;
$function$
;
