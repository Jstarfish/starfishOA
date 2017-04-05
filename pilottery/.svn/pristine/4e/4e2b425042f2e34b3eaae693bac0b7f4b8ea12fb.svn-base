package com.huacai.assist.main;

import org.json.JSONException;
import org.json.JSONObject;

import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;

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
public class ListInventoryActivity extends BaseActivity implements RequestListener, OnItemClickListener, OnSetItemListener{
	private ListView lv;
	protected YYcAdapter adapter;
	@Override
	public void initView() {
		super.initView();
		setMiddleText(R.string.string_check_store_list);//设置标题
		lv=(ListView)findViewById(R.id.list1);
		lv.setOnItemClickListener(this);
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
		String fackJson = App.getResRawString(R.raw.r020502);
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
							adapter = new YYcAdapter(ListInventoryActivity.this,
									R.layout.list_four_item,
									resultData, "dealList",
									new String[]{"time", "outletCode", "dealtypeValue", "amount", "dealtype", "finish", "dealNo"},
									new String[]{"time",			"", 		"",				"longR", 	"",			"",		""});
							adapter.setOnSetItemListener(ListInventoryActivity.this);
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

