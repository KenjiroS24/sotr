drop schema if exists sotr_game cascade;									
drop schema if exists sotr_settings cascade;									
									
create schema sotr_game;									
create schema sotr_settings;									
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------									
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------									
create table sotr_settings.items (									
	i_id int4 primary key,								
	i_title varchar unique,								
	effect jsonb								
);									
									
insert into sotr_settings.items (i_id, i_title, effect) values									
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
(11, 'Маска Люцифера', '{"num": 0, "type": "decoration", "ability": "Godness"}'::jsonb)									
;									
									
--select * from sotr_settings.items;									
									
/*select *, effect->>'num'									
	from sotr_settings.items								
where effect->>'type' = 'decoration';*/									
									
--truncate sotr_settings.items restart identity cascade;									
									
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------									
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------									
create table sotr_settings.hero_state_lvl (									
	lvl_id int4 primary key,								
	exp int4,								
	heal_points int4,								
	attack int4,								
	agility double precision								
);									
									
insert into sotr_settings.hero_state_lvl (lvl_id, "exp", heal_points, attack, agility) values									
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
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------									
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------									
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
									
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------									
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------									
create table sotr_settings.inventory (									
	in_id int4 primary key,								
	in_items_id int4 references sotr_settings.items (i_id),								
	in_cnt int4								
);									
									
insert into sotr_settings.inventory (in_id, in_items_id, in_cnt) values									
(1, 2, 1);									
									
--select * from sotr_settings.inventory;									
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------									
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------									
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
									
insert into sotr_settings.hero_condition (h_id, h_name, h_lvl, h_exp, h_heal_points, h_attack, h_agility, h_decoration) values									
(1, 'Adrian', 1, 0, 200, 15, 0.01, null);									
									
--select * from sotr_settings.hero_condition;									
									
									
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------									
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------									
									
--select sotr_game.start_new_game();									
									
create or replace function sotr_game.start_new_game(_to_continue bool default true)									
returns text									
language plpgsql									
as $function$									
begin									
	--Если на вход пришло false - сбрасываем все настройки героя, обнуляем лвл и инвентарь								
									
--	if _to_continue then								
									
--	else								
		--Создание состояния главного героя							
		create table sotr_game.g_hero as							
			select h_name, h_lvl, h_exp, h_heal_points, h_attack, h_agility, h_weapon, h_decoration						
				from sotr_settings.hero_condition;					
		--Создание списка врагов							
		create table sotr_game.g_enemy_list as							
		with list_enemy as (							
			select generate_series(1,3), e_id, e_name, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness						
				from sotr_settings.enemy_list as el					
			where e_id = 1						
			union all						
			select generate_series(1,3), e_id, e_name, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness						
				from sotr_settings.enemy_list as el					
			where e_id = 2						
			union all						
			select generate_series(1,2), e_id, e_name, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness						
				from sotr_settings.enemy_list as el					
			where e_id = 4						
			union all						
			select generate_series(1,1), e_id, e_name, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness						
				from sotr_settings.enemy_list as el					
			where e_id = 11						
			union all						
			select generate_series(1,2), e_id, e_name, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness						
				from sotr_settings.enemy_list as el					
			where e_id = 3						
			union all						
			select generate_series(1,3), e_id, e_name, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness						
				from sotr_settings.enemy_list as el					
			where e_id = 6						
			union all						
			select generate_series(1,1), e_id, e_name, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness						
				from sotr_settings.enemy_list as el					
			where e_id = 7						
			union all						
			select generate_series(1,1), e_id, e_name, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness						
				from sotr_settings.enemy_list as el					
			where e_id = 12						
			union all						
			select generate_series(1,3), e_id, e_name, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness						
				from sotr_settings.enemy_list as el					
			where e_id = 10						
			union all						
			select generate_series(1,2), e_id, e_name, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness						
				from sotr_settings.enemy_list as el					
			where e_id = 9						
			union all						
			select generate_series(1,1), e_id, e_name, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness						
				from sotr_settings.enemy_list as el					
			where e_id = 8						
			union all						
			select generate_series(1,1), e_id, e_name, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness						
				from sotr_settings.enemy_list as el					
			where e_id = 13						
		)							
		select row_number() over() as e_id, e_name, e_location, e_exp, e_heal_points, e_attack, e_drop_items, e_chance_drop, e_weakness							
			from list_enemy;						
		--Если в статистике указано: "Пройдено 1 раз" то нужно добавить скрытого босса							
		/*if else условие */							
--	end if;								
									
	return 'Путешествие в Мир Сна начато.';								
									
end;									
$function$;									
