package com.huacai.assist.site;

import java.util.ArrayList;
import java.util.HashMap;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.TextView;

import com.huacai.assist.R;
import com.huacai.assist.common.BaseActivity;
import com.huacai.assist.common.appData;

public class SiteListActivity extends BaseActivity implements OnItemClickListener {

	public static ArrayList<HashMap<String, String>> listdata = null;
	ListView listview = null;
	
	@Override
	public void initData() {//站点管理员选项对应图标
		super.initData();
	}

	@Override
	public void initView() {
		super.initView();
		setMiddleText(R.string.title_activity_site_list);
		listview = (ListView) findViewById(R.id.site_list);
//		ArrayList<HashMap<String,String>> list=new ArrayList<HashMap<String,String>>();
//        HashMap<String,String> map1=new HashMap<String,String>();
//        HashMap<String,String> map2=new HashMap<String,String>();
//        HashMap<String,String> map3=new HashMap<String,String>();
//        map1.put("code", "10010001");
//        map1.put("name", "某某站点");
//        map1.put("owner", "凝墨");
//        map1.put("phone", "13699452790");
//        map2.put("code", "10010001");
//        map2.put("name", "某某站点");
//        map2.put("owner", "凝墨");
//        map2.put("phone", "13699452790");
//        map3.put("code", "10010001");
//        map3.put("name", "某某站点");
//        map3.put("owner", "凝墨");
//        map3.put("phone", "13699452790");
//        
//        list.add(map1);
//        list.add(map2);
//        list.add(map3);
        SimpleAdapter listAdapter=new SimpleAdapter(this,
        		listdata,
        		R.layout.site_list_item,
        		new String[] {"code","name","owner","phone"},
        		new int[] {R.id.site_code,R.id.site_name,R.id.site_owner,R.id.site_phone});
        listview.setAdapter(listAdapter);
        listview.setOnItemClickListener(this);
	}

	@Override
	public void initHandle() {
		super.initHandle();
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		initActivity(this,R.layout.activity_site_list);
		initData();
		initView();
		initHandle();
	}

	@Override
	public void onItemClick(AdapterView<?> av, View v, int i, long j) {
		TextView tv = (TextView)v.findViewById(R.id.site_code);
		appData.stationCode = (String) tv.getText();
		this.startActivity(new Intent(this,SiteActivity.class));
	}

}
