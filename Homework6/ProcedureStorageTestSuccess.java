import org.junit.FixMethodOrder;
import org.junit.Test;
import org.junit.runners.MethodSorters;


import static org.junit.Assert.*;

@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class ProcedureStorageTestSuccess {
    //______________createPlayerSuccess______________
    @Test
    public void AcreatePlayerSuccess() {
        //"Create player successfully"
        assertEquals("Create player successfully", ProcedureStorage.createPlayer("playerFox"));
    }

    //______________createCitySuccess_______________
    @Test
    public void BcreateCitySuccess() {
        //"Create city successfully"
        assertEquals("Create city successfully", ProcedureStorage.createCity("cityArwing"));
    }

    //______________createCitySportCenterSuccess____________
    @Test
    public void CcreateCityCenterSuccess() {
        //Create city sport centre successfully
        assertEquals("Create city sport centre successfully"
                , ProcedureStorage.createCityCenter("barrelCenter","cityArwing"));
    }

    //_____________createStaffSuccess_________________
    @Test
    public void DcreateStaffSuccess() {
        //Create staff successfully
        assertEquals("Create staff successfully"
                , ProcedureStorage.createStaff("lylat", "cityArwing", "barrelCenter"));
    }

    //_____________createCityCenterCourtSuccess________________
    @Test
    public void EcreateCityCenterCourtSuccess() {
        //Create court successfully
        assertEquals("Create court successfully"
        , ProcedureStorage.createCityCenterCourt("court3D", "cityArwing", "barrelCenter"));
    }

    //_____________createBookingSuccess_____________________
    @Test
    public void FcreateBookingSuccess() {
        //Create booking successfully
        assertEquals("Create booking successfully"
        , ProcedureStorage.createBooking("123456", "20300303000000", "20300303080000", "20300303090000"
                        , "courtBBQ", "cityX", "logaritCenter","playerFox"));
    }
    //_____________cancelBookingSuccess_____________________

    @Test
    public void GcancelBookingSuccess() {
        //Cancel booking successfully
        assertEquals("Cancel booking successfully"
        , ProcedureStorage.cancelBooking("123456","playerSalad"));
    }

    //_____________updateBookingStatusSuccess_____________

    @Test
    public void HupdateBookingStatusSuccess() {
        //Update booking status successfully
        assertEquals("Update booking status successfully"
        , ProcedureStorage.updateBookingStatus("1","123456","cityX", "logaritCenter"
                , "luffy"));
    }
}