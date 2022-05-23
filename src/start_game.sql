create or replace function sotr_game.start_game()
returns text
language plpgsql
as $function$
begin
	
	--Проверка на запущенную сессию. Если игра уже запущена (враги сгенерены), то запустить игру снова невозможно
	perform * from sotr_game.g_enemy as ge;
	if found then
		return 'Игровая сессия уже запущена. Завершите игру, либо перезапустите.';
	end if;

	--Создание новой статистики
	insert into sotr_settings.game_statistic (cnt_kill_enemy, cnt_received_exp, game_completed)
	values
		(0,0,false);
 
	perform sotr_settings.create_enemy(1, 3);
	perform sotr_settings.create_enemy(2, 3);
	perform sotr_settings.create_enemy(4, 2);
	perform sotr_settings.create_enemy(11, 1);
	perform sotr_settings.create_enemy(3, 2);
	perform sotr_settings.create_enemy(6, 3);
	perform sotr_settings.create_enemy(7, 1);
	perform sotr_settings.create_enemy(12, 1);
	perform sotr_settings.create_enemy(10, 3);
	perform sotr_settings.create_enemy(9, 2);
	perform sotr_settings.create_enemy(8, 1);
	perform sotr_settings.create_enemy(13, 1);

	--Проверка. Если игра ранее была пройдена, то добавляется секретный босс
	perform *
    	from sotr_settings.game_statistic as gs
	where gs.game_completed;
	if found then
		perform sotr_settings.create_enemy(14, 1);
	end if;

	return 'Done';

end;
$function$;
