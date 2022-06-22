--VER 1.0.1
--16:05 22.06.2022

--------------------------------------------

drop schema if exists sotr_game cascade;
drop schema if exists sotr_settings cascade;
drop schema if exists sotr_rec cascade;



create schema sotr_game;
create schema sotr_settings;
create schema sotr_rec;

--------------------------------------------
CREATE TABLE sotr_game.g_enemy (
	e_id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	e_name varchar NULL,
	e_location varchar NULL,
	e_exp int4 NULL,
	e_heal_points int4 NULL,
	e_attack int4 NULL,
	e_drop_items int4 NULL,
	e_chance_drop float8 NULL,
	e_weakness jsonb NULL,
	CONSTRAINT g_enemy_pkey PRIMARY KEY (e_id)
);
COMMENT ON TABLE sotr_game.g_enemy IS 'Список врагов в действующей сессии';

CREATE TABLE sotr_game.g_hero (
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
	CONSTRAINT hero_condition_pkey PRIMARY KEY (h_id)
);
COMMENT ON TABLE sotr_game.g_hero IS 'Характеристика персонажа в текущей сессии';

insert into sotr_game.g_hero (h_name, h_lvl, h_exp, h_heal_points, h_attack, h_agility, h_weapon, h_decoration) 
values
('Adrian', 1, 0, 200, 15, 0.01, 2, null);

CREATE TABLE sotr_game.g_inventory (
	in_id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	in_items_id int4 NULL,
	in_cnt int4 NULL,
	CONSTRAINT inventory_pkey PRIMARY KEY (in_id),
	CONSTRAINT un_in_items_id UNIQUE (in_items_id)
);
COMMENT ON TABLE sotr_game.g_inventory IS 'Состояние инвентаря в текущей сессии';

insert into sotr_game.g_inventory (in_items_id, in_cnt) 
values
(2, 1);

CREATE TABLE sotr_game.game_statistic (
	num_walkthrough int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	cnt_kill_enemy int4 NULL,
	cnt_received_exp int4 NULL,
	game_completed bool NULL,
	CONSTRAINT game_statistic_pkey PRIMARY KEY (num_walkthrough)
);

COMMENT ON TABLE sotr_game.game_statistic IS 'Статистика игры';

COMMENT ON COLUMN sotr_game.game_statistic.num_walkthrough IS 'номер прохождения';
COMMENT ON COLUMN sotr_game.game_statistic.cnt_kill_enemy IS 'кол-во убитых врагов в прохождении';
COMMENT ON COLUMN sotr_game.game_statistic.cnt_received_exp IS 'кол-во полученной экспы';
COMMENT ON COLUMN sotr_game.game_statistic.game_completed IS 'игра пройдена? Если убит Рыцарь Ада, то да';

CREATE TABLE sotr_game.saves(
	save_id  int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	dt timestamp(0) NOT NULL DEFAULT now(),
	save_cnt int4 default 0,
	CONSTRAINT saves_pkey PRIMARY KEY (save_id)
);
COMMENT ON TABLE sotr_game.saves IS 'Сохранение игры';

COMMENT ON COLUMN sotr_game.saves.save_id is 'id сохранения';
COMMENT ON COLUMN sotr_game.saves.dt is 'дата сохранения';
COMMENT ON COLUMN sotr_game.saves.save_cnt is 'количество сохранений';

CREATE TABLE sotr_settings.attack_list (
	att_id int4 NOT NULL,
	enemy_attack text NOT NULL,
	chance_enemy_attack text NULL,
	hero_attack text NOT NULL,
	effect text NOT NULL,
	CONSTRAINT attack_list_att_id_pkey PRIMARY KEY (att_id)
);
COMMENT ON TABLE sotr_settings.attack_list IS 'Виды атак';



