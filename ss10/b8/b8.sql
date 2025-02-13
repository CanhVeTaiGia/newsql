-- 1
use world;
-- 2
delimiter &&
create procedure getCountriesByCityNames()
begin
    select c.Name as countryname, cl.Language as officiallanguage, sum(ci.Population) as totalpopulation
    from country c
    join countrylanguage cl on c.Code = cl.CountryCode
    join city ci on c.Code = ci.CountryCode
    where ci.Name like 'A%' and cl.IsOfficial = 'T'
    group by c.Name, cl.Language
    having sum(ci.Population) > 2000000
    order by countryname asc;
end &&
delimiter ;
-- 3
call getCountriesByCityNames();
-- 4
drop procedure getCountriesByCityNames;