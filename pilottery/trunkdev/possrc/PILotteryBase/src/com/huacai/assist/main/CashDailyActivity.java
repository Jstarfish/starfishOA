package com.huacai.assist.main;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.TextView;

import com.huacai.assist.R;
import com.huacai.assist.adapter.WithdrawListitemAdapter;
import com.huacai.assist.common.App;
import com.huacai.assist.common.BaseActivity;
import com.huacai.assist.net.Http;
import com.huacai.assist.net.NetResult;
import com.huacai.assist.net.RequestListener;

/**
 * 库存日结
 * 
 * @author sloanyyc
 */

public class CashDailyActivity extends BaseActivity implements RequestListener{
	private ListView lv = null;
	@Override
	public void initView() {
		setMiddleText(R.string.settlement);
		lv = (ListView) findViewById(R.id.list);
	}
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		initActivity(this,R.layout.activity_store_daily);//初始化Activity
		initView();//初始化视图
		initData();//初始化数据
		initHandle();//初始化Handle
		sendStoreDailyMsg();//发送消息请求
	}
	public void initData(){
		
	}
	/**
	 * 站点资金流水查询
	 */
	public void sendStoreDailyMsg(){
		JSONObject jo = new JSONObject();//数据包
		try {
			jo.put("follow", "");//查询起始加入数据包
			jo.put("count", 500);//查询条数加入数据包
		} catch (JSONException e) {
			e.printStackTrace();
		}
		Http.request(Http.MKT_MGR_CASH_DAILY, jo, this);//发送请求数据
	}
	@Override
	public void onComplete(NetResult res) {
		// TODO Auto-generated method stub
		Log.e("yyc", "onComplete "+res.errorStr);
		final JSONObject result;//接收的数据包
		final JSONArray array;//库存日结信息列表
		
		// 测试信息
//		String fackJson = App.getResRawString(R.raw.r020501);
//		try {
//			res.errorCode = 0;
//			res.jsonObject = new JSONObject(fackJson);
//		} catch (JSONException e1) {
//			e1.printStackTrace();
//		}
		
		if (res.jsonObject != null) {//如果数据包为空
			try {
				int errCode = res.jsonObject.getInt("errcode");//错误码赋值
				if (res.errorCode == 0 && errCode == 0) {//如果错误码为0	
					result=res.jsonObject.getJSONObject("result");//数据包赋值
					if(!result.isNull("dealList"))
						array=result.getJSONArray("dealList");//资金日结信息赋值
					else
						array=null;
					this.runOnUiThread(new Runnable() {//建立新的UI线程
						@Override
						public void run() {
							if(array!=null){
								List<MyData> listdata = new ArrayList<MyData>();
								for(int i=0;i<=array.length();i++) {
									try {
										JSONObject it = array.getJSONObject(i);
										String date = it.getString("calcDate");
										long amount = it.getLong("amount");
										String type = it.getString("dealtype");
										listdata.add(new MyData(listdata, date, "", type, amount));
									} catch (JSONException e) {
										e.printStackTrace();
									}
								}
								MyAdapter adapter=new MyAdapter(CashDailyActivity.this, listdata);
								Log.e("yyc", "yyc MyAdapter "+listdata.size());
								lv.setAdapter(adapter);
							}
						}
					});
				}
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
	} 
	

static class MyData {
	public static String lastDate = "";
	public static String lastType = "";
	
	public String date = null;
	public String plan = null;
	public String type = null;
	public long amount = 0;
	public TextView textPlan = null;
	public TextView textCount = null;
	public TextView textType = null;
	public TextView textDate = null;
	
	public MyData(List<MyData> list, String dt, String tp, String pl, long amt) {
		if (dt != null && !lastDate.equals(dt)) {
			lastDate = dt;
			lastType = "";
			list.add(new MyData(list, dt, null, null, 0));
		}
		if (tp != null && !lastType.equals(tp)) {
			lastType = tp;
			list.add(new MyData(list, null, tp, null, 0));
		}
		if (pl != null) {
			plan = pl;
			amount = amt;
		} else {
			date = dt;
			type = tp;
			plan = null;
			amount = 0;
		}
	}
	
	public static void reset() {
		lastDate = "";
		lastType = "";
	}
}

static class MyAdapter extends BaseAdapter {
	CashDailyActivity context = null;
	List<MyData> data = null;
	public MyAdapter(CashDailyActivity sda, List<MyData> ld) {
		context = sda;
		data = ld;
		MyData.reset();
	}
	@Override
	public int getCount() {
		return data.size();
	}
	@Override
	public Object getItem(int position) {
		return data.get(position);
	}
	public int getItemViewType(int position) {  
		MyData md = (MyData)getItem(position);
		if (md.plan != null) {
			return 0;
		} else if (md.type != null) {
			return 1;
		} else if (md.date != null) {
			return 2;
		}
		return 0;
	}
	public int getViewTypeCount() {  
	    return 3;  
	}  
	@Override
	public long getItemId(int position) {
		return position;
	}
	@Override
	public View getView(int index, View v, ViewGroup vg) {
		int vt = getItemViewType(index);
		MyData md = (MyData)getItem(index);
		if (v == null) {
			if (vt == 0) {
				v =  View.inflate(context, R.layout.store_daily_item, null);  
				md.textPlan = (TextView)v.findViewById(R.id.store_daily_plan);
				md.textCount = (TextView)v.findViewById(R.id.store_daily_count);
			} else if (vt == 1) {
				v = View.inflate(context, R.layout.store_daily_type, null);
				md.textType = (TextView)v.findViewById(R.id.store_daily_type);
			} else if (vt == 2){
				v = View.inflate(context, R.layout.store_daily_date, null);
				md.textDate = (TextView)v.findViewById(R.id.store_daily_date);
			}
			v.setTag(md);
		} else {
			if (vt == 0) {
				md.textPlan = (TextView)v.findViewById(R.id.store_daily_plan);
				md.textCount = (TextView)v.findViewById(R.id.store_daily_count);
			} else if (vt == 1) {
				md.textType = (TextView)v.findViewById(R.id.store_daily_type);
			} else if (vt == 2){
				md.textDate = (TextView)v.findViewById(R.id.store_daily_date);
			}
			v.setTag(md);
		}
		if (v != null && md != null) {
			Log.e("yyc", "yyc md date "+md.date+", type "+md.type+", "+md.plan);
			if (md.date != null) {
				md.textDate.setText(md.date);
			} else if (md.type != null) {
				md.textType.setText(md.type);
			} else if (md.plan != null) {
				md.textPlan.setText(md.plan);
				md.textCount.setText(App.getPriceFormated(md.amount)+App.getResString(R.string.com_unit));
			}
		}
		return v;
	}
}

}
