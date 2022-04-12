USE `booking_app`;
DROP procedure IF EXISTS `createStaff`;
DELIMITER $$
USE `booking_app`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `createStaff`(
in staffId char(32),
in cityId char(32),
in centerId char(32),
out return_message char(100))
proc:BEGIN
	
    if not (staffId regexp '^[A-Za-z0-9]+$') then 
		set return_message := "Wrong format, alphanumeric character only";
		select return_message;
		leave proc;
    end if;
    if not exists (select * from cities where (city_id like cityId)) then
		set return_message := "City Id does not exist";
		select return_message;
		leave proc;
    end if;
	if not exists (select * from sport_centres where (centre_id like centerId)) then
		set return_message := "Centre Id does not exist";
		select return_message;
		leave proc;
    end if;
    if exists (select * from staff where (staff_id like staffId)) then
		set return_message := "Duplicate staffId occurred";
		select return_message;
		leave proc;
    end if;
	if not exists (select * from sport_centres where (city_id like cityId
	  and centre_id like centerId)) then
		set return_message := "CenterId does not exist in cityId";
		select return_message;
		leave proc;
	end if;
    insert into staff(staff_id, city_id, centre_id) values (staffId, cityId, centerId);
	set return_message := "Create staff successfully";
	select return_message;
END$$
DELIMITER ;

