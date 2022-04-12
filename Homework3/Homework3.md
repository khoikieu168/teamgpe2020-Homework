Player side

1. Test booking
   * Success : Popup shown Booking Successful
   * Fail : Any other error code
2. Test cancel booking

* Success : Popup shown Booking Cancelled

3. Test get Booking info
   * Success : Popup that contain the exact booking info for the inputted booking id
4. Test getAvailableSlot
   * Success : Popup that contain the available time slot for the input courtID and centreID and user can make a booking for that time slot
5. Test getPlayerBooking
   * Success : Popup that contain the info of booking for inputted playerID and user can cancel any booking that satisfy the rule ( does not cancel within 24 hours before the deadline)

Staff side

1. Test getBookingForDate
   * Success : Popup that contain the info booking for the inputted date 
2. Test getBookingInfo
   * Success : Popup that contain the info booking for the selected bookingID and staff can change the status of the selected booking
3. Test changeBookingStatus
   * Success : Popup that show the info of the booking and allow user to change the status of it





***Presentation - Logic interface***

getAvailableSlots

* Description: for a given day, cityId and centre id, get all the slots available:
* security/caller: anonymous
* request: getSlots(day, cityId, centreId)
* response : 
  * success: if the request is approved, the return will be a struct that contain success code and a ArrayList<String> that contain the id of the available court
  * error: if fail
    * the server will return a struct also that contain fail code and a null ArrayList<String>

getPlayerBookings

* Description: for a given day, city, and playerId, get all the bookings:
* security/caller: st
* request: getPlayerBookings(playerId, date, city)
* response:
  * success: SuccessCode + array of (centreId, venueBookings), where venueBookings is an array of (venueID, courtBookings), where courtBookings is an array of (courtID, bookings), where bookings is an array of (Start hour, End hour)
  * error: if fail
    * the return will be a struct that contain an error code and a string message that indicate the cause

getVenueBookings

* Description: for a given day and venueId get all the bookings:
* security/caller: staff
* request: getVenueBookings(day, venueId)
* response:
  * success: true + array of (courtId, bookings), where bookings is an array of (startHour, endHour)
  * error: if fail
    * 400 Bad Request if the input is in wrong format 
    * 204 No Content if either venueID or day does not appear in the DB

createBooking

* Description: for a given day, court, start, end, and playerId, create a new booking.
* security/caller: callerId
* request: createBooking(day, courtId, start, end, playerId)
* response:
  * success: success code + array of string that containt booking id and booking information
  * error: if fail
    * 500 Internal Server Error : when the request slot is not available

cancelBooking

* Description: for a given bookingId, cancel the booking
* security/caller: badmintonPlayer
* request: cancelBooking(bookingId)
* response:
  * success: success code
  * error: 
    * 403 Forbiden : if the user try to either cancel the booking that does not exists or cancel after the deadline
    * 400 Bad request : if the bookingID does not valid

getBookingInfo

* Description: for a given bookingId, get all the booking's information: cityId, venueId, courtId, day, start, end, playerId, statusId.
* security/caller: staff
* request: getBookingInfo(bookingId)
* response:
  * success: success code + a array of String that contains the booking's information
  * error: if fail
    * 404 Not found : the booking can not be found in the DB

updateBookingPaymentStatus

* Description: for a given bookingId, update the booking's payment status
* security/caller: staff
* request: updateBookingPaymentStatus(bookingId, statusId)
* response:
  * success: Success code + status updated
  * error: 
    * 409 Conflict : when multiple staff try to modify the same booking
    * 503 Service Unavailable : The server cannot handle the request (because it is overloaded or down for maintenance). Generally, this is a temporary state.

getNameCity/getNameVenue/getNameCourt/getNameUser

* Description: for a given cityId/venueId/courtId/userId, get the corresponding name (to display)

* security/caller: callerId

* request: getNameCity(cityId)/getNameVenue(venueId)/getNameCourt(courtId)/getNameUser(userId)

* response:

  * success: success code + name of the cityId/venueId/courtId/userId

  * error: if fail 

    * 400 Bad request : if the input id is not in the valid format
    * 503 Service unavailable : The server cannot handle the request (because it is overloaded or down for maintenance). Generally, this is a temporary state.

    

***Logic - Data interface***

insertToTable

* Description : insert data to a table that match tableName, use when customer want to make a booking
* Caller : anonymous
* Request : insert(tableNames, HashMap<String,String> values)
* Response : 
  * success : success code
  * error : if fail 
    * 400 Bad request : if the parameter is not in valid syntax
    * 404 Not found : when the tableNames does not appear in the DB

update

* Description : update a specific row in a table, use when staff want to change the status of booking, when customer make a booking, we also use this interface to update the value of the status of the court to booked

* Caller : staff, player

* Request : (tableName, HashMap<String,String> values)

* Response : 

  * success : success code

  * error :  

    * 400 Not found : when the tableName does not appear in the DB

    * 409 Conflict : when multiple staff modify the same row at the same time

retrieve

* Description : use when system want to get data from table
* Caller : callerID, anonymous
* Request : getData(String tableName, String tableColumn, Condition condition)
* Response : 
  * success : HashMap<String,String> : a map  that get collumn name as key and row value as value 
  * error : if fail the result will be null indicate

joinTable 

* Description : This interface use when system want to select data from multiple value that contain the same collumn so that system can join 2 table with specific condition. Rarely use
* Caller : system
* Request : joinTable(String table1, String table2, String joinType, Condition condition)
* Response : 
  * success : HashMap<String,String[]> : a map that get collumn of a joined table as key and row of joined table as value. Because the  return is table so that value of each key is a array of string 
  * error : 204 No Content