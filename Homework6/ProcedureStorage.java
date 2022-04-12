import java.sql.Connection;
import java.util.Date;
import java.util.HashMap;
import java.util.SortedMap;
import java.util.TreeMap;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;

public class ProcedureStorage {
	private final static int ONE_MILIS = 1000;
	private final static long ONE_HOUR_IN_MILIS = 60 * 60 * ONE_MILIS;
    public static Statement statementCreate(){
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager
                    .getConnection("jdbc:mysql://localhost:3306/booking_app?noAccessToProcedureBodies=true"
                            ,"admin","1111");
            Statement stmt = conn.createStatement();
            return stmt;
        }catch (Exception ex){
        }
        return null;
    }

    public static String createPlayer(String playerId){
        try{
            ResultSet rs = statementCreate().executeQuery("CALL createPlayer(\""+playerId+"\",@r_m)");
            while (rs.next()){
                return rs.getString("return_message");
            }
        }
        catch (Exception ex){
        }
        return null;
    }

    public static String createCity(String cityId){
        try{
            ResultSet rs = statementCreate().executeQuery("CALL createCity(\""+cityId+"\",@r_m)");
            while (rs.next()){
                return rs.getString("return_message");
            }
        }
        catch (Exception ex){

        }
        return null;
    }

    public static String createCityCenter(String centerId,String cityId){
        try {
            String query = "CALL createCityCenter(\"" + centerId + "\",\""+ cityId+ "\",@r_m)";
        	ResultSet rs = statementCreate().executeQuery(query);
            while (rs.next()) {
                return rs.getString("return_message");
            }
        }
        catch (Exception ex){

        }
        return null;
    }

    public static String createStaff(String staffId, String cityId, String centerId){
        try {
            String query = "CALL createStaff(\"" + staffId + "\",\""+ cityId+ "\",\""+ centerId+ "\",@r_m)";
            ResultSet rs = statementCreate().executeQuery(query);
            while (rs.next()) {
                return rs.getString("return_message");
            }
        }
        catch (Exception ex){

        }
        return null;
    }

    public static String createCityCenterCourt(String courtId, String cityId, String centerId){
        try {
            String query = "CALL createCityCenterCourt(\"" + courtId + "\",\""+ cityId+ "\",\""+ centerId+ "\",@r_m)";
            ResultSet rs = statementCreate().executeQuery(query);
            while (rs.next()) {
                return rs.getString("return_message");
            }
        }
        catch (Exception ex){

        }
        return null;
    }

    public static String createBooking(String bookingId, String booking_date, String valid_from
            , String valid_to, String court, String city, String center, String customer){
        try {
            String query = "CALL createBooking(\""+ bookingId+ "\",\""+ booking_date+ "\",\""+ valid_from
                    + "\",\""+ valid_to+ "\",\""+ court+ "\",\""+ city+ "\",\""+ center+ "\",\""+ customer+ "\",@r_m)";
            ResultSet rs = statementCreate().executeQuery(query);
            while (rs.next()){
                return rs.getString("return_message");
            }
        }
        catch (Exception ex){

        }
        return null;
    }

    public static String cancelBooking(String bookingId, String playerId){
        try {
            String query = "CALL cancelBooking(\""+ bookingId+ "\",\""+ playerId+ "\",@r_m)";
            ResultSet rs = statementCreate().executeQuery(query);
            while (rs.next()) {
                return rs.getString("return_message");
            }
        }
        catch (Exception ex){
        }
        return null;
    }

    public static String updateBookingStatus(String status, String bookingId, String cityId, String centerId, String staffId){
        try {
            String query = "CALL updateBookingStatus(\""+ status+ "\",\""+ bookingId
                    + "\",\""+ cityId+ "\",\""+ centerId+ "\",\""+ staffId+ "\",@r_m)";
            ResultSet rs = statementCreate().executeQuery(query);
            while (rs.next()){
                return rs.getString("return_message");
            }
        }
        catch (Exception ex){
        }
        return null;
    }
    private static void cleanTable(String tableName, String collumnCompare) {
    	String query ="SELECT * FROM booking_app." + tableName + ";";
    	try {
			ResultSet rs = statementCreate().executeQuery(query);
			while (rs.next()) {
				query = "DELETE FROM booking_app." + tableName + " WHERE "+ collumnCompare +" LIKE \'" + rs.getString(collumnCompare) + "\';";
				statementCreate().execute(query);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    
    }    

    public static void cleanup() {
    	String[] tableName = {"booking","booked_court","customer","staff","court","sport_centres","cities"};
    	String[] collumnName = {"booking_id","booking_id","customer_id","staff_id","court_id","centre_id","city_id"};
    	for (int i = 0; i < tableName.length; i++) {
    		cleanTable(tableName[i], collumnName[i]);
    	}
    		
    }
    
	public static TreeMap<Time,Time> getOccupiedTimeSlots(Date date, String courtID) {
    	ResultSet rs = null;
    	TreeMap<Time,Time> resultMap = new TreeMap<>();
    	try {
            rs = statementCreate().executeQuery("select * from booking");
			while (rs.next()) {
				if (rs.getDate("valid_from").equals(date) && rs.getString("court").equals(courtID)) {
					long milisS = rs.getTime("valid_from").getTime() - ONE_HOUR_IN_MILIS;
					long milisE = rs.getTime("valid_to").getTime() - ONE_HOUR_IN_MILIS;
					Time timeS = new Time(milisS);
					Time timeE = new Time(milisE);
					resultMap.put(timeS, timeE);
				}
			}	
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return resultMap;
    }
}
