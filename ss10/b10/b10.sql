-- 1
use world;
-- 2
create view OfficialLanguageView as
select 
    c.Code as CountryCode, 
    c.Name as CountryName, 
    cl.Language as Language, 
    cl.IsOfficial as IsOfficial
from country c
join countrylanguage cl on c.Code = cl.CountryCode
where cl.IsOfficial = 'T';
-- 3
select * from OfficialLanguageView;
-- 4
create index idx_city_name on city(Name);
-- 5
delimiter &&
create procedure getSpecialCountriesAndCities(in language_name varchar(50))
begin
    select 
        olv.CountryName, 
        ci.Name as CityName, 
        ci.Population as CityPopulation, 
        (select sum(ci2.Population) 
         from city ci2 
         where ci2.CountryCode = olv.CountryCode) as TotalPopulation
    from OfficialLanguageView olv
    join city ci on olv.CountryCode = ci.CountryCode
    where olv.Language = language_name
      and ci.Name like 'New%'
    group by olv.CountryName, ci.Name, ci.Population, olv.CountryCode
    having TotalPopulation > 5000000
    order by TotalPopulation desc
    limit 10;
end &&
delimiter ;
-- 6
call getSpecialCountriesAndCities('English');