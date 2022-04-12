DROP DATABASE IF EXISTS booking_app;
CREATE DATABASE booking_app;
USE booking_app;

DROP TABLE IF EXISTS Customer;
CREATE TABLE Customer(
  customer_id char(32) NOT NULL PRIMARY KEY
);

DROP TABLE IF EXISTS Cities;
CREATE TABLE Cities(
  city_id char(32) NOT NULL PRIMARY KEY
);

DROP TABLE IF EXISTS Sport_Centres;
CREATE TABLE Sport_Centres(
   centre_id char(32) NOT NULL,
   city_id char(32) NOT NULL,
   constraint sport_centres_fk foreign key (city_id) references cities(city_id),
   constraint sport_centres_pk primary key (centre_id, city_id)
);

DROP TABLE IF EXISTS Staff;
CREATE TABLE Staff(
    staff_id char(32) NOT NULL PRIMARY KEY,
    city_id char(32) NOT NULL,
    centre_id char(32) NOT NULL,
    constraint staff_cityID_FK foreign key (city_id) references cities(city_id),
    constraint staff_centreID_FK foreign key (centre_id) references sport_centres(centre_id)
);

DROP TABLE IF EXISTS Court;
CREATE TABLE Court(
	court_id char(32) NOT NULL PRIMARY KEY,
	centre_id char(32) NOT NULL,
	city_id char(32) NOT NULL,
	status bit DEFAULT 1, -- 0:booked, 1:available
	CONSTRAINT court_centreID_fk FOREIGN KEY (centre_id) REFERENCES Sport_Centres(centre_id),
    constraint court_cityID_fk foreign key (city_id) references Sport_Centres(city_id)
	
);

DROP TABLE IF EXISTS Booking;
CREATE TABLE Booking(
  booking_id char(32) NOT NULL PRIMARY KEY,
  booking_date timestamp NOT NULL,
  valid_from DATETIME NOT NULL,
  valid_to DATETIME NOT NULL,
  court char(32) NOT NULL,
  city_id char(32) NOT NULL,
  centre_id char(32) NOT NULL,
  customer char(32) NOT NULL,
  status BOOLEAN default null ,
  CONSTRAINT customer_fk FOREIGN KEY (customer) REFERENCES Customer (customer_id),
  CONSTRAINT court_fk FOREIGN KEY (court) REFERENCES court(court_id),
	constraint city_id_fk foreign key (city_id) references cities(city_id),
    constraint centre_id_fk foreign key (centre_id) references sport_centres(centre_id)
);

DROP TABLE IF EXISTS Booked_Court;
CREATE TABLE Booked_Court(
  booking_id char(32) NOT NULL,
  court_id char(32) NOT NULL,
  CONSTRAINT booked_bookingID_fk
      FOREIGN KEY (booking_id) REFERENCES Booking(booking_id),
  CONSTRAINT booked_courtID_fk 
      FOREIGN KEY (court_id) REFERENCES Court(court_id),
  CONSTRAINT booked_PK PRIMARY KEY (booking_id, court_id)
);

