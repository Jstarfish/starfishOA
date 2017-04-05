package com.huacai.assist.money;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.huacai.assist.R;
import com.huacai.assist.common.App;
import com.huacai.assist.common.BaseActivity;
import com.huacai.assist.common.appData;
import com.huacai.assist.net.Http;
import com.huacai.assist.net.NetResult;
import com.huacai.assist.net.RequestListener;

public class WithdrawApplyActivity extends BaseActivity implements OnClickListener, RequestListener {
	public static WithdrawListActivity prevActivity = null;
	private Button apply;
	private EditText amount = null;
	private TextView textBalance;
	@Override
	public void initView() {
		super.initView();
		setMiddleText(R.string.withdraw_apply);
		amount  = (EditText)findViewById(R.id.withdraw_amount);
		TextView tv = (TextView)findViewById(R.id.station_code);
		tv.setText(appData.stationCode);
		textBalance = (TextView)findViewById(R.id.account_amount);
		textBalance.setText(App.getPriceFormated(appData.balance)+App.getResString(R.string.com_unit));
		apply=(Button)findViewById(R.id.withdraw_apply);
		apply.setOnClickListener(this);
	}
	@Override
	public void initHandle() {
		JSONObject jo1 = new JSONObject();
		try {
			jo1.put("outletCode", appData.stationCode);
			jo1.put("count", 1);
			isCashRefresh = true;
			Http.request(Http.QUERY_BUSINESS, jo1, this);
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		initActivity(this,R.layout.activity_apply_withdraw);
		initData();
		initView();
		initHandle();
	}
	@Override
	public void onClick(View v) {
		if (v.getId() == R.id.withdraw_apply) {
			String amountStr = amount.getText().toString();
			if(amountStr.length() == 0){
				App.showMessage(R.string.withdraw_num_error,R.string.com_tishi);
				return;
			}
			long amountLong = Long.parseLong(amountStr);
			if (amountLong <= 0 || appData.balance < amountLong) {
				App.showMessage(R.string.withdraw_num_error,R.string.com_tishi);
				return;
			}
			checkPassword();
		}
	}
	private EditText editText;
	private LinearLayout editLayout;
	static private boolean isCashRefresh = false;

	public void checkPassword(){
		editLayout = (LinearLayout) LayoutInflater.from(this).inflate(R.layout.login_set_conf, null);
		editText = (EditText)editLayout.findViewById(R.id.sys_set_password);
		editText.setHint(R.string.string_site_password);
		ViewGroup vg = (ViewGroup) editLayout.getParent();
		if (vg != null) {
			vg.removeView(editLayout);
		}
		new AlertDialog.Builder(this).setTitle(R.string.string_site_password)
			.setView(editLayout)
			.setCancelable(false)
			.setPositiveButton(R.string.string_comfirm, 
				new DialogInterface.OnClickListener() {
					@Override
					public void onClick(DialogInterface dlg, int arg1) {
						String password = editText.getText().toString();
						JSONObject jo = new JSONObject();
						String amountStr = amount.getText().toString();
						long mountLong = Long.parseLong(amountStr);
						try {
							jo.put("outletCode", appData.stationCode);
							jo.put("amount", mountLong);
							jo.put("password", password);
							isCashRefresh = false;
							Http.request(Http.WITHDRAW_APPLY, jo, WithdrawApplyActivity.this);
						} catch (JSONException e) {
							e.printStackTrace();
						}
					}})
			.setNegativeButton(R.string.com_cancel, null).show();
		
	}
	@Override
	public void onComplete(NetResult res) {
		int errCode = 0;
		String errStr = null;
		if (res.jsonObject != null) {
			try {
				errCode = res.jsonObject.getInt("errcode");
				if (res.errorCode == 0 && errCode == 0) {
					if (isCashRefresh) {
						isCashRefresh = false;
						JSONObject jo = res.jsonObject.getJSONObject("result");
						try {
							appData.balance = jo.getLong("balance");
							this.runOnUiThread(new Runnable() {
								@Override
								public void run() {
									textBalance.setText(App.getPriceFormated(appData.balance)+App.getResString(R.string.com_unit));
								}});
							Log.e("yyc", "yyc balance "+appData.balance);
						} catch (Exception e) {
							
						}
						return ;
					}
//					long withdrawnCode = res.jsonObject.getJSONObject("result").getLong("withdrawnCode");
					App.showMessage(R.string.withdraw_apply_success, R.string.com_tishi,
							new DialogInterface.OnClickListener(){
						@Override
						public void onClick(DialogInterface dlg,
								int arg1) {
							dlg.dismiss();
							App.postRun(new Runnable() {
								@Override
								public void run() {
									Intent it = new Intent(WithdrawApplyActivity.this, WithdrawListActivity.class);
									it.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
									startActivity(it);
									finish();
								}}, 50);
					}});
					return ;
				}
				errStr = res.jsonObject.getString("errmesg");
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
		if (errStr == null) {
			App.showMessage(errCode, R.string.withdraw_apply_failed, R.string.com_tishi);
		}
	}
}
