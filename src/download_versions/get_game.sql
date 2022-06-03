--Let's Go SOTR 0.9

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


select key as Actions, value->>0 as cnt 
	from jsonb_each
(sotr_game.attack_enemy(1,1))
--order by key
;

select sotr_game.get_health();

select sotr_game.inventory_bag();
