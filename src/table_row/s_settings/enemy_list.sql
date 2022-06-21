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
