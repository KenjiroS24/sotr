--VER 0.8
--12:45 26.05.2022


drop schema if exists sotr_game cascade;
drop schema if exists sotr_settings cascade;

create schema sotr_game;
create schema sotr_settings;

create table sotr_settings.items (
	i_id int4 primary key,
	i_title varchar unique,
	effect jsonb
);

COMMENT ON TABLE sotr_settings.items IS 'Список всех предметов';


create table sotr_settings.hero_state_lvl (
	lvl_id int4 primary key,
	exp int4,
	heal_points int4,
	attack int4,
	agility double precision
);

COMMENT ON TABLE sotr_settings.hero_state_lvl IS 'Уровни и способности на уровнях';


create table sotr_settings.enemy_list (
	e_id int4 primary key,
	e_name varchar unique,
	e_description text,
	e_location varchar,
	e_exp int4,
	e_heal_points int4,
	e_attack int4,
	e_drop_items int4 references sotr_settings.items (i_id),
	e_chance_drop double precision,
	e_weakness jsonb
);

COMMENT ON TABLE sotr_settings.enemy_list IS 'Список всех врагов';


CREATE TABLE sotr_game.g_inventory (
	in_id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	in_items_id int4 NULL,
	in_cnt int4 NULL,
	CONSTRAINT inventory_pkey PRIMARY KEY (in_id),
	CONSTRAINT un_in_items_id UNIQUE (in_items_id),
	CONSTRAINT inventory_in_items_id_fkey FOREIGN KEY (in_items_id) REFERENCES sotr_settings.items(i_id)
);

COMMENT ON TABLE sotr_game.g_inventory IS 'Состояние инвентаря в текущей сессии';


create table sotr_game.g_hero (
	h_id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	h_name varchar NULL,
	h_lvl int4 NULL,
	h_exp int4 NULL,
	h_heal_points int4 NULL,
	h_attack int4 NULL,
	h_agility float8 NULL,
	h_weapon int4 NULL DEFAULT 2,
	h_decoration int4 NULL,
	CONSTRAINT hero_condition_h_name_key UNIQUE (h_name),
	CONSTRAINT hero_condition_pkey PRIMARY KEY (h_id),
	CONSTRAINT hero_condition_h_decoration_fkey FOREIGN KEY (h_decoration) REFERENCES sotr_settings.items(i_id),
	CONSTRAINT hero_condition_h_weapon_fkey FOREIGN KEY (h_weapon) REFERENCES sotr_settings.items(i_id)
);

COMMENT ON TABLE sotr_game.g_hero IS 'Характеристика персонажа в текущей сессии';

create table sotr_game.g_enemy ( 
	e_id int4 primary key GENERATED ALWAYS AS IDENTITY,
	e_name varchar,
	e_location varchar,
	e_exp int4,
	e_heal_points int4,
	e_attack int4,
	e_drop_items int4 references sotr_settings.items (i_id),
	e_chance_drop double precision,
	e_weakness jsonb
);

COMMENT ON TABLE sotr_game.g_enemy IS 'Список врагов в действующей сессии';


CREATE TABLE sotr_settings.game_statistic (
	num_walkthrough int4 NOT NULL GENERATED ALWAYS AS IDENTITY, -- номер прохождения
	cnt_kill_enemy int4 NULL, -- кол-во убитых врагов в прохождении
	cnt_received_exp int4 NULL, -- кол-во полученной экспы
	game_completed bool NULL, -- игра пройдена? Если убит Рыцарь Ада, то да
	CONSTRAINT game_statistic_pkey PRIMARY KEY (num_walkthrough)
);
COMMENT ON TABLE sotr_settings.game_statistic IS 'Статистика игры';

-- Column comments

COMMENT ON COLUMN sotr_settings.game_statistic.num_walkthrough IS 'номер прохождения';
COMMENT ON COLUMN sotr_settings.game_statistic.cnt_kill_enemy IS 'кол-во убитых врагов в прохождении';
COMMENT ON COLUMN sotr_settings.game_statistic.cnt_received_exp IS 'кол-во полученной экспы';
COMMENT ON COLUMN sotr_settings.game_statistic.game_completed IS 'игра пройдена? Если убит Рыцарь Ада, то да';


