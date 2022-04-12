CREATE DATABASE booking_app;
USE booking_app;

DROP TABLE IF EXISTS Customer;
CREATE TABLE Customer(
  customer_id char(32) NOT NULL PRIMARY KEY,
  name varchar(50) NOT NULL UNIQUE,
  phone varchar(12) NOT NULL
);

DROP TABLE IF EXISTS Cities;
CREATE TABLE Cities(
  city_id char(32) NOT NULL PRIMARY KEY,
  name varchar(50) NOT NULL
);

DROP TABLE IF EXISTS Sport_Centres;
CREATE TABLE Sport_Centres(
   centre_id char(32) NOT NULL PRIMARY KEY,
   city_id char(32) NOT NULL,
   mgr_id char(32) NOT NULL,
   mgr_date DATETIME NOT NULL, --staff in charge (working period for specific staff)
   name varchar(50),
   address varchar(100),
   CONSTRAINT centre_staffID_fk FOREIGN KEY (mgr_id) REFERENCES Staff(staff_id),
   CONSTRAINT centre_cityID_fk FOREIGN KEY (city_id) REFERENCES Cities(city_id)
);

DROP TABLE IF EXISTS Staff;
CREATE TABLE Staff(
    staff_id char(32) NOT NULL PRIMARY KEY,
    name varchar(50) NOT NULL,
    phonenumber varchar(12) NOT NULL
);

DROP TABLE IF EXISTS Court;
CREATE TABLE Court(
   court_id char(32) NOT NULL PRIMARY KEY,
   centre_id char(32) NOT NULL,
   courtname varchar(50) NOT NULL UNIQUE,
   status boolean DEFAULT null, -- 0:booked, 1:available
   CONSTRAINT court_centreID_fk 
      FOREIGN KEY (centre_id) REFERENCES Sport_Centres(centre_id)
);

