package com.huacai.assist.setting;

import org.json.JSONException;
import org.json.JSONObject;

import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.EditText;
import android.widget.RadioButton;

import com.huacai.assist.R;
import com.huacai.assist.common.App;
import com.huacai.assist.common.BaseActivity;
import com.huacai.assist.common.CommonTools;
import com.huacai.assist.common.appData;
import com.huacai.assist.net.Http;
import com.huacai.assist.net.NetResult;
import com.huacai.assist.net.RequestListener;

/**
 * 系统参数
 */
public class SysPrmtrActivity extends BaseActivity implements OnClickListener, RequestListener, OnCheckedChangeListener{
	private EditText ip1;//编辑ip
	private EditText port1;//编辑接口
	private EditText ip2;//编辑ip
	private EditText port2;//编辑接口
	private Button btnConfirm;
	private Button btnTest;
	private RadioButton radio9600;
	private RadioButton radio57600;
	private RadioButton radio38400;
	private RadioButton radio19200;
	private RadioButton radio115200;
	@Override
	public void initView() {
		super.initView();
		setMiddleText(R.string.title_activity_sys);
		btnConfirm = (Button)findViewById(R.id.sys_change);
		btnTest = (Button)findViewById(R.id.sys_test_config);
		
		radio9600 = (RadioButton)findViewById(R.id.radio9600);
		radio19200 = (RadioButton)findViewById(R.id.radio19200);
		radio38400 = (RadioButton)findViewById(R.id.radio38400);
		radio57600 = (RadioButton)findViewById(R.id.radio57600);
		radio115200 = (RadioButton)findViewById(R.id.radio115200);
		radio9600.setOnCheckedChangeListener(this);
		radio19200.setOnCheckedChangeListener(this);
		radio38400.setOnCheckedChangeListener(this);
		radio57600.setOnCheckedChangeListener(this);
		radio115200.setOnCheckedChangeListener(this);
		
		ip1=(EditText)findViewById(R.id.ip_1);
		port1=(EditText)findViewById(R.id.port_1);
		ip2=(EditText)findViewById(R.id.ip_2);
		port2=(EditText)findViewById(R.id.port_2);
		btnConfirm.setOnClickListener(this);
		btnTest.setOnClickListener(this);
		loadDate();
	}
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		initActivity(this,R.layout.activity_sys_prmtr);
		initData();
		initView();
		initHandle();
		setSettingGone();
	}
	public void loadDate(){
		ip1.setText(appData.serverIpAddress_1);
		port1.setText(appData.serverPort_1);
		ip2.setText(appData.serverIpAddress_2);
		port2.setText(appData.serverPort_2);
		if (appData.bitRate == 9600) {
			radio9600.setChecked(true);
		} else if (appData.bitRate == 19200) {
			radio19200.setChecked(true);
		} else if (appData.bitRate == 38400) {
			radio38400.setChecked(true);
		} else if (appData.bitRate == 57600) {
			radio57600.setChecked(true);
		} else if (appData.bitRate == 115200) {
			radio115200.setChecked(true);
		}
	}
	public void saveData() {
		appData.serverIpAddress_1 = ip1.getText().toString();
		appData.serverPort_1 = port1.getText().toString();
		appData.serverIpAddress_2 = ip2.getText().toString();
		appData.serverPort_2 = port2.getText().toString();
	}
	
	@Override
	public void onClick(View v) {
		if (v == btnConfirm) {
			
			if (saveConfig()) {
				appData.useIp1();
				App.showMessage(R.string.sys_save_ip_port_success, 
					R.string.com_tishi);
				btnTest.setVisibility(View.VISIBLE);
			} else {
				App.showMessage(R.string.sys_save_ip_port_failed, 
						R.string.com_tishi);
			}
//		通讯测试
		} else if (v == btnTest) {
			appData.useIp1();
			Http.request(Http.NETWORK_TEST, new JSONObject(), this);
		}
	}
	
	/**保存ip和port设置
	 * @return
	 */
	private boolean saveConfig() {
		try {
//			保存到配置文件
			saveData();
			CommonTools.savePerferences(this.getApplicationContext(),appData.serverIpName_1,appData.serverIpAddress_1);
			CommonTools.savePerferences(this.getApplicationContext(),appData.serverPortName_1,appData.serverPort_1);
			CommonTools.savePerferences(this.getApplicationContext(),appData.serverIpName_2,appData.serverIpAddress_2);
			CommonTools.savePerferences(this.getApplicationContext(),appData.serverPortName_2,appData.serverPort_2);
			return true;
		} catch (Exception e) {
			
		}
		return false;
	}

	@Override
	public void onComplete(NetResult res) {
		Log.e("yyc", "onComplete " + res.errorStr);
		if (res.jsonObject != null) {
			try {
				int errCode = res.jsonObject.getInt("errcode");
				if (res.errorCode == 0 && errCode == 0) {
					// termTxTime
					// servRxTime
					// servTxTime
					JSONObject jo = res.jsonObject.getJSONObject("result");
					String termTxTime = jo.getString("termTxTime");
					String servRxTime = jo.getString("servRxTime");
					String servTxTime = jo.getString("servTxTime");
					Log.e("yyc", "network test"
							+" termTxTime: "+termTxTime
							+", servRxTime: "+servRxTime
							+", servTxTime: "+servTxTime);
					App.showMessage(R.string.alert_title_server_connected, R.string.com_tishi);
					return ;
				}
			} catch (JSONException e) {
				Log.e("yyc", "process data error!!!");
				e.printStackTrace();
			}
		}
		App.showMessage(R.string.alert_title_net_can_not_connect, R.string.com_tishi);
	}
	@Override
	public void onCheckedChanged(CompoundButton r, boolean c) {
		int bitrate = 9600;
		if (c) {
			if (radio9600 == r) {
				bitrate = 9600;
			} else if (radio19200 == r) {
				bitrate = 19200;
			} else if (radio38400 == r) {
				bitrate = 38400;
			} else if (radio57600 == r) {
				bitrate = 57600;
			} else if (radio115200 == r) {
				bitrate = 115200;
			}
			if (bitrate != appData.bitRate) {
				appData.bitRate = bitrate;
				CommonTools.savePerferences(this.getApplicationContext(),appData.bitRateName,""+appData.bitRate);
				App.restartScan();
			}
		}
	}
	
}
