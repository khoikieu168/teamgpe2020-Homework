Error lists:

-50000 :  Wrong format for ID

-50001 :  CityID already exist/ not unique

-50002 :  CenterID already exist/ not unique in 1 city  

-50003 :  The city not exist

-50004 :  CourtID already exist/ not unique in 1 city, 1 center

-50005 :  The center not exist

-50006 :  PlayerID already exist/ not unique

-50007 :  StaffID already exist/ not unique in 1 city, 1 center

-50008 :  Wrong format for timestamp/ date/ time

-50009 :  CourtID not exist

-50010 :  PlayerID not exist

-50011 :  Time error
	   - BookingDate < timestamp
	   - startTime < openTime (07:00:00)
	   - endTime > closeTime	
	   - startTime > EndTime
	   - startTime > Time of timestamp when the BookingDate = Date of timestamp

-50012 :  BookingID not exist

-50013 :  Wrong format for status

-50014 :  StaffID not exist
-50015 : BookingID does not belong to PlayerID
-50016 : StaffID does not belong to centreID
-50017 : mismatch information