INSERT INTO sotr_settings.attack_list
(att_id, enemy_attack, chance_enemy_attack, hero_attack, effect)
VALUES(1, 'Промах', '% уклонения героя', 'Быстрый удар', 'Герой наносит удар');
INSERT INTO sotr_settings.attack_list
(att_id, enemy_attack, chance_enemy_attack, hero_attack, effect)
VALUES(2, 'Промах', '% уклонения героя', 'Уклонение', 'Ничего');
INSERT INTO sotr_settings.attack_list
(att_id, enemy_attack, chance_enemy_attack, hero_attack, effect)
VALUES(3, 'Промах', '% уклонения героя', 'Парирование', 'Ничего');
INSERT INTO sotr_settings.attack_list
(att_id, enemy_attack, chance_enemy_attack, hero_attack, effect)
VALUES(4, 'Промах', '% уклонения героя', 'Удар Призрака', 'Враг наносит критический удар по герою (-50% хп)');
INSERT INTO sotr_settings.attack_list
(att_id, enemy_attack, chance_enemy_attack, hero_attack, effect)
VALUES(5, 'Критический удар', '5%', 'Быстрый удар', 'Враг наносит критический удар');
INSERT INTO sotr_settings.attack_list
(att_id, enemy_attack, chance_enemy_attack, hero_attack, effect)
VALUES(6, 'Критический удар', '5%', 'Уклонение', 'Герой не получает урона и производит контратаку (-50% хп)');
INSERT INTO sotr_settings.attack_list
(att_id, enemy_attack, chance_enemy_attack, hero_attack, effect)
VALUES(7, 'Критический удар', '5%', 'Парирование', 'Герой получает урон *2');
INSERT INTO sotr_settings.attack_list
(att_id, enemy_attack, chance_enemy_attack, hero_attack, effect)
VALUES(8, 'Критический удар', '5%', 'Удар Призрака', '-35% ХП каждому');
INSERT INTO sotr_settings.attack_list
(att_id, enemy_attack, chance_enemy_attack, hero_attack, effect)
VALUES(9, 'Безвольный удар', '15%', 'Быстрый удар', 'Удар врага делится на 2, герой наносит стандартный удар');
INSERT INTO sotr_settings.attack_list
(att_id, enemy_attack, chance_enemy_attack, hero_attack, effect)
VALUES(10, 'Безвольный удар', '15%', 'Уклонение', 'Герой получает полный (стандартный) урон, сам удар не наносит');
INSERT INTO sotr_settings.attack_list
(att_id, enemy_attack, chance_enemy_attack, hero_attack, effect)
VALUES(11, 'Безвольный удар', '15%', 'Парирование', 'Урон врага = 0');
INSERT INTO sotr_settings.attack_list
(att_id, enemy_attack, chance_enemy_attack, hero_attack, effect)
VALUES(12, 'Безвольный удар', '15%', 'Удар Призрака', 'Герой наносит смертельный удар врагу (-50% ХП), сам получает урон деленный на 2');
INSERT INTO sotr_settings.attack_list
(att_id, enemy_attack, chance_enemy_attack, hero_attack, effect)
VALUES(13, 'Быстрый удар', '% оставшийся. Примерно 70-80%', 'Быстрый удар', 'Без изменений');
INSERT INTO sotr_settings.attack_list
(att_id, enemy_attack, chance_enemy_attack, hero_attack, effect)
VALUES(14, 'Быстрый удар', '% оставшийся. Примерно 70-80%', 'Уклонение', 'Только враг наносит удар');
INSERT INTO sotr_settings.attack_list
(att_id, enemy_attack, chance_enemy_attack, hero_attack, effect)
VALUES(15, 'Быстрый удар', '% оставшийся. Примерно 70-80%', 'Парирование', 'Урон врага делится на 2');
INSERT INTO sotr_settings.attack_list
(att_id, enemy_attack, chance_enemy_attack, hero_attack, effect)
VALUES(16, 'Быстрый удар', '% оставшийся. Примерно 70-80%', 'Удар Призрака', 'Без изменений');

