/* 	СОДЕРЖАНИЕ:
create schema sotr_game
create schema sotr_settings
create table sotr_settings.items
create table sotr_settings.hero_state_lvl
create table sotr_settings.enemy_list
create table sotr_settings.inventory
create table sotr_settings.hero_condition
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

create table sotr_settings.inventory (
	in_id int4 primary key,
	in_items_id int4 references sotr_settings.items (i_id),
	in_cnt int4
);

create table sotr_settings.hero_condition (
	h_id int4 primary key,
	h_name varchar unique,
	h_description text,
	h_lvl int4,
	h_exp int4,
	h_heal_points int4,
	h_attack int4,
	h_agility double precision,
	h_weapon int4 references sotr_settings.items (i_id) default 2,
	h_decoration int4 references sotr_settings.items (i_id)
);
