package com.huacai.assist.adapter;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;
import android.widget.Toast;

import com.huacai.assist.R;
import com.huacai.assist.common.App;
import com.huacai.assist.site.OrderListActivity;
/**
 * 拥有四个TextView
 * 
 * ListView适配器
 * 
 */
public class OrderListitemAdapter extends BaseAdapter implements OnClickListener{
	private int res_id=0;
	private OrderListActivity mList;
	private List<OrderItemData> itemData = new ArrayList<OrderItemData>();
	
	public OrderListitemAdapter(OrderListActivity orderListActivity,
			JSONObject data, int withdrawItem) {
		mList = orderListActivity;
		if (data != null) {
			try {
				JSONArray ja = data.getJSONArray("orderList");
				int count = ja.length();
				for (int i=0; i<count; i++) {
					JSONObject obj = ja.getJSONObject(i);
					// {"amount":400000,"orderNo":"DD00000219","status":"4","tickets":200,"time":"09-28 18:34"}
					int state = obj.getInt("status");
//					String state = obj.getString("statusValue");
					String time = getTime(ja, i, "time");
//					String orderNo = getItemSring(i, "orderNo");
					JSONArray ia = obj.getJSONArray("detailList");
					int icount = ia.length();
					for (int j=0; j<icount; j++) {
						JSONObject jo = ia.getJSONObject(j);
						long amount = jo.getLong("amount");
						int tickets = jo.getInt("tickets");
						String name = jo.getString("planName");
						itemData.add(new OrderItemData(amount, j==0?time:"", name, tickets,j==0?state:-1));
					}
				}
				/*
			{
                "detailList": [
                    {
                        "amount": 2000,
                        "planCode": "J2016",
                        "planName": "J方案",
                        "tickets": 1
                    },
                    {
                        "amount": 2000,
                        "planCode": "K2016",
                        "planName": "K方案",
                        "tickets": 1
                    }
                ],
                "orderNo": "DD00000159",
                "status": "3",
                "time": "10-15 11:34"
            },
            */
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
		res_id = withdrawItem;
	}
	@Override
	public int getCount() {
		return itemData.size();
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
		public TextView tv4;
		public OrderItemData oi;
	}
	private String getTime(JSONArray list, int n, String name) {
		String time = getItemSring(list, n, name);
		if (time.length() >= 5) {
			return time.substring(0, 5);
		}
		return time;
	}
	private String getItemSring(JSONArray list, int n, String name) {
		if (n < 0) {
			return "";
		}
		try {
			JSONObject obj = list.getJSONObject(n);
			return obj.getString(name);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return null;
	}
	class OrderItemData {
		public OrderItemData(long am, String time, String name, int tickets, int state) {
			amount = am;
			strDate = time;
			strName = name;
			strCount = ""+tickets;
			if (state < 0) {
				strState = "";
				return ;
			}
			String[] stateText = new String[]{
					App.getResString(R.string.withdraw_state),
					App.getResString(R.string.order_apply_1),
					App.getResString(R.string.order_apply_2),
					App.getResString(R.string.order_apply_3),
					App.getResString(R.string.withdraw_state)+4,
					App.getResString(R.string.withdraw_state)+5,
					App.getResString(R.string.order_apply_6),
					App.getResString(R.string.order_apply_7),
			};
			if (state >0 && state <stateText.length) {
				strState = stateText[state];
			} else {
				strState = stateText[0]+state;
			}
		}
		public String strDate;
		public String strName;
		public String strCount;
		public String strState;
		public long amount;
	}
	@Override
	public View getView(int n, View convertView, ViewGroup vp) {
		OrderItem wi = null;
		if (convertView == null) {
			wi = new OrderItem();
			convertView = LayoutInflater.from(mList).inflate(res_id, null);
			wi.tv1=(TextView) convertView.findViewById(R.id.order_date);
			wi.tv2=(TextView)convertView.findViewById(R.id.order_lottery_name);
			wi.tv3=(TextView)convertView.findViewById(R.id.order_lotter_price);
			wi.tv4=(TextView)convertView.findViewById(R.id.order_state);
			convertView.setTag(wi);
			convertView.setOnClickListener(this);
		} else {
			wi = (OrderItem) convertView.getTag();
		}
		if (itemData == null) {
			return convertView;
		}
		OrderItemData oid = itemData.get(n);
		wi.oi = oid;
		wi.tv1.setText(oid.strDate);
		wi.tv2.setText(oid.strName);
		wi.tv3.setText(oid.strCount);
		wi.tv4.setText(oid.strState);
		if (oid.strDate.length() != 0) {
			convertView.setBackgroundResource(R.drawable.list_item_bg);
		} else {
			convertView.setBackgroundResource(R.drawable.list_item_null_bg);
		}
		return convertView;
	}
	Toast toast = null;
	@Override
	public void onClick(View v) {
		Object obj = v.getTag();
		if (obj instanceof OrderItem) {
			OrderItem oi = (OrderItem)obj;
			App.showToast(App.getResString(R.string.order_total_amount)
						+App.getPriceFormated(oi.oi.amount));
		}
	}
}
