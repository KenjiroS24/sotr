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
