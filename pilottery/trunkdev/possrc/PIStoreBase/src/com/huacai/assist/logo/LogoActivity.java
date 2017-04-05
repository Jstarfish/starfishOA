package com.huacai.assist.logo;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;

import com.huacai.assist.common.BaseActivity;
import com.huacai.assist.common.CommonTools;
import com.huacai.assist.common.appData;
import com.huacai.assist.main.MainMenuActivity;
import com.huacai.pistore.R;

public class LogoActivity extends BaseActivity {

	@Override
	public void initData() {
		super.initData();
	}

	@Override
	public void initView() {
		super.initView();
	}

	@Override
	public void initHandle() {
		super.initHandle();
		mainHandler = new Handler(){
			@Override
			public void handleMessage(Message msg) {
				super.handleMessage(msg);
				
				switch (msg.what){
				default:
					break;
				case 1:
//					Http.o.token = "002420151030094357061449b6-f4ea-";
					Intent intent = new Intent(LogoActivity.this,MainMenuActivity.class);
//					Intent intent = new Intent(LogoActivity.this,SelectCheckInventoryListActivity.class);
					LogoActivity.this.startActivity(intent);
					LogoActivity.this.finish();
					break;
				}
			}
		};
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_logo);
		
		initHandle();
//		从配置文件中读取ip和port
		appData.serverIpAddress_1 = CommonTools.getPerferences(this.getApplicationContext(),appData.serverIpName_1,appData.serverIpAddress_1);
		appData.serverPort_1 = CommonTools.getPerferences(this.getApplicationContext(),appData.serverPortName_1,appData.serverPort_1);
		appData.serverIpAddress_2 = CommonTools.getPerferences(this.getApplicationContext(),appData.serverIpName_2,appData.serverIpAddress_2);
		appData.serverPort_2 = CommonTools.getPerferences(this.getApplicationContext(),appData.serverPortName_2,appData.serverPort_2);
		String bitRate = CommonTools.getPerferences(this.getApplicationContext(),appData.bitRateName,""+appData.bitRate);
		appData.bitRate = Integer.parseInt(bitRate);
		//最后一次联通使用哪个ip
//		appData.usIpTag = CommonTools.getPerferences(this.getApplicationContext(),appData.usIpTag,"1");
//设置本次使用的ip
//		if(appData.usIpTag.equals("1"))
		appData.useIp1();//需求 ，默认每次启动都使用ip1
//		else
//			appData.useIp2();
		
		mainHandler.sendEmptyMessageDelayed(1,1000);
	}

	@Override
	protected void onDestroy() {
		// TODO Auto-generated method stub
		super.onDestroy();
	}
	
	
}
