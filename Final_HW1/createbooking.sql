
USE `booking_app`;
DROP procedure IF EXISTS `createBooking`;
DELIMITER $$
USE `booking_app`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `createBooking`(
in pBookingId char(32),
in pdate char(20),
in pstart char(20), 
in pend char(20), 
in pcourt char(32), 
in pcity char(32),
in pcentre char(32),
in pcustomer char(32),
out return_message char(100))
proc:BEGIN
  declare start_timestamp timestamp;
  declare end_timestamp timestamp;
  declare book_date datetime;
  declare startTime datetime;
  declare endTime datetime;
  declare opentime timestamp;
  declare closetime timestamp;
  
  -- declare nonpaid int;
  
  

  set book_date := timestamp(pdate);
  set startTime := timestamp(pstart);
  set endTime := timestamp(pend);
  select addtime(book_date, "070000") into opentime;
  select addtime(book_date, "210000") into closetime;
  select count(*) into @unpaidstatus from booking where customer = pcustomer and unix_timestamp(valid_from) < pdate and status = 0;
  select count(*) into @paidstatus from booking where customer = pcustomer and status = 1;
/*
Check if court already be booked
==> PASS : check if customer had more than 3 bookings
*/
if not (pBookingId regexp '^[A-Za-z0-9]+$') then 
	set return_message := "Wrong format, alphanumeric character only";
	select return_message;
	leave proc;
end if;
IF exists (select * from booking where booking_id like pBookingId) 
then
   set return_message := "Duplicated bookingId";
   select return_message;
   leave proc;
end if;

 IF not EXISTS (SELECT * FROM customer WHERE customer_id LIKE pcustomer)
THEN
   set return_message := "CustomerId does not exist";
   select return_message;
   leave proc;
END IF; 

IF not EXISTS (SELECT * FROM court WHERE court_id LIKE pcourt)
THEN
   set return_message := "CourtId does not exist";
   select return_message;
   leave proc;
END IF;

IF not EXISTS (SELECT * FROM cities WHERE city_id like pcity)
THEN
   set return_message := "CityId does not exist";
   select return_message;
   leave proc;
END IF;

IF not EXISTS (SELECT * FROM sport_centres WHERE centre_id like pcentre)
THEN
   set return_message := "CenterId does not exist";
   select return_message;
   leave proc;
END IF;

if not exists (select * from sport_centres where (city_id like pcity
  and centre_id like pcentre)) then
	set return_message := "CenterId does not exist in cityId";
	select return_message;
	leave proc;
end if;

if not exists (select * from court where (court_id like pcourt
 and centre_id like pcentre)) then
	set return_message := "CourtId does not exist in centerId";
	select return_message;
	leave proc;
end if;	

if ( @paidstatus >=3) then
	set return_message := "Customer cannot register in advance more than 3 slots";
	select return_message;
	leave proc;
end if;
IF ( @unpaidstatus >=1) then
   set return_message := "Customer cannot register in advance when unpaid";
   select return_message;
   leave proc;
END IF; 
IF (start_timestamp < now())
THEN 
   set return_message := "Start timestamp of the registration < current timestamp";
   select return_message;
   leave proc;
END IF;
IF  (startTime < openTime)
THEN 
   set return_message := "Start time of the registration < open time(7) of the court";
   select return_message;
   leave proc;
END IF;
IF  (endTime > closeTime) 
THEN 
   set return_message := "End time of the registration > close time(21) of the court";
   select return_message;
   leave proc;
END IF;

IF (endTime < startTime)
THEN 
   set return_message := "End time of the registration < start time of the registration";
   select return_message;
   leave proc;
END IF;

if exists (select * from booking where court like pcourt) then
   if exists (select booking_date from booking where booking_date like book_date) then
      if exists (select valid_from,valid_to from booking 
		where valid_from <= startTime and valid_to >= startTime) then
			/* set return_message := concat("Overlap with ",convert(char,startTime)
			  ,"-",convert(char,endTime),"on this day"); */
			set return_message := "Overlap with another booking time";  
			select return_message;
			leave proc;
	  end if;	
			
   end if;
end if;

INSERT INTO booking(booking_id, booking_date, valid_from, valid_to, court, city_id, centre_id, customer, status) 
  values (pBookingId, book_date, startTime, endTime, pcourt, pcity, pcentre, pcustomer, 0);
   set return_message :="Create booking successfully";
   select return_message;
END$$
DELIMITER ;
