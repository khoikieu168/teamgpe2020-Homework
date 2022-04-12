import org.junit.Test;

import static org.junit.Assert.*;

public class ProcedureStorageTestFailure {
    //_____________________createPlayerFails_______________
    @Test
    public void createPlayerTestFailure() {
        //"Duplicated playerId occured"
        assertEquals("Duplicated playerId occured", ProcedureStorage.createPlayer("playerX"));
    }

    @Test
    public void createPlayerTestFailureA() {
        //Wrong format, alphanumeric character only
        assertEquals("Wrong format, alphanumeric character only"
                , ProcedureStorage.createPlayer("{}[]"));
    }

    //_____________________createCityFails________________
    @Test
    public void createCityTestFailure() {
        //Duplicated cityId occured
        assertEquals("Duplicated cityId occured", ProcedureStorage.createCity("cityX"));
    }

    @Test
    public void createCityTestFailureA() {
        //Wrong format, alphanumeric character only
        assertEquals("Wrong format, alphanumeric character only"
        , ProcedureStorage.createCity("[]"));
    }

    //____________________createSportCentreFails_____________


    @Test
    public void createCityCenterFailure() {
        //Wrong format, alphanumeric character only
        assertEquals("Wrong format, alphanumeric character only"
        , ProcedureStorage.createCityCenter("++","cityX"));
    }

    @Test
    public void createCityCenterFailureA() {
        //Duplicate centerId occured
        assertEquals(ProcedureStorage.createCityCenter("luigiCenter","cityX")
                , "Duplicate centerId occured");
    }

    @Test
    public void createCityCenterFailureB() {
        //CityId does not exist
        assertEquals("CityId does not exist"
                , ProcedureStorage.createCityCenter("luigiCent", "cityAlpha"));
    }



    //___________________createStaffFails_______________
    @Test
    public void createStaffFailure() {
        //City Id does not exist
        assertEquals("City Id does not exist"
        , ProcedureStorage.createStaff("asd", "kdkd", "marioCenter"));
    }

    @Test
    public void createStaffFailureA() {
        //Centre Id does not exist
        assertEquals("Centre Id does not exist"
        , ProcedureStorage.createStaff("asd", "cityX", "asdf"));
    }

    @Test
    public void createStaffFailureB() {
        //Duplicate staffId occurred
        assertEquals("Duplicate staffId occurred"
        , ProcedureStorage.createStaff("luffy", "cityX", "marioCenter"));
    }

    @Test
    public void createStaffFailureC() {
        //Wrong format, alphanumeric character only
        assertEquals("Wrong format, alphanumeric character only"
        , ProcedureStorage.createStaff("{][]", "cityX", "logaritCenter"));
    }

    @Test
    public void createStaffFailureD() {
        //CenterId does not exist in cityId
        assertEquals("CenterId does not exist in cityId"
        , ProcedureStorage.createStaff("staffDoc", "cityX", "barrelCenter"));
    }
    //_______________createCityCenterCourtFails____________________________

    @Test
    public void createCityCenterCourtFailure() {
        //CityId does not exist
        assertEquals("CityId does not exist"
        , ProcedureStorage.createCityCenterCourt("lalala", "889", "marioCenter"));
    }

    @Test
    public void createCityCenterCourtFailureA() {
        //CenterId does not exist
        assertEquals("CenterId does not exist"
        , ProcedureStorage.createCityCenterCourt("lalala", "cityX", "mamarioCenter"));
    }

    @Test
    public void createCityCenterCourtFailureB() {
        //Duplicate courtId
        assertEquals("Duplicate courtId"
        , ProcedureStorage.createCityCenterCourt("courtA", "cityX", "marioCenter"));
    }

    @Test
    public void createCityCenterCourtFailureC() {
        //Wrong format, alphanumeric character only
        assertEquals("Wrong format, alphanumeric character only"
        , ProcedureStorage.createCityCenterCourt("{}[]", "cityX", "marioCenter"));
    }

    @Test
    public void createCityCenterCourtFailureD() {
        //CenterId does not exist in cityId
        assertEquals("CenterId does not exist in cityId"
        , ProcedureStorage.createCityCenterCourt("courtY8", "cityX", "barrelCenter"));
    }
    //____________________createBookingFails________________________

    @Test
    public void createBookingFailure() {
        //Duplicated bookingId
        assertEquals("Duplicated bookingId"
        , ProcedureStorage.createBooking("123456", "20300303000000", "20300303080000", "20300303090000"
                        , "court3D", "cityX", "logaritCenter","playerFox"));
    }

    @Test
    public void createBookingFailureA() {
        //CustomerId does not exist
        assertEquals("CustomerId does not exist"
        , ProcedureStorage.createBooking("123456", "20300303000000", "20300303080000", "20300303090000"
                        , "court3D", "cityX", "logaritCenter","playerFox"));
    }

    @Test
    public void createBookingFailureB() {
        //CourtId does not exist
        assertEquals("CourtId does not exist"
        , ProcedureStorage.createBooking("123456", "20300303000000", "20300303080000", "20300303090000"
                        , "court3D", "cityX", "logaritCenter","playerFox"));
    }

