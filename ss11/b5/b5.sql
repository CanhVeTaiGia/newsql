use chinook;

-- 3
create view View_Album_Artist
as select al.AlbumId, al.Title "Album_Title", ar.Name "Artist_Name" 
from Album al
join Artist ar;

-- 4
create view View_Customer_Spending as
select 
    c.CustomerId,
    c.FirstName,
    c.LastName,
    c.Email,
    coalesce(sum(i.Total), 0) as Total_Spending
from customer c
left join invoice i on c.CustomerId = i.CustomerId
group by c.CustomerId, c.FirstName, c.LastName, c.Email;

-- 5
create index idx_Employee_LastName on Employee(LastName);
explain select * from Employee e
where e.LastName = "King";

-- 6
delimiter &&
create procedure getTracksByGenre(p_GenreId int)
begin
    select 
        t.TrackId, 
        t.Name as Track_Name, 
        a.Title as Album_Title, 
        ar.Name as Artist_Name
    from track t
    join album a on t.AlbumId = a.AlbumId
    join artist ar on a.ArtistId = ar.ArtistId
    where t.GenreId = p_GenreId;
end &&
delimiter ;

call GetTracksByGenre(1);
-- 7
delimiter &&
create procedure GetTrackCountByAlbum(p_AlbumId int)
begin
	select count(*) as Total_Tracks
    from track t
    where t.AlbumID = p_AlbumID;
end &&
delimiter ;
call GetTrackCountByAlbum(2);

-- 8
drop view View_Album_Artist;

drop view View_Customer_Spending;

alter table Employee
drop index idx_Employee_LastName;

drop procedure GetTracksByGenre;

drop procedure GetTrackCountByAlbum;