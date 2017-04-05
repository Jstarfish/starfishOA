package cls.taishan.common.utils;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.serializer.SerializerFeature;

public class FastJsonUtils {

	public static <T> String converter(T obj) {
		return JSON.toJSONString(obj, SerializerFeature.DisableCircularReferenceDetect);
	}

	public static <T> T converter(String text, Class<T> clazz) {
		return (T) JSON.parseObject(text, clazz);
	}

	public static byte[] toBytes(Object obj){
		return JSON.toJSONBytes(obj, SerializerFeature.DisableCircularReferenceDetect);
	}
	
}