USE `booking_app`;
DROP procedure IF EXISTS `CreateBooking`;
DELIMITER $$
USE `booking_app`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateBooking`(
in pBookingId char(32),
in pdate DATETIME,
in pstart DATETIME, 
in pend DATETIME, 
in pcourt char(32), 
in pcity char(32),
in pcentre char(32),
in pcustomer char(32),
in pStatus bit)
BEGIN
  DECLARE bookedTime datetime;
  DECLARE openTime datetime;
  DECLARE closeTime datetime;
  DECLARE startTime datetime;
  DECLARE endTime datetime;
  DECLARE court_id char(32);
  DECLARE customer_id char(32);
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET STACKED DIAGNOSTICS CONDITION 1 @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;	
    SELECT @p1, @p2;
    ROLLBACK;
  END;
  SELECT date_add(date_add(pdate, INTERVAL 7 HOUR), INTERVAL 0 MINUTE) into openTime;
  SELECT date_add(date_add(pdate, INTERVAL 21 HOUR), INTERVAL 0 MINUTE) into closeTime;
  SELECT date_add(date_add(pdate, INTERVAL extract(HOUR from pstart) HOUR), INTERVAL extract(MINUTE from pstart) MINUTE) into startTime;
  SELECT date_add(date_add(pdate, INTERVAL extract(HOUR from pend) HOUR), INTERVAL extract(MINUTE from pend) MINUTE) into endTime;
  SELECT pcourt into court_id;
  SELECT pcustomer into customer_id;
/*
Check if court already be booked
==> PASS : check if customer had more than 3 bookings
*/
START TRANSACTION;
IF EXISTS (SELECT * FROM booking WHERE customer LIKE customer_id AND status IS FALSE)
THEN
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'CB-007';
END IF;
IF EXISTS (SELECT * FROM booked_court WHERE court_id LIKE pcourt)
THEN
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'CB-005';
END IF;
IF ((SELECT COUNT(IF (customer LIKE customer_id,1,NULL)) as COUNT FROM booking) > 3)
THEN
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'CB-006';
END IF;
IF (startTime < DATE(NOW()))
THEN 
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'CB-001';
END IF;
IF  (startTime < openTime )
THEN 
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'CB-002';
END IF;
IF  (endTime > closeTime) 
THEN 
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'CB-003';
END IF;

IF (endTime < startTime)
THEN 
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'CB-004';
END IF;
INSERT INTO booking(booking_id, booking_date, valid_from, valid_to, court, city_id, centre_id, customer, status) values (pBookingId, pdate, pstart, pend, pcourt, pcity, pcentre, pcustomer, pstatus);
END$$
DELIMITER ;

USE `booking_app`;
DROP procedure IF EXISTS `CreateCityCenter`;
DELIMITER $$
USE `booking_app`$$
CREATE PROCEDURE `CreateCityCenter` (
in centerId char(32),
in cityId  char(32))
BEGIN
	DECLARE exit handler for 50004
    begin
		select concat('Duplicate key (', centerID, ',', cityID,' )') as msg;
    end;
	if exists (select * from court where (court_id like courtId)) then
		signal sqlstate '50004';
    end if;
    insert into sport_centres(centre_id, city_id) values (centerId, cityId);
END$$
DELIMITER ;

USE `booking_app`;
DROP procedure IF EXISTS `CreatePlayer`;
DELIMITER $$
USE `booking_app`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CreatePlayer`(
in playerId char(32))
BEGIN
	declare exit handler for 50006
    begin
		select concat('Duplicate key (', playerId,') occured') as msg;
    end;
    if exists (select * from customer where (customer_id like playerId)) then
		signal sqlstate '50006';
    end if;
    insert into customer(customer_id) values (playerId);
END$$
DELIMITER ;

USE `booking_app`;
DROP procedure IF EXISTS `CreateStaff`;
DELIMITER $$
USE `booking_app`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateStaff`(
in staffId char(32),
in cityId char(32),
in centerId char(32))
BEGIN
	declare exit handler for sqlstate '50007' 
    begin
		select concat('Duplicate key (', staffId, ') occurred') as msg;
    end;
    declare exit handler for sqlstate '50003' 
    begin
		select concat('City id (', cityID, ') not exists') as msg;
    end;
    declare exit handler for sqlstate '50005' 
    begin
		select concat('Centre id (',centerID, ') not exists') as msg;
    end;
    if not exists (select * from cities where (city_id not like cityId)) then
		signal sqlstate '50003';
    end if;
	if not exists (select * from sport_centres where (centre_id not like centerId)) then
		signal sqlstate '50005';
    end if;
    if exists (select * from staff where (staff_id like staffId)) then
		signal sqlstate '50007';
    end if;
    insert into staff(staff_id, city_id, centre_id) values (staffId, cityId, centreId);
END$$
DELIMITER ;

USE `booking_app`;
DROP procedure IF EXISTS `CreateCityCenterCourt`;
DELIMITER $$
USE `booking_app`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateCityCenterCourt`(
in courtId char(32),
in cityId char(32),
in centerId char(32))
BEGIN
	declare exit handler for sqlstate '50003' 
    begin
		select concat('City id (', cityId, ') does not exists') as msg;
    end;
	declare exit handler for sqlstate '50005'  
    begin
		select concat('Center id (', centerId, ') does not exists') as msg;
    end;
	declare exit handler for sqlstate '50004'  
    begin
		select concat('Duplicate key  (', courtId, ') occurred') as msg;
    end;
    if not exists (select * from cities where (city_id not like cityId)) then
		signal sqlstate '50003';
    end if;
	if not exists (select * from sport_centres where (centre_id not like centerId)) then
		signal sqlstate '50005';
    end if;
	if exists (select * from court where (court_id like courtId)) then
		signal sqlstate '50004';
    end if;
	insert into court(court_id, centre_id, city_id) values (courtId, centerID, cityID);
