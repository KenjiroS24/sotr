/* 	СОДЕРЖАНИЕ:
create schema sotr_game
create schema sotr_settings
create table sotr_settings.items
create table sotr_settings.hero_state_lvl
create table sotr_settings.enemy_list
create table sotr_game.g_inventory
create table sotr_game.g_hero
create table sotr_game.g_enemy
create or replace view sotr_game.v_game_statistic
create table sotr_settings.game_statistic
create table sotr_settings.attack_list
*/

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
