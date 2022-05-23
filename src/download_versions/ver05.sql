--VER 0.5 16:45 23.05.2022

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


create table sotr_game.g_inventory (
	in_id int4 NOT null GENERATED ALWAYS as IDENTITY,
	in_items_id int4 NULL,
	in_cnt int4 NULL,
	CONSTRAINT inventory_pkey PRIMARY KEY (in_id),
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
(5, 'Святой Меч', '{"num": 1.6, "type": "weapon", "ability": "Святость"}'::jsonb),
(6, 'Амулет Жизни', '{"num": 5, "type": "decoration"}'::jsonb),
(7, 'Аура Смерти', '{"num": 10, "type": "decoration"}'::jsonb),
(8, 'Перчатка Азазеля', '{"num": 0, "type": "decoration", "ability": "Огонь"}'::jsonb),
(9, 'Меч Истины', '{"num": 2, "type": "weapon"}'::jsonb),
(10, 'Меч Каина', '{"num": 3, "type": "weapon", "ability": "Святость"}'::jsonb),
(11, 'Маска Люцифера', '{"num": 0, "type": "decoration", "ability": "Godness"}'::jsonb);

--select * from sotr_settings.items;

------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
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

--select * from sotr_settings.hero_state_lvl;
------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
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

--select * from sotr_settings.enemy_list;
------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
insert into sotr_game.g_inventory (in_items_id, in_cnt) 
values
(2, 1);

--select * from sotr_game.g_inventory;
------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
insert into sotr_game.g_hero (h_name, h_lvl, h_exp, h_heal_points, h_attack, h_agility, h_weapon, h_decoration) 
values
('Adrian', 1, 0, 200, 15, 0.01, null, null);

--select * from sotr_game.g_hero;							
									
------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
insert into sotr_settings.attack_list (att_id, enemy_attack, hero_attack, effect) 
values
(1, 'Промах', 'Быстрый удар', 'Герой наносит удар'),
(2, 'Промах', 'Уклонение', 'Ничего'),
(3, 'Промах', 'Парирование', 'Ничего'),
(4, 'Промах', 'Удар Призрака', 'Враг наносит критический удар по герою (-50% хп)'),
(5, 'Критический удар', 'Быстрый удар', 'Обычный обмен ударами'),
(6, 'Критический удар', 'Уклонение', 'Герой не получает урона и производит контратаку (-50% хп)'),
(7, 'Критический удар', 'Парирование', 'Герой получает урон *2'),
(8, 'Критический удар', 'Удар Призрака', '-35% ХП каждому'),
(9, 'Безвольный удар', 'Быстрый удар', 'Обычный обмен ударами'),
(10, 'Безвольный удар', 'Уклонение', 'Герой получает урон *2'),
(11, 'Безвольный удар', 'Парирование', 'Урон врага = 0'),
(12, 'Безвольный удар', 'Удар Призрака', 'Герой наносит смертельный удар врагу (-50% ХП), сам получает урон деленный на 2'),
(13, 'Быстрый удар', 'Быстрый удар', 'Обычный обмен ударами'),
(14, 'Быстрый удар', 'Уклонение', 'Только враг наносит удар'),
(15, 'Быстрый удар', 'Парирование', 'Урон врага делится на 2'),
(16, 'Быстрый удар', 'Удар Призрака', 'Обычный обмен ударами');

--select * from sotr_settings.attack_list;

------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------

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

/*
	Функция, принимающая на вход цифры от 0.0 до 1.0.
	В ответ выдает либо TRUE, либо FALSE.
	Входной параметр - процент вероятности совершения события где 0.0 - событие никогда не произойдет , 1.0 - событие будет происходить всегда, 0.5 событие 	произойдет с вероятностью в 50%.
*/

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

