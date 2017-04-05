package cls.pilottery.pos.common.constants;

import java.util.HashMap;
import java.util.Map;

import cls.pilottery.pos.common.model.MethodInfo;

public class PosConstant {
	public static Map<String,MethodInfo> methodMap = new HashMap<String,MethodInfo>();

	public static final String CHAR_SET = "utf-8";
	
	public static final int SESSION_TIMEOUT = 30*60;	//30分钟
}
