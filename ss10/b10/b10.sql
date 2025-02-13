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
        total_pop.TotalPopulation
    from OfficialLanguageView olv
    join city ci on olv.CountryCode = ci.CountryCode
    join (
        select CountryCode, sum(Population) as TotalPopulation
        from city
        group by CountryCode
    ) total_pop on ci.CountryCode = total_pop.CountryCode
    where olv.Language = language_name
      and ci.Name like 'New%'
    having TotalPopulation > 5000000
    order by TotalPopulation desc
    limit 10;
end &&
delimiter ;
-- 6
call getSpecialCountriesAndCities('English');