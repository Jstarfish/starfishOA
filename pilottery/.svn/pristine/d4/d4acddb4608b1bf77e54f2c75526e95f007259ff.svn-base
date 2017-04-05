package com.huacai.assist.store;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ListView;

import com.huacai.assist.R;
import com.huacai.assist.adapter.ThreeTvAdapter;
import com.huacai.assist.common.App;
import com.huacai.assist.common.BaseActivity;
import com.huacai.assist.form.AddFormListActivity;
import com.huacai.assist.form.EnsureDFGActivity;
import com.huacai.assist.model.Lottery;
import com.huacai.assist.net.Http;
import com.huacai.assist.net.NetResult;
import com.huacai.assist.net.RequestListener;

/**
 * 库存查询
 */
public class QueryStockActivity extends BaseActivity implements RequestListener{
	/** 库存列表*/
	private ListView lv;
	/** 库存列表第一列，即方案简称*/
	private String[] testStrAry1={};
	/** 库存列表第一列，即方案对赢彩票张数*/
	private String[] testStrAry2={};
	/** 库存列表第一列，即方案对赢彩票总金额*/
	private String[] testStrAry3={};
	/** 还货单申请按钮*/
	private Button returnGoods;
	private String[] str1={};
	/** 从AddFormListActivity传来的预出货列表对应list*/
	private List<Lottery> mylist=new ArrayList<Lottery>();
	
	@Override
	public void initView() {
		// TODO Auto-generated method stub
		super.initView();
		setMiddleText(R.string.title_activity_store);//设置标题
		lv=(ListView)findViewById(R.id.list);//页面列表赋值
		returnGoods=(Button)findViewById(R.id.apply);//页面列表赋值
	}
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		initActivity(this,R.layout.activity_query_stock);//初始化Activity
		initData();//初始化数据
		initView();//初始化视图
		initHandle();//初始化Handle
		sendQueryFundMsg();//发送查询库存的信息
	}
	public void sendQueryFundMsg(){//发送消息查询在手库存
		JSONObject jo = new JSONObject();//发送的数据包
		Http.request(Http.QUERY_STOCK, jo, this);//发送请求数据
	}
	@Override
	public void onComplete(NetResult res) {//接收网络数据
		// TODO Auto-generated method stub
		Log.e("yyc", "onComplete "+res.errorStr);
		final JSONObject result;//返回的数据包
		final JSONArray array;//返回的库存信息列表
		if (res.jsonObject != null) {//如果返回数据包为空
			try {
				int errCode = res.jsonObject.getInt("errcode");//返回的错误码
				if (res.errorCode == 0 && errCode == 0) {//如果错误码为0
					result=res.jsonObject.getJSONObject("result");//返回的数据包赋值到本地
					array=result.getJSONArray("detailList");//返回的
					this.runOnUiThread(new Runnable() {//开启新的UI线程
						@Override
						public void run() {
							
							
							int listLength=array.length();//获取列表条目数
							testStrAry1=new String[listLength];//新建列表第一列数组实例
							testStrAry2=new String[listLength];
							testStrAry3=new String[listLength];
							str1=new String[listLength];
							for(int i=0;i<listLength;i++){//将返回的列表信息填入列表list对应位置
								try {
									testStrAry1[i]=array.getJSONObject(i).getString("planName");//获得方案名称
									testStrAry2[i]=String.valueOf(array.getJSONObject(i).getInt("tickets"));//获得对应数量
									testStrAry3[i]=App.getPriceFormated(array.getJSONObject(i).getLong("amount"));//获得总额
									str1[i]=String.valueOf(array.getJSONObject(i).getLong("amount"));
									Lottery l=new Lottery(testStrAry1[i],testStrAry2[i],str1[i]);
									mylist.add(l);
								} catch (JSONException e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								}
								
							}
							
							ThreeTvAdapter adapter=new ThreeTvAdapter(QueryStockActivity.this, testStrAry1, testStrAry2, testStrAry3, R.layout.query_stock_item
									);//构建页面列表适配器
							lv.setAdapter(adapter);//设置页面列表适配器
						}
					});
				}
			} catch (JSONException e) {
				e.printStackTrace();
			}
	}
		returnGoods.setOnClickListener(new OnClickListener() {//设置确认键监听事件
			
			@Override
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				if(mylist.size()!=0){//如果下端列表有内容
					Intent intent=new Intent(QueryStockActivity.this,ERGActivity.class);//构建intent
		            intent.putExtra("list", (Serializable)mylist);//将下列表对应list传到下一个Activity
		            intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);//选择下一Activity的打开方式为打开原有堆栈中的Activity
		            QueryStockActivity.this.startActivity(intent);//启动下一Activity
				}
				else{//如果下端列表没有任何内容
					App.showMessage(QueryStockActivity.this.getString(R.string.at_least_oneOrder), QueryStockActivity.this.getString(R.string.no_order_choose));//弹出错误消息
				}
				     
			}
		});
	}
}
