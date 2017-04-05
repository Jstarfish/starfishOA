package cls.taishan.common.helper;

import java.util.HashMap;
import java.util.Map;

public class MethodHelper {
	
	public static Map<String,String> methodMap = new HashMap<String,String>();
	
	public static String getMethodUrl(String methodCode){
		return methodMap.get(methodCode);
	}

}
