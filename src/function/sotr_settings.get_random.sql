/*
	Функция, принимающая на вход цифры от 0.0 до 1.0.
	В ответ выдает либо TRUE, либо FALSE.
	Входной параметр - процент вероятности совершения события где 0.0 - событие никогда не произойдет , 1.0 - событие будет происходить всегда, 0.5 событие 	произойдет с вероятностью в 50%.
*/

create or replace function sotr_settings.get_random(_percent_in double precision)
returns bool
language plpgsql
as $function$
declare
p_loss double precision;
begin 
	
	if (_percent_in <= (0.0)::double precision ) then
		return false;
	elsif (_percent_in >= (1.0)::double precision ) then
		return true;
	end if;

	select 1.0 / _percent_in into p_loss;
	return (select 1 = ceil(random()*p_loss));

end;
$function$;


--
--Вызов
select generate_series(1,10), sotr_settings.get_random(0.4);
