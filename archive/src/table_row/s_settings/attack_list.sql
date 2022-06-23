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