CREATE OR REPLACE VIEW sotr_game.v_game_statistic
AS WITH total AS (
         SELECT sum(gst.cnt_kill_enemy) AS cnt_kill_enemy_total,
            sum(gst.cnt_received_exp) AS cnt_received_exp_total
           FROM sotr_settings.game_statistic gst
        )
 SELECT gs.num_walkthrough,
    gs.cnt_kill_enemy,
    gs.cnt_received_exp,
    t.cnt_kill_enemy_total,
    t.cnt_received_exp_total
   FROM total t,
    sotr_settings.game_statistic gs
  ORDER BY gs.num_walkthrough DESC
 LIMIT 1;

COMMENT ON VIEW sotr_game.v_game_statistic IS 'Статистика игры. Сколько врагов убитов, сколько EXP заработано. (Учет сессии и общий)';

create table sotr_settings.attack_list (
	att_id int4 not null,
	enemy_attack text not null,
	hero_attack text not null,
	effect text not null,
	CONSTRAINT attack_list_att_id_pkey PRIMARY KEY (att_id)
);

COMMENT ON TABLE sotr_settings.attack_list IS 'Виды атак';

insert into sotr_settings.items (i_id, i_title, effect) 
values
(1, 'Травы', '{"num": 30, "type": "heal"}'::jsonb),
(2, 'Кулаки', '{"num": 1, "type": "weapon"}'::jsonb),
(3, 'Стилет', '{"num": 1.3, "type": "weapon"}'::jsonb),
(4, 'Кинжал Света', '{"num": 1.6, "type": "weapon"}'::jsonb),
(5, 'Святой Меч', '{"num": 1.6, "type": "weapon", "effect": "Святость"}'::jsonb),
(6, 'Амулет Жизни', '{"num": 5, "type": "decoration", "effect": "Уклонение"}'::jsonb),
(7, 'Аура Смерти', '{"num": 10, "type": "decoration", "effect": "Лечение"}'::jsonb),
(8, 'Перчатка Азазеля', '{"num": 0, "type": "decoration", "effect": "Огонь"}'::jsonb),
(9, 'Меч Истины', '{"num": 2, "type": "weapon"}'::jsonb),
(10, 'Меч Каина', '{"num": 3, "type": "weapon", "effect": "Святость"}'::jsonb),
(11, 'Маска Люцифера', '{"num": 0, "type": "decoration", "effect": "Godness"}'::jsonb);

insert into sotr_settings.hero_state_lvl (lvl_id, "exp", heal_points, attack, agility) 
values
(1, 0, 200, 15, 0.01),
(2, 100, 240, 18, 0.01),
(3, 200, 290, 22, 0.02),
(4, 400, 350, 26, 0.03),
(5, 800, 450, 30, 0.05),
(6, 1600, 590, 35, 0.07),
(7, 3200, 760, 40, 0.1),
(8, 5000, 1100, 60, 0.15),
(9, 7000, 1500, 85, 0.2),
(10, 9000, 2500, 120, 0.3);

insert into sotr_settings.enemy_list (e_id, e_name, e_description, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness)
values									
(1, 'Зомби', '- бывший охотник на нечисть, убитый в бою, но воскресший Некромантом для служения силам тьмы.', 'Замок', 30, 35, 10, 3, 0.4, null),
(2, 'Скелет', '- до конца разложившийся зомби, сохранивший возможность двигаться благодаря темной магии.', 'Замок', 30, 35, 10, 1, 0.3, null),
(3, 'Мученик', '- бывший маг-человек, случайно открывший портал в параллельный мир и потерявший там душу.', 'Параллельный мир', 30, 35, 10, 1, 0.3, null),
(4, 'Верфульф', '- бывший человек, переживший укус Верфульфа. Постоянно охотится на людей.', 'Замок', 80, 60, 15, 4, 0.2, null),
(5, 'Дух Падшего', '- дух охотника погибшего от рук Древней Ведьмы.', 'Замок', 0, 25, 10, null, null, null),
(6, 'Гиппогриф', '- древние существа, охраняющие Параллельный мир.', 'Параллельный мир', 140, 80, 15, 6, 0.3, '{"weakness": "Огонь", "num": 1.5}'::jsonb),
(7, 'Некромант', '- бывший маг-человек, который первым попал в Параллельный мир. Смог постигнуть древние тайны этого места, впоследствии став самым могущественным существом в пределах своего царства.', 'Параллельный мир', 150, 120, 20, 5, 1, null),
(8, 'Ангел Смерти', '- ангел, влюбленный в Люцифера и его ненависть к человечеству. Стремится истребить все живое.', 'Адские врата', 550, 350, 30, 9, 1, null),
(9, 'Демон', '- низший демон, бывший человек, совершивший страшное убийство и подаривший душу Ангелу Смерти взамен бессмертию.', 'Адские врата', 450, 250, 25, 6, 0.3, '{"weakness": "Святость", "num": 1.5}'::jsonb),
(10, 'Адский Зомби', '- зомби, отмеченный знаком Люцифера.', 'Адские врата', 150, 60, 20, 1, 0.5, null),
(11, 'Древняя Ведьма (Босс)', '- воплощение тьмы в реальном мире. Легенды гласят, что она появилась из слез самого Люцифера.', 'Замок', 120, 120, 20, 8, 1, null),
(12, 'Каратель (Босс)', '- высший демон, способный принимать облик самого страшного врага.', 'Параллельный мир', 300, 300, 30, 7, 1, null),
(13, 'Рыцарь Ада (Босс)', '- генерал армии Люцифера, легенды гласят, что под броней скрывается первый человек, совершивший убийство родного брата.', 'Адские врата', 10000, 800, 40, 10, 1, null),
(14, 'Люцифер (Секретный Босс)', '- король Ада и властитель темных сил. Бывший Ангел Рая.', '9-й круг ада', 0, 6666, 666, 11, 1, null);

