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