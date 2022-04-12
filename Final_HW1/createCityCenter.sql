USE `booking_app`;
DROP procedure IF EXISTS `createCityCenter`;
DELIMITER $$
USE `booking_app`$$
CREATE PROCEDURE `CreateCityCenter` (
in pcenterId char(32),
in pcityId  char(32),
out return_message char(100))
proc:BEGIN

	if not (pcenterId regexp '^[A-Za-z0-9]+$') then 
		set return_message := "Wrong format, alphanumeric character only";
		select return_message;
		leave proc;
    end if;
	-- no need check city, it was already checked in createCity
	if exists (select * from Sport_Centres where centre_id like pcenterId) 
    then
		set return_message := "Duplicate centerId occured";
		select return_message;
		leave proc;
    end if;
	if not exists (select * from cities where city_id like pcityId) 
    then
		set return_message := "CityId does not exist";
		select return_message;
		leave proc;
    end if;
	
    insert into Sport_Centres(centre_id, city_id) values (pcenterId, pcityId);
	set return_message := "Create city sport centre successfully";
	select return_message;
END$$
DELIMITER ;