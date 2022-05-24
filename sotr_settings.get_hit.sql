CREATE OR REPLACE FUNCTION sotr_settings.get_hit(_enemy_id integer, _hero_type_hit integer)
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
declare
p_enemy_type_hit varchar; --тип атаки врага
p_hero_type_hit varchar; --тип атаки героя

p_hero_max_hp int; --предел ХП героя
p_enemy_max_hp int; --предел ХП врага

p_h_lvl int;
p_hero_attack_point int; --Назначение очков атаки героя
p_enemy_attack_point int; --Назначение очков атаки врага

begin 
	--назначение уровня героя, его урон
		select h_lvl, h_attack into p_h_lvl, p_hero_attack_point 
	from sotr_game.g_hero as gh;
	
	--назначение пределов ХП для героя
	select heal_points into p_hero_max_hp 
		from sotr_settings.hero_state_lvl as hsl where lvl_id = p_h_lvl;
	
	--назначение пределов ХП для врага
	select e_heal_points, e_attack into p_enemy_max_hp, p_enemy_attack_point
		from sotr_settings.enemy_list as el where e_id = _enemy_id;

	
	--Рандом атаки врага
	if (select sotr_settings.get_random(h_agility) from sotr_game.g_hero as gh) then
		select 'Промах' into p_enemy_type_hit;
	elsif (select sotr_settings.get_random(0.05)) then
		select 'Критический удар' into p_enemy_type_hit;
	elsif (select sotr_settings.get_random(0.15)) then
		select 'Безвольный удар' into p_enemy_type_hit;
	else
		select 'Быстрый удар' into p_enemy_type_hit;
	end if; 
--	return to_jsonb(p_enemy_type_hit);

	--Назначение атаки героя
	if _hero_type_hit = 1 then
		select 'Быстрый удар' into p_hero_type_hit;
	elsif _hero_type_hit = 2 then
		select 'Уклонение' into p_hero_type_hit;
	elsif _hero_type_hit = 3 then
		select 'Парирование' into p_hero_type_hit;
	elsif _hero_type_hit = 4 then
		select 'Удар Призрака' into p_hero_type_hit;
	end if; 

--Сценарий действий
if p_enemy_type_hit = 'Промах' and p_hero_type_hit = 'Быстрый удар' then
	--Только герой наносит удар, удар врага обнуляется
	p_enemy_attack_point = 0;
	return jsonb_build_object('hero_type_hit', p_hero_type_hit, 'enemy_type_hit', p_enemy_type_hit, 'hit_point_hero', p_hero_attack_point, 'hit_point_enemy', p_enemy_attack_point);
elsif p_enemy_type_hit = 'Промах' and p_hero_type_hit = 'Уклонение' then
	--Атаки обнуляются
	p_enemy_attack_point = 0;
	p_hero_attack_point = 0;
	return jsonb_build_object('hero_type_hit', p_hero_type_hit, 'enemy_type_hit', p_enemy_type_hit, 'hit_point_hero', p_hero_attack_point, 'hit_point_enemy', p_enemy_attack_point);
elsif p_enemy_type_hit = 'Промах' and p_hero_type_hit = 'Парирование' then
	--Атаки обнуляются
	p_enemy_attack_point = 0;
	p_hero_attack_point = 0;
	return jsonb_build_object('hero_type_hit', p_hero_type_hit, 'enemy_type_hit', p_enemy_type_hit, 'hit_point_hero', p_hero_attack_point, 'hit_point_enemy', p_enemy_attack_point);
elsif p_enemy_type_hit = 'Промах' and p_hero_type_hit = 'Удар Призрака' then
	--Враг наносит 50 процентов урона, атака героя обнуляется
	p_enemy_attack_point = (select p_hero_max_hp * 50 / 100);
	p_hero_attack_point = 0;
	return jsonb_build_object('hero_type_hit', p_hero_type_hit, 'enemy_type_hit', p_enemy_type_hit, 'hit_point_hero', p_hero_attack_point, 'hit_point_enemy', p_enemy_attack_point);
elsif p_enemy_type_hit = 'Критический удар' and p_hero_type_hit = 'Быстрый удар' then
	--Враг наносит критический удар
	p_enemy_attack_point = p_enemy_attack_point * 3;
	return jsonb_build_object('hero_type_hit', p_hero_type_hit, 'enemy_type_hit', p_enemy_type_hit, 'hit_point_hero', p_hero_attack_point, 'hit_point_enemy', p_enemy_attack_point);
elsif p_enemy_type_hit = 'Критический удар' and p_hero_type_hit = 'Уклонение' then
	--Герой не получает урона и производит контратаку (-50% хп)
	p_enemy_attack_point = 0;
	p_hero_attack_point = (select p_enemy_max_hp * 50 / 100);
	return jsonb_build_object('hero_type_hit', p_hero_type_hit, 'enemy_type_hit', p_enemy_type_hit, 'hit_point_hero', p_hero_attack_point, 'hit_point_enemy', p_enemy_attack_point);
