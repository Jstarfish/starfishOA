package com.huacai.assist.main;

import android.content.Context;
import android.content.Intent;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.huacai.assist.common.BaseActivity;
import com.huacai.assist.common.appData;
import com.huacai.assist.net.Http;
import com.huacai.assist.setting.SettingActivity;
import com.huacai.pistore.R;

public class MainMenuActivity extends BaseActivity implements LocationListener {
	ListView main_menu = null;
	/*
	 	0<item>入库记录</item>
        1<item>批次入库</item>
        2<item>调拨单入库</item>
        3<item>还货单入库</item>
        4<item>出库记录</item>
        5<item>调拨单出库</item>
        6<item>出货单出库</item>
        7<item>盘点记录</item>
        8<item>库存盘点</item>
        9<item>物流查询</item>
        10<item>系统设置</item>
        */
	private int menu_market_logo[] = {
			R.drawable.icon_rkjl,
			R.drawable.icon_pcrk,
			R.drawable.icon_dbdrk,
			R.drawable.icon_hhdrk,
			
			R.drawable.icon_ckjl,
			R.drawable.icon_dbdck,
			R.drawable.icon_chdck,

			R.drawable.icon_ckpd, // 盘点记录，有点问题 
			R.drawable.icon_kcpd,
			R.drawable.icon_wlcx,
			R.drawable.icon_setting,};
	private TextView user_name_view = null;

	private LocationManager locationManager;

	private double latitude;

	private double longitude;
	
	@Override
	public void initData() {
		// TODO Auto-generated method stub
		super.initData();
	}

	@Override
	public void onBackPressed() {
		//super.onBackPressed();
	}
	
	@Override
	public void initView() {
		// TODO Auto-generated method stub
		super.initView();
		setMiddleText(R.string.title_activity_main_menu);
		LinearLayout sss = (LinearLayout)findViewById(R.id.sss);
		sss.setBackgroundColor(0xEEEEEEFF);
		user_name_view = (TextView) findViewById(R.id.user_name);
		main_menu = (ListView) findViewById(R.id.main_menu);
		setGoBackGone();
		user_name_view.setText(appData.username);
		
		if (appData.user_type == 1){
			main_menu.setAdapter(new menuAdapter(this,getResources().getStringArray(R.array.menu_market_name),menu_market_logo));
			main_menu.setOnItemClickListener(new OnItemClickListener(){
				@Override
				public void onItemClick(AdapterView<?> av, View v,
						int id, long ln) {
					MainMenuActivity thiz = MainMenuActivity.this;
					switch(id){
					case 0: // 入库记录
						startActivity(new Intent(thiz, ListInStoreActivity.class));
						break;
					case 1: // 批次入库
						startActivity(new Intent(thiz, SelectInBatchStoreListActivity.class));
						break;
					case 2: // 调拨单入库
						startActivity(new Intent(thiz, SelectInMoveStoreListActivity.class));
						break;
					case 3: // 还货入库
						startActivity(new Intent(thiz, SelectInReturnStoreListActivity.class));
						break;

					case 4: // 出库记录
						startActivity(new Intent(thiz, ListOutStoreActivity.class));
						break;
					case 5: // 调拨单出库
						startActivity(new Intent(thiz, SelectOutMoveStoreListActivity.class));
						break;
					case 6: // 出货单出库
						startActivity(new Intent(thiz, SelectOutStoreListActivity.class));
						break;

					case 7: // 盘点记录
						startActivity(new Intent(thiz, ListInventoryActivity.class));
						break;
					case 8: // 库存盘点
						startActivity(new Intent(MainMenuActivity.this,
								SelectCheckInventoryListActivity.class));
						break;
					case 9: // 物流查询
						startActivity(new Intent(MainMenuActivity.this,
								LogisticsActivity.class));
						break;
					case 10: //系统设置
						startActivity(new Intent(MainMenuActivity.this,
								SettingActivity.class));
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
		initActivity(this,R.layout.activity_main_menu);
		
		locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
        locationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 0,
                0, this);
		initData();
		initView();
		initHandle();
	}

	@Override
	public void onLocationChanged(Location lo) {
		latitude = lo.getLatitude();
		longitude = lo.getLongitude();
		Http.setLocation(latitude, longitude);
		Log.e("yyc", "la: "+latitude + ", lo: "+ longitude);
		locationManager.removeUpdates(this);
	}

	@Override
	public void onProviderDisabled(String dis) {
		Log.e("yyc", "onProviderDisabled "+dis);
	}

	@Override
	public void onProviderEnabled(String en) {
		Log.e("yyc", "onProviderEnabled "+en);
	}

	@Override
	public void onStatusChanged(String st, int n, Bundle bu) {
		Log.e("yyc", "onStatusChanged "+st+", "+n+", Bundle "+bu);
	}
}
