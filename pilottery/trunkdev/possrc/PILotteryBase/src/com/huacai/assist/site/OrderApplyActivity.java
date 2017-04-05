package com.huacai.assist.site;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.DialogInterface.OnMultiChoiceClickListener;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.huacai.assist.R;
import com.huacai.assist.adapter.OrderApplyItemAdapter;
import com.huacai.assist.adapter.OrderApplyItemAdapter.OrderItem;
import com.huacai.assist.common.App;
import com.huacai.assist.common.BaseActivity;
import com.huacai.assist.common.appData;
import com.huacai.assist.net.Http;
import com.huacai.assist.net.NetResult;
import com.huacai.assist.net.RequestListener;

public class OrderApplyActivity extends BaseActivity implements OnClickListener, OnMultiChoiceClickListener, android.content.DialogInterface.OnClickListener, RequestListener, OnItemClickListener {

	private Button apply;
	private Button confirm;
	private ListView lv;
	private String[] lotteryNames = new String[]{};
	private String[] lotteryPrices = new String[]{};
	private String[] lotteryCodes = new String[]{};
	private boolean[] checks = new boolean[]{};
	private int[] lotteryCount = new int[]{};
	private int[] orderIdxs = new int[]{};
	private int[] countArray = new int[]{};
	private boolean[] tempChecks;
	private OrderApplyItemAdapter adapter = null;
	private TextView scode;
	public TextView totalAmount;
	private EditText editText;
	private LinearLayout editLayout;
	@Override
	public void initView() {
		super.initView();
		setMiddleText(R.string.title_activity_order_apply);
		editLayout = (LinearLayout) LayoutInflater.from(this).inflate(R.layout.order_apply_edit, null);
		editText = (EditText)editLayout.findViewById(R.id.order_apply_edit);
		editText.setSelectAllOnFocus(true);
		apply=(Button)findViewById(R.id.order_apply_add);
		confirm=(Button)findViewById(R.id.order_apply_confirm);
		lv=(ListView)findViewById(R.id.order_apply_list);
		totalAmount = (TextView)findViewById(R.id.text_total_amount);
		scode = (TextView)findViewById(R.id.text_station_code);
		scode.setText(App.getResString(R.string.withdraw_station_code)+appData.stationCode);
		int count = appData.planList.length();
		lotteryNames = new String[count];
		lotteryPrices = new String[count];
		lotteryCodes = new String[count];
		lotteryCount = new int[count];
		checks = new boolean[count];
		countArray = new int[count];
		for (int i=0; i<count;i++) {
			countArray[i] = 0;
		}

//		lotteryNames[i] += " \n"+jo.getString("planCode");
//		lotteryNames[i] += " \t"+jo.getInt("faceValue")+unit;
		for (int i=0; i<count; i++) {
			try {
				JSONObject jo = appData.planList.getJSONObject(i);
				lotteryNames[i] = jo.getString("planName");
				lotteryCodes[i] = jo.getString("planCode");
				lotteryPrices[i] = App.getPriceFormated(jo.getLong("faceValue"));
				lotteryCount[i] = 0;
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
		setTotal(0);
		lv.setOnItemClickListener(this);
		apply.setOnClickListener(this);
		confirm.setOnClickListener(this);
		loadDate();
	}
	public void setTotal(long price) {
		String unit = getResources().getString(R.string.com_unit);
		String totalText = App.getResString(R.string.order_total_amount);
		totalAmount.setText(totalText+App.getPriceFormated(price)+unit);
	}
	private void loadDate() {
		adapter =new OrderApplyItemAdapter(this, R.layout.order_apply_item);
		lv.setAdapter(adapter);
	}
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		initActivity(this,R.layout.activity_order_apply);
		initData();
		initView();
		initHandle();
	}
	@Override
	public void onClick(View v) {
		if (v == confirm) {
			// STATION_ORDER_NEW
			/*
站点编号	outletCode	String
方案数组	goodsTagList	
	方案编码	goodsTag	String
	申请张数	tickets	Uint32
*/
			if (orderIdxs.length <= 0) {
				App.showToast(R.string.order_must_has_content);
				return ;
			}
			JSONObject jo = new JSONObject();
			JSONArray ja = new JSONArray();
			try {
				jo.put("outletCode", appData.stationCode);
				for (int i=0; i<orderIdxs.length; i++) {
					int idx = orderIdxs[i];
					JSONObject ji = new JSONObject();
					ji.put("goodsTag", lotteryCodes[idx]);
					ji.put("tickets", countArray[idx]);
					ja.put(ji);
				}
				jo.put("goodsTagList", ja);
				Http.request(Http.STATION_ORDER_NEW, jo, this);
			} catch (JSONException e) {
				e.printStackTrace();
			}
		} else {
			tempChecks = checks.clone();
			new AlertDialog.Builder(this).setTitle(R.string.order_select_lotery_name)
				.setMultiChoiceItems(
						lotteryNames,
						tempChecks,
						this)
				.setCancelable(false)
				.setPositiveButton(R.string.string_comfirm, this)
				.setNegativeButton(R.string.com_cancel, null).show();
		}
		
	}
	@Override
	public void onClick(DialogInterface dlg, int idx, boolean check) {
		Log.e("yyc", "onClick "+idx+", "+check);
		tempChecks[idx] = check;
	}
	@Override
	public void onClick(DialogInterface dlg, int idx) {
		int cnt = 0;
		for (int i=0; i<tempChecks.length; i++) {
			cnt += tempChecks[i]?1:0;
		}
		int index = 0;
		orderIdxs = new int[cnt];
		for (int i=0; i<tempChecks.length; i++) {
			if (tempChecks[i]) {
				orderIdxs[index++] = i;
				countArray[i] = countArray[i]>0?countArray[i]:1;
			} else {
				countArray[i] = 0;
			}
		}
		checks = tempChecks;
		adapter.setData(orderIdxs, countArray);
	}
	@Override
	public void onComplete(NetResult res) {
		int errCode = 0;
		String errStr = null;
		Log.e("yyc", "onComplete " + res.errorStr);
		if (res.jsonObject != null) {
			try {
				errCode = res.jsonObject.getInt("errcode");
				if (res.errorCode == 0 && errCode == 0) {
					String orderCode = res.jsonObject.getJSONObject("result").getString("orderCode");
					Log.e("yyc", "orderCode "+orderCode);
					App.showMessage(R.string.order_apply_success, R.string.com_tishi,
							new DialogInterface.OnClickListener(){
						@Override
						public void onClick(DialogInterface dlg,
								int arg1) {
							dlg.dismiss();
							App.postRun(new Runnable() {
								@Override
								public void run() {
									Intent it = new Intent(OrderApplyActivity.this, OrderListActivity.class);
									it.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
									startActivity(it);
									finish();
								}}, 50);
						}});
					return ;
				}
				errStr = res.jsonObject.getString("errmesg");
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}

		if (errStr == null) {
			App.showMessage(errCode, R.string.order_apply_failed, R.string.com_tishi);
		}
	}
	@Override
	public void onItemClick(AdapterView<?> apt, View v, int idx, long n) {
		OrderApplyItemAdapter.OrderItem oi = (OrderItem) v.getTag();
		final int index = oi.idx;
		ViewGroup vg = (ViewGroup) editLayout.getParent();
		if (vg != null) {
			vg.removeView(editLayout);
		}
		editText.setText(""+((long)countArray[index]));
		editText.selectAll();
		new AlertDialog.Builder(this).setTitle(R.string.order_input_lotery_count)
			.setView(editLayout)
			.setCancelable(false)
			.setPositiveButton(R.string.string_comfirm, 
				new DialogInterface.OnClickListener() {
					@Override
					public void onClick(DialogInterface dlg, int arg1) {
						String cs = editText.getText().toString();
						if (cs.length() == 0) {
							cs = "1";
						}
						int count = Integer.parseInt(cs);
						if (count <=0 ) {
							count = 1;
						}
						adapter.updateLine(index, count);
						countArray[index] = count;
					}})
			.setNegativeButton(R.string.com_cancel, null).show();
		
	}
}
