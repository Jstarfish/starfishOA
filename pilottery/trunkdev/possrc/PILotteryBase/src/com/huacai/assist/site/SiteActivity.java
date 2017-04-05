package com.huacai.assist.site;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import com.huacai.assist.R;
import com.huacai.assist.common.App;
import com.huacai.assist.common.BaseActivity;
import com.huacai.assist.common.appData;
import com.huacai.assist.money.WithdrawListActivity;
import com.huacai.assist.net.Http;
import com.huacai.assist.net.NetResult;
import com.huacai.assist.net.RequestListener;
import com.huacai.assist.store.PutInStorage1;

/**
 * 查看站点信息
 */

public class SiteActivity extends BaseActivity implements OnClickListener,
		RequestListener {

	private Button ensure;// 确定
	private Button queryBusiness;// 交易流水
	private Button dayBusiness;// 资金日结
	private Button putInStorage;// 入库
	private Button recharge;// 充值
	private Button acceptPrize;// 兑奖
	private Button order;// 订单
	private Button pickUpGoods;// 提货
	private Button returnOfGoods;// 退货
	private EditText putInNum;// 输入站点编号
	private TextView siteCode;
	private TextView siteName;// 站点名称
	private TextView respPerson;// 负责人
	private TextView phone;// 电话
	private LinearLayout ll;// 站点信息

	private String scodeblance = null;// 站点账户余额
	private boolean isPutIn = false;

	@Override
	public void initData() {
		// TODO Auto-generated method stub
		super.initData();
	}

	@Override
	public void initView() {
		// TODO Auto-generated method stub
		super.initView();
		setMiddleText(R.string.title_activity_site);
		putInNum = (EditText) findViewById(R.id.putIN_num);
		if(appData.stationCode!=null){//如果本地存储的站点号不为空
			putInNum.setText(appData.stationCode);//将本地存储的站点号赋值给输入框
		}
		siteCode = (TextView) findViewById(R.id.site_code);
		siteName = (TextView) findViewById(R.id.site_name);
		respPerson = (TextView) findViewById(R.id.man);
		phone = (TextView) findViewById(R.id.phone);
		queryBusiness = (Button) findViewById(R.id.query_business);
		dayBusiness = (Button) findViewById(R.id.froze_fund);
		putInStorage = (Button) findViewById(R.id.putIn_storage);
		recharge = (Button) findViewById(R.id.recharge);
		acceptPrize = (Button) findViewById(R.id.acPrize);
		order = (Button) findViewById(R.id.order);
		pickUpGoods = (Button) findViewById(R.id.pickUp_goods);
		returnOfGoods = (Button) findViewById(R.id.returnOf_goods);
		ensure = (Button) findViewById(R.id.ensure);
		ll = (LinearLayout) findViewById(R.id.result);
		Button[] btnArray = { ensure, queryBusiness, dayBusiness, putInStorage,
				recharge, acceptPrize, order, pickUpGoods, returnOfGoods };
		for (int i = 0; i < btnArray.length; i++) {
			btnArray[i].setOnClickListener(this);
		}

	}

	@Override
	public void initHandle() {
		// TODO Auto-generated method stub
		super.initHandle();
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		initActivity(this, R.layout.activity_site_serve);
		initData();
		initView();
		initHandle();
		sendQueryFundMsg();
	}
	/**
	 * 发送数据用于加载初始信息，包括站点信息等
	 */
	public void sendQueryFundMsg() {
		JSONObject jo = new JSONObject();
		try {
			jo.put("outletCode", appData.stationCode);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		Http.request(Http.SITE_INFO, jo, this);
	}

	@Override
	public void onClick(View v) {
		v.setEnabled(false);
		final View vv = v;
		App.postRun(new Runnable(){
			@Override
			public void run() {
				vv.setEnabled(true);
			}}, 100);
		switch (v.getId()) {
		case R.id.query_business: // 交易流水
			SiteActivity.this.startActivity(new Intent(SiteActivity.this,
					QueryBusinessActivity.class));
			break;
		case R.id.froze_fund: // 资金日结
			SiteActivity.this.startActivity(new Intent(SiteActivity.this,
					DayBusinessActivity.class));
			break;
		case R.id.recharge: // 站点充值
			SiteActivity.this.startActivity(new Intent(SiteActivity.this,
					RechargeActivity.class));
			break;
		case R.id.ensure:// 输入站点编号后确认
			hideKeyboard(v);
			ll.setVisibility(View.GONE);
			sendQueryFundMsg();
			break;
		case R.id.putIn_storage: // 入库
			// 请求余额
			isPutIn = true;
			JSONObject jo1 = new JSONObject();
			try {
				jo1.put("outletCode", putInNum.getText());
//				jo1.put("follow", "0");
				jo1.put("count", 1);
				Http.request(Http.QUERY_BUSINESS, jo1, this);
			} catch (JSONException e) {
				e.printStackTrace();
			}
			break;
		case R.id.pickUp_goods: {
			// 提现
			SiteActivity.this.startActivity(new Intent(SiteActivity.this,
					WithdrawListActivity.class));
			break;
		}
		case R.id.order: {
			// 订单
			SiteActivity.this.startActivity(new Intent(SiteActivity.this,
					OrderListActivity.class));
			break;
		}
		case R.id.acPrize:// 兑奖
			Intent initt13 = new Intent(SiteActivity.this, PutInStorage1.class);
			initt13.putExtra("storagetype", 2);
			initt13.putExtra("sitenum", putInNum.getText().toString());
			initt13.putExtra("scodeblance", scodeblance);
			SiteActivity.this.startActivity(initt13);
			break;
		case R.id.returnOf_goods: // 退货
			JSONObject jo2 = new JSONObject();
			isPutIn = false;
			try {
				jo2.put("outletCode", putInNum.getText());
				jo2.put("follow", "0");
				jo2.put("count", 1);
				Http.request(Http.QUERY_BUSINESS, jo2, this);
			} catch (JSONException e) {
				e.printStackTrace();
			}
			break;
		}

	}

	@Override
	public void onComplete(NetResult res) {
		int code = 0;
		Log.e("yyc", "onComplete " + res.errorStr);
		if (res.jsonObject != null) {
			try {
				int errCode = res.jsonObject.getInt("errcode");
				String method = res.jsonObject.getString("method");
				code = Integer.parseInt(method, 16);
				if (code == Http.QUERY_BUSINESS) {//获取站点余额
					if (res.errorCode == 0 && errCode == 0) {
						if (res.jsonObject.has("result")) {
							JSONObject site = res.jsonObject
									.getJSONObject("result");
							if (isPutIn) {
								scodeblance = site.getString("balance");
								Intent initt2 = new Intent(SiteActivity.this,
										PutInStorage1.class);
								initt2.putExtra("storagetype", 1);
								initt2.putExtra("sitenum", putInNum.getText()
										.toString());
								initt2.putExtra("scodeblance", scodeblance);
								SiteActivity.this.startActivity(initt2);
							} else {
								scodeblance = site.getString("balance");
								Intent initt = new Intent(SiteActivity.this, PutInStorage1.class);
								initt.putExtra("storagetype", 3);
								initt.putExtra("sitenum", putInNum.getText().toString());
								initt.putExtra("scodeblance", scodeblance);
								SiteActivity.this.startActivity(initt);
							}
							appData.balance = site.getLong("balance");
						}
					}
				} else {//获取站点信息并显示
					if (res.errorCode == 0 && errCode == 0) {
						final NetResult resp = res;
						this.runOnUiThread(new Runnable() {
							@Override
							public void run() {
								String name;
								try {
									JSONObject site = resp.jsonObject
											.getJSONObject("result");//站点信息
									appData.stationCode=site//存储站点编号
											.getString("outletCode");
									appData.stationName = site//存储站点名称
											.getString("outletName");
									String code = SiteActivity.this.getString(R.string.withdraw_station_code)+appData.stationCode;
									name = SiteActivity.this.getString(R.string.site_siteName)
											+ site.getString("outletName");//站点名称
									String contact = SiteActivity.this.getString(R.string.site_responMan)
											+ site.getString("contact");
									String phone1 = SiteActivity.this.getString(R.string.site_phone)
											+ site.getString("phone");
									ll.setVisibility(View.VISIBLE);
									siteCode.setText(code);
									siteName.setText(name);
									respPerson.setText(contact);
									phone.setText(phone1);
									long balance = site.getLong("balance");
									appData.balance = balance;
								} catch (JSONException e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								}

							}
						});
					}
					else{
						this.runOnUiThread(new Runnable() {
							@Override
							public void run() {
									ll.setVisibility(View.GONE);

							}
						});
					}
				}
			} catch (JSONException e) {
				Log.e("yyc", "process " + code + " data error!!!");
				e.printStackTrace();
			}
		}
	}
}
