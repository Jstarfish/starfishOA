package cls.taishan.common.constant;

import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.Map;

public class CommonConstant {
	
	public final static String DEFAULT_CONTENT_TYPE = "application/json;charset=UTF-8";
	
	public static final String DEFAULT_CHARSET = Charset.defaultCharset().name();
	
	public static final int HTTP_TIMEOUT_SECEND = 5000;
	
	public static final String REDIS_AGENCY_PUBLIC_KEY = "agency_public_key:token:";
	
	public static final Map<Integer,String> gameCodeMaps = new HashMap<Integer,String>();
	public static final Map<String,Integer> gameNameMaps = new HashMap<String,Integer>();
	
	static{
		gameCodeMaps.put(5, "SSC");
		gameCodeMaps.put(6, "KOCTTY");
		gameCodeMaps.put(7, "KOC7LX");
		gameCodeMaps.put(11, "KOCK3");
		gameCodeMaps.put(12, "K11X5");
		gameCodeMaps.put(13, "TEMA");
		gameCodeMaps.put(14, "FBS");
	}
	
	static{
		gameNameMaps.put("SSC",5);
		gameNameMaps.put("KOCTTY",6);
		gameNameMaps.put("KOC7LX",7);
		gameNameMaps.put("KOCK3",11);
		gameNameMaps.put("K11X5",12);
		gameNameMaps.put("TEMA",13);
		gameNameMaps.put("FBS",14);
	}
	
	public static Integer getGameCode(String gameName){
		return gameNameMaps.get(gameName.toUpperCase());
	}
	
	public static String getGameName(Integer gameCode){
		return gameCodeMaps.get(gameCode);
	}
	
}
