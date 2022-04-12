USE `booking_app`;
DROP procedure IF EXISTS `CancelBooking`;
DELIMITER $$
USE `booking_app`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CancelBooking`(
in bookingId char(32),
in playerId char(32),
out return_message char(100))
proc:BEGIN
	if not exists (select * from booking where (customer like playerId)) then
		set return_message := "CustomerId does not exist in any bookings";
		select return_message;
		leave proc;
    end if;
	if not exists (select * from booking where (booking_id like bookingId)) then 
		set return_message := "BookingId does not exist";
		select return_message;
		leave proc;
    end if;
    if exists (select * from booking where (booking_id like bookingId and customer not like playerId)) then
		set return_message := "BookingId does not belong to customerId";
		select return_message;
		leave proc;
	end if;
	
	
    -- delete from booked_court where booking_id=bookingId;
    delete from booking where booking_id like bookingId;
	set return_message := "Cancel booking successfully";
	select return_message;
END$$
DELIMITER ;
