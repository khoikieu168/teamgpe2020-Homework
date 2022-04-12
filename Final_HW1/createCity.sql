USE `booking_app`;
DROP procedure IF EXISTS `createCity`;
DELIMITER $$
USE `booking_app`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `createCity`(
in pcityId char(32),
out return_message char(100))
proc:BEGIN
	
	if not (pcityId regexp '^[A-Za-z0-9]+$') then 
		set return_message := "Wrong format, alphanumeric character only";
		select return_message;
		leave proc;
    end if;
    if exists (select * from cities where city_id like pcityId) then
		set return_message := "Duplicated cityId occured";
		select return_message;
		leave proc;
    end if;
    insert into cities(city_id) values (pcityId);
	set return_message := "Create city successfully";
	select return_message;
END$$
DELIMITER ;