insert into sotr_game.g_inventory (in_items_id, in_cnt) 
values
(2, 1);

insert into sotr_game.g_hero (h_name, h_lvl, h_exp, h_heal_points, h_attack, h_agility, h_weapon, h_decoration) 
values
('Adrian', 1, 0, 200, 15, 0.01, 2, null);
									
insert into sotr_settings.attack_list (att_id, enemy_attack, hero_attack, effect) 
values
(1, 'Промах', 'Быстрый удар', 'Герой наносит удар'),
(2, 'Промах', 'Уклонение', 'Ничего'),
(3, 'Промах', 'Парирование', 'Ничего'),
(4, 'Промах', 'Удар Призрака', 'Враг наносит критический удар по герою (-50% хп)'),
(5, 'Критический удар', 'Быстрый удар', 'Враг наносит критический удар'),
(6, 'Критический удар', 'Уклонение', 'Герой не получает урона и производит контратаку (-50% хп)'),
(7, 'Критический удар', 'Парирование', 'Герой получает урон *2'),
(8, 'Критический удар', 'Удар Призрака', '-35% ХП каждому'),
(9, 'Безвольный удар', 'Быстрый удар', 'Удар врага делится на 2, герой наносит стандартный удар'),
(10, 'Безвольный удар', 'Уклонение', 'Герой получает полный (стандартный) урон, сам удар не наносит'),
(11, 'Безвольный удар', 'Парирование', 'Урон врага = 0'),
(12, 'Безвольный удар', 'Удар Призрака', 'Герой наносит смертельный удар врагу (-50% ХП), сам получает урон деленный на 2'),
(13, 'Быстрый удар', 'Быстрый удар', 'Без изменений'),
(14, 'Быстрый удар', 'Уклонение', 'Только враг наносит удар'),
(15, 'Быстрый удар', 'Парирование', 'Урон врага делится на 2'),
(16, 'Быстрый удар', 'Удар Призрака', 'Без изменений');

CREATE OR REPLACE FUNCTION sotr_game.get_health()
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare 
p_res 		text;
p_in_cnt	int4;
p_effect	int4;
p_max_hp	int4;
p_now_hp	int4;

begin
	
	--Проверка наличия инвентаря с heal
	select gi.in_cnt into p_in_cnt 
		from sotr_game.g_inventory as gi 
	where in_items_id = 1;
	if not found then 
		return  'У Вас нет Трав в инвентаре';
	end if;

	--Назначение очков хилла
	select (i.effect ->> 'num')::int4 into p_effect
		from sotr_settings.items i
	where i_id = 1;
	
	--Проверка предела ХП
	select hsl.heal_points as hhp, gh.h_heal_points as ghhp into p_max_hp, p_now_hp
		from sotr_settings.hero_state_lvl hsl 
		join sotr_game.g_hero gh on hsl.lvl_id = gh.h_lvl;

	--Если текущий уровень здоровья равен максимальному, ничего не делать
	if p_now_hp = p_max_hp then 
		p_res = 'Персонаж не нуждается в лечении.';
	--Если после прибавления очков ХП будет достигнут или преодолен предел ХП, уровень ХП обновится на свой максимум и не выше
	elseif p_now_hp + p_effect >= p_max_hp then 
		update sotr_game.g_hero 
			set h_heal_points = p_max_hp
		where h_id = 1;

		update sotr_game.g_inventory 
			set in_cnt = in_cnt - 1
		where in_items_id = 1
		returning in_cnt into p_in_cnt;
	
		p_res = 'ХП повысилось до максимального значения. Ваше ХП составляет [' || p_max_hp::text || '/' || p_max_hp::text || ']';
	else 
		update sotr_game.g_hero 
			set h_heal_points = h_heal_points + p_effect
		where h_id = 1
		returning h_heal_points into p_now_hp;
	
		update sotr_game.g_inventory 
			set in_cnt = in_cnt - 1
		where in_items_id = 1
		returning in_cnt into p_in_cnt;
		
		p_res = 'Ваше ХП повысилось на [' || p_effect || ']. Ваше ХП составляет [' || p_now_hp::text || '/' || p_max_hp::text || ']';
	end if;

	if p_in_cnt <= 0 then 
		delete from sotr_game.g_inventory
		where in_items_id = 1;
	end if;

	return p_res;
