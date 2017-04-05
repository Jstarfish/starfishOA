package com.huacai.assist.site;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.TextView;

import com.huacai.assist.R;
import com.huacai.assist.adapter.DayBusinessListAdapter;
import com.huacai.assist.common.App;
import com.huacai.assist.common.BaseActivity;
import com.huacai.assist.common.appData;
import com.huacai.assist.model.DayBusinessListItem;
import com.huacai.assist.net.Http;
import com.huacai.assist.net.NetResult;
import com.huacai.assist.net.RequestListener;

/**
 * 资金日结
 * 
 * @author niyifeng
 */
public class DayBusinessActivity extends BaseActivity implements RequestListener{
	/** 用来显示账户余额*/
	private TextView remainder;
	/** 用来显示信用额度*/
	private TextView limitOfCredit;
	/** 资金明细列表*/
	private ListView lv;
	/** 资金明细列表对应的list*/
	private List<DayBusinessListItem> list=new ArrayList<DayBusinessListItem>();
	/** 资金明细列表对应的list*/
//	private String[] testStrAry1=new String[7];//列表每个条目中的7条交易类型
//	private String[] testStrAry2=new String[7];//列表每个条目中的7条交易类型对应金额
//	DayBusinessListItem dbli=new DayBusinessListItem(testStrAry1, testStrAry2);	//构建代表资金日结每个列表单元的对象
	@Override
	public void initView() {
		// TODO Auto-generated method stub
		super.initView();
		setMiddleText(R.string.title_activity_day_business);//设置标题
		remainder=(TextView)findViewById(R.id.remainder);//赋值
		limitOfCredit=(TextView)findViewById(R.id.credit);
		lv=(ListView)findViewById(R.id.list);
	}
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		initActivity(this,R.layout.activity_day_business);//初始化Activity
		initData();//初始化数据
		initView();//初始化视图
		initHandle();//初始化Handle
		sendDayBusinessMsg();//发送消息请求资金流水信息
	}
	/**
	 * 站点资金流水查询
	 */
	public void sendDayBusinessMsg(){
		JSONObject jo = new JSONObject();//数据包
		try {
			jo.put("outletCode", appData.stationCode);//站点号加入数据包
			jo.put("follow", "");//查询起始加入数据包
			jo.put("count", 500);//查询条数加入数据包
		} catch (JSONException e) {
			e.printStackTrace();
		}
		Http.request(Http.DAY_BUSINESS, jo, this);//发送请求数据
	}
	/**
	 * ScrollView中嵌套ListView需重新计算并设置ListView高度
	 */
	public  void setListViewHeightBasedOnChildren(ListView listView) {  
        ListAdapter listAdapter = listView.getAdapter();   
        if (listAdapter == null) {   
            return;  
        }  
        int totalHeight = 0;  
        for (int i = 0; i < listAdapter.getCount(); i++) {  
            View listItem = listAdapter.getView(i, null, listView);  
            listItem.measure(0, 0);  
            totalHeight += listItem.getMeasuredHeight();  
        }  
        ViewGroup.LayoutParams params = listView.getLayoutParams();  
        params.height = totalHeight + (listView.getDividerHeight() * listAdapter.getCount() );  
        listView.setLayoutParams(params);  
    }
	@Override
	public void onComplete(NetResult res) {
		// TODO Auto-generated method stub
		Log.e("yyc", "onComplete "+res.errorStr);
		final JSONObject result;//接收的数据包
		final JSONArray array;//资金日结信息列表
		if (res.jsonObject != null) {//如果数据包为空
			try {
				int errCode = res.jsonObject.getInt("errcode");//错误码赋值
				if (res.errorCode == 0 && errCode == 0) {//如果错误码为0	
					result=res.jsonObject.getJSONObject("result");//数据包赋值
					if(!result.isNull("salesList"))
						array=result.getJSONArray("salesList");//资金日结信息赋值
					else
						array=null;
					this.runOnUiThread(new Runnable() {//建立新的UI线程
						@Override
						public void run() {
							try {
								long remain = result.getLong("balance");//得到余额
								long limit=result.getLong("credit");//得到信用额
								String remain1=App.getPriceFormated(remain)+DayBusinessActivity.this.getString(R.string.com_unit);//将余额转换为3个数字一个逗点的格式并加上单位
								String limit1=App.getPriceFormated(limit)+DayBusinessActivity.this.getString(R.string.com_unit);//将信用额转换为3个数字一个逗点的格式并加上单位
								remainder.setText(remain1);//显示余额
								limitOfCredit.setText(limit1);//显示信用额
							} catch (JSONException e1) {
								// TODO Auto-generated catch block
								e1.printStackTrace();
							}
							if(array!=null){
								for(int i=0;i<=array.length();i++){
									try {
										String[] testStrAry1=new String[8];//列表每个条目中的7条交易类型
										String[] testStrAry2=new String[8];//列表每个条目中的7条交易类型对应金额
										testStrAry1[0]=array.getJSONObject(i).getString("date");//列表第一列日期赋值
										//交易类型，每个列表单元都有7种交易类型：
										testStrAry2[0]=App.getPriceFormated(array.getJSONObject(i).getLong("sale"));//销售金额
										testStrAry2[1]=App.getPriceFormated(array.getJSONObject(i).getLong("saleCommission"));//销售佣金
										testStrAry2[2]=App.getPriceFormated(array.getJSONObject(i).getLong("payout"));//对奖金额
										testStrAry2[3]=App.getPriceFormated(array.getJSONObject(i).getLong("payoutCommission"));//兑奖佣金
										testStrAry2[4]=App.getPriceFormated(array.getJSONObject(i).getLong("topup"));//充值金额
										testStrAry2[5]=App.getPriceFormated(array.getJSONObject(i).getLong("withdrawn"));//提现金额
										testStrAry2[6]=App.getPriceFormated(array.getJSONObject(i).getLong("returned"));//退货金额
										testStrAry2[7]=App.getPriceFormated(array.getJSONObject(i).getLong("returnCommission"));//退货佣金
										
										for(int j=1;j<7;j++){
											testStrAry1[j]="";//资金日结每个列表单元出日期外的其他行为空白
										}
//										DayBusinessListItem dbli=new DayBusinessListItem(testStrAry1, testStrAry2);	//构建代表资金日结每个列表单元的对象
										list.add(new DayBusinessListItem(testStrAry1, testStrAry2));//对象加入list	
									} catch (JSONException e) {
										// TODO Auto-generated catch block
										e.printStackTrace();
									}
									
								}
								DayBusinessListAdapter adapter=new DayBusinessListAdapter(DayBusinessActivity.this, list);//构建页面列表适配器
								lv.setAdapter(adapter);//设置适配器
								setListViewHeightBasedOnChildren(lv);//动态设置列表单元高度
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
