USE `booking_app`;
DROP procedure IF EXISTS `createCitySportCenter`;
DELIMITER $$
USE `booking_app`$$
CREATE PROCEDURE `CreateCitySportCenter` (
in pcenterId char(32),
in pcityId  char(32),
out return_message char(100))
proc:BEGIN
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