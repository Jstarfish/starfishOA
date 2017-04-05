package com.huacai.assist.main;

import java.util.ArrayList;
import java.util.Arrays;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.ArrayAdapter;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.TextView;

import com.huacai.assist.common.App;
import com.huacai.assist.common.BaseActivity;
import com.huacai.assist.main.YYcAdapter.YYcData;
import com.huacai.assist.net.Http;
import com.huacai.assist.net.NetResult;
import com.huacai.assist.net.RequestListener;
import com.huacai.pistore.R;
/**
 * 
 * 出货单列表
 * 
 * @author sloanyyc
 *
 */
public class SelectOutMoveStoreListActivity extends BaseActivity implements RequestListener, OnItemClickListener, OnSetItemListener, OnItemSelectedListener{
	private ListView lv;
	private TextView tv1;
	private Spinner sp1;
	private TextView tv3;
	private TextView tv4;
	private TextView tv5;
	private TextView tv6;
	private TextView tv7;
	private TextView tv8;
	private LinearLayout panel1;
	private LinearLayout panel2;
	private LinearLayout panel3;
	private ArrayAdapter<String> sp1adapter;
	protected JSONArray jsonArray;
	private YYcAdapter yycAdapter = null;
	@Override
	public void initView() {
		super.initView();
		setMiddleText(R.string.string_move_out_store);//设置标题
		lv=(ListView)findViewById(R.id.listView1);
		lv.setOnItemClickListener(this);
		panel1 = (LinearLayout)findViewById(R.id.panel1);
		panel2 = (LinearLayout)findViewById(R.id.panel2);
		panel3 = (LinearLayout)findViewById(R.id.panel3);
		panel2.setVisibility(View.VISIBLE);
		panel3.setVisibility(View.VISIBLE);
		tv1 = (TextView)findViewById(R.id.textView1);
		sp1 = (Spinner)findViewById(R.id.spinner1);
		tv3 = (TextView)findViewById(R.id.textView3);
		tv4 = (TextView)findViewById(R.id.textView4);
		tv5 = (TextView)findViewById(R.id.textView5);
		tv6 = (TextView)findViewById(R.id.textView6);
		tv7 = (TextView)findViewById(R.id.textView7);
		tv8 = (TextView)findViewById(R.id.textView8);
		tv1.setText(R.string.string_check_store_no);
		tv3.setText(R.string.string_check_store_lottery);
		tv4.setText("");
		tv5.setText(R.string.string_check_store_batch);
		tv6.setText("");
		tv7.setText(R.string.string_check_store_user);
		tv8.setText("");
		
		ArrayList<String> entries = new ArrayList<String>();
		// 建立Adapter并且绑定数据源
		sp1adapter=new ArrayAdapter<String>(this,android.R.layout.simple_spinner_item, entries);
		sp1adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
		//绑定 Adapter到控件
		sp1.setAdapter(sp1adapter);
		sp1.setOnItemSelectedListener(this);
	}
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		initActivity(this,R.layout.activity_select_list);//初始化Activity
		initView();//初始化视图
		initData();//初始化数据
		initHandle();//初始化Handle
		sendInitialMsg();
	}

	/**
	 * 刚进入页面时获取出货单列表信息发送的数据
	 */
	public void sendInitialMsg(){
		JSONObject jo = new JSONObject();//构建数据包
		try {
			jo.put("listType", "1");
		} catch (JSONException e) {
			e.printStackTrace();
		}
		Http.request(Http.MKT_MGR_STORE_CHECK, jo, this);//发送查询数据的请求
	}

	@Override
	public void onComplete(NetResult res) {//接收网络数据
		Log.e("yyc", "onComplete "+res.errorStr);
		JSONObject result;//数据包
		
		// 测试信息
		String fackJson = App.getResRawString(R.raw.r020503);
		try {
			res.errorCode = 0;
			res.jsonObject = new JSONObject(fackJson);
		} catch (JSONException e1) {
			e1.printStackTrace();
		}
		
		if (res.jsonObject != null) {//如果返回的数据包为空
			try {
				int errCode = res.jsonObject.getInt("errcode");//返回的错误码
				if (res.errorCode == 0 && errCode == 0) {//如果错误码位0
					result=res.jsonObject.getJSONObject("result");//数据包赋值
					final JSONObject resultData = result;
					this.runOnUiThread(new Runnable() {
						@Override
						public void run() {
							// 显示盘点列表
							// "2|1,ff0000,2,00ff00,0000ff"
//							YYcAdapter adapter = new YYcAdapter(CheckInventoryListActivity.this,
//									R.layout.list_four_item,
//									resultData, "dealList",
//									new String[]{"time", "outletCode", "dealtypeValue", "amount", "dealtype"},
//									new String[]{"time",			"", 		"",				"longR", ""});
//							adapter.setOnSetItemListener(CheckInventoryListActivity.this);
//							lv.setAdapter(adapter);
							try {
								jsonArray = resultData.getJSONArray("checkList");
								if (jsonArray != null) {
									sp1adapter.clear();
									int cnt = jsonArray.length();
									for (int i=0; i<cnt; i++) {
										JSONObject item = jsonArray.getJSONObject(i);
										
										sp1adapter.add(item.getString("checkNo"));
									}
								}
							} catch (JSONException e) {
								e.printStackTrace();
							}
						}
					});
				}
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
		
	}
	@Override
	public void onItemClick(AdapterView<?> av, View v, final int index, long pos) {
		
	}
	@Override
	public void onSetItem(View v, YYcData tvs, String[] data) {
		// set base on data value
		
	}
	@Override
	public void onItemSelected(AdapterView<?> av, View v, int n, long id) {
		// checkList
		if (jsonArray != null && jsonArray.length() > n) {
			try {
				JSONObject jo = jsonArray.getJSONObject(n);
				JSONArray list = jo.getJSONArray("planList");
				if (yycAdapter == null) {
					yycAdapter = new YYcAdapter(this, R.layout.list_three_item,
							jo, "planList",
							new String[]{"code", "inStoreTickets", "checkTickets"},
							new String[]{"","",""});
					lv.setAdapter(yycAdapter);
				} else {
					yycAdapter.setJsonData(list);
					yycAdapter.notifyDataSetChanged();
				}
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
	}
	@Override
	public void onNothingSelected(AdapterView<?> av) {
		Log.e("yyc", "yyc onNothingSelected "+av);
	}
}

