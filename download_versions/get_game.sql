--Let's Go SOTR 1.0.1

/* Пример вызова
select jsonb_array_elements(sotr_game.attack_enemy(20,1));
Либо
select key as Actions, value->>0 as cnt 
	from jsonb_each
(sotr_game.attack_enemy(39,1))
--order by key
;
*/


--Запуск игровой сессии
select sotr_game.start_game();

/*
--Начало игры и возможные действия
0. Для удобства просмотра открыть таблицы g_hero - следить за статистикой героя, g_enemy - просмотреть врагов, v_game_statistic - глобальная статистика, attack_list - описание атак

1. Чтобы атаковать врага, выберите цель и передайте её в 1-й параметр функции sotr_game.attack_enemy. Вторым параметром обозначьте тип своего удара.
	1 = Быстрый удар
	2 = Уклонение
	3 = Парирование
	4 = Удар Призрака

2. Просмотреть свой инвентарь - вызов функции inventory_bag. Если не передавать параметры, выдаст список, если указать ID, произойдет замена оружия.

3. Если в инвентаре есть лечилки, можно пополнить свой запас HP функцией get_health
*/

--Состояние героя
select * from sotr_game.g_hero gh;
--Состояние врагов
select * from sotr_game.g_enemy ge order by e_id;


--Произвести атаку
select key as Actions, value->>0 as cnt 
	from jsonb_each
(sotr_game.attack_enemy(12,4))
--order by key
;
--Посмотреть лист атак
select * from sotr_settings.attack_list as al;


--Проверить инвентарь
select sotr_game.inventory_bag(2);
--Вылечиться
select sotr_game.get_health();