CREATE TABLE sotr_settings.hero_state_lvl (
	lvl_id int4 NOT NULL,
	"exp" int4 NULL,
	heal_points int4 NULL,
	attack int4 NULL,
	agility float8 NULL,
	CONSTRAINT hero_state_lvl_pkey PRIMARY KEY (lvl_id)
);
COMMENT ON TABLE sotr_settings.hero_state_lvl IS 'Уровни и способности на уровнях';

INSERT INTO sotr_settings.hero_state_lvl
(lvl_id, "exp", heal_points, attack, agility)
VALUES(1, 0, 200, 15, 0.01);
INSERT INTO sotr_settings.hero_state_lvl
(lvl_id, "exp", heal_points, attack, agility)
VALUES(2, 100, 240, 18, 0.01);
INSERT INTO sotr_settings.hero_state_lvl
(lvl_id, "exp", heal_points, attack, agility)
VALUES(3, 200, 290, 22, 0.02);
INSERT INTO sotr_settings.hero_state_lvl
(lvl_id, "exp", heal_points, attack, agility)
VALUES(4, 400, 350, 26, 0.03);
INSERT INTO sotr_settings.hero_state_lvl
(lvl_id, "exp", heal_points, attack, agility)
VALUES(5, 800, 450, 30, 0.05);
INSERT INTO sotr_settings.hero_state_lvl
(lvl_id, "exp", heal_points, attack, agility)
VALUES(6, 1600, 590, 35, 0.07);
INSERT INTO sotr_settings.hero_state_lvl
(lvl_id, "exp", heal_points, attack, agility)
VALUES(7, 3200, 760, 40, 0.1);
INSERT INTO sotr_settings.hero_state_lvl
(lvl_id, "exp", heal_points, attack, agility)
VALUES(8, 5000, 1100, 60, 0.15);
INSERT INTO sotr_settings.hero_state_lvl
(lvl_id, "exp", heal_points, attack, agility)
VALUES(9, 7000, 1500, 85, 0.2);
INSERT INTO sotr_settings.hero_state_lvl
(lvl_id, "exp", heal_points, attack, agility)
VALUES(10, 9000, 2500, 120, 0.3);

CREATE TABLE sotr_settings.items (
	i_id int4 NOT NULL,
	i_title varchar NULL,
	effect jsonb NULL,
	CONSTRAINT items_i_title_key UNIQUE (i_title),
	CONSTRAINT items_pkey PRIMARY KEY (i_id)
);
COMMENT ON TABLE sotr_settings.items IS 'Список всех предметов';


INSERT INTO sotr_settings.items
(i_id, i_title, effect)
VALUES(1, 'Травы', '{"num": 30, "type": "heal"}'::jsonb);
INSERT INTO sotr_settings.items
(i_id, i_title, effect)
VALUES(2, 'Кулаки', '{"num": 1, "type": "weapon"}'::jsonb);
INSERT INTO sotr_settings.items
(i_id, i_title, effect)
VALUES(3, 'Стилет', '{"num": 1.3, "type": "weapon"}'::jsonb);
INSERT INTO sotr_settings.items
(i_id, i_title, effect)
VALUES(4, 'Кинжал Света', '{"num": 1.6, "type": "weapon"}'::jsonb);
INSERT INTO sotr_settings.items
(i_id, i_title, effect)
VALUES(5, 'Святой Меч', '{"num": 1.6, "type": "weapon", "effect": "Святость"}'::jsonb);
INSERT INTO sotr_settings.items
(i_id, i_title, effect)
VALUES(6, 'Амулет Жизни', '{"num": 5, "type": "decoration", "effect": "Уклонение"}'::jsonb);
INSERT INTO sotr_settings.items
(i_id, i_title, effect)
VALUES(7, 'Аура Смерти', '{"num": 10, "type": "decoration", "effect": "Лечение"}'::jsonb);
INSERT INTO sotr_settings.items
(i_id, i_title, effect)
VALUES(8, 'Перчатка Азазеля', '{"num": 0, "type": "decoration", "effect": "Огонь"}'::jsonb);
INSERT INTO sotr_settings.items
(i_id, i_title, effect)
VALUES(9, 'Меч Истины', '{"num": 2, "type": "weapon"}'::jsonb);
INSERT INTO sotr_settings.items
(i_id, i_title, effect)
VALUES(10, 'Меч Каина', '{"num": 3, "type": "weapon", "effect": "Святость"}'::jsonb);
INSERT INTO sotr_settings.items
(i_id, i_title, effect)
VALUES(11, 'Маска Люцифера', '{"num": 0, "type": "decoration", "effect": "Godness"}'::jsonb);

