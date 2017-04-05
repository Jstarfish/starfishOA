package com.huacai.assist.main;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.TextView;

import com.huacai.assist.R;
import com.huacai.assist.adapter.ThreeTvAdapter;
import com.huacai.assist.adapter.TwoTvAdapter;
import com.huacai.assist.common.App;
import com.huacai.assist.common.BaseActivity;
import com.huacai.assist.net.Http;
import com.huacai.assist.net.NetResult;
import com.huacai.assist.net.RequestListener;

/**
 * 资金管理
 */
public class BusinessRecordChildActivity extends BaseActivity implements RequestListener{
	/** 用来显示账户余额*/
	private TextView tvOutletCode;
	private TextView tvTime;
	/** 用来显示信用额度*/
	private TextView tv2;
	/** 用来显示信用额度*/
	private TextView tv3;
	/** 用来显示信用额度*/
	private TextView tv4;
	private TextView tv5;
	
	private TextView tv2Value;
	/** 用来显示信用额度*/
	private TextView tv3Value;
	/** 用来显示信用额度*/
	private TextView tv4Value;
	
	private LinearLayout tv4Panel;
	private TextView tvSpec;
	private TextView tvAmount;
	/** 用来显示资金明细*/
	private ListView lv1;
	private ListView lv2;
	/** 资金明细第一列，即时间*/
	private String[] testStrAry1={"J01023","J31121"};
	/** 资金明细第二列，即资金变动类型*/
	private String[] testStrAry2={"100","500"};
	/** 资金明细第二列，即金额*/
	private String[] testStrAry3={"140000 R","230000 R"};
	/** 资金明细第二列，即金额*/
	private String[] testStrAry4={"J0004-12333334-33221","J0004-125533334-335521"};
	/** 资金明细第二列，即金额*/
	private String[] testStrAry5={"100 R","200 R"};
	private String[] testStrAry6={"100 R","200 R"};
	private String testStr2="010101012     2011-5-6";
	private String testStr3="010101012     2011-5-6";
	private String testStr4="010101012     2011-5-6";
	private String dealNo = "";
	private String type = "";
	private TextView listHeadCol1;
	
