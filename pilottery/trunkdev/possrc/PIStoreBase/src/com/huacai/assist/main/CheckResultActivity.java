package com.huacai.assist.main;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.os.Bundle;
import android.widget.ListView;
import android.widget.TextView;

import com.huacai.assist.common.BaseActivity;
import com.huacai.pistore.R;
/**
 * 
 * 出货单列表
 * 
 * @author sloanyyc
 *
 */

public class CheckResultActivity extends BaseActivity {
	public static JSONObject data = null;
	private ListView lv;
	private TextView quantity1;
	private TextView quantity2;
	private TextView quantity3;
	private String[] testStrAry1={"J0004-223344-2233","J0004-223344-2233","J0004-223344-2233"};
	private String[] testStrAry2={"100R","100R","100R"};
	private int[] colors = {0xff000000, 0xffff0000, 0xffff0000};
	@Override
	public void initView() {
		// TODO Auto-generated method stub
		super.initView();
		setMiddleText(R.string.check_invy);//设置标题
		lv=(ListView)findViewById(R.id.list1);
		quantity1=(TextView)findViewById(R.id.quantity1_value);
		quantity2=(TextView)findViewById(R.id.quantity2_value);
		quantity3=(TextView)findViewById(R.id.quantity3_value);
//		inventoryTickets
//		checkTickets
//		diffTickets
//		recordList
//		tagCode
//		status
		try {
			int inventoryTickets = data.getInt("inventoryTickets");
			int checkTickets = data.getInt("checkTickets");
			int diffTickets = data.getInt("diffTickets");
			quantity1.setText(""+inventoryTickets);
			quantity2.setText(""+checkTickets);
			quantity3.setText(""+diffTickets);
			JSONArray ja = data.getJSONArray("recordList");
			testStrAry1 = new String[ja.length()];
			testStrAry2 = new String[ja.length()];
			colors = new int[ja.length()];
			for (int i=0; i<ja.length(); i++) {
				JSONObject jo = ja.getJSONObject(i);
				testStrAry1[i] = jo.getString("tagCode");
				testStrAry2[i] = jo.getString("statusValue");
				String status = jo.getString("status");
				if (status.equals("1")) {
					colors[i] = 0xffff0000;
				} else {
					colors[i] = 0xff653bd3;
				}
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		initActivity(this,R.layout.activity_check_invy2);//初始化Activity
		initView();//初始化视图
		initData();//初始化数据
		initHandle();//初始化Handle
//		sendInitialMsg();//发送查询出货单列表的请求数据
	}
	public void initData(){
		TwoTvAdapter adapter=new TwoTvAdapter(CheckResultActivity.this, testStrAry1, testStrAry2,  R.layout.business_child_item2);//
		adapter.setColors(colors);
		lv.setAdapter(adapter);//
	}
}


