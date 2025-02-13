-- 1
use world;
-- 2
delimiter &&
create procedure getEnglishSpeakingCountriesWithCities(language varchar(50))
begin
    select c.Name as countryname, sum(ci.Population) as totalpopulation
    from country c
    join countrylanguage cl on c.Code = cl.CountryCode
    join city ci on c.Code = ci.CountryCode
    where cl.Language = language and cl.IsOfficial = 'T'
    group by c.Name
    having sum(ci.Population) > 5000000
    order by totalpopulation desc
    limit 10;
end &&
delimiter ;
-- 3
call getEnglishSpeakingCountriesWithCities('English');
-- 4
drop procedure getEnglishSpeakingCountriesWithCities;