end;
$function$
;

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
		select gi.in_id || ': ' || i.i_title || case when gi.in_cnt > 1 then '. Кол-во: ' || gi.in_cnt else '' end as inventory
			from sotr_game.g_inventory as gi
			join sotr_settings.items as i on gi.in_items_id = i.i_id;
	else 
	--Записываем значения in_items_id, i_title, num, type, effect для последующих выражений и проверяем корректность id
		select gi.in_items_id,  i.i_title , (i.effect->> 'num')::numeric  as num, (i.effect ->>'type') as "type",  (i.effect ->>'effect') as effect into p_items_id, p_inv_name, p_num_inv, p_type_inv, p_effect
			from sotr_game.g_inventory gi
			join sotr_settings.items i on i.i_id = gi.in_items_id
		where gi.in_id = _inv;
		if not found then
			RAISE EXCEPTION 'В инвентаре нет предмета с ID [%].', $1;
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
		return query select ('Оружие изменено на [' || p_inv_name || '].');

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
		return query select ('Украшение изменено на [' || p_inv_name || ']. Ваша ловкость увеличилась.');

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
		return query select ('Украшение изменено на [' || p_inv_name || '].');

	end if;

end;
$function$;


create or replace function sotr_game.start_game()
returns text
language plpgsql
as $function$
begin
	
	--Проверка на запущенную сессию. Если игра уже запущена (враги сгенерены), то запустить игру снова невозможно
	perform * from sotr_game.g_enemy as ge;
	if found then
		return 'Игровая сессия уже запущена. Завершите игру, либо перезапустите.';
	end if;

	--Создание новой статистики
	insert into sotr_settings.game_statistic (cnt_kill_enemy, cnt_received_exp, game_completed)
	values
		(0,0,false);
 
	perform sotr_settings.create_enemy(1, 3);
	perform sotr_settings.create_enemy(2, 3);
	perform sotr_settings.create_enemy(4, 2);
	perform sotr_settings.create_enemy(11, 1);
	perform sotr_settings.create_enemy(3, 2);
	perform sotr_settings.create_enemy(6, 3);
	perform sotr_settings.create_enemy(7, 1);
	perform sotr_settings.create_enemy(12, 1);
	perform sotr_settings.create_enemy(10, 3);
	perform sotr_settings.create_enemy(9, 2);
	perform sotr_settings.create_enemy(8, 1);
	perform sotr_settings.create_enemy(13, 1);

	--Проверка. Если игра ранее была пройдена, то добавляется секретный босс
	perform *
    	from sotr_settings.game_statistic as gs
	where gs.game_completed;
	if found then
		perform sotr_settings.create_enemy(14, 1);
		return 'С возвращением в мир зла!';
	end if;

	return 'Адриан начал свое путешествие в мир зла.';

end;
$function$;

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
		--Враг наносит критический удар (x3)
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
вид атак (_hero_type_hit)
1 = Быстрый удар
2 = Уклонение
3 = Парирование
4 = Удар Призрака';

create or replace function sotr_settings.get_random(_percent_in double precision)
returns bool
language plpgsql
as $function$
declare
p_loss double precision;
begin 
	
	if (_percent_in <= (0.0)::double precision ) then
		return false;
	elsif (_percent_in >= (1.0)::double precision ) then
		return true;
	end if;

	select 1.0 / _percent_in into p_loss;
	return (select 1 = ceil(random()*p_loss));

end;
$function$;