elsif p_enemy_type_hit = 'Критический удар' and p_hero_type_hit = 'Парирование' then
	--Герой получает урон двойной урон
	p_enemy_attack_point = p_enemy_attack_point * 2;
	return jsonb_build_object('hero_type_hit', p_hero_type_hit, 'enemy_type_hit', p_enemy_type_hit, 'hit_point_hero', p_hero_attack_point, 'hit_point_enemy', p_enemy_attack_point);
elsif p_enemy_type_hit = 'Критический удар' and p_hero_type_hit = 'Удар Призрака' then
	--Минус 35% ХП каждому
	p_enemy_attack_point = (select p_hero_max_hp * 35 / 100);
	p_hero_attack_point = (select p_enemy_max_hp * 35 / 100);
	return jsonb_build_object('hero_type_hit', p_hero_type_hit, 'enemy_type_hit', p_enemy_type_hit, 'hit_point_hero', p_hero_attack_point, 'hit_point_enemy', p_enemy_attack_point);
elsif p_enemy_type_hit = 'Безвольный удар' and p_hero_type_hit = 'Быстрый удар' then
	--Удар врага делится на 2, герой наносит стандартный удар
	p_enemy_attack_point = p_enemy_attack_point / 2;
	return jsonb_build_object('hero_type_hit', p_hero_type_hit, 'enemy_type_hit', p_enemy_type_hit, 'hit_point_hero', p_hero_attack_point, 'hit_point_enemy', p_enemy_attack_point);
elsif p_enemy_type_hit = 'Безвольный удар' and p_hero_type_hit = 'Уклонение' then
	--Герой получает полный (стандартный) урон, сам удар не наносит
	p_hero_attack_point = 0;
	return jsonb_build_object('hero_type_hit', p_hero_type_hit, 'enemy_type_hit', p_enemy_type_hit, 'hit_point_hero', p_hero_attack_point, 'hit_point_enemy', p_enemy_attack_point);
elsif p_enemy_type_hit = 'Безвольный удар' and p_hero_type_hit = 'Парирование' then
	--Удар отражается полностью, герой удар не наносит
	p_enemy_attack_point = 0;
	p_hero_attack_point = 0;
	return jsonb_build_object('hero_type_hit', p_hero_type_hit, 'enemy_type_hit', p_enemy_type_hit, 'hit_point_hero', p_hero_attack_point, 'hit_point_enemy', p_enemy_attack_point);
elsif p_enemy_type_hit = 'Безвольный удар' and p_hero_type_hit = 'Удар Призрака' then
	--Герой наносит смертельный удар врагу (-50% ХП), сам получает урон деленный на 2
	p_enemy_attack_point = p_enemy_attack_point / 2;
	p_hero_attack_point = (select p_enemy_max_hp * 50 / 100);
	return jsonb_build_object('hero_type_hit', p_hero_type_hit, 'enemy_type_hit', p_enemy_type_hit, 'hit_point_hero', p_hero_attack_point, 'hit_point_enemy', p_enemy_attack_point);
elsif p_enemy_type_hit = 'Быстрый удар' and p_hero_type_hit = 'Быстрый удар' then
	--Без изменений
	return jsonb_build_object('hero_type_hit', p_hero_type_hit, 'enemy_type_hit', p_enemy_type_hit, 'hit_point_hero', p_hero_attack_point, 'hit_point_enemy', p_enemy_attack_point);
elsif p_enemy_type_hit = 'Быстрый удар' and p_hero_type_hit = 'Уклонение' then
	--Только враг наносит удар
	p_hero_attack_point = 0;
	return jsonb_build_object('hero_type_hit', p_hero_type_hit, 'enemy_type_hit', p_enemy_type_hit, 'hit_point_hero', p_hero_attack_point, 'hit_point_enemy', p_enemy_attack_point);
elsif p_enemy_type_hit = 'Быстрый удар' and p_hero_type_hit = 'Парирование' then
	--Урон врага делится на 2
	p_enemy_attack_point = p_enemy_attack_point / 2;
	return jsonb_build_object('hero_type_hit', p_hero_type_hit, 'enemy_type_hit', p_enemy_type_hit, 'hit_point_hero', p_hero_attack_point, 'hit_point_enemy', p_enemy_attack_point);
elsif p_enemy_type_hit = 'Быстрый удар' and p_hero_type_hit = 'Удар Призрака' then
	--Без изменений
	return jsonb_build_object('hero_type_hit', p_hero_type_hit, 'enemy_type_hit', p_enemy_type_hit, 'hit_point_hero', p_hero_attack_point, 'hit_point_enemy', p_enemy_attack_point);
end if;

end;
$function$
;

COMMENT ON FUNCTION sotr_settings.get_hit(int4, int4) IS 'в _enemy_id передавать ид монстра, а не порядковый номер в списке врагов

вид атак:
	_hero_type_hit = 1 = ''Быстрый удар''
	_hero_type_hit = 2 = ''Уклонение''
	_hero_type_hit = 3 = ''Парирование''
	_hero_type_hit = 4 = ''Удар Призрака''';
