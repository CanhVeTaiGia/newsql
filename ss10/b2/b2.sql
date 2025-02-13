-- 1
use world;
-- 2
delimiter &&
create procedure calculatePopulation (p_countryCode char(3), out total_population int)
begin
	select sum(c.population) into total_population from city c
    where c.countrycode = p_countrycode;
end &&
delimiter ;
-- 3
call calculatePopulation("AFG", @total_population);
select @total_population;
-- 4
drop procedure calculatePopulation;