package com.huacai.assist.login;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.Intent;
import android.graphics.Typeface;
import android.os.Bundle;
import android.text.method.PasswordTransformationMethod;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.huacai.assist.R;
import com.huacai.assist.common.App;
import com.huacai.assist.common.BaseActivity;
import com.huacai.assist.common.PreferenceUtil;
import com.huacai.assist.common.appData;
import com.huacai.assist.net.Http;
import com.huacai.assist.net.NetResult;
import com.huacai.assist.net.RequestListener;

/**
 * Activity which displays a login screen to the user, offering registration as
 * well.
 */
public class ModifyPasswordActivity extends BaseActivity implements 
		RequestListener, OnClickListener {
	private EditText mOldPassword;
	private EditText mNewPassword;
	private Button btnLogin;
	private EditText mConfirmPassword;
	public static boolean isTradePassword = false;
	@Override
	public void onClick(View v) {
		String oldPassword = mOldPassword.getText().toString();
		String newPassword = mNewPassword.getText().toString();
		String confirmPassword = mConfirmPassword.getText().toString();
		if (oldPassword.length() < 6 
				|| newPassword.length() < 6
				|| confirmPassword.length() < 6) {
			// notify
			App.showMessage(R.string.modify_password_length_to_short, R.string.com_tishi);
			return ;
		}
		if (newPassword.equals(oldPassword)) {
			App.showMessage(R.string.modify_password_is_same, R.string.com_tishi);
			return ;
		}
		if (!newPassword.equals(confirmPassword)) {
			App.showMessage(R.string.modify_password_twice_diff, R.string.com_tishi);
			return ;
		}
		JSONObject jo = new JSONObject();
		try {
			jo.put("oldPassword", oldPassword);
			jo.put("newPassword", newPassword);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		if (isTradePassword) 
			Http.request(Http.MODIFY_TRADE_PASSWROD, jo, this);
		else
			Http.request(Http.MODIFY_LOGIN_PASSWORD, jo, this);
	}
	
	@Override
	public void initData() {
		super.initData();
	}

	@Override
	public void initView() {
		super.initView();

		setSettingGone();
		
		mOldPassword = (EditText) findViewById(R.id.old_password);
		mOldPassword.setOnEditorActionListener(new TextView.OnEditorActionListener() {
			@Override
			public boolean onEditorAction(TextView textView, int id,
					KeyEvent keyEvent) {
				return false;
			}
		});
		
		mNewPassword = (EditText) findViewById(R.id.new_password);
		mNewPassword.setOnEditorActionListener(new TextView.OnEditorActionListener() {
					@Override
					public boolean onEditorAction(TextView textView, int id,
							KeyEvent keyEvent) {
						return false;
					}
				});
		
		mConfirmPassword = (EditText) findViewById(R.id.comfirm_password);
		mConfirmPassword.setOnEditorActionListener(new TextView.OnEditorActionListener() {
					@Override
					public boolean onEditorAction(TextView textView, int id,
							KeyEvent keyEvent) {
						return false;
					}
				});

		if (isTradePassword) {
			setMiddleText(R.string.menu_modify_trade_password);
			mNewPassword.setHint(R.string.prompt_new_password1);
			mOldPassword.setHint(R.string.prompt_old_password1);
		} else {
			setMiddleText(R.string.menu_modify_login_password);
			mNewPassword.setHint(R.string.prompt_new_password);
			mOldPassword.setHint(R.string.prompt_old_password);
		}
		

		mOldPassword.setTypeface(Typeface.DEFAULT);
		mOldPassword.setTransformationMethod(new PasswordTransformationMethod());
		mNewPassword.setTypeface(Typeface.DEFAULT);
		mNewPassword.setTransformationMethod(new PasswordTransformationMethod());
		mConfirmPassword.setTypeface(Typeface.DEFAULT);
		mConfirmPassword.setTransformationMethod(new PasswordTransformationMethod());
		
		btnLogin = (Button)findViewById(R.id.btn_modify_confirm);
		btnLogin.setOnClickListener(this);
	}

	@Override
	public void initHandle() {
		super.initHandle();
	}
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		PreferenceUtil.init(this);
		initActivity(this,R.layout.activity_modify_password);
		
		initData();
		initView();
		initHandle();
	}

	@Override
	public void onBackPressed() {
		super.onBackPressed();
	}

	@Override
	public void onComplete(NetResult res) {
		String servError = null;
		int errId = 0;
		Log.e("yyc", "onComplete "+res.errorStr+", "+res.jsonObject.toString());
		if (res.errorCode == 0) {
			if (res.jsonObject != null) {
				try {
					int errCode = res.jsonObject.getInt("errcode");
					errId = errCode;
					if (errCode == 0) {
						appData.reset();
						Intent intent = new Intent(ModifyPasswordActivity.this,LoginActivity.class);
						startActivity(intent);
						return ;
					}
					servError = res.jsonObject.getString("errmesg");
				} catch (JSONException e) {
					e.printStackTrace();
				}
			}
		}
		if (servError == null) {
			App.showMessage(errId, R.string.modify_password_error, R.string.com_tishi);
		}
	}
	
}
