USE `booking_app`;
DROP procedure IF EXISTS `createPlayer`;
DELIMITER $$
USE `booking_app`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `createPlayer`(
in playerId char(32),
out return_message char(100))
proc:BEGIN
	
	if not (playerId regexp '^[A-Za-z0-9]+$') then 
		set return_message := "Wrong format, alphanumeric character only";
		select return_message;
		leave proc;
    end if;
    if exists (select * from customer where (customer_id like playerId)) then
		set return_message := "Duplicated playerId occured";
		select return_message;
		leave proc;
    end if;
    insert into customer(customer_id) values (playerId);
	set return_message := "Create player successfully";
	select return_message;
END$$
DELIMITER ;