package com.huacai.assist.net;

import java.util.Date;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.DialogInterface;
import android.content.Intent;

import com.huacai.assist.common.App;
import com.huacai.assist.common.BaseActivity;
import com.huacai.assist.common.appData;
import com.huacai.assist.login.LoginActivity;
import com.huacai.pistore.R;

public class Http implements RequestListener {
	public static final int STORE_IN_LIST 			= 0x070001; // 入库记录
	public static final int STORE_IN_BATCH_LIST 		= 0x070002; // 批次入库信息
	
	public static final int STORE_OUT_LIST 			= 0x070008; // 出库记录
	
	
	
	public static final int MKT_MGR_SOTRE_DAILY = 0x020501; // 市场管理员库存日结查询
	public static final int MKT_MGR_TRANS_DAILY = 0x020502; // 市场管理员交易记录汇总查询
	public static final int MKT_MGR_SALES_RECORD = 0x020503; // 销售记录查询
	public static final int MKT_MGR_PAYOUT_RECORD = 0x020504; // 销售记录查询
	public static final int MKT_MGR_RETURN_RECORD = 0x020505; // 销售记录查询
	public static final int MKT_MGR_LOGISTICS = 0x020506; // 市场管理员物流查询
	public static final int MKT_MGR_STORE_CHECK = 0x020507; // 市场管理员库存盘点
	public static final int MKT_MGR_CASH_DAILY = 0x020508; // 市场管理员资金日结
	
	
	public static final int LOGIN = 0x10001;//登录
	public static final int LOTTERY_LIST = 0x990001;//获取方案列表
	public static final int FORM_LIST = 0x020101;//出货单列表
	public static final int FORM_DETAIL = 0x020102;//出货单详情
	public static final int MAKE_FORM_LIST = 0x020103;//生成出货单
	public static final int QUERY_ORDER_LIST = 0x020104;//订单列表查询
	public static final int ORDER_DETAIL = 0x020105;//订单详细
	public static final int QUERY_FUND = 0x020204;//资金查询
	public static final int QUERY_STOCK = 0x020305;//库存查询
	public static final int SITE_INFO = 0x020401;//站点信息查询
	public static final int QUERY_BUSINESS = 0x020402;//站点资金流水查询
	public static final int DAY_BUSINESS = 0x020403;//站点日结记录查询
	public static final int RECHARGE = 0x020404;//充值
	public static final int RETURN_GOODS = 0x020306;//确认还货
	
	// 通讯测试 
	public static final int NETWORK_TEST = 0x010009;
	// 修改登录密码
	public static final int MODIFY_LOGIN_PASSWORD = 0x010002;
	// 修改交易密码
	public static final int MODIFY_TRADE_PASSWROD = 0x010003;
	// 登出，签出
	public static final int LOGOUT = 0x010004;
	// 站点提现列表
	public static final int STATION_WITHDRAW_LIST = 0x020405;
	// 站点提现申请
	public static final int WITHDRAW_APPLY = 0x020406;
	// 站点提现确认
	public static final int WITHDRAW_CONFIRM = 0x020407;
	// 站点订单列表
	public static final int STATION_ORDER_LIST = 0x020104;
	// 站点订单申请
	public static final int STATION_ORDER_NEW = 0x020409;
	// 站点列表
	public static final int SITE_LIST = 0x990002;
	
	public String token = "";
	public int msn = 0;
	private RequestListener requestListener = null;
	
	public static Http o = new Http();
	private static double lat = 0;
	private static double lon = 0;
	
	public static void setToken(String tok) {
		// 009520150923131601b8532d7f-dde5-
		o.token = tok;
	}
	
	public static void request(int what, JSONObject jo, RequestListener listener) {
		if (o.requestListener != null) {
			return ;
		}
		if (what == LOGIN) {
			o.token = "";
			o.msn = 1;
		} else {
			o.msn += 1;
		}
		int msn = o.msn;
		o.requestListener = null;
		JSONObject jp = new JSONObject();
		try {
			if (what == NETWORK_TEST) {
				msn = 0;
				jo.put("term1Time", (long)(new Date().getTime()/1000));
			}
			jp.put("method", String.format("%06x", what));
			jp.put("when", (long)(new Date().getTime()/1000));
			jp.put("token", o.token);
			jp.put("msn", msn);
			jp.put("lat", lat);
			jp.put("lon", lon);
			jp.put("param", jo);
			o.requestListener = listener;
			AsyncRunner.request(jp, o);
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}
	
	/*
	0	处理成功
	1	业务处理失败
	10001	认证失败
	10002	用户名或密码错误
	10003	此用户目前不可用
	10004	原有密码输入错误
	10005	新密码格式不符合要求
	10006	市场管理员账户余额不足
	10007	站点输入错误
	10008	站点账户余额不足
	*/

	@Override
	public void onComplete(NetResult response) {
		RequestListener listener = requestListener;
		requestListener = null;
		if (response.jsonObject != null) {
			try {
				int err = response.jsonObject.getInt("errcode");
				
				String errMsg = response.jsonObject.getString("errmesg");
				
				if (err == 100101) {
					if (BaseActivity.b instanceof LoginActivity) {
						if (errMsg != null && errMsg.length() > 0 && err != 10022) {
							App.showMessage(errMsg, App.getResString(R.string.alert_title_server_response));
						}
						appData.reset();
						return ;
					}
					App.showMessage(App.getResString(R.string.alert_session_timeout), 
						App.getResString(R.string.alert_title_server_response),
						new DialogInterface.OnClickListener(){
							@Override
							public void onClick(DialogInterface arg0,
									int arg1) {
								if (BaseActivity.b != null) {
									Intent intent = new Intent(BaseActivity.b, LoginActivity.class);
									BaseActivity.b.startActivity(intent);
								}
							}});
//					JSONObject jo = new JSONObject();
//					if (appData.username.length() > 0) {
//						Http.request(Http.LOGOUT, jo, null);
//					}
					appData.reset();
				} else if (errMsg != null && errMsg.length() > 0 && err != 10022) {
					App.showMessage(err, errMsg, App.getResString(R.string.alert_title_server_response));
					response.errorCode = 0;
				}
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
		if (response.errorCode != 0) {
			App.showMessage(response.errorStr
					+"("+response.errorCode+")", 
					App.getResString(R.string.com_tishi));
		}
		if (listener != null) {
			listener.onComplete(response);
		}
	}

	public static void setLocation(double latitude, double longitude) {
		lat = latitude;
		lon = longitude;
	}
}

