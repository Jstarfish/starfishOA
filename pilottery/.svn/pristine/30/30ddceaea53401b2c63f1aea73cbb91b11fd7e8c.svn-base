package com.huacai.assist.adapter;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.graphics.Paint;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.TextView;

import com.huacai.assist.R;
import com.huacai.assist.common.App;
import com.huacai.assist.money.WithdrawListActivity;
/**
 * 拥有三个TextView和一个可隐藏button的列表元素
 * 
 * ListView适配器
 * 
 */
public class WithdrawListitemAdapter extends BaseAdapter implements OnClickListener{
	private int res_id=0;
	private WithdrawListActivity mList = null;
	private JSONArray jsonData = null;
	
	public WithdrawListitemAdapter(WithdrawListActivity withdrawListActivity,
			JSONArray data, int withdrawItem) {
		mList = withdrawListActivity;
		jsonData = data;
		res_id = withdrawItem;
	}
	@Override
	public int getCount() {
		if (jsonData != null) {
			return jsonData.length();
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
	public final class WithdrawItem {
		public TextView tv1;
		public TextView tv2;
		public TextView tv3;
		public Button btn;
		public int state = 0;
		public long amount = 0;
		public String withdrawCode = "";
	}
	@Override
	public View getView(int n, View convertView, ViewGroup vp) {
		WithdrawItem wi = null;
		if (convertView == null) {
			wi = new WithdrawItem();
			convertView = LayoutInflater.from(mList).inflate(res_id, null);
			wi.tv1=(TextView) convertView.findViewById(R.id.withdraw_date);
			wi.tv2=(TextView)convertView.findViewById(R.id.withdraw_amount);
			wi.tv3=(TextView)convertView.findViewById(R.id.withdraw_state);
			wi.btn=(Button)convertView.findViewById(R.id.withdraw_confirm);
			wi.btn.getPaint().setFlags(Paint.UNDERLINE_TEXT_FLAG);
			wi.btn.setOnClickListener(this);
			convertView.setTag(wi);
		} else {
			wi = (WithdrawItem) convertView.getTag();
		}
		try {
			/*
{"method":"020405","when":1443428264,"token":"00952015092816171253398540-b7bb-","msn":6,"param":{"outletCode":"03510001"}}

{"errcode":0,"errmesg":"","method":"020405","msn":6,"result":{
"balance":610000,
"outletCode":"03510001",
"withdrawnList":[
{
	"amount":"500",
	"status":"已提交",
	"time":"09-28 16:17",
	"withdrawnCode":"FA00000122"
},{"amount":"10","status":"已提交","time":"09-28 15:11","withdrawnCode":"FA00000109"}]},"token":"00952015092816171253398540-b7bb-","when":1443428264}
*/
			JSONObject obj = jsonData.getJSONObject(n);
			String time = obj.getString("time");
			if (time.length() < 5) {
				time = "       ";
			}
			wi.state = obj.getInt("status");
			wi.amount = obj.getLong("amount");
			// {"amount":"10","status":"已提交","time":"09-28 15:11","withdrawnCode":"FA00000109"}
			wi.withdrawCode = obj.getString("withdrawnCode");
			wi.tv1.setText(time.subSequence(0, 5));
			wi.tv2.setText(App.getPriceFormated(wi.amount));
			String stateString = obj.getString("statusValue");
			wi.tv3.setText(stateString);
			if (wi.state == 3) {
				wi.btn.setVisibility(View.VISIBLE);
				wi.btn.setTag(wi);
				wi.btn.setOnClickListener(this);
			} else {
				wi.btn.setVisibility(View.INVISIBLE);
				wi.btn.setTag(null);
				wi.btn.setOnClickListener(null);
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return convertView;
	}
	@Override
	public void onClick(View btn) {
		if (btn.getTag() != null) {
			WithdrawItem wi = (WithdrawItem) btn.getTag();
			mList.doConfirm(wi.withdrawCode, wi.amount);
		}
	}
}