CREATE TABLE sotr_settings.enemy_list (
	e_id int4 NOT NULL,
	e_name varchar NULL,
	e_description text NULL,
	e_location varchar NULL,
	e_exp int4 NULL,
	e_heal_points int4 NULL,
	e_attack int4 NULL,
	e_drop_items int4 NULL,
	e_chance_drop float8 NULL,
	e_weakness jsonb NULL,
	CONSTRAINT enemy_list_e_name_key UNIQUE (e_name),
	CONSTRAINT enemy_list_pkey PRIMARY KEY (e_id),
	CONSTRAINT enemy_list_e_drop_items_fkey FOREIGN KEY (e_drop_items) REFERENCES sotr_settings.items(i_id)
);
COMMENT ON TABLE sotr_settings.enemy_list IS 'Список всех врагов';

INSERT INTO sotr_settings.enemy_list
(e_id, e_name, e_description, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness)
VALUES(1, 'Зомби', '- бывший охотник на нечисть, убитый в бою, но воскресший Некромантом для служения силам тьмы.', 'Замок', 30, 35, 10, 3, 0.4, NULL);
INSERT INTO sotr_settings.enemy_list
(e_id, e_name, e_description, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness)
VALUES(2, 'Скелет', '- до конца разложившийся зомби, сохранивший возможность двигаться благодаря темной магии.', 'Замок', 30, 35, 10, 1, 0.3, NULL);
INSERT INTO sotr_settings.enemy_list
(e_id, e_name, e_description, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness)
VALUES(3, 'Мученик', '- бывший маг-человек, случайно открывший портал в параллельный мир и потерявший там душу.', 'Параллельный мир', 30, 35, 10, 1, 0.3, NULL);
INSERT INTO sotr_settings.enemy_list
(e_id, e_name, e_description, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness)
VALUES(4, 'Верфульф', '- бывший человек, переживший укус Верфульфа. Постоянно охотится на людей.', 'Замок', 80, 60, 15, 4, 0.2, NULL);
INSERT INTO sotr_settings.enemy_list
(e_id, e_name, e_description, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness)
VALUES(5, 'Дух Падшего', '- дух охотника погибшего от рук Древней Ведьмы.', 'Замок', 0, 25, 10, NULL, NULL, NULL);
INSERT INTO sotr_settings.enemy_list
(e_id, e_name, e_description, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness)
VALUES(6, 'Гиппогриф', '- древние существа, охраняющие Параллельный мир.', 'Параллельный мир', 140, 80, 15, 6, 0.3, '{"num": 1.5, "weakness": "Огонь"}'::jsonb);
INSERT INTO sotr_settings.enemy_list
(e_id, e_name, e_description, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness)
VALUES(7, 'Некромант', '- бывший маг-человек, который первым попал в Параллельный мир. Смог постигнуть древние тайны этого места, впоследствии став самым могущественным существом в пределах своего царства.', 'Параллельный мир', 150, 120, 20, 5, 1.0, NULL);
INSERT INTO sotr_settings.enemy_list
(e_id, e_name, e_description, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness)
VALUES(8, 'Ангел Смерти', '- ангел, влюбленный в Люцифера и его ненависть к человечеству. Стремится истребить все живое.', 'Адские врата', 550, 350, 30, 9, 1.0, NULL);
INSERT INTO sotr_settings.enemy_list
(e_id, e_name, e_description, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness)
VALUES(9, 'Демон', '- низший демон, бывший человек, совершивший страшное убийство и подаривший душу Ангелу Смерти взамен бессмертию.', 'Адские врата', 450, 250, 25, 6, 0.3, '{"num": 1.5, "weakness": "Святость"}'::jsonb);
INSERT INTO sotr_settings.enemy_list
(e_id, e_name, e_description, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness)
VALUES(10, 'Адский Зомби', '- зомби, отмеченный знаком Люцифера.', 'Адские врата', 150, 60, 20, 1, 0.5, NULL);
INSERT INTO sotr_settings.enemy_list
(e_id, e_name, e_description, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness)
VALUES(11, 'Древняя Ведьма (Босс)', '- воплощение тьмы в реальном мире. Легенды гласят, что она появилась из слез самого Люцифера.', 'Замок', 120, 120, 20, 8, 1.0, NULL);
INSERT INTO sotr_settings.enemy_list
(e_id, e_name, e_description, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness)
VALUES(12, 'Каратель (Босс)', '- высший демон, способный принимать облик самого страшного врага.', 'Параллельный мир', 300, 300, 30, 7, 1.0, NULL);
INSERT INTO sotr_settings.enemy_list
(e_id, e_name, e_description, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness)
VALUES(13, 'Рыцарь Ада (Босс)', '- генерал армии Люцифера, легенды гласят, что под броней скрывается первый человек, совершивший убийство родного брата.', 'Адские врата', 10000, 800, 40, 10, 1.0, NULL);
INSERT INTO sotr_settings.enemy_list
(e_id, e_name, e_description, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness)
VALUES(14, 'Люцифер (Секретный Босс)', '- король Ада и властитель темных сил. Бывший Ангел Рая.', '9-й круг ада', 0, 6666, 666, 11, 1.0, NULL);

