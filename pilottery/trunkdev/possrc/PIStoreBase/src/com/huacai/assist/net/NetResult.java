package com.huacai.assist.net;

import org.json.JSONException;
import org.json.JSONObject;

/**网络返回类
 * @author dell
 *
 */
public class NetResult {
	/**
	 * 网络结果编码
	 */
	public int errorCode = 0;
	public JSONObject jsonObject = null;
	public String errorStr;
	
	/**
	 * 超时异常
	 */
	public static int TIMEOUTEXCEPTION = 901;
	
	/**
	 * 未知异常
	 */
	public static int UNKNOWEXCEPTION = 902;
	/**
	 * 未知异常
	 */
	public static int PARAM_ERROR = 904;
	
	/**
	 * 无法连接
	 */
	public static int CANNOT_CONNECT = 903;
	
	public NetResult(int errorCode, String error)
	{
		this.errorCode = errorCode;
		this.errorStr = error;
		try {
			jsonObject = new JSONObject("{}");
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}
}
