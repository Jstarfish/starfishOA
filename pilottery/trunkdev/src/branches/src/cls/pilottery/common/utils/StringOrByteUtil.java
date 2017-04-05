package cls.pilottery.common.utils;

import java.io.UnsupportedEncodingException;

/*
 * String与字节数组转换工具类
 */
public class StringOrByteUtil {
	private static String CHAR_ENCODE = "UTF-8";

	public static void configCharEncode(String charEncode) {
		CHAR_ENCODE = charEncode;
	}

	public static byte[] stringToByte(String str) {
		return stringToByte(str, CHAR_ENCODE);
	}

	public static String byteToString(byte[] srcObj) {
		return byteToString(srcObj, CHAR_ENCODE);
	}

	public static byte[] stringToByte(String str, String charEncode) {
		byte[] destObj = null;
		try {
			if (null == str || str.trim().equals("")) {
				destObj = new byte[0];
				return destObj;
			} else {
				destObj = str.getBytes(charEncode);
			}
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return destObj;
	}

	public static String byteToString(byte[] srcObj, String charEncode) {
		String destObj = null;
		try {
			destObj = new String(srcObj, charEncode);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return destObj.replaceAll("\0", " ");
	}
}