CREATE TABLE sotr_rec.saves(
	save_id  int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	dt timestamp(0) NOT NULL DEFAULT now(),
	save_cnt int4 default 0,
	CONSTRAINT saves_pkey PRIMARY KEY (save_id)
);
COMMENT ON TABLE sotr_rec.saves IS 'Сохранение игры';

COMMENT ON COLUMN sotr_rec.saves.save_id is 'id сохранения';
COMMENT ON COLUMN sotr_rec.saves.dt is 'дата сохранения';
COMMENT ON COLUMN sotr_rec.saves.save_cnt is 'количество сохранений';


CREATE TABLE sotr_rec.hero (
	h_id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	h_name varchar NULL,
	h_lvl int4 NULL,
	h_exp int4 NULL,
	h_heal_points int4 NULL,
	h_attack int4 NULL,
	h_agility float8 NULL,
	h_weapon int4 NULL DEFAULT 2,
	h_decoration int4 NULL,
	save_id int4 NOT null,
	CONSTRAINT hero_condition_h_name_key UNIQUE (h_name),
	CONSTRAINT hero_condition_pkey PRIMARY KEY (h_id),
	constraint hero_condition_fkey foreign key (save_id) REFERENCES sotr_rec.saves (save_id)
);
COMMENT ON TABLE sotr_rec.hero IS 'Сохранение характеристик персонажа в текущей сессии';


CREATE TABLE sotr_rec.inventory (
	in_id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	in_items_id int4 NULL,
	in_cnt int4 NULL,
	save_id int4 NOT null,
	CONSTRAINT inventory_pkey PRIMARY KEY (in_id),
	CONSTRAINT un_in_items_id UNIQUE (in_items_id),
	constraint hero_condition_fkey foreign key (save_id) REFERENCES sotr_rec.saves (save_id)
);
COMMENT ON TABLE sotr_rec.inventory IS 'Сохранение состояния инвентаря в текущей сессии';

