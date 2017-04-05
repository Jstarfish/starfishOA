package com.huacai.assist.site;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.huacai.assist.R;
import com.huacai.assist.adapter.OrderListitemAdapter;
import com.huacai.assist.common.App;
import com.huacai.assist.common.BaseActivity;
import com.huacai.assist.common.appData;
import com.huacai.assist.net.Http;
import com.huacai.assist.net.NetResult;
import com.huacai.assist.net.RequestListener;

public class OrderListActivity extends BaseActivity implements OnClickListener, RequestListener {

	private Button apply;
	private ListView lv;
	private TextView scode;
	public static JSONObject data = new JSONObject();
	@Override
	public void initView() {
		super.initView();
		setMiddleText(R.string.title_activity_order);
		apply=(Button)findViewById(R.id.order_apply);
		lv=(ListView)findViewById(R.id.order_list);
		apply.setOnClickListener(this);
		scode = (TextView)findViewById(R.id.text_station_code);
		scode.setText(App.getResString(R.string.withdraw_station_code)+appData.stationCode);
		JSONObject jo = new JSONObject();
		try {
			jo.put("outletCode", appData.stationCode);
			jo.put("count", 500);
			Http.request(Http.STATION_ORDER_LIST, jo, this);
		} catch (JSONException e) {
			e.printStackTrace();
		}
//		loadDate();
	}
	private void loadDate() {
		OrderListitemAdapter adapter=new OrderListitemAdapter(this, data, R.layout.order_item);
		lv.setAdapter(adapter);
	}
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		initActivity(this,R.layout.activity_order_list);
		initData();
		initView();
		initHandle();
	}
	@Override
	public void onClick(View v) {
		this.startActivity(new Intent(this, OrderApplyActivity.class));
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
				if (code == Http.STATION_ORDER_LIST) {
					if (res.errorCode == 0 && errCode == 0) {
						JSONObject site = res.jsonObject
								.getJSONObject("result");
						try {
							appData.balance = site.getLong("balance");
						} catch (Exception e) {
							
						}
						OrderListActivity.data = site;
						runOnUiThread(new Runnable() {
							@Override
							public void run() {
								loadDate();
							}
						});
					} else {
						//
					}
				}
			} catch (JSONException e) {
				Log.e("yyc", "process " + code + " data error!!!");
				e.printStackTrace();
			}
		}
	}
}
