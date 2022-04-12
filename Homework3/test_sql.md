/* test 1 */

CALL createCity ("city*1");

/* error cc00 */ 
___
/* test 2 */

CALL createCity ("city1");

CALL createCity ("city1");

/* error  cc01 */  
___
/* test 3 */

CALL createCity ("city1");

CALL createCityCenter ("center#1", "city1");

CALL createCityCenter ("center1", "city#1");

/* error cc00 */ 
___
/* test 4 */

CALL createCity ("city1");

CALL createCityCenter ("center1", "city1");

CALL createCityCenter ("center1", "city1");

/* error cc02 */ 
___
/* test 5 */

CALL createCity ("city1");

CALL createCityCenter ("center1", "city2");

/* error cc03 */
___
/* test 6 */

CALL createCity ("city1");

CALL createCityCenter ("center1", "city1");

CALL createCityCenterCourt ("court#1", "city1", "center1");

CALL createCityCenterCourt ("court1", "city#1", "center1");

CALL createCityCenterCourt ("court1", "city1", "center#1");

/* error cc00 */
___
/* test 7 */

CALL createCity ("city1");

CALL createCityCenter ("center1", "city1");

CALL createCityCenterCourt ("court1", "city1", "center1");

CALL createCityCenterCourt ("court1", "city1", "center1");

/* error cc04*/
___
/* test 8, 9 */

CALL createCity ("city1");

CALL createCityCenter ("center1", "city1");

CALL createCityCenterCourt ("court1", "city2", "center1");

CALL createCityCenterCourt ("court1", "city1", "center2");

/* error cc03 */

/* error cc05 */
___
/* test 10 */

CALL createPlayer ("player#1");

/* error cc00 */
___
/* test 11 */

CALL createPlayer ("player1");

CALL createPlayer ("player1");

/* error cc06*/
___
/* test 12 */

CALL createCity ("city1");

CALL createCityCenter ("center1", "city1");

CALL createStaff ("staff$1", "city1", "center1");

CALL createStaff ("staff1", "city@1", "center1");

CALL createStaff ("staff1", "city1", "center%1");

/* error cc00 */
___
/* test 13 */

CALL createCity ("city1");

CALL createCityCenter ("center1", "city1");

CALL createStaff ("staff1", "city1", "center1");

CALL createStaff ("staff1", "city1", "center1");

/* error cc07 */
___
/* test 14, 15 */

CALL createCity ("city1");

CALL createCityCenter ("center1", "city1");

CALL createStaff ("staff1", "city2", "center1");

CALL createStaff ("staff1", "city1", "center2");

/* error cc03 */

/* error cc05 */
___
/* test 16 */

CALL createCity ("city1");

CALL createCityCenter ("center1", "city1");

CALL createCityCenterCourt ("court1", "city1", "center1");

CALL createPlayer ("player1");

CALL createBooking ("book#1", "2020-04-04 08:00:01", "2020-04-06 09:00:00", "2020-04-06 11:00:00", "city1", "center1", "court1", "player1");

/* error cc00 */
___
/* test 17 */

CALL createCity ("city1");

CALL createCityCenter ("center1", "city1");

CALL createCityCenterCourt ("court1", "city1", "center1");

CALL createPlayer ("player1");

CALL createBooking ("book1", "2020-04-31 25:00:01", "2020-15-06 09:00:00", "2020-15-06 31:00:00", "city1", "center1", "court1", "player1");

/* error cc08 */
___
/* test 18, 19, 20, 21 */

CALL createCity ("city1");

CALL createCity ("city2");

CALL createCityCenter ("center1", "city1");

CALL createCityCenter ("center2", "city2");

CALL createCityCenterCourt ("court1", "city1", "center1");

CALL createCityCenterCourt ("court2", "city2", "center2");

CALL createPlayer ("player1");

CALL createPlayer ("player2");

CALL createBooking ("book1", "2020-04-04 08:00:01", "2020-04-06 09:00:00", "2020-04-06 11:00:00", "city2", "center1", "court1", "player1");

CALL createBooking ("book1", "2020-04-04 08:00:01", "2020-04-06 09:00:00", "2020-04-06 11:00:00", "city1", "center2", "court1", "player1");

CALL createBooking ("book1", "2020-04-04 08:00:01", "2020-04-06 09:00:00", "2020-04-06 11:00:00", "city1", "center1", "court2", "player1");

CALL createBooking ("book1", "2020-04-04 08:00:01", "2020-04-06 09:00:00", "2020-04-06 11:00:00", "city1", "center2", "court2", "player2");

/* error cc17 */
___
/* test 22, 23, 24 */

CALL createCity ("city1");

CALL createCityCenter ("center1", "city1");

CALL createCityCenterCourt ("court1", "city1", "center1");

CALL createPlayer ("player1");

CALL createBooking ("book1", "2020-04-04 08:00:01", "2020-03-31 09:00:00", "2020-03-31 11:00:00", "city1", "center1", "court1", "player1");

CALL createBooking ("book1", "2020-04-04 08:00:01", "2020-04-06 06:00:00", "2020-04-06 22:00:00", "city1", "center1", "court1", "player1");

