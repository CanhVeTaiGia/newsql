-- 1
use world;
-- 2
delimiter &&
create procedure proGetCountryByLanguage(language char(30))
begin
	select c.CountryCode, c.Language, c.Percentage from countryLanguage c
    where c.Language = language and c.Percentage > 50;
end &&
delimiter ;

-- 3
call proGetCountryByLanguage("Spanish");

-- 4
drop procedure proGetCountryByLanguage;