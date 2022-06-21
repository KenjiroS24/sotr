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
