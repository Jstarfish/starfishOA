package com.huacai.assist.site;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.os.Bundle;
import android.util.Log;
import android.widget.ListView;
import android.widget.TextView;

import com.huacai.assist.R;
import com.huacai.assist.adapter.ThreeTvAdapter;
import com.huacai.assist.common.App;
import com.huacai.assist.common.BaseActivity;
import com.huacai.assist.common.appData;
import com.huacai.assist.net.Http;
import com.huacai.assist.net.NetResult;
import com.huacai.assist.net.RequestListener;

/**
 * 交易流水
 */
public class QueryBusinessActivity extends BaseActivity implements RequestListener{
	/** 账户余额 */
	private TextView remainder;
	/** 信用额度 */
	private TextView limitOfCredit;
	/** 可用额度 */
	private TextView available;
	/** 交易流水页面列表第一行，即时间 */
	private String[] testStrAry1={};
	/** 交易流水页面列表第二行，即交易类型 */
	private String[] testStrAry2={};
	/** 交易流水页面列表第三行，即交易金额 */
	private String[] testStrAry3={};
	/** 页面列表适配器 */
	private ThreeTvAdapter adapter;
	/** 页面列表（资金明细） */
	private ListView lv;
	@Override
	public void initView() {
		// TODO Auto-generated method stub
		super.initView();
		setMiddleText(R.string.title_activity_query_business);//设置标题
		remainder=(TextView)findViewById(R.id.remainder);//组件赋值
		limitOfCredit=(TextView)findViewById(R.id.credit);
		available=(TextView)findViewById(R.id.available);
		lv=(ListView)findViewById(R.id.list);
	}
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		initActivity(this,R.layout.activity_query_business);//初始化Activity
		initData();//初始化数据
		initView();//初始化视图
		initHandle();//初始化Handle
		sendQueryFundMsg();//发送数据请求资金流水信息
	}
	/**
	 * 站点资金流水查询
	 */
	public void sendQueryFundMsg(){
		JSONObject jo = new JSONObject();//发送的数据包
		try {
			jo.put("outletCode", appData.stationCode);//站点号加入数据包
			jo.put("follow", "");//查询起始加入数据包
			jo.put("count", 500);//查询条数加入数据包
		} catch (JSONException e) {
			e.printStackTrace();
		}
		Http.request(Http.QUERY_BUSINESS, jo, this);//发送请求数据
	}
	/**
	 * 接收网络数据
	 */
	@Override
	public void onComplete(NetResult res) {
		// TODO Auto-generated method stub
		Log.e("yyc", "onComplete "+res.errorStr);
		if (res.jsonObject != null) {//如果返回的数据包为空
			try {
				int errCode = res.jsonObject.getInt("errcode");//错误码赋值
				if (res.errorCode == 0 && errCode == 0) {//如果错误码为0
					JSONObject jo = res.jsonObject.getJSONObject("result");//返回的数据包赋值
					JSONArray ja = null;
					if(!jo.isNull("recordList"))
						ja=jo.getJSONArray("recordList");//资金流水列表
					else
						ja=null;
					if(ja!=null){
						int count = ja.length();//资金流水列表条目数
						//构建用来显示每列的数组
						testStrAry1 = new String[count];
						testStrAry2 = new String[count];
						testStrAry3 = new String[count];
						for (int i=0; i<count; i++) {//循环为每列对应的数组赋值
							JSONObject item = ja.getJSONObject(i);//每个条目对应的三个数据
							testStrAry3[i] = App.getPriceFormated(item.getLong("amount"));//流水金额赋值
							testStrAry2[i] = ""+item.getString("type");//流水类型
							if (testStrAry2[i].length() > 10) {
								testStrAry2[i] = testStrAry2[i].substring(0, 9);
							}
							testStrAry1[i] = ""+item.getString("time");
							if (testStrAry1[i].length() > 16) {
								testStrAry1[i] = testStrAry1[i].substring(5, 16);
								//testStrAry3[i].replaceAll("(\\\\d\\\\d\\\\d\\\\d-)(\\\\d\\\\d-\\\\d\\d \\\\d\\\\d:\\\\d\\\\d)(:\\\\d\\\\d)", "$2");
							}
						}
					}
					final long balance = jo.getLong("balance");//赋值
					
					final long credit = jo.getLong("credit");
					
					this.runOnUiThread(new Runnable() {//开启新的UI线程
						@Override
						public void run() {
							//赋值
							remainder.setText(App.getPriceFormated(balance)+App.getResString(R.string.com_unit));
							limitOfCredit.setText(App.getPriceFormated(credit)+App.getResString(R.string.com_unit));
							available.setText(App.getPriceFormated(balance+credit)+App.getResString(R.string.com_unit));
							if(testStrAry2.length!=0){
								adapter=new ThreeTvAdapter(QueryBusinessActivity.this, testStrAry1, testStrAry2, testStrAry3, R.layout.query_business_item);//构建列表适配器
								lv.setAdapter(adapter);//设置列表适配器
								adapter.setData(testStrAry1, testStrAry2, testStrAry3);//设置列表内容
							}
						}});
				}
			} catch (JSONException e) {
				e.printStackTrace();
			}
	}
	}
}
