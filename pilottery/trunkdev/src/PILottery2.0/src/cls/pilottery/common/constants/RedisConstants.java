package cls.pilottery.common.constants;

/**
 * 项目名：泰山无纸化平台 
 * 文件名：RedisConstants.java
 * 类描述：定义了redis使用的一些基本常量，包括KEY的规则等
 * 创建人：huangchengyuan@chinalotsynergy.com
 * 日期：</b>2015-8-21-上午09:47:44
 * 版本信息：v1.0.0
 * Copyright (c) 2015华彩控股有限公司-版权所有
 */
public class RedisConstants {
	/*
	 * 用户的基本信息KEY
	 */
	public final static String USER_KEY = "user:userid:";
	/*
	 * 用户session过期时间，单位秒
	 */
	public final static long USER_SESSION_TIMEOUT = 60*60;
	/*
	 * 用户的菜单权限KEY
	 */
	public final static String USER_PRIVILEGE_KEY = "user:privilege:userid:";
	
	/**
	 * 记录用户登录次数
	 */
	public final static String USER_LOGIN_ERROE_TIMES_KEY = "user:login_error_times:loginId:";
	
	public final static int USER_LOGIN_ERROR_TIMES = 5;
	

}