    @Test
    public void createBookingFailureC() {
        //Customer cannot register in advance when unpaid
        assertEquals("Customer cannot register in advance when unpaid"
        , ProcedureStorage.createBooking("23456", "20300303000000", "20310303080000", "20300303090000"
                        , "courtBBQ", "cityX", "logaritCenter","playerFox"));

    }

    @Test
    public void createBookingFailureD() {
        //Start timestamp of the registration < current timestamp
        assertEquals("Start timestamp of the registration < current timestamp"
        , ProcedureStorage.createBooking("123456", "20300303000000", "20300303080000", "20300303090000"
                        , "court3D", "cityX", "logaritCenter","playerFox"));
    }

    @Test
    public void createBookingFailureE() {
        //Start time of the registration < open time(7) of the court
        assertEquals("Start time of the registration < open time(7) of the court"
        , ProcedureStorage.createBooking("3456", "20300303000000", "20300303060000", "20300303070000"
                        , "courtBBQ", "cityX", "logaritCenter","playerSalad"));
    }

    @Test
    public void createBookingFailureF() {
        //End time of the registration > close time(21) of the court
        assertEquals("End time of the registration > close time(21) of the court"
        , ProcedureStorage.createBooking("123456", "20300303000000", "20300303080000", "20300303090000"
                        , "court3D", "cityX", "logaritCenter","playerFox"));
    }

    @Test
    public void createBookingFailureG() {
        //End time of the registration < start time of the registration
        assertEquals("End time of the registration < start time of the registration"
        , ProcedureStorage.createBooking("123456", "20300303000000", "20300303080000", "20300303090000"
                        , "court3D", "cityX", "logaritCenter","playerFox"));
    }

    @Test
    public void creteBookingFailureH() {
        //Overlap with another booking time
        assertEquals("Overlap with another booking time"
        , ProcedureStorage.createBooking("156", "20300303000000", "20300303080000", "20300303100000"
                        , "courtBBQ", "cityX", "logaritCenter","playerFox"));
    }

    @Test
    public void createBookingFailureI() {
        //Customer cannot register in advance more than 3 slots
        assertEquals("Customer cannot register in advance more than 3 slots"
        , ProcedureStorage.createBooking("123456", "20300303000000", "20300303080000", "20300303090000"
                        , "court3D", "cityX", "logaritCenter","playerFox"));
    }
    //______________CancelBookingFails_____________________________


    @Test
    public void cancelBookingFailureB() {
        //CustomerId does not exist in any bookings
        assertEquals("CustomerId does not exist in any bookings"
                , ProcedureStorage.cancelBooking("23560","playerSalad"));
    }
    @Test
    public void cancelBookingFailureA() {
        //BookingId does not exist
        assertEquals("BookingId does not exist"
        , ProcedureStorage.cancelBooking("12344","playerFox"));
    }


    @Test
    public void cancelBookingFailure() {
        //BookingId does not belong to customerId
        assertEquals("BookingId does not belong to customerId"
                , ProcedureStorage.cancelBooking("123456","playerFox"));
    }
    //_____________updateBookingStatusFails____________________

    @Test
    public void updateBookingStatusFailure() {
        //Wrong status format (0 or 1 only)
        assertEquals("Wrong status format (0 or 1 only)"
        , ProcedureStorage.updateBookingStatus("1","123456","cityX", "logaritCenter"
                        , "luffy"));
    }

    @Test
    public void updateBookingStatusFailureA() {
        //BookingId does not exist
        assertEquals("BookingId does not exist"
        , ProcedureStorage.updateBookingStatus("1","123456","cityX", "logaritCenter"
                        , "luffy"));
    }

    @Test
    public void updateBookingStatusFailureB() {
        //StaffId does not exist
        assertEquals("StaffId does not exist"
        , ProcedureStorage.updateBookingStatus("1","123456","cityX", "logaritCenter"
                        , "luffy"));
    }

    @Test
    public void updateBookingStatusFailureC() {
        //CityId does not exist
        assertEquals("CityId does not exist"
        , ProcedureStorage.updateBookingStatus("0","123456","cityXyz", "logaritCenter"
                        , "luffy"));
    }

    @Test
    public void updateBookingStatusFailureD() {
        //CenterId does not exist
        assertEquals("CenterId does not exist"
        , ProcedureStorage.updateBookingStatus("0","123456","cityX", "logritCenter"
                        , "luffy"));
    }

    @Test
    public void updateBookingStatusFailureE() {
        //CenterId does not exist in cityId
        assertEquals("CenterId does not exist in cityId"
        , ProcedureStorage.updateBookingStatus("0","123456","cityX", "logCenter"
                        , "luffy"));
    }

    @Test
    public void updateBookingStatusFailureF() {
        //StaffId does not work in this centerId
        assertEquals("StaffId does not work in this centerId"
        , ProcedureStorage.updateBookingStatus("0","123456","cityX", "logaritCenter"
                        , "lylat"));
    }
}