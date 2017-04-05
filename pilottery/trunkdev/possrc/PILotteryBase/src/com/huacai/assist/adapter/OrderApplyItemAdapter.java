package com.huacai.assist.adapter;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnFocusChangeListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.EditText;
import android.widget.TextView;

import com.huacai.assist.R;
import com.huacai.assist.common.App;
import com.huacai.assist.common.appData;
import com.huacai.assist.site.OrderApplyActivity;
/**
 * 拥有四个TextView
 * 
 * ListView适配器
 * 
 */
public class OrderApplyItemAdapter extends BaseAdapter implements OnFocusChangeListener {
	private int res_id=0;
	private OrderApplyActivity mList;
	private int[] indexArray = null;
	private int[] countArray = null;
	
	public OrderApplyItemAdapter(OrderApplyActivity orderApplyActivity, int withdrawItem) {
		mList = orderApplyActivity;
		res_id = withdrawItem;
	}
	public void setData(int[] idxs, int[] cnts) {
		indexArray = idxs;
		countArray = cnts;
		notifyDataSetChanged();
		long total = getTotalAmount();
		mList.setTotal(total);
	}
	public void updateLine(int idx, int count) {
		countArray[idx] = count;
		notifyDataSetChanged();
		long total = getTotalAmount();
		mList.setTotal(total);
	}
	private long getTotalAmount() {
		long total = 0;
		for (int i=0; i<countArray.length; i++) {
			total += getPrice(i)*(long)countArray[i];
		}
		return total;
	}
	@Override
	public int getCount() {
		if (appData.planList != null
				&& indexArray != null) {
			return indexArray.length;
		}
		return 0;
	}
	@Override
	public Object getItem(int n) {
		return n;
	}
	@Override
	public long getItemId(int n) {
		return n;
	}
	public final class OrderItem {
		public TextView tv1;
		public TextView tv2;
		public TextView tv3;
		public int idx = 0;
		public int price = 0;
	}
	public int getPrice(int n) {
		JSONArray list = appData.planList;
		JSONObject obj;
		try {
			obj = list.getJSONObject(n);
			return obj.getInt("faceValue");
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return 0;
	}
	@Override
	public View getView(int idx, View convertView, ViewGroup vp) {
		OrderItem wi = null;
		if (convertView!=null) {
			OrderItem ci = (OrderItem) convertView.getTag();
			if (ci.idx != indexArray[idx]) {
				convertView = null;
			}
		}
		if (convertView == null) {
			wi = new OrderItem();
			convertView = LayoutInflater.from(mList).inflate(res_id, null);
			wi.tv1=(TextView) convertView.findViewById(R.id.order_lottery_name);
			wi.tv2=(TextView)convertView.findViewById(R.id.order_count);
			wi.tv3=(TextView)convertView.findViewById(R.id.order_amount);
			convertView.setTag(wi);
		} else {
			wi = (OrderItem) convertView.getTag();
		}
		if (appData.planList == null) {
			return convertView;
		}
		try {
			JSONArray list = appData.planList;
			int n = indexArray[idx];
			JSONObject obj = list.getJSONObject(n);
			wi.idx = n;
			wi.price = obj.getInt("faceValue");
			wi.tv1.setText(obj.getString("planName"));
			wi.tv2.setText(""+((long)countArray[n]));
			wi.tv3.setText(""+App.getPriceFormated((long)wi.price*countArray[n]));

// {"errcode":0,"errmesg":"","method":"990001","msn":2,"result":[
//{"faceValue":1000,"planCode":"jk0002","planName":"lucky star A","printerCode":"1"},{"faceValue":1000,"planCode":"jk0003","planName":"lucky star H","printerCode":"1"},{"faceValue":1000,"planCode":"p20050930","planName":"happy basketball","printerCode":"1"},{"faceValue":1000,"planCode":"p20050929","planName":"happy volleyball","printerCode":"1"},{"faceValue":1000,"planCode":"s1","planName":"super quick plan 1","printerCode":"1"},{"faceValue":1000,"planCode":"s2","planName":"super quick plan 2","printerCode":"1"},{"faceValue":1000,"planCode":"s3","planName":"super quick plan 3","printerCode":"1"},{"faceValue":1000,"planCode":"s4","planName":"super quick plan 4","printerCode":"1"},{"faceValue":2000,"planCode":"J0001","planName":"SPY J0001","printerCode":"1"},{"faceValue":2000,"planCode":"J2015","planName":"天下足球","printerCode":"1"},{"faceValue":1000,"planCode":"p20050931","planName":"happy football","printerCode":"1"},{"faceValue":1000,"planCode":"jk0001","planName":"lucky star 5D","printerCode":"2"}],"token":"00952015092515074214115eea-9f02-","when":1443164862}

		} catch (JSONException e) {
			e.printStackTrace();
		}
		return convertView;
	}
	@Override
	public void onFocusChange(View v, boolean f) {
		EditText edt = (EditText)v;
		if (f) {
			edt.selectAll();
		} else if (edt.getText().toString().length() == 0) {
			edt.setText("1");
			edt.selectAll();
		}
	}
}