CREATE TABLE sotr_rec.enemy (
	e_id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	e_name varchar NULL,
	e_location varchar NULL,
	e_exp int4 NULL,
	e_heal_points int4 NULL,
	e_attack int4 NULL,
	e_drop_items int4 NULL,
	e_chance_drop float8 NULL,
	e_weakness jsonb NULL,
	save_id int4 NOT null,
	CONSTRAINT enemy_pkey PRIMARY KEY (e_id),
	constraint hero_condition_fkey foreign key (save_id) REFERENCES sotr_rec.saves (save_id)
);
COMMENT ON TABLE sotr_rec.enemy IS 'Сохранение списка врагов в действующей сессии';

CREATE TABLE sotr_rec.game_statistic (
	num_walkthrough int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	cnt_kill_enemy int4 NULL,
	cnt_received_exp int4 NULL,
	game_completed bool NULL,
	cnt_kill_hero int4 NOT null,
	save_id int4 NOT null,
	CONSTRAINT game_statistic_pkey PRIMARY KEY (num_walkthrough),
	constraint hero_condition_fkey foreign key (save_id) REFERENCES sotr_rec.saves (save_id)
);
COMMENT ON TABLE sotr_rec.game_statistic IS 'Статистика игры';

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
	insert into sotr_game.game_statistic (cnt_kill_enemy, cnt_received_exp, game_completed)
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
    	from sotr_game.game_statistic as gs
	where gs.game_completed;
	if found then
		perform sotr_settings.create_enemy(14, 1);
		return 'С возвращением в мир зла!';
	end if;

	return 'Адриан начал свое путешествие в мир зла.';

end;
$function$;

/* Пример вызова
select jsonb_array_elements(sotr_game.attack_enemy(20,1));
Либо
select key as Actions, value->>0 as cnt 
	from jsonb_each
(sotr_game.attack_enemy(39,1))
--order by key
;
*/


CREATE OR REPLACE FUNCTION sotr_game.attack_enemy(_enemy_id integer, _hero_type_hit integer)
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
declare
p_total_result jsonb;
p_res jsonb;
p_request_get_hit jsonb;
p_res_drop jsonb;

p_glob_enemy_id int;
p_weakness_enemy varchar;
p_loss_weakness float;

p_info_about_effect jsonb;
p_hero_type_hit varchar;
p_enemy_type_hit varchar;
p_hit_point_hero int;
p_hit_point_enemy int;

p_h_lvl int;
p_hero_max_hp int;
p_enemy_max_hp int;
p_heal_hero int;

p_heal_points_enemy int;
p_heal_points_hero int;
p_show_heal_points_enemy text;
p_show_heal_points_hero text;

