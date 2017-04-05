package cls.taishan.common.constants;

/**
 * 项目名：泰山无纸化平台 
 * 文件名：SysConstants.java
 * 类描述：定义系统的常量
 * 创建人：huangchengyuan@chinalotsynergy.com
 * 日期：</b>2015-8-21-上午09:53:44
 * 版本信息：v1.0.0
 * Copyright (c) 2015华彩控股有限公司-版权所有
 */
public class SysConstants {
	
	//当前登陆用户
	public static final String CURR_LOGIN_USER_SESSION="currentUser";
	
	//用于语言切换页面--英文页面后缀
	public static final String PAGE_EN_SUFFIX ="";
	
	//用于语言切换页面--中文页面后缀
	public static final String PAGE_ZH_SUFFIX ="_zh";
	
	public static final String INIT_LOGIN_PASSWORD = "111111";
	
	public static final String INIT_TRANS_PASSWORD = "111111";
	
	public static final String CAPITAL_SECURITY_KEY = "223541DC8C965E9BDB379709E2B848F9";
	
	public static int OMS_MSG_MSN = 0;
	
	public static final String CHAR_SET = "UTF-8";
	
	//单次排期默认最大期数
	public static final Long MAX_ISSUE_NUMBERS = (long) 300;

	//游戏参数
	public static final short KOCSSC  = 5;
	public static final short KOCTTY  = 6;
	public static final short KOC7LX  = 7;
	public static final short KOCKENO = 8;
	public static final short KOCK2   = 9;
    public static final short C30S6   = 10;
	public static final short KOCK3   = 11;
	public static final short KOC11X5 = 12;
	
	public static final String SYSTEM_OMS = "oms";
	public static final String SYSTEM_PILOTTERY = "pilottery";
	public static final String SYSTEM_CNCP = "cncp";
	public static final String SYSTEM_BANK_GATE = "bank_gate";
	
	// 数据库记录的Wing交易状态
	public static final int DB_WING_REST_STATUS_POSTING = 0;
	public static final int DB_WING_REST_STATUS_SUCC = 1;
	public static final int DB_WING_REST_STATUS_FAIL = 2;
	public static final int DB_WING_REST_STATUS_TIMEOUT = 3;

	// 错误枚举

	public static final int ERR_COMMON_ORACLE_ERROR = 91;
	
	public static final int ERR_PARAMETER_NOT_VALID = 11;
	public static final int ERR_PARAMETER_HAS_NULL = 12;
	
	public static final int ERR_SEARCH_INVALID_INPUT = 21;

	
	// Wing交易状态
	public static final int WING_REST_SUCC = 0;
	public static final int WING_REST_TIMEOUT = 1;
	public static final int WING_REST_CONNECTION = 2; 
	public static final int WING_REST_RETURN_ERROR = 3;
	
	public static final int ERR_PRECODE_BANK_BEFORE_WING = 100;
	public static final int ERR_PRECODE_WING = 200;
	public static final int ERR_PRECODE_BANK_AFTER_WING = 300;
	
}