END$$
DELIMITER ;

USE `booking_app`;
DROP procedure IF EXISTS `CancelBooking`;
DELIMITER $$
USE `booking_app`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CancelBooking`(
in bookingId char(32),
in playerId char(32))
BEGIN
	declare exit handler for sqlstate '50006'
    begin
		select concat('Player ID (', playerId, ') does not exists') as msg;
    end;
	declare exit handler for sqlstate '50012'
    begin
		select concat('Booking ID (', bookingId, ') does not exists') as msg;
    end;
	declare exit handler for sqlstate '50015' 
    begin
		select concat('Booking ID (', bookingId, ') does not belong to Player ID (', playerId,')') as msg;
    end;
    if exists (select * from booking where (booking_id like bookingId and customer not like playerId)) then
		signal sqlstate '50015';
	end if;
	if not exists (select * from booking where (booking_id like bookingId)) then 
      signal sqlstate '50012';
      end if;
	if not exists (select * from customer where (customer_id like playerId)) then
		signal sqlstate '50006';
    end if;
    delete from booked_court where booking_id=bookingId;
    delete from booking where booking_id like bookingId and customer like playerId;
END$$
DELIMITER ;

USE `booking_app`;
DROP procedure IF EXISTS `UpdateBookingStatus`;
DELIMITER $$
USE `booking_app`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateBookingStatus`(
in status bit,
in bookingId char(32),
in centreId char(32),
in cityId char(32),
in staffId char(32))
BEGIN
	declare exit handler for sqlstate '50014'
    begin
		select concat('Staff ID (', staffId, ') does not exists') as msg;
    end;
	declare exit handler for sqlstate '50012'
    begin
		select concat('Booking ID (', bookingId, ') does not exists') as msg;
    end;
	declare exit handler for sqlstate '50003'  
    begin
		select concat('City ID (', cityId, ') does not exists') as msg;
    end;
    declare exit handler for sqlstate '50005'
    begin
		select concat('Centre ID (', centreId, ') does not exists') as msg;
    end;
    declare exit handler for sqlstate '50016'
    begin
		select concat('Staff ID (', staffId, ') does not supervise the centreID(',centreId,') at cityID(',cityId,')') as msg;
    end;
    declare exit handler for sqlstate '50013'
    begin
		select concat('Wrong format of status = ',status) as msg;
    end;
    declare exit handler for sqlstate '50017'
    begin
		select concat('Mismatch information between bookingId(',bookingId,') cityId(',cityId,') and centreId(',centreId,')') as msg;
    end;
    if not exists (select * from staff where (staff_id like staffId and centre_id like centreId and city_id like cityId)) then
		signal sqlstate '50016';
	end if;
    if (status!=0 and status!=1) then
		signal sqlstate '50013';
	end if;
    if not exists (select * from booking where (booking_id like bookingId)) then 
      signal sqlstate '50012';
      end if;
    if not exists (select * from booking where (booking_id like bookingId and city_id like cityId and centre_id like centre_id)) then
		signal sqlstate '50017';
    end if;
    if not exists (select * from staff where (staff_id not like staffId)) then
		signal sqlstate '50014';
    end if;
	if not exists (select * from cities where (city_id not like cityId)) then
		signal sqlstate '50003';
    end if;
	if not exists (select * from sport_centres where (centre_id not like centreId)) then
		signal sqlstate '50005';
    end if;
    update booking set status=status where booking_id like bookingId;
