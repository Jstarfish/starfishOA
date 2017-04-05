package com.huacai.assist.money;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.huacai.assist.R;
import com.huacai.assist.common.App;
import com.huacai.assist.common.BaseActivity;
import com.huacai.assist.common.appData;
import com.huacai.assist.net.Http;
import com.huacai.assist.net.NetResult;
import com.huacai.assist.net.RequestListener;

public class WithdrawConfirmActivity extends BaseActivity implements OnClickListener, RequestListener {
	public static String withdrawCode = "";
	public static long withdrawAmount = 0;
	public static WithdrawListActivity prevActivity = null;
	private Button apply;
	private EditText password;
	@Override
	public void initView() {
		super.initView();
		setMiddleText(R.string.title_activity_withdraw_confirm);
		password = (EditText)findViewById(R.id.withdraw_password);
		TextView tv = (TextView)findViewById(R.id.station_code);
		tv.setText(appData.stationCode);
		tv = (TextView)findViewById(R.id.withdraw_amount);
		tv.setText(App.getPriceFormated(withdrawAmount)+" "+App.getResString(R.string.com_unit));
		
		apply=(Button)findViewById(R.id.withdraw_apply);
		apply.setOnClickListener(this);
	}
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		initActivity(this,R.layout.activity_confirm_withdraw);
		initData();
		initView();
		initHandle();
	}
	@Override
	public void onClick(View v) {
		if (v.getId() == R.id.withdraw_apply) {
			String strPassword = password.getText().toString();
			if (strPassword.length() < 6) {
				App.showMessage(R.string.modify_password_length_to_short, R.string.com_tishi);
				return ;
			}
			JSONObject jo = new JSONObject();
			try {
				jo.put("outletCode", appData.stationCode);
				jo.put("password", strPassword);//Crypto.getMd5Hash(strPassword));
				jo.put("withdrawnCode", withdrawCode);
			} catch (JSONException e) {
				e.printStackTrace();
			}
			Http.request(Http.WITHDRAW_CONFIRM, jo, this);
		}
	}
	@Override
	public void onComplete(NetResult res) {
		int errCode = 0;
		String errStr = null;
		if (res.jsonObject != null) {
			try {
				errCode = res.jsonObject.getInt("errcode");
				if (res.errorCode == 0 && errCode == 0) {
					App.showMessage(R.string.withdraw_confirm_success, R.string.com_tishi,
							new DialogInterface.OnClickListener(){
						@Override
						public void onClick(DialogInterface dlg,
								int arg1) {
							dlg.dismiss();
							App.postRun(new Runnable() {
								@Override
								public void run() {
									Intent it = new Intent(WithdrawConfirmActivity.this, WithdrawListActivity.class);
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
			App.showMessage(errCode, R.string.withdraw_confirm_failed, R.string.com_tishi);
		}
	}
}
