package com.huacai.assist.money;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ListView;

import com.huacai.assist.R;
import com.huacai.assist.adapter.WithdrawListitemAdapter;
import com.huacai.assist.common.BaseActivity;
import com.huacai.assist.common.appData;
import com.huacai.assist.net.Http;
import com.huacai.assist.net.NetResult;
import com.huacai.assist.net.RequestListener;

public class WithdrawListActivity extends BaseActivity implements OnClickListener, RequestListener {
	private Button apply;
	private ListView lv;
	public static JSONArray data;
	@Override
	public void initView() {
		super.initView();
		setMiddleText(R.string.title_activity_withdraw);
		apply=(Button)findViewById(R.id.withdraw_apply);
		lv=(ListView)findViewById(R.id.withdraw_list);
		apply.setOnClickListener(this);
		JSONObject jo = new JSONObject();
		try {
			jo.put("outletCode", appData.stationCode);
			jo.put("count", 500);
			Http.request(Http.STATION_WITHDRAW_LIST, jo, this);
		} catch (JSONException e) {
			e.printStackTrace();
		}
//		loadDate();
	}
	private void loadDate() {
		WithdrawListitemAdapter adapter=new WithdrawListitemAdapter(this, data, R.layout.withdraw_item);
		lv.setAdapter(adapter);
	}
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		initActivity(this,R.layout.activity_withdraw);
		initData();
		initView();
		initHandle();
	}
	public void doConfirm(String withdrawCode, long withdrawAmount) {
		Intent intent = new Intent(this,WithdrawConfirmActivity.class);
		WithdrawConfirmActivity.withdrawCode = withdrawCode;
		WithdrawConfirmActivity.withdrawAmount = withdrawAmount;
		WithdrawConfirmActivity.prevActivity = this;
		startActivity(intent);
	}
	@Override
	public void onClick(View v) {
		if (v.getId() == R.id.withdraw_apply) {
			WithdrawApplyActivity.prevActivity = this;
			startActivity(new Intent(this, WithdrawApplyActivity.class));
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
				if (code == Http.STATION_WITHDRAW_LIST) {
					if (res.errorCode == 0 && errCode == 0) {
						JSONObject site = res.jsonObject
								.getJSONObject("result");
						JSONArray ja = site.getJSONArray("withdrawnList");
						appData.balance = site.getLong("balance");
						WithdrawListActivity.data = ja;
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
