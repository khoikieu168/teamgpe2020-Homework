USE `booking_app`;
DROP procedure IF EXISTS `CreateCityCenterCourt`;
DELIMITER $$
USE `booking_app`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateCityCenterCourt`(
in courtId char(32),
in cityId char(32),
in centerId char(32),
out return_message char(100))
proc:BEGIN
	if not (courtId regexp '^[A-Za-z0-9]+$') then 
		set return_message := "Wrong format, alphanumeric character only";
		select return_message;
		leave proc;
    end if;
	if exists (select * from court where (court_id like courtId)) then
		set return_message := "Duplicate courtId";
		select return_message;
		leave proc;
    end if;
    if not exists (select * from cities where (city_id like cityId)) then
		set return_message := "CityId does not exist";
		select return_message;
		leave proc;
    end if;
	if not exists (select * from sport_centres where (centre_id like centerId)) then
		set return_message := "CenterId does not exist";
		select return_message;
		leave proc;
    end if;
	
	if not exists (select * from sport_centres where (city_id like cityId
	  and centre_id like centerId)) then
		set return_message := "CenterId does not exist in cityId";
		select return_message;
		leave proc;
	end if;
	insert into court(court_id, centre_id, city_id) values (courtId, centerID, cityID);
	set return_message := "Create court successfully";
	select return_message;
END$$
DELIMITER ;