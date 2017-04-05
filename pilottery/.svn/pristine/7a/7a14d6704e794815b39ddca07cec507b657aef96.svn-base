package com.huacai.assist.main;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.TextView;
import cls.pilottery.packinfo.EunmPackUnit;
import cls.pilottery.packinfo.PackInfo;

import com.huacai.assist.R;
import com.huacai.assist.adapter.PutInStorage1Adapter.ViewHolder;
import com.huacai.assist.common.App;
import com.huacai.assist.net.Http;
import com.huacai.assist.net.NetResult;
import com.huacai.assist.net.RequestListener;
import com.huacai.assist.store.PutInStorage1;
/**
 * 
 * 出货单列表
 * 
 * @author sloanyyc
 *
 */


public class CheckInventoryActivity extends ScanActivity implements OnClickListener,RequestListener, OnItemClickListener{
	private Button store_check;
	private ListView lv;
	private TextView text_count;
	private int totalCount;
	@Override
	public void initView() {
		super.initView();
		setMiddleText(R.string.check_invy);//设置标题
		store_check=(Button)findViewById(R.id.store_check);
		lv=(ListView)findViewById(R.id.list1);
		lv.setOnItemClickListener(this);
		text_count=(TextView)findViewById(R.id.count_value);
		store_check.setOnClickListener(this);//设置新增出货单按钮点击事件
	}
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		initActivity(this,R.layout.activity_check_invy);//初始化Activity
		initView();//初始化视图
		initData();//初始化数据
		initHandle();//初始化Handle
	}

	@Override
	public void initData() {
		stopScanFlag = false;
		myAdapter = new MyAdapter(this);
		lv.setAdapter(myAdapter);
	}
	
	@Override
	public void onClick(View v) {
		switch (v.getId()) {
			case R.id.store_check:
				stopScan();
				sendInitialMsg();
				break;
		}
	}
	/**
	 * 刚进入页面时获取出货单列表信息发送的数据
	 */
	public void sendInitialMsg(){
		JSONObject jo = new JSONObject();//构建数据包
		try {
			JSONArray ja = new JSONArray();
			for (int i=0; i<myAdapter.codes.size(); i++) {
				JSONObject item = new JSONObject();
				item.put("tagNo", myAdapter.codes.get(i));
				ja.put(item);
			}
			jo.put("tagList", ja);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		Http.request(Http.MKT_MGR_STORE_CHECK, jo, this);//发送查询数据的请求
	}

	@Override
	public void onComplete(NetResult res) {//接收网络数据
		// TODO Auto-generated method stub
		Log.e("yyc", "onComplete "+res.errorStr);
		JSONObject result;//数据包
		final JSONArray recordList;
		if (res.jsonObject != null) {//如果返回的数据包为空
			try {
				int errCode = res.jsonObject.getInt("errcode");//返回的错误码
				if (res.errorCode == 0 && errCode == 0) {//如果错误码位0
					result=res.jsonObject.getJSONObject("result");//数据包赋值
//					recordList=result.getJSONArray("recordList");//出货单编号列表
					final JSONObject resultData = result;
					this.runOnUiThread(new Runnable() {
						@Override
						public void run() {//更新出货单列表
							Intent intent = new Intent(CheckInventoryActivity.this, 
									CheckInventoryActivity1.class);
							CheckInventoryActivity1.data = resultData;
							startActivity(intent);
						}
					});
				}
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
		
	}
	MyAdapter myAdapter = null;
	static class MyData {
		TextView tvSpec;
		TextView tvCount;
	}
	static class MyAdapter extends BaseAdapter {
		CheckInventoryActivity context=null;
	
		public ArrayList<String> specs = new ArrayList<String>();
		public ArrayList<String> counts = new ArrayList<String>();
		public ArrayList<String> codes = new ArrayList<String>();
		public ArrayList<PackInfo> pis = new ArrayList<PackInfo>();
		public MyAdapter(CheckInventoryActivity cia) {
			context = cia;
		}
		
		public void addOne(PackInfo pi, String code, String spec, int count) {
			pis.add(pi);
			codes.add(code);
			specs.add(spec);
			counts.add(""+count);
			notifyDataSetChanged();
		}

		public void delOne(int index) {
			pis.remove(index);
			codes.remove(index);
			specs.remove(index);
			counts.remove(index);
			notifyDataSetChanged();
		}
	
		@Override
		public int getCount() {
			return specs.size();
		}
	
		@Override
		public Object getItem(int idx) {
			return specs.get(idx);
		}
	
		@Override
		public long getItemId(int idx) {
			return idx;
		}
	
		@Override
		public View getView(int index, View v, ViewGroup vg) {
			MyData md = null;
			if (v == null) {
				v =  View.inflate(context, R.layout.check_inventory_item, null);  
				md = new MyData();
				md.tvCount = (TextView) v.findViewById(R.id.check_inventory_count);
				md.tvSpec = (TextView) v.findViewById(R.id.check_inventory_spec);
				v.setTag(md);
			} else {
				md = (MyData) v.getTag();
			}
			if (md != null) {
				md.tvSpec.setText(specs.get(index));
				md.tvCount.setText(counts.get(index));
			}
			return v;
		}
	}
	@Override
	public void onItemClick(AdapterView<?> av, View v, final int index, long pos) {
		final String spec = myAdapter.specs.get(index);
		AlertDialog.Builder builder = new Builder(this);
		String mess = this.getString(R.string.com_okdel)
				+ " " + spec //+" "
				+ this.getString(R.string.com_ma);
		builder.setMessage(mess);
		builder.setTitle(R.string.com_tishi);
		builder.setPositiveButton(R.string.string_comfirm,
				new DialogInterface.OnClickListener() {
					@Override
					public void onClick(
							DialogInterface dialog,
							int which) {
						App.showToast(R.string.del_ok);
						myAdapter.delOne(index);
					}
				});

		builder.setNegativeButton(R.string.com_cancel,
				new DialogInterface.OnClickListener() {
					@Override
					public void onClick(
							DialogInterface dialog,
							int which) {
						dialog.dismiss();
					}
				});
		builder.create().show();
	}
	@Override
	public boolean isSame(PackInfo pi, String s) {
		ArrayList<PackInfo> pis = myAdapter.pis;
		for (PackInfo info: pis) {
			if (info.isSame(pi)) {
				return true;
			}
		}
		return false;
	}

	@Override
	public boolean onScan(PackInfo pi, String s) {
		if (pi != null) {
			String text = "";
			int count = pi.getTicketNum();
			if (pi.getPackUnit() ==  EunmPackUnit.pkg ) {
				text = pi.getBatchCode()+"-"+pi.getPackUnitCode();
			} else if (pi.getPackUnit() ==  EunmPackUnit.Box) {
//				text = pi.getBatchCode()+"-"+pi.getPackUnitCode();
				return false;
			} else if (pi.getPackUnit() ==  EunmPackUnit.Trunck) {
//				text = pi.getBatchCode()+"-"+pi.getPackUnitCode();
				return false;
			} 
			else if (pi.getPackUnit() ==  EunmPackUnit.ticket) {
//				text = pi.getFirstPkgCode()+"-"+pi.getPackUnitCode();
				return false;
			}
			totalCount += count;
			text_count.setText(""+totalCount);
			myAdapter.addOne(pi, s, text, count);
			return true;
		}
		return false;
	}
	@Override
	public String checkError(PackInfo pi, String s) {
		if (pi.getPackUnit() !=  EunmPackUnit.pkg ) {
			return App.getResString(R.string.store_check_packet_only);
		}
		return null;
	}
}

