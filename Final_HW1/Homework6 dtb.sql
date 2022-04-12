-- homework 6 database
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
  booking_date date NOT NULL,
  valid_from time NOT NULL,
  valid_to time NOT NULL,
  court char(32) NOT NULL,
  customer char(32) NOT NULL,
  status BOOLEAN default null ,
  CONSTRAINT customer_fk FOREIGN KEY (customer) REFERENCES Customer (customer_id),
  CONSTRAINT court_fk FOREIGN KEY (court) REFERENCES court(court_id));
	

/* DROP TABLE IF EXISTS Booked_Court;
CREATE TABLE Booked_Court(
  booking_id char(32) NOT NULL,
  court_id char(32) NOT NULL,
  CONSTRAINT booked_bookingID_fk
      FOREIGN KEY (booking_id) REFERENCES Booking(booking_id),
  CONSTRAINT booked_courtID_fk 
      FOREIGN KEY (court_id) REFERENCES Court(court_id),
  CONSTRAINT booked_PK PRIMARY KEY (booking_id, court_id)
); */