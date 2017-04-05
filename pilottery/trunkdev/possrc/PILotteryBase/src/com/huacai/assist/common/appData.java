package com.huacai.assist.common;

import org.json.JSONArray;

import com.huacai.assist.net.Http;

public class appData {
	//测试环境 http://192.168.26.45:9090/
	//默认端口号，用户修改
	public static final String defaultPort = "9090";
	
	 //当前使用的ip
	public static String usingServerIpAddress = "";
	
	//当前使用的端口号
	public static String usingServerPort = "";
	
	//内存中的ip地址
	public static String serverIpAddress_1 = "175.100.28.50";//开发
	
	//内存中的端口号
	public static String serverPort_1 = "9090";
	
	//内存中的ip地址
	public static String serverIpAddress_2 = "116.212.139.5";
	
	//内存中的端口号
	public static String serverPort_2 = "9090";
	
	public static int bitRate = 9600;
	
	public static String bitRateName = "bitRate";
	
	//保存在配置文件ip地址的键值
	public static final String serverIpName_1 = "ip1";
	
	//保存在配置文件中的端口号的键值
	public static final String serverPortName_1 = "port1";
	
	//保存在配置文件ip地址的键值
	public static final String serverIpName_2 = "ip2";
	
	//保存在配置文件中的端口号的键值
	public static final String serverPortName_2 = "port2";

	//保存在配置文件中的当前使用的ip的标记
	public static String usIpTag = "1";
	
	//保存在配置文件中的登录名的键值
	public static final String logoInName = "logoinname";
	
	//登录名内存中变量
	public static String username = "";
	
	/**
	 * 1 市场管理员 2 站点操作
	 */
	public static int user_type = 1; 
	public static JSONArray planList = new JSONArray();
	
	/**
	 * 站点编号
	 */
	public static String stationCode = "";
	
	/**
	 * 站点名称
	 */
	public static String stationName = "";
	
	public static long balance = 0;

	public static void reset() {
		Http.setToken("");
		user_type = 1;
		planList = new JSONArray();
		username = "";
		balance = 0;
	}
	
	public static void useIp1(){
		usingServerIpAddress = serverIpAddress_1;
		usingServerPort = serverPort_1;
		usIpTag = "1";
	}
	
	public static void useIp2(){
		usingServerIpAddress = serverIpAddress_2;
		usingServerPort = serverPort_2;
		usIpTag = "2";
	}
}
