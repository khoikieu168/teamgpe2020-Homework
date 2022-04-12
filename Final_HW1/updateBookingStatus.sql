USE `booking_app`;
DROP procedure IF EXISTS `UpdateBookingStatus`;
DELIMITER $$
USE `booking_app`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateBookingStatus`(
in pstatus char(1),
in bookingId char(32),
in cityId char(32),
in centreId char(32),
in staffId char(32),
out return_message char(100))
proc:BEGIN

    
    if (pstatus not like "1" and pstatus not like "0") then
		set return_message := "Wrong status format (0 or 1 only)";
		select return_message;
		leave proc;
	end if;
    if not exists (select * from booking where (booking_id like bookingId)) then 
		set return_message := "BookingId does not exist";
		select return_message;
		leave proc;
    end if;
  
    if not exists (select * from staff where (staff_id like staffId)) then
		set return_message := "StaffId does not exist";
		select return_message;
		leave proc;
    end if;
IF not EXISTS (SELECT * FROM cities WHERE city_id like cityId)
THEN
   set return_message := "CityId does not exist";
   select return_message;
   leave proc;
END IF;

IF not EXISTS (SELECT * FROM sport_centres WHERE centre_id like centreId)
THEN
   set return_message := "CenterId does not exist";
   select return_message;
   leave proc;
END IF;

if not exists (select * from sport_centres where (city_id like cityId
  and centre_id like centreId)) then
	set return_message := "CenterId does not exist in cityId";
	select return_message;
	leave proc;
end if;

if not exists (select * from staff where (staff_id like staffId
 and centre_id like centreId)) then
	set return_message := "StaffId does not work in this centerId";
	select return_message;
	leave proc;
end if;	


    update booking set status=pstatus where booking_id like bookingId;
	set return_message := "Update booking status successfully";
	select return_message;
END$$
DELIMITER ;