END$$
DELIMITER ;




/* Scenario */
INSERT INTO cities (city_id) values ('CITY#1');
insert into Sport_Centres(centre_id, city_id) values ('Centre#1', 'CITY#1');
INSERT INTO Court (court_id, centre_id, city_id) values ('Court#1','Centre#1', 'CITY#1');
INSERT INTO Court (court_id, centre_id, city_id) values ('Court#2','Centre#1', 'CITY#1');
INSERT INTO Staff(staff_id, city_id, centre_id) VALUES('STAFF#1', 'CITY#1', 'Centre#1');

INSERT INTO  cities (city_id) values ('CITY#2');
insert into Sport_Centres(centre_id, city_id) values ('Centre#2', 'CITY#2');
INSERT INTO Staff(staff_id, city_id, centre_id) VALUES('STAFF#2', 'CITY#2', 'Centre#2');
INSERT INTO Court (court_id, centre_id, city_id) values ('Court#3','Centre#2', 'CITY#2');
INSERT INTO Court (court_id, centre_id, city_id) values ('Court#4','Centre#2', 'CITY#2');


INSERT INTO Customer (customer_id) values ('079097002545');
INSERT INTO Customer (customer_id) values ('079097002543');
INSERT INTO Customer (customer_id) values ('079097002541');


-- Tests 
call CreateBooking('Booking#1',DATE(now()), '2020-05-30 15:00:00', '2020-05-30 19:00:00', 'Court#1','CITY#1','Centre#1','079097002545', 1); -- paid
/*call CreateBooking('2020-01-01 13:54:00', '2020-03-30 15:00:00', '2020-03-30 19:00:00', 'Court#1', 'Customer#A', 'Booking#2', 1); -- expected: CB-005 / / court already been booked

call CreateBooking('2020-01-01', '2020-03-30 15:00:00', '2020-03-30 19:00:00', 'Court#1', 'Customer#A', 'Booking#3', 1); -- paid
call CreateBooking('2020-03-31', '2020-03-30 15:00:00', '2020-03-30 19:00:00', 'Court#2', 'Customer#A', 'Booking#4', 1);  -- expected: CB-001 / / start time before day book   
call CreateBooking('2020-01-01', '2020-03-30 04:00:00', '2020-03-30 14:00:00', 'Court#2', 'Customer#A', 'Booking#5', 1); -- expected: CB-002 / / start time less than open time

call CreateBooking('2020-01-01', '2020-03-30 20:00:00', '2020-03-30 22:00:00', 'Court#2', 'Customer#A', 'Booking#6', 1);  -- expected: CB-003 / / end time after close time
call CreateBooking('2020-01-01', '2020-03-30 20:00:00', '2020-03-30 19:00:00', 'Court#2', 'Customer#A', 'Booking#7', 1);  -- expected: CB-004 / / end time before start time

call CreateBooking('2020-01-01 13:56:00', '2020-03-30 15:00:00', '2020-03-30 19:00:00', 'Court#2', 'Customer#A', 'Booking#8', 1); -- paid
call CreateBooking('2020-01-01 13:58:00', '2020-03-30 15:00:00', '2020-03-30 19:00:00', 'Court#3', 'Customer#A', 'Booking#9', 0); -- unpaid
call CreateBooking('2020-01-01 13:59:00', '2020-03-30 15:00:00', '2020-03-30 19:00:00', 'Court#4', 'Customer#A', 'Booking#10', 0); -- unpaid
   -- expected: CB-006 / / customer had more than 3 active booking currently 
   
call CreateBooking('2020-03-31 13:59:00', '2020-04-01 15:00:00', '2020-03-30 19:00:00', 'Court#4', 'Customer#A', 'Booking#11', 1);
   -- expected: CB-007 / / customer had equal or more than 1 unpaid booking in the past */
call UpdateBookingStatus(1,'Booking#2','Centre#1','CITY#1','STAFF#1')