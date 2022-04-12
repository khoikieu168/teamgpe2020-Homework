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
    city_id char(32) NOT NULL,
	centre_id char(32) NOT NULL,
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



USE booking_app;
DROP procedure IF EXISTS CreateCity;
DELIMITER $$
USE `booking_app`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateCity`(
in cityId char(32))
BEGIN
    declare exit handler for sqlstate '50001' 
    begin
		select concat('Error CC001:   City id (', cityID, ') already exists') as msg;
    end;
    declare exit handler for sqlstate '50000'
    begin 
		select concat('Error CC000:   Wrong ID Format') as msg;
    end;
    if not (cityId regexp '^[A-Za-z0-9]+$') then 
		signal sqlstate '50000';
    end if;
    if exists (select * from cities where city_id like cityId) then
		signal sqlstate '50001';
	end if;
    insert into cities(city_id) values (cityId);
END$$
DELIMITER ;




USE booking_app;
DROP procedure IF EXISTS CreateCityCenter;
DELIMITER $$
USE `booking_app`$$
CREATE PROCEDURE CreateCityCenter (
in centerId char(32),
in cityId  char(32))
BEGIN
	DECLARE exit handler for sqlstate '50002'
    begin
		select concat('Error CC002:   Duplicate key (', centerID, ',', cityID,' )') as msg;
    end;
    declare exit handler for sqlstate '50000'
    begin 
		select concat('Error CC000:   Wrong ID Format') as msg;
    end;
	declare exit handler for sqlstate '50003' 
    begin
		select concat('Error CC003:   City id (', cityID, ') not exists') as msg;
    end;
    /*declare exit handler for sqlstate '50001'
    begin
		select concat('Error CC001: Duplicate key (', cityID,')') as msg;
    end;*/
    if not (cityId regexp '^[A-Za-z0-9]+$') then 
		signal sqlstate '50000';
    end if;
    if not (centerId regexp '^[A-Za-z0-9]+$') then 
		signal sqlstate '50000';
    end if;
    if not exists (select * from cities where (city_id like cityId)) then
		signal sqlstate '50003';
    end if;
    /*if exists (select * from cities where city_id like cityId) then
		signal sqlstate '50001';
	end if;*/
	if exists (select * from sport_centres where (centre_id like centerID and city_id like cityID)) then
		signal sqlstate '50002';
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
	declare exit handler for sqlstate '50006'
    begin
		select concat('Error CC006:   Duplicate key (', playerId,') occured') as msg;
    end;
    declare exit handler for sqlstate '50000'
    begin 
		select concat('Error CC000:   Wrong ID Format') as msg;
    end;
    if not (playerId regexp '^[A-Za-z0-9]+$') then 
		signal sqlstate '50000';
    end if;    
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
		select concat('Error CC007:   Duplicate key (', staffId, ') occurred') as msg;
    end;
    declare exit handler for sqlstate '50003' 
    begin
		select concat('Error CC003:   City id (', cityID, ') not exists') as msg;
    end;
    declare exit handler for sqlstate '50005' 
    begin
		select concat('Error CC005:   Centre id (',centerID, ') not exists') as msg;
    end;
    declare exit handler for sqlstate '50000'
    begin 
		select concat('Error CC000:   Wrong ID Format') as msg;
    end;
    if not (staffId regexp '^[A-Za-z0-9]+$') then 
		signal sqlstate '50000';
    end if;
    if not (centerId regexp '^[A-Za-z0-9]+$') then 
		signal sqlstate '50000';
    end if;
    if not (cityId regexp '^[A-Za-z0-9]+$') then 
		signal sqlstate '50000';
    end if;
    if not exists (select * from cities where (city_id like cityId)) then
		signal sqlstate '50003';
    end if;
	if not exists (select * from sport_centres where (centre_id like centerId)) then
		signal sqlstate '50005';
    end if;
    if exists (select * from staff where (staff_id like staffId)) then
		signal sqlstate '50007';
    end if;
    insert into staff(staff_id, city_id, centre_id) values (staffId, cityId, centerId);
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
		select concat('Error CC003:   City id (', cityId, ') does not exists') as msg;
    end;
	declare exit handler for sqlstate '50005'  
    begin
		select concat('Error CC005:   Center id (', centerId, ') does not exists') as msg;
    end;
	declare exit handler for sqlstate '50004'  
    begin
		select concat('Error CC004:   Duplicate key  (', courtId, ') occurred') as msg;
    end;
    declare exit handler for sqlstate '50000'
    begin 
		select concat('Error CC000:   Wrong ID Format') as msg;
    end;
    if not (cityId regexp '^[A-Za-z0-9]+$') then 
		signal sqlstate '50000';
    end if;
    if not (centerId regexp '^[A-Za-z0-9]+$') then 
		signal sqlstate '50000';
    end if;
    if not (courtId regexp '^[A-Za-z0-9]+$') then 
		signal sqlstate '50000';
    end if;
    if not exists (select * from cities where (city_id like cityId)) then
		signal sqlstate '50003';
    end if;
	if not exists (select * from sport_centres where (centre_id like centerId)) then
		signal sqlstate '50005';
    end if;
	if exists (select * from court where (court_id like courtId)) then
		signal sqlstate '50004';
    end if;
	insert into court(court_id, city_id, centre_id) values (courtId, cityID, centerID);
END$$
DELIMITER ;




USE booking_app;
DROP procedure IF EXISTS CreateBooking;
DELIMITER $$
USE `booking_app`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateBooking`(
in pBookingId char(32),
in pdate DATETIME,
in pstart DATETIME, 
in pend DATETIME, 
in pcity char(32),
in pcentre char(32),
in pcourt char(32), 
in pcustomer char(32))
BEGIN
  DECLARE bookedTime datetime;
  DECLARE openTime datetime;
  DECLARE closeTime datetime;
  DECLARE startTime datetime;
  DECLARE endTime datetime;
  declare MESSAGE_TEXT varchar(200);
  declare exit handler for sqlstate '50010'
  begin
	select concat('Error CC010: Player ID (', pcustomer,') does not exists') as msg;
  end;
  declare exit handler for sqlstate '50003'
  begin
      select concat('Error CC003:   City ID (', pcity,') does not exists') as msg;
  end;
  declare exit handler for sqlstate '50005'
  begin
      select concat('Error CC005:   Center ID (', pcentre,') does not exists') as msg;
  end;
  declare exit handler for sqlstate '50009'
  begin
      select concat('Error CC009:   Court ID (', pcourt,') does not exists') as msg;
  end;
  declare exit handler for sqlstate '50017'
  begin
      select concat('Error CC017:   Mismatch information between courtID (',pcourt,') , centreID (',pcentre,') and cityID (',pcity,')') as msg;
  end;
  declare exit handler for sqlstate '50011'
  begin
	select concat('Error CC011:   Time error') as msg;
  end;
  declare exit handler for sqlstate '50018'
  begin
    select concat('Error CC018:   Failed player booking condition') as msg;
  end;
  declare exit handler for sqlstate '50000'
  begin 
	select concat('Error CC000:   Wrong ID Format') as msg;
  end;
  if not (pBookingId regexp '^[A-Za-z0-9]+$') then 
	signal sqlstate '50000';
  end if;
  if not (pcity regexp '^[A-Za-z0-9]+$') then 
	signal sqlstate '50000';
  end if;
  if not (pcentre regexp '^[A-Za-z0-9]+$') then 
	signal sqlstate '50000';
  end if;
  if not (pcourt regexp '^[A-Za-z0-9]+$') then 
	signal sqlstate '50000';
  end if;
  if not (pcustomer regexp '^[A-Za-z0-9]+$') then 
	signal sqlstate '50000';
  end if;
  if not exists (select * from cities where(city_id like pcity)) then
	signal sqlstate '50003';
  end if;
  if not exists (select * from sport_centres where (centre_id like pcentre)) then
	  signal sqlstate '50005';
  end if;
  if not exists (select * from court where (court_id like pcourt)) then
      signal sqlstate '50009';
  end if;
  if not exists (select * from customer where customer_id = pcustomer) then
	signal sqlstate '50010';
  end if;
  if not exists (select * from court where (court_id like pcourt and centre_id like pcentre and city_id like pcity)) then
      signal sqlstate '50017';
  end if;
  SELECT date_add(date_add(pstart, INTERVAL -extract(HOUR from pstart) + 7 HOUR), INTERVAL 0 MINUTE) into openTime;
  SELECT date_add(date_add(pstart, INTERVAL -extract(HOUR from pstart) + 22 HOUR), INTERVAL 0 MINUTE) into closeTime;
  SELECT date_add(date_add(pstart, INTERVAL extract(HOUR from pstart) HOUR), INTERVAL extract(MINUTE from pstart) MINUTE) into startTime;
  SELECT date_add(date_add(pend, INTERVAL extract(HOUR from pend) HOUR), INTERVAL extract(MINUTE from pend) MINUTE) into endTime;
  SELECT concat(openTime,' ',closeTime,' ',startTime,' ',endTime) as msg;
	IF EXISTS (SELECT * FROM booking WHERE customer LIKE pcustomer AND status = 0)
	THEN
	   SIGNAL SQLSTATE '50018'
	   SET MESSAGE_TEXT = 'Error CC018:   Customer already had 1 unpaid booking';
	END IF;
	IF EXISTS (SELECT * FROM booking WHERE court LIKE pcourt and (startTime < endTime and 
	((startTime >= valid_From and endTime >= valid_To) or (startTime >= valid_From and endTime <= valid_to) 
	or (startTime <= valid_from and endTime >= valid_to) or (startTime <= valid_from and endTime <= valid_to))))
	THEN
	   SIGNAL SQLSTATE '50018'
	   SET MESSAGE_TEXT = 'Error CC018:   Court already be booked';
	END IF;
	IF ((SELECT COUNT(IF (customer LIKE pcustomer,1,NULL)) as COUNT FROM booking) > 3)
	THEN
	   SIGNAL SQLSTATE '50018'
	   SET MESSAGE_TEXT = 'Error CC018:   Customer had 3 active booking';
	END IF;
