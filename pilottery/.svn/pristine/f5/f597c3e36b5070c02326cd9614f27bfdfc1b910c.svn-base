package com.huacai.assist.main;

import org.json.JSONArray;
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

import com.huacai.assist.R;
import com.huacai.assist.adapter.BusinessRecordAdapter;
import com.huacai.assist.adapter.ThreeTvAdapter;
import com.huacai.assist.common.App;
import com.huacai.assist.common.BaseActivity;
import com.huacai.assist.net.Http;
import com.huacai.assist.net.NetResult;
import com.huacai.assist.net.RequestListener;

/**
 * 资金管理
 */
public class BusinessRecordActivity extends BaseActivity implements RequestListener{
	/** 用来显示账户余额*/
	private TextView remainder;
	/** 用来显示信用额度*/
	private TextView limitOfCredit;
	/** 用来显示资金明细*/
	private ListView lv;
	/** 资金明细第一列，即时间*/
	private String[] testStrAry1={"1982-2-3","1982-2-3","1982-2-3"};
	/** 资金明细第二列，即资金变动类型*/
	private String[] testStrAry2={"销售","兑奖","退票"};
	/** 资金明细第二列，即金额*/
	private String[] testStrAry3={"1000","1000","1000"};
	private String[] testStrAry4={"10da12","103130","1022300"};
	private String[] testStrAry5={"001","002","003"};
	private String[] testStrAry6={"1","2","3"};
	
	@Override
	public void initView() {
		// TODO Auto-generated method stub
		super.initView();
		setMiddleText(R.string.transaction);//设置标题
		remainder=(TextView)findViewById(R.id.remainder);//赋值
		limitOfCredit=(TextView)findViewById(R.id.credit);
		lv=(ListView)findViewById(R.id.list);
		lv.setOnItemClickListener(new OnItemClickListener(){//添加出货单列表点击事件
			
			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1,
				int i, long arg3) {
				Intent intent=new Intent(BusinessRecordActivity.this,
						BusinessRecordChildActivity.class);//构建跳转到FormDetailActivity的intent
				intent.putExtra("dealNo", testStrAry5[i]);
				intent.putExtra("type", testStrAry6[i]);
                BusinessRecordActivity.this.startActivity(intent);
			}
		});
	}
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		initActivity(this,R.layout.activity_business_record);//初始化Activity
		initView();//初始化视图
		initData();//初始化数据
		initHandle();//初始化Handle
		sendQueryFundMsg();
	}
	public void initData(){
//		BusinessRecordAdapter adapter1=new BusinessRecordAdapter(this,testStrAry1,//构建子列表适配器
//				testStrAry2,
//				testStrAry4,
//				testStrAry3);
//		lv.setAdapter(adapter1);
	}
	public void sendQueryFundMsg(){//发送消息查询页面初始信息
		JSONObject jo = new JSONObject();//发送的数据包
		try {
			jo.put("follow", "");//将查询起始加入到数据包
			jo.put("count", 500);//将查询条数加入导数据报
		} catch (JSONException e) {
			e.printStackTrace();
		}
		Http.request(Http.MKT_MGR_TRANS_DAILY, jo, this);//发送查询消息
	}
	@Override
	public void onComplete(NetResult res) {//接收数据
		// TODO Auto-generated method stub
		Log.e("yyc", "onComplete "+res.errorStr);
		final JSONObject result;//接收的数据包
		final JSONArray dealList;//资金流动明细列表
		
//		// 测试信息
//		String fackJson = App.getResRawString(R.raw.r020502);
//		try {
//			res.errorCode = 0;
//			res.jsonObject = new JSONObject(fackJson);
//		} catch (JSONException e1) {
//			e1.printStackTrace();
//		}
		
		if (res.jsonObject != null) {//如果数据包为空
			try {
				int errCode = res.jsonObject.getInt("errcode");//接收到的错误码
				if (res.errorCode == 0 && errCode == 0) {//如果错误码为0
//				if (true) {//如果错误码为0
					result=res.jsonObject.getJSONObject("result");//接收到的数据包赋值到本地
					if(!result.isNull("dealList"))
						dealList=result.getJSONArray("dealList");//接收到的资金流动明细赋值到本地
					else
						dealList=null;
					this.runOnUiThread(new Runnable() {//开启新UI线程
						@Override
						public void run() {//更新账户信息及资金明细列表
							if(dealList != null){
//								交易数组	dealList	以下为数组
//								日期	time		String
//								站点编号	outletCode	String
//								交易类型	dealtype		String
//								金额	amount	Long
//								交易编号	dealNo	String
								int listLength=dealList.length();//获取烈数组长度
								testStrAry1=new String[listLength];//新建列数组实例
								testStrAry2=new String[listLength];
								testStrAry3=new String[listLength];
								testStrAry4=new String[listLength];
								testStrAry5=new String[listLength];
								testStrAry6=new String[listLength];
								for(int i=0;i<listLength;i++){
									try {
										testStrAry1[i]=dealList.getJSONObject(i).getString("time");//获得时间
										if (testStrAry1[i].length() == 19) {
											testStrAry1[i] = testStrAry1[i].substring(5, 16);
										}
										testStrAry2[i]=dealList.getJSONObject(i).getString("dealtypeValue");//获得类型
										testStrAry3[i]=App.getPriceFormated(dealList.getJSONObject(i).getLong("amount"))
												+App.getResString(R.string.com_unit);//获得总额
										testStrAry4[i]=dealList.getJSONObject(i).getString("outletCode");//获得站点
										testStrAry5[i]=dealList.getJSONObject(i).getString("dealNo");//获得编号
										testStrAry6[i]=dealList.getJSONObject(i).getString("dealtype");//获得类型
										
									} catch (JSONException e) {
										e.printStackTrace();
									}
									
								}
								BusinessRecordAdapter adapter1=new BusinessRecordAdapter(BusinessRecordActivity.this,
										testStrAry1,//构建子列表适配器
										testStrAry2,
										testStrAry4,
										testStrAry3);
								lv.setAdapter(adapter1);
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
