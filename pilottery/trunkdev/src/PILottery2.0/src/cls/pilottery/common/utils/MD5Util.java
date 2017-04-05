package cls.pilottery.common.utils;

import java.security.MessageDigest;
import java.util.HashMap;
import java.util.Map;

/**
 * 项目名：泰山无纸化平台 
 * 文件名：MD5Util.java
 * 类描述：MD5工具类
 * 创建人：huangchengyuan@chinalotsynergy.com
 * 日期：</b>2015-8-21-上午09:56:33
 * 版本信息：v1.0.0
 * Copyright (c) 2015华彩控股有限公司-版权所有
 */
public class MD5Util {

	private final static String[] hexDigits = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f" };

	public static String MD5Encode(String origin) {
		String resultString = null;
		try {
			resultString = new String(origin);
			MessageDigest md = MessageDigest.getInstance("MD5");
			resultString = byteArrayToHexString(md.digest(resultString.getBytes()));
		} catch (Exception ex) {
		}
		return resultString;
	}

	private static String byteArrayToHexString(byte[] b) {
		StringBuffer resultSb = new StringBuffer();
		for (int i = 0; i < b.length; i++) {
			resultSb.append(byteToHexString(b[i]));
		}
		return resultSb.toString();
	}

	private static String byteToHexString(byte b) {
		int n = b;
		if (n < 0) {
			n = 256 + n;
		}
		int d1 = n / 16;
		int d2 = n % 16;
		return hexDigits[d1] + hexDigits[d2];
	}

	public static void main(String[] args) {
		System.out.println(MD5Util.MD5Encode("574403"));
		
		Map<String, String> resourceMap= new HashMap<String, String>();
		resourceMap.put("111", "333");
		resourceMap.put("111", "444");
		System.out.println(resourceMap.get("111"));
	}
}