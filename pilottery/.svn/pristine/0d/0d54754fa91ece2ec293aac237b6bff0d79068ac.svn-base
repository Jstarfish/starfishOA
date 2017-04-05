package cls.taishan.common.helper;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.serializer.SerializerFeature;

public class FastJsonHelper {

	public static <T> String converter(T obj) {
		return JSON.toJSONString(obj, SerializerFeature.DisableCircularReferenceDetect);
	}

	public static <T> T converter(String text, Class<T> clazz) {
		return (T) JSON.parseObject(text, clazz);
	}

	public static byte[] toBytes(Object obj){
		return JSON.toJSONBytes(obj, SerializerFeature.DisableCircularReferenceDetect);
	}
	
	public static String joinPostParam(String token,String transType,String transMessage,String digest){
		StringBuilder sb = new StringBuilder();
		sb.append("token=");
		sb.append(token);
		sb.append("&transType=");
		sb.append(transType);
		sb.append("&digest=");
		sb.append(digest);
		sb.append("&transMessage=");
		sb.append(transMessage);
		return sb.toString();
	}
}