CALL createBooking ("book1", "2020-04-04 08:00:01", "2020-04-06 12:00:00", "2020-04-06 09:00:00", "city1", "center1", "court1", "player1");

/* error cc11 */
___
/* test 25 */

CALL cancelBooking ("book$1", "player^1");

/* error cc00 */
___
/* test 26 */

CALL cancelBooking ("book1", "player1");

/* error cc12 */
___
/* test 27 */

CALL createCity ("city1");

CALL createCityCenter ("center1", "city1");

CALL createStaff ("staff1", "city1", "center1");

CALL createCityCenterCourt ("court1", "city1", "center1");

CALL createPlayer ("player1");

CALL createBooking ("book1", "2020-04-04 08:00:01", "2020-04-04 09:00:00", "2020-04-04 11:00:00", "city1", "center1", "court1", "player1");

CALL updateBookingStatus (2, "book%1", "city^1", "center&1", "staff*1");

/* error cc13 */

/* error cc00 */
___
/* test 28 */

CALL createCity ("city1");

CALL createCityCenter ("center1", "city1");

CALL createCityCenter ("center2", "city1");

CALL createStaff ("staff1", "city1", "center1");

CALL createStaff ("staff2", "city1", "center2");

CALL createCityCenterCourt ("court1", "city1", "center1");

CALL createPlayer ("player1");

CALL createBooking ("book1", "2020-04-04 08:00:01", "2020-04-04 09:00:00", "2020-04-04 11:00:00", "city1", "center1", "court1", "player1");

CALL updateBookingStatus(1, "book1", "city1", "center1", "staff2");

/* error cc16 */
___
/* test 29 */

CALL createCity ("city1");

CALL createCityCenter ("center1", "city1");

CALL createCityCenterCourt ("court1", "city1", "center1");

CALL createPlayer ("player1");

CALL createStaff ("staff1", "city1", "center1");

CALL createBooking ("book1", DATE(NOW()), "2020-04-07 09:00:00", "2020-04-07 11:00:00", "city1", "center1", "court1", "player1");

CALL updateBookingStatus (1, "book1", "city1", "center1", "staff1");


/* Staff1 changes the status of booking1 to paid */
___
/* test 30 */

CALL createCity ("city1");

CALL createCityCenter ("center1", "city1");

CALL createCityCenterCourt ("court1", "city1", "center1");

CALL createPlayer ("player1");

CALL createBooking ("book1", "2020-04-04 08:00:01", "2020-04-06 09:00:00", "2020-04-06 11:00:00", "city1", "center1", "court1", "player2");

/* error cc10 */
___
/* test 31 */

CALL createCity ("city1");

CALL createCityCenter ("center1", "city1");

CALL createCityCenterCourt ("court1", "city1", "center1");

CALL createPlayer ("player1");

CALL createBooking ("book1", DATE(NOW()), "2020-04-08 09:00:00", "2020-04-07 11:00:00", "city1", "center1", "court1", "player1");

/* error cc09 */
___
/* test 32 */

CALL createCity ("city1");

CALL createCityCenter ("center1", "city1");

CALL createStaff ("staff1", "city1", "center1");

CALL createCityCenterCourt ("court1", "city1", "center1");

CALL createPlayer ("player1");

CALL createBooking ("book1", "2020-04-04 08:00:01", "2020-04-04 09:00:00", "2020-04-04 11:00:00", "city1", "center1", "court1", "player1");

CALL updateBookingStatus(1, "book1", "city1", "center1", "staff2");

/* error cc14 */
___
/* test 33 */

CALL createCity ("city1");

CALL createCity ("city2");

CALL createCityCenter ("center1", "city1");

CALL createCityCenter ("center2", "city2");

CALL createStaff ("staff1", "city1", "center1");

CALL createStaff ("staff2", "city2", "center2");

CALL createCityCenterCourt ("court1", "city1", "center1");

CALL createCityCenterCourt ("court2", "city2", "center2");

CALL createPlayer ("player1");

CALL createPlayer ("player2");

CALL createBooking ("book1", "2020-04-04 08:00:01", "2020-04-04 09:00:00", "2020-04-04 11:00:00", "city1", "center1", "court1", "player1");

CALL createBooking ("book2", "2020-04-04 08:00:01", "2020-04-04 09:00:00", "2020-04-04 11:00:00", "city2", "center2", "court2", "player2");

CALL cancelBooking("book2", "player1");

/* error cc15 */
___
/* test 34 */

CALL createCity ("city1");

CALL createCityCenter ("center1", "city1");

CALL createCityCenterCourt ("court1", "city1", "center1");

CALL createPlayer ("player1");

CALL createBooking ("book1", "2020-04-07 08:00:01", "2020-04-10 09:00:00", "2020-04-10 11:00:00", "city1", "center1", "court1", "player1");

CALL createBooking ("book1", "2020-04-07 09:00:01", "2020-04-10 13:00:00", "2020-04-10 17:00:00", "city1", "center1", "court1", "player1");

/* error cc18 */
