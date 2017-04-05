package com.huacai.assist.login;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.graphics.Typeface;
import android.os.Bundle;
import android.telephony.TelephonyManager;
import android.text.method.PasswordTransformationMethod;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.TextView;
import cls.pilottery.packinfo.PackHandleFactory;
import cls.pilottery.packinfo.PlanInfo;

import com.huacai.assist.R;
import com.huacai.assist.common.App;
import com.huacai.assist.common.BaseActivity;
import com.huacai.assist.common.CommonTools;
import com.huacai.assist.common.PreferenceUtil;
import com.huacai.assist.common.appData;
import com.huacai.assist.main.MainMenuActivity;
import com.huacai.assist.net.Downloader;
import com.huacai.assist.net.Downloader.DownloadListener;
import com.huacai.assist.net.Http;
import com.huacai.assist.net.NetResult;
import com.huacai.assist.net.RequestListener;
import com.huacai.assist.setting.SysPrmtrActivity;
/**
 * Activity which displays a login screen to the user, offering registration as
 * well.
 */
@SuppressLint("SdCardPath")
public class LoginActivity extends BaseActivity implements OnCheckedChangeListener, 
		RequestListener, OnClickListener, DownloadListener {
	private EditText mUserView;
	private EditText mPasswordView;
	private RadioButton radio_en = null;
	private RadioButton radio_cn = null;
	private RadioButton radio_kh = null;
	private CompoundButton radio_site;
	private RadioButton radio_market;
	private Button btnLogin;
	private TelephonyManager tm;
	private int lang = 1;
	private TextView mVersion;
	private boolean isLoginRequest = true;
	protected String fileName = "/sdcard/PILottery.apk";

	public void updateApk(String url, String user, String pass) {
		down = new Downloader();
//		down.setURL("http://175.100.28.50:12884/download/pilottery_apk/test.apk");
//		down.addAuth("tsuser", "#taishan1371-CLS!");
		down.setURL(url);
		down.addAuth(user, pass);
		down.setListener(LoginActivity.this);

		Log.e("yyc", "yyc filepath "+fileName);
		try {
			File file = new File(fileName);
			file.createNewFile();
			down.setOutPutStream(new FileOutputStream(file));
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		down.showProgress(LoginActivity.this);
		down.request(null);
	}
	
	@Override
	public void onClick(View v) {
		String username = mUserView.getText().toString();
		if (username.length() <= 0) {
			App.showMessage(R.string.prompt_user, R.string.com_tishi);
			return ;
		}

		appData.username = username; 
//		保存登录名
		CommonTools.savePerferences(this, appData.logoInName, appData.username);
		String password = mPasswordView.getText().toString();

		if (password.length() < 6 ) {
			// notify
			App.showMessage(R.string.modify_password_length_to_short, R.string.com_tishi);
			return ;
		}
		JSONObject jo = new JSONObject();
		try {
			jo.put("type", ""+appData.user_type);
			jo.put("username", appData.username);
			jo.put("password", password);
			jo.put("deviceType", ""+2);
//			jo.put("deviceSign", "357376056983151");
			jo.put("deviceSign", tm.getDeviceId());
			jo.put("Lang", lang);
			jo.put("version", getVersionName());
		} catch (JSONException e) {
			e.printStackTrace();
		}
		Http.request(Http.LOGIN, jo, this);
	}
	private String getVersionName()
	{  
	        // 获取packagemanager的实例  
	        PackageManager packageManager = getPackageManager();  
	        // getPackageName()是你当前类的包名，0代表是获取版本信息  
	        PackageInfo packInfo;
			try {
				packInfo = packageManager.getPackageInfo(getPackageName(),0);
		        String version = packInfo.versionName;  
		        return version; 
			} catch (NameNotFoundException e) {
				e.printStackTrace();
			}  
			return null;
	}
	
	@Override
	public void initData() {
		super.initData();
	}

	@Override
	public void initView() {
		super.initView();

		setMiddleText(R.string.title_activity_login);
//		setSettingGone();
		setGoBackGone();
		tm = (TelephonyManager) this.getSystemService(TELEPHONY_SERVICE); 
		mVersion = (TextView) findViewById(R.id.version);
		mVersion.setText("v"+getVersionName());
//		mVersion.setText(App.getPriceFormated(-1234l));
		mUserView = (EditText) findViewById(R.id.user);
		mUserView.setOnEditorActionListener(new TextView.OnEditorActionListener() {
			@Override
			public boolean onEditorAction(TextView textView, int id,
					KeyEvent keyEvent) {
				return false;
			}
		});
		
		mPasswordView = (EditText) findViewById(R.id.password);
		mPasswordView.setOnEditorActionListener(new TextView.OnEditorActionListener() {
					@Override
					public boolean onEditorAction(TextView textView, int id,
							KeyEvent keyEvent) {
						return false;
					}
				});
		mPasswordView.setTypeface(Typeface.DEFAULT);
		mPasswordView.setTransformationMethod(new PasswordTransformationMethod());
		
//		读取并设置默认登录名
		appData.username = CommonTools.getPerferences(this, appData.logoInName, "");
		mUserView.setText(appData.username);

		btnLogin = (Button)findViewById(R.id.sign_in_button);
		btnLogin.setOnClickListener(this);
		radio_market = (RadioButton) findViewById(R.id.radio_market);
		radio_market.setOnCheckedChangeListener(this);
		radio_site = (RadioButton) findViewById(R.id.radio_site);
		radio_site.setOnCheckedChangeListener(this);
		radio_en = (RadioButton) findViewById(R.id.radioEnglish);
		radio_cn = (RadioButton) findViewById(R.id.radioChinese);
		radio_kh = (RadioButton) findViewById(R.id.radioCambodia);
		radio_en.setOnCheckedChangeListener(this);
		radio_cn.setOnCheckedChangeListener(this);
		radio_kh.setOnCheckedChangeListener(this);
		
		menu.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				showSetConf();
			}
		});
	}

	@Override
	public void initHandle() {
		super.initHandle();
	}

	protected void switchLanguage(String language) {
		//设置应用语言类型
		Resources resources = getResources();
        Configuration config = resources.getConfiguration();
        DisplayMetrics dm = resources.getDisplayMetrics();
       if (language.equals("en")) {
            config.locale = Locale.ENGLISH;
            lang  = 1;
        } else if (language.equals("cn")) {
        		config.locale = Locale.SIMPLIFIED_CHINESE;
            lang = 2;
        } else {
        		config.locale = Locale.JAPANESE;
            lang = 3;
        }
        resources.updateConfiguration(config, dm);
        
        //保存设置语言的类型
        PreferenceUtil.commitString("language", language);
    }
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		PreferenceUtil.init(this);
		initActivity(this,R.layout.activity_login);
		
		initData();
		initView();
		initHandle();
		
		onCheckedChanged(radio_en, true);
	}

	@Override
	public void onBackPressed() {
//		super.onBackPressed();
	}

	// 切换语言，切换站点和市场管理员
	@Override
	public void onCheckedChanged(CompoundButton btn, boolean check) {
		if (check) {
			if (btn == radio_en) {
				switchLanguage("en");
			} else if (btn == radio_cn) {
				switchLanguage("cn");
			} else if (btn == radio_kh) {
				switchLanguage("jp");
			} else if (btn == radio_site) {
				appData.user_type = 2;
			} else if (btn == radio_market) {
				appData.user_type = 1;
			}
			setMiddleText(R.string.title_activity_login);
			radio_market.setText(R.string.radio_1);
			radio_site.setText(R.string.radio_2);
			if (appData.user_type == 1) {
				mUserView.setHint(R.string.prompt_user);
			} else {
				mUserView.setHint(R.string.string_site_code);
			}
			mPasswordView.setHint(R.string.prompt_password);
			btnLogin.setText(R.string.title_activity_login);
		}
	}
	@Override
	public void onComplete(NetResult res) {
		String errString = null;
		Log.e("yyc", "onComplete "+res.errorStr);
		if (!isLoginRequest) {
			isLoginRequest = true;
			if (res.jsonObject != null) {
				if (res.errorCode != 0) {
				// 	final String errStr = res.errorStr;
				// 	runOnUiThread(new Runnable() {
				// 		@Override
				// 		public void run() {
				// 			App.showMessage(errStr, App.getResString(R.string.com_tishi));
				// 		}
				// 	});
					return ;
				}
				try {
					int errCode = res.jsonObject.getInt("errcode");
					JSONArray jsonPlans = res.jsonObject.getJSONArray("result");
					if (res.errorCode == 0 && errCode == 0) {
						appData.planList = jsonPlans;
						appData.username = mUserView.getText().toString();
						
						List<PlanInfo> plans = new ArrayList<PlanInfo>();
						for (int i = 0; i < jsonPlans.length(); i++) {
							JSONObject item = jsonPlans.getJSONObject(i);
							plans.add(new PlanInfo(item
									.getString("planCode"), item
									.getString("planName"), item
									.getInt("faceValue"), item
									.getString("printerCode")));
						}
						PackHandleFactory.initParameter(plans);
						
						Intent intent = new Intent(LoginActivity.this,MainMenuActivity.class);
						LoginActivity.this.startActivity(intent);
					}
				} catch (JSONException e) {
					e.printStackTrace();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			return ;
		}
		// {"errcode":0,"errmesg":"","method":"010001","msn":0,
		// "result":{"token":"009520150923131601b8532d7f-dde5-"},
		// "token":"","when":1442985359}
		if (res.jsonObject != null) {
			try {
				int errCode = res.jsonObject.getInt("errcode");
				JSONObject result = res.jsonObject.getJSONObject("result");
				try {
					final String url = result.getString("url");
					final String user = result.getString("username");
					final String pass = result.getString("password");
					// {"password":null,"token":"","url":null,"username":null},"token":"","when":1448349232}
					if (url != null && url.length() > 10) {
						App.showMessage(R.string.need_update, R.string.com_tishi, 
								new DialogInterface.OnClickListener(){
							@Override
							public void onClick(DialogInterface arg0, int arg1) {
								arg0.dismiss();
								updateApk(url, user, pass);
//								AutoInstall.install(LoginActivity.this, fileName);
								return ;
							}});
					}
				} catch (JSONException e) {
					
				}
				if (res.errorCode == 0 && errCode == 0) {
					Http.setToken(result.getString("token"));
					if (appData.user_type == 2) {
						// 站点操作，进入修改站点密码
						ModifyPasswordActivity.isTradePassword = false;
						Intent intent = new Intent(LoginActivity.this,
								ModifyPasswordActivity.class);
						LoginActivity.this.startActivity(intent);
						return ;
					}
					isLoginRequest = false;
					JSONObject jo = new JSONObject();
					try {
						jo.put("notused", "");
					} catch (JSONException e) {
						e.printStackTrace();
					}
					Http.request(Http.LOTTERY_LIST, jo, this);
					int flag = result.getInt("flag");
					if (flag == 1) {
						BaseActivity.titleColor = 0xffFF2DFF;
					}
					return ;
				} else {
					errString = res.jsonObject.getString("errmesg");
				}
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
		if (errString == null) {
			errString = App.getResString(R.string.alert_title_net_error);
			if (res.errorStr != null) {
				errString = res.errorStr;
			}
		}
//		App.showMessage(errString, App.getResString(R.string.com_tishi));;
	}
	
	private EditText editText;
	private LinearLayout editLayout;

	@SuppressLint("InflateParams")
	public void showSetConf(){
		editLayout = (LinearLayout) LayoutInflater.from(this).inflate(R.layout.login_set_conf, null);
		editText = (EditText)editLayout.findViewById(R.id.sys_set_password);
		editText.setHint(R.string.login_set_password);
		editText.setTypeface(Typeface.DEFAULT);//设置密码字体风格为普通
		ViewGroup vg = (ViewGroup) editLayout.getParent();
		if (vg != null) {
			vg.removeView(editLayout);
		}
		new AlertDialog.Builder(this).setTitle(R.string.login_set_password)
			.setView(editLayout)
			.setCancelable(false)
			.setPositiveButton(R.string.string_comfirm, 
				new DialogInterface.OnClickListener() {
					@Override
					public void onClick(DialogInterface dlg, int arg1) {
						String sss = editText.getText().toString();
						if(sss.equalsIgnoreCase("001371")){
							Intent intent = new Intent(LoginActivity.this,SysPrmtrActivity.class);
							LoginActivity.this.startActivity(intent);
						}else
							App.showMessage(R.string.login_set_password_error,R.string.com_tishi);
					}})
			.setNegativeButton(R.string.com_cancel, null).show();
		
	}
	@Override
	public void onConnectionFinished(Downloader http) {
		Log.e("yyc", "yyc onConnectionFinished");
		try {
			http.getOutPutStream().close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		AutoInstall.install(LoginActivity.this, fileName);
		down.showProgress(null);
//		finish();
	}
	@Override
	public void onError(Downloader http, int erroCode, String errmsg) {
		down.showProgress(null);
		App.showMessage(R.string.alert_title_net_error, R.string.com_tishi);
	}
	@Override
	public void onDownloadProgress(Downloader http, long currentSize,
			long totalSize) {
		Log.e("yyc", "yyc onDownloadProgress "+currentSize+"/"+totalSize);
		down.setProgress(currentSize, totalSize);
	}
	@Override
	public void onSendProgress(Downloader http, long currentSize, long totalSize) {
		
	}
	Downloader down = null;
}