	@Override
	public void initView() {
		// TODO Auto-generated method stub
		super.initView();

		if (type.equals("1")) {
			setMiddleText(R.string.detail);//设置标题
		} else if (type.equals("2")) {
			setMiddleText(R.string.detail2);//设置标题
		} else if (type.equals("3")) {
			setMiddleText(R.string.detail1);//设置标题
		} 
		tvOutletCode=(TextView)findViewById(R.id.tv_outlet_code);//赋值
		tvTime=(TextView)findViewById(R.id.tv_time);//赋值
		listHeadCol1 = (TextView)findViewById(R.id.list1_head_col1);
		tv2=(TextView)findViewById(R.id.tv2);//赋值
		tv3=(TextView)findViewById(R.id.tv3);//赋值
		tv4=(TextView)findViewById(R.id.tv4);//赋值
		tv5=(TextView)findViewById(R.id.tv5);//赋值
		tv2Value=(TextView)findViewById(R.id.tv2Value);//赋值
		tv3Value=(TextView)findViewById(R.id.tv3Value);//赋值
		tv4Value=(TextView)findViewById(R.id.tv4Value);//赋值
		tv4Panel = (LinearLayout) findViewById(R.id.tv4Panel);
		lv1=(ListView)findViewById(R.id.list1);
		lv2=(ListView)findViewById(R.id.list2);
		tvAmount = (TextView)findViewById(R.id.state);
		tvSpec = (TextView)findViewById(R.id.spec);
	}
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		initActivity(this,R.layout.activity_business_record_child);//初始化Activity
		dealNo = getIntent().getStringExtra("dealNo");
		type = getIntent().getStringExtra("type");
		initView();//初始化视图
		initData();//初始化数据
		initHandle();//初始化Handle
		if (dealNo != null && dealNo.length() > 0) {
			sendQueryFundMsg();//发送数据请求资金变动信息
		}
	}
	public void initData(){
		if (type.equals("1")) {
			tv2.setText(R.string.sale);
			tv3.setText(R.string.sale_commission);
		} else if (type.equals("2")) {
			tvSpec.setText(R.string.prize);
			tvAmount.setText(R.string.withdraw_state);
			listHeadCol1.setText(R.string.prizes);
			tv2.setText(R.string.payout_tickets);
			tv3.setText(R.string.payout2);
			tv4.setText(R.string.compay);
			tv5.setVisibility(View.VISIBLE);
			tv5.setText(App.getResString(R.string.scan_count)+0);
			tv4Panel.setVisibility(View.VISIBLE);
		} else if (type.equals("3")) {
			tv2.setText(R.string.return1);
			tv3.setText(R.string.com_return);
		}
	}
	public void sendQueryFundMsg(){//发送消息查询页面初始信息
		JSONObject jo = new JSONObject();//发送的数据包
		try {
			jo.put("dealNo", dealNo);//将查询条数加入导数据报
		} catch (JSONException e) {
			e.printStackTrace();
		}
		if (type.equals("1")) {
			Http.request(Http.MKT_MGR_SALES_RECORD, jo, this);
		} else if (type.equals("2")) {
			Http.request(Http.MKT_MGR_PAYOUT_RECORD, jo, this);
		} else if (type.equals("3")) {
			Http.request(Http.MKT_MGR_RETURN_RECORD, jo, this);
		} 
	}
	@Override
	public void onComplete(NetResult res) {//接收数据
		// TODO Auto-generated method stub
		Log.e("yyc", "onComplete "+res.errorStr);
		final JSONObject result;//接收的数据包
		final JSONArray planList;//资金流动明细列表
		final JSONArray recordList;
		
//		// 测试信息
//		String fackJson = null;
//		if (type.equals("1")) {
//			fackJson = App.getResRawString(R.raw.r020503);
//		} else if (type.equals("2")) {
//			fackJson = App.getResRawString(R.raw.r020504);
//		} else if (type.equals("3")) {
//			fackJson = App.getResRawString(R.raw.r020505);
//		}
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
					if(!result.isNull("planList"))
						planList=result.getJSONArray("planList");//接收到的资金流动明细赋值到本地
					else
						planList=null;
					if(!result.isNull("recordList"))
						recordList=result.getJSONArray("recordList");//接收到的资金流动明细赋值到本地
					else
						recordList=null;
					this.runOnUiThread(new Runnable() {//开启新UI线程
						@Override
						public void run() {//更新账户信息及资金明细列表
							try {
								String outletCode = result.getString("outletCode");
								String time = result.getString("time");
								// 012345678901234567890
								// 2015-12-16 12:12:12
								if (time.length() == 19) {
									time = time.substring(5, 16);
								}
								tvOutletCode.setText(outletCode);
								tvTime.setText(time);
								if (type.equals("1")) {
									long saleAmount = result.getLong("saleAmount");
									long saleComm = result.getLong("saleComm");
									tv2Value.setText(App.getPriceFormated(saleAmount)+App.getResString(R.string.com_unit));
									tv3Value.setText(App.getPriceFormated(saleComm)+App.getResString(R.string.com_unit));
								} else if (type.equals("2")) {
									long winAmount = result.getLong("winAmount");
									int winTickets = result.getInt("winTickets");
									long payoutComm = result.getLong("payoutComm");
									int count = result.getInt("scanTickets");
									tv2Value.setText(""+winTickets);
									tv3Value.setText(App.getPriceFormated(winAmount)+App.getResString(R.string.com_unit));
									tv4Value.setText(App.getPriceFormated(payoutComm)+App.getResString(R.string.com_unit));
									tv5.setText(App.getResString(R.string.scan_count)+count);
								} else if (type.equals("3")) {
									long saleAmount = result.getLong("returnAmount");
									long saleComm = result.getLong("returnComm");
									tv2Value.setText(App.getPriceFormated(saleAmount)+App.getResString(R.string.com_unit));
									tv3Value.setText(App.getPriceFormated(saleComm)+App.getResString(R.string.com_unit));
								}
							} catch (JSONException e1) {
								// TODO Auto-generated catch block
								e1.printStackTrace();
							}
							
							if(!result.isNull("planList")){
								int listLength=planList.length();//获取烈数组长度
								testStrAry1=new String[listLength];//新建列数组实例
								testStrAry2=new String[listLength];
								testStrAry3=new String[listLength];
								for(int i=0;i<listLength;i++){
									try {
										if (!type.equals("2")) {
											testStrAry1[i]=planList.getJSONObject(i).getString("plan");//获得时间
										} else {
											testStrAry1[i]=App.getPriceFormated(planList.getJSONObject(i).getLong("levelAmount"))+App.getResString(R.string.com_unit);//获得时间
										}
										testStrAry2[i]=""+planList.getJSONObject(i).getInt("tickets");//获得类型
										testStrAry3[i]=App.getPriceFormated(planList.getJSONObject(i).getLong("amount"))+App.getResString(R.string.com_unit);//获得总额
									} catch (JSONException e) {
										e.printStackTrace();
									}
								}
								ThreeTvAdapter adapter=new ThreeTvAdapter(BusinessRecordChildActivity.this, 
										testStrAry1, testStrAry2, testStrAry3, R.layout.business_child_item1);//构建主列表适配器
								lv1.setAdapter(adapter);//设置主列表适配器
							}
							if(!result.isNull("recordList")){
								int listLength=recordList.length();//获取烈数组长度
								testStrAry4=new String[listLength];//新建列数组实例
								testStrAry5=new String[listLength];
								if (!type.equals("2")) {
									for(int i=0;i<listLength;i++){
										try {
											testStrAry4[i]=recordList.getJSONObject(i).getString("tagNo");//获得时间
											testStrAry5[i]=App.getPriceFormated(recordList.getJSONObject(i).getLong("amount"))+App.getResString(R.string.com_unit);//获得类型
										} catch (JSONException e) {
											e.printStackTrace();
										}
									}
									TwoTvAdapter adapter2=new TwoTvAdapter(BusinessRecordChildActivity.this, testStrAry4, testStrAry5,  R.layout.business_child_item2);//构建主列表适配器
									lv2.setAdapter(adapter2);//设置主列表适配器
								} else {
									int count = recordList.length();
									ArrayList<String[]> list = new ArrayList<String[]>();
									for (int i=0; i<count; i++) {
										try {
											JSONObject jo = recordList.getJSONObject(i);
											String[] str = new String[5];
											str[0] = jo.getString("tagNo");
											str[1] = App.getPriceFormated(jo.getLong("amount")); // +App.getResString(R.string.com_unit);
											str[2] = jo.getString("payStatusValue");
											str[4] = jo.getString("payStatus");
											if (str[4].equals("1")) {
												
											} else if (str[4].equals("4")) {
												str[1] = "*";
											} else {
												str[1] = "-";
											}
											str[3] = "";
											try {
												str[3] = jo.getString("ticketFlag");
											} catch (JSONException e) {
											}
											list.add(str);
										} catch (JSONException e1) {
											e1.printStackTrace();
										}
									}
									ExpiryAdapter adapter=new ExpiryAdapter(BusinessRecordChildActivity.this, list);//构建主列表适配器
									lv2.setAdapter(adapter);//设置主列表适配器
								}
							}
							setListViewHeightBasedOnChildren(lv1);
							setListViewHeightBasedOnChildren(lv2);
						}
					});
				}
			} catch (JSONException e) {
				e.printStackTrace();
			}
	}
	}
	/**
	 * 
	 * ScrollView中嵌套ListView需重新计算并设置ListView高度
	 * 
	 * @param listView
	 * 		
	 * 		需要计算高度的listview
	 * 
	 */
	public  void setListViewHeightBasedOnChildren(ListView listView) {  
        ListAdapter listAdapter = listView.getAdapter();   
        if (listAdapter == null) {   
            return;  
        }  
  
        int totalHeight = 0;  
        for (int i = 0; i < listAdapter.getCount(); i++) {  
            View listItem = listAdapter.getView(i, null, listView);  
            listItem  
            .setLayoutParams(new ListView.LayoutParams(  
                    ListView.LayoutParams.WRAP_CONTENT,  
                    ListView.LayoutParams.WRAP_CONTENT));
            listItem.measure(0, 0);  
            totalHeight += listItem.getMeasuredHeight();  
        }  
        
        ViewGroup.LayoutParams params = listView.getLayoutParams();  
        params.height = totalHeight + (listView.getDividerHeight() * listAdapter.getCount() );  
        listView.setLayoutParams(params);  
    } 
}
