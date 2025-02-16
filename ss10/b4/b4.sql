-- 1
use world;
-- 2
delimiter &&
create procedure updateCityPopulation (city_id int, new_population int)
begin
	update city
    set Population = new_population 
    where ID = city_id;
    select ID as cityid, Name as name, Population as population 
    from city 
    where ID = city_id;
end &&
delimiter ;
-- 3
call updateCityPopulation(1, 500000);
-- 4
drop procedure updateCityPopulation;