/* 	СОДЕРЖАНИЕ:
create schema sotr_game
create schema sotr_settings
create table sotr_settings.items
create table sotr_settings.hero_state_lvl
create table sotr_settings.enemy_list
create table sotr_game.g_inventory
create table sotr_game.g_hero
create table sotr_game.g_enemy
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

create table sotr_settings.hero_state_lvl (
	lvl_id int4 primary key,
	exp int4,
	heal_points int4,
	attack int4,
	agility double precision
);


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

CREATE TABLE sotr_game.g_inventory (
	in_id int4 NOT null GENERATED ALWAYS as IDENTITY,
	in_items_id int4 NULL,
	in_cnt int4 NULL,
	CONSTRAINT inventory_pkey PRIMARY KEY (in_id),
	CONSTRAINT inventory_in_items_id_fkey FOREIGN KEY (in_items_id) REFERENCES sotr_settings.items(i_id)
);

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
	CONSTRAINT hero_condition_pkey PRIMARY KEY (h_id),
	CONSTRAINT hero_condition_h_decoration_fkey FOREIGN KEY (h_decoration) REFERENCES sotr_settings.items(i_id),
	CONSTRAINT hero_condition_h_weapon_fkey FOREIGN KEY (h_weapon) REFERENCES sotr_settings.items(i_id)
);

CREATE TABLE sotr_game.g_enemy ( 
	e_id int4 primary key GENERATED ALWAYS AS IDENTITY,
	e_name varchar unique,
	e_location varchar,
	e_exp int4,
	e_heal_points int4,
	e_attack int4,
	e_drop_items int4 references sotr_settings.items (i_id),
	e_chance_drop double precision,
	e_weakness jsonb
);