-- IF (startTime < DATE(NOW()))
	IF (pstart < pdate)
	THEN 
	   SIGNAL SQLSTATE '50011'
	   SET MESSAGE_TEXT = 'Error CC011:   Start time before current time';
	   SELECT MESSAGE_TEXT AS msg;
	END IF;
	IF  (startTime < openTime )
	THEN 
	   SIGNAL SQLSTATE '50011'
	   SET MESSAGE_TEXT = 'Error CC011:   Start time before open time';
	END IF;
	IF  (endTime > closeTime) 
	THEN 
	   SIGNAL SQLSTATE '50011'
	   SET MESSAGE_TEXT = 'Error CC011:   End time after close time';
	END IF;

	IF (endTime < startTime)
	THEN 
	   SIGNAL SQLSTATE '50011'
	   SET MESSAGE_TEXT = 'Error CC011:   End time after start time';
	END IF;
	INSERT INTO booking(booking_id, booking_date, valid_from, valid_to, court, city_id, centre_id, customer, status) 
		values (pBookingId, pdate, pstart, pend, pcourt, pcity, pcentre, pcustomer, 0);
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
	declare exit handler for sqlstate '50010'
    begin
		select concat('Error CC010:   Player ID (', playerId, ') does not exists') as msg;
    end;
	declare exit handler for sqlstate '50012'
    begin
		select concat('Error CC012:   Booking ID (', bookingId, ') does not exists') as msg;
    end;
	declare exit handler for sqlstate '50015' 
    begin
		select concat('Error CC015:   Booking ID (', bookingId, ') does not belong to Player ID (', playerId,')') as msg;
    end;
    declare exit handler for sqlstate '50000'
	begin 
		select concat('Error CC000:   Wrong ID Format') as msg;
	end;
	if not (bookingId regexp '^[A-Za-z0-9]+$') then 
		signal sqlstate '50000';
	end if;
   	if not (playerId regexp '^[A-Za-z0-9]+$') then 
		signal sqlstate '50000';
	end if;
    if exists (select * from booking where (booking_id like bookingId and customer not like playerId)) then
		signal sqlstate '50015';
	end if;
	if not exists (select * from booking where (booking_id like bookingId)) then 
      signal sqlstate '50012';
      end if;
	if not exists (select * from customer where (customer_id like playerId)) then
		signal sqlstate '50010';
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
in cityId char(32),
in centreId char(32),
in staffId char(32))
BEGIN
	declare exit handler for sqlstate '50014'
    begin
		select concat('Error CC014:   Staff ID (', staffId, ') does not exists') as msg;
    end;
	declare exit handler for sqlstate '50012'
    begin
		select concat('Error CC012:   Booking ID (', bookingId, ') does not exists') as msg;
    end;
	declare exit handler for sqlstate '50003'  
    begin
		select concat('Error CC003:   City ID (', cityId, ') does not exists') as msg;
    end;
    declare exit handler for sqlstate '50005'
    begin
		select concat('Error CC005:   Centre ID (', centreId, ') does not exists') as msg;
    end;
    declare exit handler for sqlstate '50016'
    begin
		select concat('Error CC016:   Staff ID (', staffId, ') does not supervise the centreID(',centreId,') at cityID(',cityId,')') as msg;
    end;
    declare exit handler for sqlstate '50013'
    begin
		select concat('Error CC013:   Wrong format of status = ',status) as msg;
    end;
    declare exit handler for sqlstate '50017'
    begin
		select concat('Error CC017:   Mismatch information between bookingId(',bookingId,') cityId(',cityId,') and centreId(',centreId,')') as msg;
    end;
	declare exit handler for sqlstate '50000'
	begin 
		select concat('Error CC000:   Wrong ID Format') as msg;
	end;
    if (status!=0 and status!=1) then
		signal sqlstate '50013';
	end if;
	if not (bookingId regexp '^[A-Za-z0-9]+$') then 
		signal sqlstate '50000';
	end if;
	if not (cityId regexp '^[A-Za-z0-9]+$') then 
		signal sqlstate '50000';
	end if;
   	if not (centreId regexp '^[A-Za-z0-9]+$') then 
		signal sqlstate '50000';
	end if;
   	if not (staffId regexp '^[A-Za-z0-9]+$') then 
		signal sqlstate '50000';
	end if;
    if not exists (select * from booking where (booking_id like bookingId)) then 
      signal sqlstate '50012';
	end if;
    if not exists (select * from cities where (city_id like cityId)) then
		signal sqlstate '50003';
    end if;
	if not exists (select * from sport_centres where (centre_id like centreId)) then
		signal sqlstate '50005';
    end if;
	if not exists (select * from staff where (staff_id like staffId)) then
		signal sqlstate '50014';
    end if;
	if not exists (select * from staff where (staff_id like staffId and centre_id like centreId and city_id like cityId)) then
		signal sqlstate '50016';
	end if;
    if not exists (select * from booking where (booking_id like bookingId and city_id like cityId and centre_id like centre_id)) then
		signal sqlstate '50017';
    end if;
    update booking set status=status where booking_id like bookingId;
END$$
DELIMITER ;







