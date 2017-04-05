package com.huacai.assist.form;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.ListView;

import com.huacai.assist.R;
import com.huacai.assist.adapter.ThreeTvAdapter;
import com.huacai.assist.common.App;
import com.huacai.assist.common.BaseActivity;
import com.huacai.assist.net.Http;
import com.huacai.assist.net.NetResult;
import com.huacai.assist.net.RequestListener;
/**
 * 
 * 出货单详情
 *
 * @author niyifeng
 *
 */
public class FormDetailActivity extends BaseActivity implements RequestListener{
	/**  资金明细页面主列表*/
	private ListView lv;
	/**  出货单详情第一列对应数组，即方案简称*/
	private String[] testStrAry1={};
	/**  出货单详情第二列对应数组，即方案彩票张数*/
	private String[] testStrAry2={};
	/**  出货单详情第三列对应数组，即方案彩票总额*/
	private String[] testStrAry3={};
	/**  查询出货单详情时传入的单号*/
	private String listCode;
	@Override
	public void initView() {
		// TODO Auto-generated method stub
		super.initView();
		setMiddleText(R.string.title_activity_form_detail);//设置标题
		lv=(ListView)findViewById(R.id.list);//主列表赋值
	}
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		initActivity(this,R.layout.activity_form_detail);//初始化Activity
		initData();//初始化数据
		initView();//初始化视图
		initHandle();//初始化Handle
		sendQueryDetailMsg();//发送查询出货单详情的请求数据
	}
	/**
	 * 发送消息查询页面初始信息
	 */
	public void sendQueryDetailMsg(){
		JSONObject jo = new JSONObject();//发送的数据包
		try {
			jo.put("deliveryOrder", listCode);//出货单编号加入数据包
		} catch (JSONException e) {
			e.printStackTrace();
		}
		Http.request(Http.FORM_DETAIL, jo, this);//发送请求数据
	}
	public void initData(){
		Intent intent=getIntent();//获取FormListActivity传入的intent  
		listCode=intent.getStringExtra("listCode");//接收发送过来的出货单编号
	}
	@Override
	public void onComplete(NetResult res) {//接收网络数据
		// TODO Auto-generated method stub
		Log.e("yyc", "onComplete "+res.errorStr);
		final JSONObject result;//接收的数据包
		final JSONArray detailList;//要查询的出货单方案数组
		if (res.jsonObject != null) {//如果返回消息不为空
			try {
				int errCode = res.jsonObject.getInt("errcode");//接收的错误码
				if (res.errorCode == 0 && errCode == 0) {//如果错误码为0
					result=res.jsonObject.getJSONObject("result");//返回的数据包赋值
					detailList=result.getJSONArray("detailList");//返回的发难数组赋值
					this.runOnUiThread(new Runnable() {//开启新UI线程
						@Override
						public void run() {
							
							int listLength=detailList.length();//获取下方数组长度
							testStrAry1=new String[listLength];//初始化页面列表所用数组
							testStrAry2=new String[listLength];
							testStrAry3=new String[listLength];
							for(int i=0;i<listLength;i++){//循环，把对应值加入数组
								try {
									testStrAry1[i]=detailList.getJSONObject(i).getString("planName");//当前方案对应方案名赋值
									testStrAry2[i]=String.valueOf(detailList.getJSONObject(i).getInt("tickets"));//当前方案对应彩票数量赋值
									testStrAry3[i]=App.getPriceFormated(detailList.getJSONObject(i).getLong("amount"));//当前方案对应彩票总金额赋值
								} catch (JSONException e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								}
								
							}
							ThreeTvAdapter adapter=new ThreeTvAdapter(FormDetailActivity.this, testStrAry1, testStrAry2, testStrAry3, R.layout.ensure_dfg_item);//新建页面列表所用适配器
							lv.setAdapter(adapter);//设置页面列表适配器
						}
					});
				}
			} catch (JSONException e) {
				e.printStackTrace();
			}
	}
	}
}
