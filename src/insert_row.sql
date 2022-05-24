/* 	СОДЕРЖАНИЕ:
insert into sotr_settings.items
insert into sotr_settings.hero_state_lvl
insert into sotr_settings.enemy_list
insert into sotr_game.g_inventory
insert into sotr_game.g_hero
insert into sotr_settings.attack_list

Для перезапуска таблицы и обновления счетчика используйте: truncate [table] restart identity cascade;
*/

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

/*select *, effect->>'num'
	from sotr_settings.items
where effect->>'type' = 'decoration';*/

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
('Adrian', 1, 0, 200, 15, 0.01, 2, null);

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
