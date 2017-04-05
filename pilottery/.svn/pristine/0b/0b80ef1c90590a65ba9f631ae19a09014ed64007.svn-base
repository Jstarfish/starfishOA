package com.huacai.assist.main;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.os.Bundle;
import android.util.Log;
import android.widget.ListView;
import android.widget.TextView;
import cls.pilottery.packinfo.EunmPackUnit;
import cls.pilottery.packinfo.PackInfo;

import com.huacai.assist.R;
import com.huacai.assist.adapter.LogisticsAdapter;
import com.huacai.assist.net.Http;
import com.huacai.assist.net.NetResult;
import com.huacai.assist.net.RequestListener;
/**
 * 
 * 物流信息查询
 * 
 * @author niyifeng
 *
 */

public class LogisticsActivity extends ScanActivity implements RequestListener{
	
	private ListView lv;
	/**  上方规格值 */
	private TextView spec;
	/**  上方编号 */
	private TextView code;
	private String[] testStrAry1={"一晚","一晚"};
	private String[] testStrAry2={"2015-2-3","2014-3-4"};
	private String[] testStrAry3={"张三","李四"};
	private String[] testStrAry4={"入库","出库"};
	@Override
	public void initView() {
		super.initView();
		setMiddleText(R.string.logistics);//设置标题
		lv=(ListView)findViewById(R.id.list1);
		spec=(TextView)findViewById(R.id.spec_value);
		code=(TextView)findViewById(R.id.code_value);
		

	}
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		initActivity(this,R.layout.activity_logistics);//初始化Activity
		initView();//初始化视图
//		initData();//初始化数据
		initHandle();//初始化Handle
//		sendInitialMsg();//发送查询出货单列表的请求数据
	}
	public void initData(){
		LogisticsAdapter adapter=new LogisticsAdapter(LogisticsActivity.this, testStrAry1, testStrAry2, testStrAry3,testStrAry4,
				R.layout.logistics_item);//
		lv.setAdapter(adapter);//
	}

	/**
	 * 刚进入页面时获取出货单列表信息发送的数据
	 */
	public void sendInitialMsg(String s){
		
		JSONObject jo = new JSONObject();//构建数据包
		try {
			jo.put("tagNo", s);//查询起始位置加入数据包
			jo.put("count", 500);//查询条数加入数据包
		} catch (JSONException e) {
			e.printStackTrace();
		}
		Http.request(Http.MKT_MGR_LOGISTICS, jo, this);//发送查询数据的请求
	}

	@Override
	public void onComplete(NetResult res) {//接收网络数据
		// TODO Auto-generated method stub
		Log.e("yyc", "onComplete "+res.errorStr);
		JSONObject result;//数据包
		final JSONArray deliveryList;//出货单编号
		
//		// 测试信息
//		String fackJson = App.getResRawString(R.raw.r020506);
//		try {
//			res.errorCode = 0;
//			res.jsonObject = new JSONObject(fackJson);
//		} catch (JSONException e1) {
//			e1.printStackTrace();
//		}
		
		if (res.jsonObject != null) {//如果返回的数据包为空
			try {
				int errCode = res.jsonObject.getInt("errcode");//返回的错误码
				if (res.errorCode == 0 && errCode == 0) {//如果错误码位0
					result=res.jsonObject.getJSONObject("result");//数据包赋值
					deliveryList=result.getJSONArray("recordList");//出货单编号列表
					if (deliveryList == null) {
						return ;
					}
					this.runOnUiThread(new Runnable() {
						@Override
						public void run() {//更新出货单列表
//							记录数组	recordList	以下为数组
//							时间	time		String
//							操作名称	operation	String
//							仓库	warehouse	String
//							操作人	operator		String
							int listLength=deliveryList.length();//获取下方数组长度
							testStrAry1=new String[listLength];//构建列表所用数组对象
							testStrAry2=new String[listLength];
							testStrAry3=new String[listLength];
							testStrAry4=new String[listLength];//构建订单号数组
							for(int i=0;i<listLength;i++){//根据返回数组构建列表所需本地数组
								try {
									JSONObject jo = deliveryList.getJSONObject(i);
									testStrAry1[i]=jo.getString("warehouse");
									testStrAry2[i]=jo.getString("operation");
									testStrAry3[i]=jo.getString("operator");
									testStrAry4[i]=jo.getString("time");
									if (testStrAry4[i].length() == 19) {
										testStrAry4[i] = testStrAry4[i].substring(5, 16);
									}
								} catch (JSONException e) {
									e.printStackTrace();
								}
							}
							LogisticsAdapter adapter=new LogisticsAdapter(LogisticsActivity.this, 
									testStrAry1, testStrAry2, 
									testStrAry3,testStrAry4, R.layout.logistics_item);//
							lv.setAdapter(adapter);//
						}
					});
				}
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
	}
	@Override
	public boolean onScan(PackInfo pi, String s) {
		if (pi != null) {
			if (pi.getPackUnit() ==  EunmPackUnit.Trunck) {
				spec.setText(R.string.specifications_trunck);
				String text = pi.getBatchCode()+"-"+pi.getPackUnitCode();
				code.setText(text);
			} else if (pi.getPackUnit() ==  EunmPackUnit.Box) {
				spec.setText(R.string.specifications_box);
				String text = pi.getBatchCode()+"-"+pi.getPackUnitCode();
				code.setText(text);
			} else if (pi.getPackUnit() ==  EunmPackUnit.pkg) {
				spec.setText(R.string.specifications_packet);
				String text = pi.getBatchCode()+"-"+pi.getPackUnitCode();
				code.setText(text);
			} else if (pi.getPackUnit() ==  EunmPackUnit.ticket) {
				spec.setText(R.string.specifications_ticket);
//				String text = pi.getFirstPkgCode()+"-"+pi.getPackUnitCode();
//				code.setText(text);
				stopScanFlag = false;
				Log.e("yyc", "yyc stopScanFlag B "+stopScanFlag);
				return false;
			}
			sendInitialMsg(s);
			stopScanFlag = true;
			Log.e("yyc", "yyc stopScanFlag A "+stopScanFlag);
			return true;
		}
		stopScanFlag = false;
		Log.e("yyc", "yyc stopScanFlag B "+stopScanFlag);
		return false;
	}
	@Override
	public boolean isSame(PackInfo pi, String s) {
		return false;
	}
	@Override
	public String checkError(PackInfo pi, String s) {
		return null;
	}
}
