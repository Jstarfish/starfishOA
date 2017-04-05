package com.huacai.assist.setting;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;

import com.huacai.assist.common.BaseActivity;
import com.huacai.assist.common.appData;
import com.huacai.assist.main.menuAdapter;
import com.huacai.pistore.R;
/**
 * 设置
 */
public class SettingActivity extends BaseActivity {

	ListView setting_menu = null;//菜单列表
	
	int menu_market_logo[] = {//市场管理员选项对应图标
			R.drawable.setting_1,
			R.drawable.setting_2,
			R.drawable.setting_3
		};
	int menu_site_logo[] = {
			R.drawable.ic_launcher,
			R.drawable.ic_launcher,
			R.drawable.ic_launcher
		};
	
	@Override
	public void initData() {//站点管理员选项对应图标
		// TODO Auto-generated method stub
		super.initData();
	}

	@Override
	public void initView() {
		// TODO Auto-generated method stub
		super.initView();
		setMiddleText(R.string.title_activity_setting);
		
		setting_menu = (ListView) findViewById(R.id.setting_menu);
		
		if (appData.user_type == 1){//市场管理员
			setting_menu.setAdapter(new menuAdapter(this,getResources().getStringArray(R.array.setting_market_name),menu_market_logo));//设置菜单列表的适配器
			
			setting_menu.setOnItemClickListener(new OnItemClickListener(){

				@Override
				public void onItemClick(AdapterView<?> arg0, View arg1,
						int arg2, long arg3) {
					// TODO Auto-generated method stub
					switch(arg2){
					case 0: //设备信息
						SettingActivity.this.startActivity(new Intent(SettingActivity.this,DeviceInfoActivity.class));
						break;
					case 1: //扫描测试
						SettingActivity.this.startActivity(new Intent(SettingActivity.this,ScanTestActivity.class));
						break;
					}
				}
				
			});
		}else if (appData.user_type == 2){//站点管理员
			setting_menu.setAdapter(new menuAdapter(this,getResources().getStringArray(R.array.setting_site_name),menu_site_logo));
			
			setting_menu.setOnItemClickListener(new OnItemClickListener(){

				@Override
				public void onItemClick(AdapterView<?> arg0, View arg1,
						int arg2, long arg3) {
					// TODO Auto-generated method stub
					switch(arg2){
					case 0: //通讯测试
						break;
					case 1: //扫描测试
						break;
					case 2: //设备信息
						break;
					}
				}
				
			});
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
		initActivity(this,R.layout.activity_setting);
		initData();
		initView();
		initHandle();
	}

}
