-- 1
use world;
-- 2
delimiter &&
create procedure getLargeCitiesByCountry (country_code char(3))
begin
	select ID as cityid, Name as cityname, Population as population
    from city
    where CountryCode = country_code and Population > 1000000
    order by Population desc;
end &&
delimiter ;
-- 3
call getLargeCitiesByCountry('USA');
-- 4
drop procedure getLargeCitiesByCountry;