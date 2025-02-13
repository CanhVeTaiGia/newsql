-- 1
use world;
-- 2
delimiter &&
create procedure getCountriesWithLargeCities ()
begin
	select c.Name as countryname, sum(ci.Population) as totalpopulation
    from country c
    join city ci on c.Code = ci.CountryCode
    where c.Continent = 'Asia'
    group by c.Name
    having sum(ci.Population) > 10000000
    order by totalpopulation desc;
end &&
delimiter ;
-- 3
call getCountriesWithLargeCities();
-- 4
drop procedure getCountriesWithLargeCities;