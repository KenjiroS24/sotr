CREATE TABLE sotr_settings.hero_state_lvl (
	lvl_id int4 NOT NULL,
	"exp" int4 NULL,
	heal_points int4 NULL,
	attack int4 NULL,
	agility float8 NULL,
	CONSTRAINT hero_state_lvl_pkey PRIMARY KEY (lvl_id)
);
COMMENT ON TABLE sotr_settings.hero_state_lvl IS 'Уровни и способности на уровнях';

INSERT INTO sotr_settings.hero_state_lvl
(lvl_id, "exp", heal_points, attack, agility)
VALUES(1, 0, 200, 15, 0.01);
INSERT INTO sotr_settings.hero_state_lvl
(lvl_id, "exp", heal_points, attack, agility)
VALUES(2, 100, 240, 18, 0.01);
INSERT INTO sotr_settings.hero_state_lvl
(lvl_id, "exp", heal_points, attack, agility)
VALUES(3, 200, 290, 22, 0.02);
INSERT INTO sotr_settings.hero_state_lvl
(lvl_id, "exp", heal_points, attack, agility)
VALUES(4, 400, 350, 26, 0.03);
INSERT INTO sotr_settings.hero_state_lvl
(lvl_id, "exp", heal_points, attack, agility)
VALUES(5, 800, 450, 30, 0.05);
INSERT INTO sotr_settings.hero_state_lvl
(lvl_id, "exp", heal_points, attack, agility)
VALUES(6, 1600, 590, 35, 0.07);
INSERT INTO sotr_settings.hero_state_lvl
(lvl_id, "exp", heal_points, attack, agility)
VALUES(7, 3200, 760, 40, 0.1);
INSERT INTO sotr_settings.hero_state_lvl
(lvl_id, "exp", heal_points, attack, agility)
VALUES(8, 5000, 1100, 60, 0.15);
INSERT INTO sotr_settings.hero_state_lvl
(lvl_id, "exp", heal_points, attack, agility)
VALUES(9, 7000, 1500, 85, 0.2);
INSERT INTO sotr_settings.hero_state_lvl
(lvl_id, "exp", heal_points, attack, agility)
VALUES(10, 9000, 2500, 120, 0.3);
