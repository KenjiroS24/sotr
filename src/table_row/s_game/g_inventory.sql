CREATE TABLE sotr_game.g_inventory (
	in_id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	in_items_id int4 NULL,
	in_cnt int4 NULL,
	CONSTRAINT inventory_pkey PRIMARY KEY (in_id),
	CONSTRAINT un_in_items_id UNIQUE (in_items_id)
);
COMMENT ON TABLE sotr_game.g_inventory IS 'Состояние инвентаря в текущей сессии';
