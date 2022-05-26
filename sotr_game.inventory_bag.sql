CREATE OR REPLACE FUNCTION sotr_game.inventory_bag (_inv bigint default 0)
 RETURNS setof text
 LANGUAGE plpgsql
AS $function$
declare
p_inv_name	text;
p_items_id	int4;
p_num_inv	numeric;
p_type_inv	text;
p_effect	text;

begin
	--Выводим список инвентаря, если _inv = 0 
	if _inv = 0 then
		return query 
		select gi.in_id || ': ' || i.i_title as inventory
			from sotr_game.g_inventory gi
			join sotr_settings.items as i on gi.in_items_id = i.i_id;
	else 
	--Записываем значения in_items_id, i_title, num, type, effect для последующих выражений и проверяем корректность id
		select gi.in_items_id,  i.i_title , (i.effect->> 'num')::numeric  as num, (i.effect ->>'type') as "type",  (i.effect ->>'effect') as effect into p_items_id, p_inv_name, p_num_inv, p_type_inv, p_effect
			from sotr_game.g_inventory gi
			join sotr_settings.items i on i.i_id = gi.in_items_id
		where gi.in_id = _inv;
			if not found then
				RAISE EXCEPTION 'С id % оружия не существует.', $1;
			end if;
	end if;

	--Если тип инвентаря heal, то функция обрывается
	if p_type_inv = 'heal' then
		return query select 'Вы не можете использовать Траву в качестве оружия';

	--Если тип инвентаря weapon , тогда мы обновляем в таблице g_hero значения h_weapon, h_attack
	elseif p_type_inv = 'weapon' then

		with upd as (
				select lvl.attack as att
					from sotr_game.g_hero as h
				join sotr_settings.hero_state_lvl as lvl on lvl.lvl_id = h.h_lvl
				where h.h_id = 1
		)
		update sotr_game.g_hero
			set h_weapon = p_items_id,
				h_attack = upd.att * p_num_inv
			from upd
		where h_id = 1;
		return query select ('Оружие изменено на ' || p_inv_name);

	--Если тип инвентаря decoration с эффектом Уклонение, в таблице g_hero обновляем значения h_decoration и h_agility
	elseif p_type_inv = 'decoration' and p_effect = 'Уклонение' then

		with upd as (
				select lvl.agility  as ag
					from sotr_game.g_hero as h
				join sotr_settings.hero_state_lvl as lvl on lvl.lvl_id = h.h_lvl
				where h.h_id = 1
		)
		update sotr_game.g_hero
			set h_decoration = p_items_id,
				h_agility = upd.ag  + (p_num_inv/100)
			from upd
		where h_id = 1;
		return query select ('Украшение изменено на ' || p_inv_name || '. ' || 'Ваша ловкость увеличилась.');

	--Если тип инвентаря decoration без эффекта Уклонение, в таблице g_hero обновляем значения h_decoration и исходный h_agility в соответствии с уровнем героя
	elseif p_type_inv = 'decoration' and p_effect != 'Уклонение' then

		with upd as (
				select lvl.agility  as ag
					from sotr_game.g_hero as h
				join sotr_settings.hero_state_lvl as lvl on lvl.lvl_id = h.h_lvl
				where h.h_id = 1
		)
		update sotr_game.g_hero
			set h_decoration = p_items_id,
				h_agility = upd.ag
			from upd
		where h_id = 1;
		return query select ('Украшение изменено на ' || p_inv_name || '. ');

	end if;

end;
$function$;





/*insert into sotr_game.g_inventory (in_items_id, in_cnt)
values 
(1, 1),
(4, 1),
(6, 1),
(8, 1);
select sotr_game.inventory_bag ();*/