begin

	--Получение эффекта слабости врага и его глобальный ID (из листа врагов для передачи в get_hit)
	select el.e_id, el.e_weakness->>'weakness', (el.e_weakness->>'num')::float, el.e_heal_points into p_glob_enemy_id, p_weakness_enemy, p_loss_weakness, p_enemy_max_hp
		from sotr_game.g_enemy as ge
		join sotr_settings.enemy_list as el on el.e_name = ge.e_name
	where ge.e_id = _enemy_id;
	if not found then
		return jsonb_build_object('ERROR','Врага с таким ID не найдено');
	end if;

	--Получение эффекта оружия героя
	select gh.h_lvl, jsonb_build_object('weapon_effect', i.effect) || jsonb_build_object('decoration_effect', i2.effect) into p_h_lvl, p_info_about_effect
		from sotr_game.g_hero as gh
		left join sotr_settings.items as i on i.i_id = gh.h_weapon
		left join sotr_settings.items as i2 on i2.i_id = gh.h_decoration
	where gh.h_id = 1;

	--назначение пределов ХП для героя
	select heal_points into p_hero_max_hp
		from sotr_settings.hero_state_lvl as hsl where lvl_id = p_h_lvl;

	--Вызов функции, которая вернет тип атаки врага + очки урона героя и врага
	select sotr_settings.get_hit(p_glob_enemy_id, _hero_type_hit) into p_request_get_hit;
	--Распределение по переменным итога вызова функции выше
	select p_request_get_hit->>'hero_type_hit' into p_hero_type_hit;
	select p_request_get_hit->>'enemy_type_hit' into p_enemy_type_hit;
	select (p_request_get_hit->>'hit_point_hero')::int into p_hit_point_hero;
	select (p_request_get_hit->>'hit_point_enemy')::int into p_hit_point_enemy;

	--Проверка на наличие слабости у врага и наличию эффекта у оружия глав.героя
	if (p_info_about_effect->'weapon_effect'->>'effect' = p_weakness_enemy) or (p_info_about_effect->'decoration_effect'->>'effect' = p_weakness_enemy) then
		p_hit_point_hero = p_hit_point_hero * p_loss_weakness;
	
		p_total_result = jsonb_build_object('Сработал эффект [Усиление]:', p_loss_weakness);
	end if;

	--Нанесение урона врагу
	update sotr_game.g_enemy as ge
		set e_heal_points = e_heal_points - p_hit_point_hero
	where ge.e_id = _enemy_id
	returning e_heal_points into p_heal_points_enemy;

	p_hero_type_hit	= 'Вы применили прием: [' || p_hero_type_hit || ']. Урон: ';
	p_res = jsonb_build_object(p_hero_type_hit, p_hit_point_hero);
	
	--вызов функции дропа-убийства, возврат из неё предмета и инфы кого убили, получение exp, повысился ли уровень?
	if p_heal_points_enemy <= 0 then
		select sotr_settings.kill_enemy(_enemy_id) into p_res_drop;
--		p_heal_points_enemy = 0;
		p_res = p_res || p_res_drop;
	else 
		p_show_heal_points_enemy = p_heal_points_enemy::text || '/' || p_enemy_max_hp::text;
		p_res = p_res || jsonb_build_object('Остаток жизни врага: ', p_show_heal_points_enemy);	
	end if;

	--Проверка на эффект Лечение
	if p_info_about_effect->'decoration_effect'->>'effect' = 'Лечение' then
		p_heal_hero = (select p_hit_point_hero * (p_info_about_effect->'decoration_effect'->>'num')::float / 100);
	
		update sotr_game.g_hero as gh
			set h_heal_points = case when (h_heal_points + p_heal_hero) > p_hero_max_hp then p_hero_max_hp else h_heal_points + p_heal_hero end
		where gh.h_id = 1;
	
		p_total_result = coalesce(p_total_result, jsonb_build_object()) || jsonb_build_object('Сработал эффект [Лечение]. Восстановлено HP: ', p_heal_hero);
	end if;

	--Нанесение урона герою
	update sotr_game.g_hero as gh
		set h_heal_points = h_heal_points - p_hit_point_enemy
	where gh.h_id = 1
	returning h_heal_points into p_heal_points_hero;

	p_enemy_type_hit = 'Враг применил прием: [' || p_enemy_type_hit || ']. Урон: ';
	p_res = p_res || jsonb_build_object(p_enemy_type_hit, p_hit_point_enemy);

	--Смерть героя
	if p_heal_points_hero <= 0 then
