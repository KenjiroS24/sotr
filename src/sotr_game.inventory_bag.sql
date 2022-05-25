CREATE OR REPLACE FUNCTION sotr_game.inventory_bag (_inv bigint default 0)
 RETURNS setof text
 LANGUAGE plpgsql
AS $function$
declare
p_inv_name text;

begin

	if 	_inv = 0 then
		return query
		select gi.in_id || ': ' || i.i_title as inventory
			from sotr_game.g_inventory gi
			join sotr_settings.items as i on gi.in_items_id = i.i_id;
	else
		with s1 as (
			select gi.in_id , i.i_id, i.i_title, gi.in_cnt
				from sotr_game.g_inventory gi
				join sotr_settings.items as i on gi.in_items_id = i.i_id
		)
		, s2 as (
			select i_id, i_title
				from s1
			where in_id = _inv
		)
		update sotr_game.g_hero
			set h_weapon = s2.i_id
			from s2
		where h_id = 1
		returning i_title into p_inv_name;

		if not found then
			return query select 'С таким id оружия не существует';
		end if;

	end if;
	
	if _inv > 0 then
		return query select ('Оружие изменено на ' || p_inv_name);
	end if;

end;
$function$;