DROP TABLE IF EXISTS Booking;
CREATE TABLE Booking(
  booking_id char(32) NOT NULL PRIMARY KEY,
  booking_date timestamp NOT NULL,
  valid_from DATETIME NOT NULL,
  valid_to DATETIME NOT NULL,
  court char(32) NOT NULL,
  customer char(32) NOT NULL,
  status BOOLEAN default null ,
  CONSTRAINT customer_fk 
      FOREIGN KEY (customer) REFERENCES Customer (customer_id),
  CONSTRAINT court_fk
      FOREIGN KEY (court) REFERENCES Court(court_id)
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



DROP PROCEDURE IF EXISTS CreateBooking;
DELIMITER //
CREATE PROCEDURE CreateBooking(
in pdate DATETIME, 
in pstart DATETIME, 
in pend DATETIME, 
in pcourt char(32), 
in pcustomer char(32),
BEGIN

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

SELECT 
  date_add(date_add(pdate, INTERVAL 7 HOUR), INTERVAL 0 MINUTE)
  into openTime;
SELECT 
  date_add(date_add(pdate, INTERVAL 21 HOUR), INTERVAL 0 MINUTE)
  into closeTime;  
SELECT 
  date_add(date_add(pdate, INTERVAL  SELECT extract(HOUR from pstart) HOUR), INTERVAL SELECT extract(MINUTE from pstart) MINUTE)
  into startTime;
SELECT 
  date_add(date_add(pdate, INTERVAL SELECT extract(HOUR from pend) HOUR), INTERVAL SELECT extract(MINUTE from pend) MINUTE)
  into endTime;
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
END IF
IF EXISTS (SELECT * FROM booked_court WHERE court_id LIKE court)
THEN
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'CB-005';
END IF;
IF COUNT(IF (SELECT * FROM booking WHERE customer LIKE customer_id) > 3
THEN
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'CB-006';
END IF;
IF EXISTS
IF startTime < DATE(NOW())
THEN 
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'CB-001';
END IF;
IF  startTime < openTime 
THEN 
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'CB-002';
END IF;
IF  endTime > closeTime 
THEN 
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'CB-003';
END IF;

IF endTime < startTime 
THEN 
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'CB-004';
END IF;
END //
DELIMITER ;

/* Scenario */
INSERT INTO  cities (city_id, name) values ('CITY 1', 'CITY 1');
INSERT INTO Staff(staff_id, name, phonenumber) VALUES('STAFF 1', 'STAFF 1', '+84925589532');
insert into Sport_Centres(centre_id, city_id, mgr_id, mgr_date, name, address) values ('Centre#1', 'CITY 1', 'STAFF 1','03-03-2020 19:19:19', 'centre 1', '123 abc street');
INSERT INTO Court (court_id, centre_id, courtname) values ('Court#1','Centre#1','Court#1');
INSERT INTO Court (court_id, centre_id, courtname) values ('Court#2','Centre#1','Court#2');

INSERT INTO  cities (city_id, name) values ('CITY 2', 'CITY 2');
INSERT INTO Staff(staff_id, name, phonenumber) VALUES('STAFF 2', 'STAFF 2', '+84925589532');
insert into Sport_Centres(centre_id, city_id, mgr_id, mgr_date, name, address) values ('Centre#2', 'CITY 2', 'STAFF 2','03-03-2020 19:19:19', 'centre 2', '123 abc street');
INSERT INTO Court (court_id, centre_id, courtname) values ('Court#3','Centre#2','Court#3');
INSERT INTO Court (court_id, centre_id, courtname) values ('Court#4','Centre#2','Court#4');


INSERT INTO Customer (customer_id, name, phone) values ('079097002545','Customer#A','+84123456789');
INSERT INTO Customer (customer_id, name, phone) values ('079097002543','Customer#B','+84123465789');
INSERT INTO Customer (customer_id, name, phone) values ('079097002541','Customer#C','+84123475689');





/* Tests */
--Case 1
call CreateBooking('2020-01-01 13:53:59', '2020-03-30 15:00:00', '2020-03-30 19:00:00', 'Court#1', 'Customer#A'); -- paid
call CreateBooking('2020-01-01 13:54:00', '2020-03-30 15:00:00', '2020-03-30 19:00:00', 'Court#1', 'Customer#A');  /* expected: CB-005 / / court already been booked */

--Case 2   
call CreateBooking('2020-01-01', '2020-03-30 15:00:00', '2020-03-30 19:00:00', 'Court#1', 'Customer#A');-- paid
call CreateBooking('2020-03-31', '2020-03-30 15:00:00', '2020-03-30 19:00:00' 'Court#2', 'Customer#A');   /* expected: CB-001 / / start time before day book */   
call CreateBooking('2020-01-01', '2020-03-30 04:00:00', '2020-03-30 14:00:00', 'Court#2', 'Customer#A');/* expected: CB-002 / / start time less than open time */

call CreateBooking('2020-01-01', '2020-03-30 20:00:00', '2020-03-30 22:00:00', 'Court#2', 'Customer#A'); /* expected: CB-003 / / end time after close time */
call CreateBooking('2020-01-01', '2020-03-30 20:00:00', '2020-03-30 19:00:00', 'Court#2', 'Customer#A'); /* expected: CB-004 / / end time before start time */

--Case 3:
call CreateBooking('2020-01-01 13:56:00', '2020-03-30 15:00:00', '2020-03-30 19:00:00', 'Court#2', 'Customer#A'); -- paid
call CreateBooking('2020-01-01 13:58:00', '2020-03-30 15:00:00', '2020-03-30 19:00:00', 'Court#3', 'Customer#A'); -- unpaid
call CreateBooking('2020-01-01 13:59:00', '2020-03-30 15:00:00', '2020-03-30 19:00:00', 'Court#4', 'Customer#A'); --unpaid
   /* expected: CB-006 / / customer had more than 3 active booking currently */
   
call CreateBooking('2020-03-31 13:59:00', '2020-04-01 15:00:00', '2020-03-30 19:00:00', 'Court#4', 'Customer#A');
   /* expected: CB-007 / / customer had equal or more than 1 unpaid booking in the past */