--		вызов функции убийства глав.героя, возврат к сейвпоинту. Временно прописал обнуление результатов
		truncate sotr_game.g_enemy restart identity;
		truncate sotr_game.g_inventory restart identity;
		truncate sotr_game.game_statistic restart identity;
	
		insert into sotr_game.g_inventory (in_items_id, in_cnt) values (2, 1);
		update sotr_game.g_hero
			set h_lvl = 1, h_exp = 0, h_heal_points = 200, h_attack = 15, h_agility = 0.01, h_weapon = 2, h_decoration = null
		where h_id = 1;
		--insert into sotr_game.game_statistic (cnt_kill_enemy, cnt_received_exp, game_completed) values (0, 0, false);
		perform sotr_game.start_game();
		return jsonb_build_object('Вам нанесли смертельное ранение.','[Игра вернулась к контрольной точке]');
	else	
		p_show_heal_points_hero = p_heal_points_hero::text || '/' || p_hero_max_hp::text;
		p_res = p_res || jsonb_build_object('У вас осталось HP: ', p_show_heal_points_hero);
	end if;

	p_total_result = coalesce(p_total_result, jsonb_build_object()) || p_res;

	return p_total_result;

end;
$function$
;

COMMENT ON FUNCTION sotr_game.attack_enemy(int4, int4) IS 'Функцию по нанесению урона врагу. В _enemy_id берется враг под номером из таблицы g_enemy.
В _hero_type_hit принимаются 4 аргумента:
1 = Быстрый удар
2 = Уклонение
3 = Парирование
4 = Удар Призрака';

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


--
--Вызов
--select generate_series(1,10), sotr_settings.get_random(0.4);

CREATE OR REPLACE FUNCTION sotr_settings.kill_enemy(_enemy_id integer)
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
declare
p_res_drop jsonb;
p_e_name varchar; 
p_e_exp int;
p_e_drop_items int;
p_e_chance_drop float;
p_get_drop_items varchar;
p_hero_lvl_now int;
p_hero_lvl_must int;

begin
	
	delete from sotr_game.g_enemy as ge
		where ge.e_id = _enemy_id
	returning e_name, e_exp, e_drop_items, e_chance_drop into p_e_name, p_e_exp, p_e_drop_items, p_e_chance_drop;

	--Проверка на дроп
	if (select sotr_settings.get_random(p_e_chance_drop)) then
		insert into sotr_game.g_inventory (in_items_id, in_cnt) 
			values 
		(p_e_drop_items, 1)
		on conflict (in_items_id) do update
			set in_cnt = excluded.in_cnt + 1;
		
		p_get_drop_items = (select i_title from sotr_settings.items where i_id = p_e_drop_items);
		p_res_drop = jsonb_build_object('Выбитое оружие: ', p_get_drop_items);
	else
		p_res_drop = jsonb_build_object();
	end if;

	--Добавление EXP
	update sotr_game.g_hero as gh
		set h_exp = h_exp + p_e_exp
	where h_id = 1
	returning h_lvl, h_exp into p_hero_lvl_now, p_e_exp;

	--Обновление статистики
	update sotr_game.game_statistic 
		set cnt_kill_enemy = cnt_kill_enemy + 1,
			cnt_received_exp = cnt_received_exp + p_e_exp
	where not game_completed;

	--Переменная для проверки соответствия уровня и EXP
	select hsl.lvl_id into p_hero_lvl_must
		from sotr_settings.hero_state_lvl as hsl 
	where hsl.exp <= p_e_exp
	order by hsl.lvl_id desc limit 1;

	--Проверка и повышение ЛВЛа
	if p_hero_lvl_now != p_hero_lvl_must then
		--повысить лвл
		--Вызов функции с передачей лвл на который надо поднять перса p_hero_lvl_must
		perform sotr_settings.lvl_up(p_hero_lvl_must);
		p_res_drop = coalesce(p_res_drop, jsonb_build_object()) || jsonb_build_object('Вы перешли на новый уровень: ', p_hero_lvl_must);
	end if;


	p_res_drop = coalesce(p_res_drop, jsonb_build_object()) || jsonb_build_object('Вы убили врага: ', p_e_name);
	
	return p_res_drop;

end;
$function$;

CREATE OR REPLACE FUNCTION sotr_settings.lvl_up(_lvl_id integer)
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
				h_attack = (p_state_lvl.attack * (p_current_weapon->>'num')::float)::int,
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
