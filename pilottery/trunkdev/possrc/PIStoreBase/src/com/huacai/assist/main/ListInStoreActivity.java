package com.huacai.assist.main;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;
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
public class ListInStoreActivity extends BaseActivity implements RequestListener, OnItemClickListener, OnSetItemListener{
	private ListView lv;
	private TextView tv1;
	private TextView tv2;
	protected YYcAdapter adapter;
	@Override
	public void initView() {
		super.initView();
		setMiddleText(R.string.string_in_store_list);//设置标题
		lv=(ListView)findViewById(R.id.list1);
		lv.setOnItemClickListener(this);
		tv1 = (TextView) findViewById(R.id.tv1);
		tv2 = (TextView) findViewById(R.id.tv2);
		tv1.setText(R.string.withdraw_date);
		tv2.setText(R.string.withdraw_amount);
	}
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		initActivity(this,R.layout.activity_one_list);//初始化Activity
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
//		try {
//			jo.put("listType", "1");
//		} catch (JSONException e) {
//			e.printStackTrace();
//		}
		Http.request(Http.STORE_IN_LIST, jo, this);//发送查询数据的请求
	}

	@Override
	public void onComplete(NetResult res) {//接收网络数据
		Log.e("yyc", "onComplete "+res.errorStr);
		JSONObject result;//数据包
		
		// 测试信息
		String fackJson = App.getResRawString(R.raw.r070001);
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
						public void run() {//更新出货单列表
							adapter = new YYcAdapter(ListInStoreActivity.this,
									R.layout.list_four_item,
									resultData, "recordList",
									new String[]{"time", "sendOrg", "type", "amount", "typeValue", "status", "sgrNo"},
									new String[]{"time",		"", 		"",		"longR", 	"",			"",		""});
							adapter.setOnSetItemListener(ListInStoreActivity.this);
							lv.setAdapter(adapter);
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
		String[] data = adapter.data.get(index);
		if (data!= null && data.length > 6 && data[5].equals("0")) {
//			data[6]; // dealNo
			if (data[4].equals("1")) {
				// 批次入库
				startActivity(new Intent(this, SelectInBatchStoreListActivity.class));
			} else if (data[4].equals("2")) {
				// 调拨单入库
				startActivity(new Intent(this, SelectInMoveStoreListActivity.class));
			} else if (data[4].equals("3")) {
				// 还货入库
				startActivity(new Intent(this, SelectInReturnStoreListActivity.class));
			}
		}
	}
	@Override
	public void onSetItem(View v, YYcData tvs, String[] data) {
		// set base on data value
		if (data[5].equals("0")) {
			tvs.texts[0].setTextColor(0xffff0000);
			tvs.texts[1].setTextColor(0xffff0000);
			tvs.texts[2].setTextColor(0xffff0000);
			tvs.texts[3].setTextColor(0xffff0000);
			tvs.arrow.setVisibility(View.VISIBLE);
		} else {
			tvs.texts[0].setTextColor(0xff000000);
			tvs.texts[1].setTextColor(0xff000000);
			tvs.texts[2].setTextColor(0xff000000);
			tvs.texts[3].setTextColor(0xff000000);
			tvs.arrow.setVisibility(View.INVISIBLE);
		}
	}
}

