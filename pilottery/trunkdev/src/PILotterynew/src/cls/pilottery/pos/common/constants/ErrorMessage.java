package cls.pilottery.pos.common.constants;

import java.util.HashMap;
import java.util.Map;

public class ErrorMessage {
	public static final Map<Integer, String> errorMap = new HashMap<Integer, String>();

	static {
		errorMap.put(0, "");	//Success
		errorMap.put(1, "Failure");
		errorMap.put(10001, "Authentication failure");
		errorMap.put(10002, "Username or password error");
		errorMap.put(10003, "User not exist or disabled");
		errorMap.put(10004, "Wrong password");
		errorMap.put(10005, "Wrong format in new password");
		errorMap.put(10006, "MM insufficient balance");
		errorMap.put(10007, "Wrong outlet");
		errorMap.put(10008, "Outlet insufficent balance");
		errorMap.put(10009, "User has already signed in");
		errorMap.put(10010, "Session invalid or signed in other terminal");
		errorMap.put(10011, "Repeated request message");
		errorMap.put(10012, "Null or invalid parameters");
		errorMap.put(10013, "Total amount is 0");
		errorMap.put(10014, "Invalid barcode");
		errorMap.put(10015, "Query result is empty");		
		errorMap.put(10016, "Outlet is deleted or not authorized");
		errorMap.put(10017, "MM insufficient loan amount");
		errorMap.put(10018, "Wrong outlet password");
		errorMap.put(10019, "Invalid barcode");
		errorMap.put(10020, "The outlet account does not exist, or the outlet status is incorrect.");
		errorMap.put(10021, "Wrong tickets number of applications");
		errorMap.put(10022, "Please update new version");
		
		errorMap.put(10500, "Server error");
	}

	public static String getMsg(Integer errorCode) {
		return errorMap.get(errorCode);
	}
}
