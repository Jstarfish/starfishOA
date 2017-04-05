package com.huacai.assist.main;

import java.util.ArrayList;
import java.util.HashMap;

import org.json.JSONArray;
import org.json.JSONObject;

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

import com.huacai.assist.R;
import com.huacai.assist.adapter.menuAdapter;
import com.huacai.assist.common.BaseActivity;
import com.huacai.assist.common.appData;
import com.huacai.assist.form.FormListActivity;
import com.huacai.assist.money.QueryFundActivity;
import com.huacai.assist.net.Http;
import com.huacai.assist.net.NetResult;
import com.huacai.assist.net.RequestListener;
import com.huacai.assist.setting.SettingActivity;
import com.huacai.assist.site.SiteListActivity;
import com.huacai.assist.store.QueryStockActivity;

public class MainMenuActivity extends BaseActivity implements RequestListener, LocationListener {
	ListView main_menu = null;
	
	private int menu_market_logo[] = {
			R.drawable.icon_chdgl,	// 出货单管理
			R.drawable.icon_zjgl,	// 资金管理
			R.drawable.icon_jyjl,	// 资金日结
			R.drawable.icon_zjrj,	// 交易记录
			R.drawable.icon_zdfw,	// 站点服务
			
			R.drawable.icon_kccx,	// 库存查询
			R.drawable.icon_kcpd,	// 库存盘点
			R.drawable.icon_wlcx,	// 物流查询
			R.drawable.icon_kcrj,	// 库存日结
			R.drawable.icon_setting,	// 系统设置
		};
	private int menu_site_logo[] = {
			R.drawable.ic_launcher,
			R.drawable.ic_launcher,
			R.drawable.ic_launcher,
			R.drawable.ic_launcher,
			R.drawable.ic_launcher,
			R.drawable.ic_launcher,
			R.drawable.ic_launcher,
			R.drawable.ic_launcher};
	
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
				public void onItemClick(AdapterView<?> arg0, View arg1,
						int arg2, long arg3) {
					// TODO Auto-generated method stub
					switch(arg2){
					case 0: //出货管理
						MainMenuActivity.this.startActivity(new Intent(MainMenuActivity.this,
								FormListActivity.class));
						break;
					case 1: //资金管理
						MainMenuActivity.this.startActivity(new Intent(MainMenuActivity.this,
								QueryFundActivity.class));
						break;
					case 2: //资金日结
						MainMenuActivity.this.startActivity(new Intent(MainMenuActivity.this,
								CashDailyActivity.class));
						break;
					case 3: //交易记录
						MainMenuActivity.this.startActivity(new Intent(MainMenuActivity.this,
								BusinessRecordActivity.class));
						break;
					case 4: //站点服务
//						MainMenuActivity.this.startActivity(new Intent(MainMenuActivity.this,SiteActivity.class));
						Http.request(Http.SITE_LIST,  new JSONObject(), MainMenuActivity.this);
						break;
					case 5: //库存查询
						MainMenuActivity.this.startActivity(new Intent(MainMenuActivity.this,
								QueryStockActivity.class));
						break;
					case 6: //库存盘点
						MainMenuActivity.this.startActivity(new Intent(MainMenuActivity.this,
								CheckInventoryActivity.class));
						break;
					case 7: //物流查询
						MainMenuActivity.this.startActivity(new Intent(MainMenuActivity.this,
								LogisticsActivity.class));
						break;
					case 8: //库存日结
						MainMenuActivity.this.startActivity(new Intent(MainMenuActivity.this,
								StoreDailyActivity.class));
						break;
					case 9: //系统设置
						MainMenuActivity.this.startActivity(new Intent(MainMenuActivity.this,
								SettingActivity.class));
						break;
					}
				}
				
			});
		}else if (appData.user_type == 2){
			main_menu.setAdapter(new menuAdapter(this,getResources().getStringArray(R.array.menu_site_name),menu_site_logo));
			
			main_menu.setOnItemClickListener(new OnItemClickListener(){

				@Override
				public void onItemClick(AdapterView<?> arg0, View arg1,
						int arg2, long arg3) {
					// TODO Auto-generated method stub
					switch(arg2){
					case 7: //退出登录
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
	public void onComplete(NetResult res) {
		String strError = null;
		Log.e("yyc", "onComplete " + res.errorStr);
		if (res.jsonObject != null) {
			try {
				int errCode = res.jsonObject.getInt("errcode");
				if (res.errorCode == 0 && errCode == 0) {
//					outletList
//					outletCode
//					outletName
//					contactPerson
//					contactPhone
					JSONObject jo = res.jsonObject.getJSONObject("result");
					JSONArray ja = jo.getJSONArray("outletList");
					int cnt = ja.length();
					ArrayList<HashMap<String,String>> list=new ArrayList<HashMap<String,String>>();
					for (int i=0; i<cnt; i++) {
						jo = ja.getJSONObject(i);
						HashMap<String,String> map=new HashMap<String,String>();
				        map.put("code", jo.getString("outletCode"));
				        map.put("name", jo.getString("outletName"));
				        map.put("owner", jo.getString("contactPerson"));
				        map.put("phone", jo.getString("contactPhone"));
						list.add(map);
					}
					SiteListActivity.listdata = list;
					MainMenuActivity.this.startActivity(new Intent(MainMenuActivity.this, SiteListActivity.class));
					return ;
				}
				strError = res.jsonObject.getString("errmesg");
			} catch (Exception e) {
				
			}
		}
		if (strError != null) {
//			App.showMessage(strError, App.getResString(R.string.com_tishi));
		}
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
