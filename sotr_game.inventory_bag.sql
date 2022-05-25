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

	if 	_inv = 0 then
		return query
		select gi.in_id || ': ' || i.i_title as inventory
			from sotr_game.g_inventory gi
			join sotr_settings.items as i on gi.in_items_id = i.i_id;
	end if;

	select gi.in_items_id,  i.i_title , (i.effect->> 'num')::numeric  as num, (i.effect ->>'type') as "type",  (i.effect ->>'effect') as effect into p_items_id, p_inv_name, p_num_inv, p_type_inv, p_effect
		from sotr_game.g_inventory gi
		join sotr_settings.items i on i.i_id = gi.in_items_id
	where gi.in_id = _inv;

	if p_type_inv = 'heal' then
		return query select 'Вы не можете использовать Траву в качестве оружия';

	elseif p_type_inv = 'weapon' then
		update sotr_game.g_hero
			set h_weapon = p_items_id,
				h_attack = h_attack * p_num_inv
		where h_id = 1;
		return query select ('Оружие изменено на ' || p_inv_name);

	elseif p_type_inv = 'decoration' and p_effect = 'Уклонение' then
		update sotr_game.g_hero
			set h_decoration = p_items_id,
				h_agility = h_agility  + p_num_inv
		where h_id = 1;
		return query select ('Украшение изменено на ' || p_inv_name || '. ' || 'Ваша ловкость увеличилась.');

	elseif p_type_inv = 'decoration' and p_effect != 'Уклонение' then
		update sotr_game.g_hero
			set h_decoration = p_items_id
		where h_id = 1;
		return query select ('Украшение изменено на ' || p_inv_name || '. ');

	end if;

		if not found then
			return query select 'С таким id оружия не существует';
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
