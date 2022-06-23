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
