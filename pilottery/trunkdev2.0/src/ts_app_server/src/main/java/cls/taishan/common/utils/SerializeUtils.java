package cls.taishan.common.utils;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

import org.apache.log4j.Logger;

/**
 * 项目名：泰山无纸化平台 
 * 文件名：SerializeUtils.java
 * 类描述：序列化工具类
 * 创建人：huangchengyuan@chinalotsynergy.com
 * 日期：2015-8-21-上午09:54:20
 * 版本信息：v1.0.0
 * Copyright (c) 2015华彩控股有限公司-版权所有
 */
public class SerializeUtils {
	private static Logger logger = Logger.getLogger(SerializeUtils.class);

	/**
	 * 序列化
	 */
	public static byte[] serialize(Object object) {
		if (null == object) {
			return null;
		}
		ObjectOutputStream oos = null;
		ByteArrayOutputStream baos = null;
		try {
			baos = new ByteArrayOutputStream();
			oos = new ObjectOutputStream(baos);
			oos.writeObject(object);
			byte[] bytes = baos.toByteArray();
			return bytes;
		} catch (Exception e) {
			logger.error("", e);
		}
		return null;
	}

	/**
	 * 反序列化
	 */
	@SuppressWarnings("unchecked")
	public static <T> T unserialize(Class<T> clazz, byte[] bytes) {
		ByteArrayInputStream bais = null;
		try {
			if (null == bytes) {
				return null;
			}
			bais = new ByteArrayInputStream(bytes);
			ObjectInputStream ois = new ObjectInputStream(bais);
			return (T) ois.readObject();
		} catch (Exception e) {
			logger.error("", e);
		}
		return null;
	}

	/**
	 * 反序列化
	 */
	public static Object unserialize(byte[] bytes) {
		ByteArrayInputStream bais = null;
		try {
			if (null == bytes) {
				return null;
			}
			bais = new ByteArrayInputStream(bytes);
			ObjectInputStream ois = new ObjectInputStream(bais);
			return ois.readObject();
		} catch (Exception e) {
			logger.error("", e);
		}
		return null;
	}
}
