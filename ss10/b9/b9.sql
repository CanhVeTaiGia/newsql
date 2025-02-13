-- 1
use world;
-- 2
create view CountryLanguageView as
select 
    c.Code as CountryCode, 
    c.Name as CountryName, 
    cl.Language as Language, 
    cl.IsOfficial as IsOfficial
from country c
join countrylanguage cl on c.Code = cl.CountryCode
where cl.IsOfficial = 'T';
-- 3
select * from CountryLanguageView;
-- 4
delimiter &&
create procedure getLargeCitiesWithEnglish()
begin
    select ci.Name as cityname, c.Name as countryname, ci.Population as population
    from city ci
    join country c on ci.CountryCode = c.Code
    join countrylanguage cl on c.Code = cl.CountryCode
    where ci.Population > 1000000 
      and cl.Language = 'English' 
      and cl.IsOfficial = 'T'
    order by ci.Population desc
    limit 20;
end &&
delimiter ;
-- 5
call getLargeCitiesWithEnglish();
-- 6
drop view CountryLanguageView;
drop procedure getLargeCitiesWithEnglish;