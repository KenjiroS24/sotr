CREATE TABLE sotr_settings.game_statistic (
	num_walkthrough int4 NOT NULL GENERATED ALWAYS AS IDENTITY, -- номер прохождения
	cnt_kill_enemy int4 NULL, -- кол-во убитых врагов в прохождении
	cnt_received_exp int4 NULL, -- кол-во полученной экспы
	game_completed bool NULL, -- игра пройдена? Если убит Рыцарь Ада, то да
	CONSTRAINT game_statistic_pkey PRIMARY KEY (num_walkthrough)
);
COMMENT ON TABLE sotr_settings.game_statistic IS 'Статистика игры';

-- Column comments

COMMENT ON COLUMN sotr_settings.game_statistic.num_walkthrough IS 'номер прохождения';
COMMENT ON COLUMN sotr_settings.game_statistic.cnt_kill_enemy IS 'кол-во убитых врагов в прохождении';
COMMENT ON COLUMN sotr_settings.game_statistic.cnt_received_exp IS 'кол-во полученной экспы';
COMMENT ON COLUMN sotr_settings.game_statistic.game_completed IS 'игра пройдена? Если убит Рыцарь Ада, то да';
