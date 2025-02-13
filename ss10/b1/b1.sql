-- 1
use world;
-- 2
delimiter &&
create procedure proFilterCountryByCode(country_code char(3))
begin
	select city.ID, city.Name, city.Population from city
    join country
    where city.CountryCode = country.code;
end &&
delimiter ; 
-- 3
call proFilterCountryByCode("AFG");
-- 4
drop procedure proFilterCountryByCode;