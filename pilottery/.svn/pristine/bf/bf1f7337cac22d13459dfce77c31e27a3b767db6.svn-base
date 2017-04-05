package com.huacai.assist.money;

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
import com.huacai.assist.net.Http;
import com.huacai.assist.net.NetResult;
import com.huacai.assist.net.RequestListener;

/**
 * 资金管理
 */
public class QueryFundActivity extends BaseActivity implements RequestListener{
	/** 用来显示账户余额*/
	private TextView remainder;
	/** 用来显示信用额度*/
	private TextView limitOfCredit;
	/** 用来显示资金明细*/
	private ListView lv;
	/** 资金明细第一列，即时间*/
	private String[] testStrAry1={};
	/** 资金明细第二列，即资金变动类型*/
	private String[] testStrAry2={};
	/** 资金明细第二列，即金额*/
	private String[] testStrAry3={};
	
	
	@Override
	public void initView() {
		// TODO Auto-generated method stub
		super.initView();
		setMiddleText(R.string.title_activity_money);//设置标题
		remainder=(TextView)findViewById(R.id.remainder);//赋值
		limitOfCredit=(TextView)findViewById(R.id.credit);
		lv=(ListView)findViewById(R.id.list);
	}
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		initActivity(this,R.layout.activity_query_fund);//初始化Activity
		initData();//初始化数据
		initView();//初始化视图
		initHandle();//初始化Handle
		sendQueryFundMsg();//发送数据请求资金变动信息
	}
	public void sendQueryFundMsg(){//发送消息查询页面初始信息
		JSONObject jo = new JSONObject();//发送的数据包
		try {
			jo.put("follow", "");//将查询起始加入到数据包
			jo.put("count", 500);//将查询条数加入导数据报
		} catch (JSONException e) {
			e.printStackTrace();
		}
		Http.request(Http.QUERY_FUND, jo, this);//发送查询消息
	}
	@Override
	public void onComplete(NetResult res) {//接收数据
		// TODO Auto-generated method stub
		Log.e("yyc", "onComplete "+res.errorStr);
		final JSONObject result;//接收的数据包
		final JSONArray recordList;//资金流动明细列表
		if (res.jsonObject != null) {//如果数据包为空
			try {
				int errCode = res.jsonObject.getInt("errcode");//接收到的错误码
				if (res.errorCode == 0 && errCode == 0) {//如果错误码为0
//				if (true) {//如果错误码为0
					result=res.jsonObject.getJSONObject("result");//接收到的数据包赋值到本地
					if(!result.isNull("recordList"))
						recordList=result.getJSONArray("recordList");//接收到的资金流动明细赋值到本地
					else
						recordList=null;
					this.runOnUiThread(new Runnable() {//开启新UI线程
						@Override
						public void run() {//更新账户信息及资金明细列表
							try {
								long remain = result.getLong("balance");//得到余额
								long limit=result.getLong("credit");//得到信用额
								String remain1=App.getPriceFormated(remain)+QueryFundActivity.this.getString(R.string.com_unit);//将余额转换为3个数字一个逗点的格式并加上单位com_unit
								String limit1=App.getPriceFormated(limit)+QueryFundActivity.this.getString(R.string.com_unit);//将信用额转换为3个数字一个逗点的格式并加上单位
								remainder.setText(remain1);//显示余额
								limitOfCredit.setText(limit1);//显示信用额
							} catch (JSONException e1) {
								// TODO Auto-generated catch block
								e1.printStackTrace();
							}
							
							if(!result.isNull("recordList")){
								int listLength=recordList.length();//获取烈数组长度
								testStrAry1=new String[listLength];//新建列数组实例
								testStrAry2=new String[listLength];
								testStrAry3=new String[listLength];
								for(int i=0;i<listLength;i++){
									try {
										testStrAry1[i]=recordList.getJSONObject(i).getString("time");//获得时间
										testStrAry2[i]=recordList.getJSONObject(i).getString("type");//获得类型
										testStrAry3[i]=App.getPriceFormated(recordList.getJSONObject(i).getLong("amount"));//获得总额
									} catch (JSONException e) {
										// TODO Auto-generated catch block
										e.printStackTrace();
									}
									
								}
								ThreeTvAdapter adapter=new ThreeTvAdapter(QueryFundActivity.this, testStrAry1, testStrAry2, testStrAry3, R.layout.query_fund_item);//构建主列表适配器
								lv.setAdapter(adapter);//设置主列表适配器
							}
						}
					});
				}
			} catch (JSONException e) {
				e.printStackTrace();
			}
	}
	}
}
