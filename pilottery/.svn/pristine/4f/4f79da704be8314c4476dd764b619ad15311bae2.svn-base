package com.huacai.assist.setting;

import java.util.ArrayList;

import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.huacai.assist.common.App;
import com.huacai.assist.common.App.IScanResult;
import com.huacai.assist.common.BaseActivity;
import com.huacai.pistore.R;

/**
 * 扫描测试
 */
public class ScanTestActivity extends BaseActivity implements OnClickListener, IScanResult {
	private Button saomiaobtn;
	private Button saomiaobtn_cancel;

	private ImageView saomiaoimage;// 扫描动画背景
	private ListView contentlist;
	private TextView contentlabel;
	private ScanTestAdapter adapter;
	private ArrayList<String> fadmlistdata;
	private Integer count = 0;
	
	private boolean issaomiaogoing;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		initActivity(this, R.layout.activity_msg_test);
		initData();
		initView();
		initHandle();
	}

	@Override
	public void initHandle() {
		super.initHandle();
	}

	@Override
	public void initView() {
		super.initView();
		setMiddleText(R.string.saomiaorutestbtn);
		saomiaobtn = (Button) findViewById(R.id.saomiaobtn);
		saomiaobtn.setOnClickListener(this);
		saomiaobtn_cancel = (Button) findViewById(R.id.saomiaobtn_cancel);
		saomiaobtn_cancel.setOnClickListener(this);
		saomiaoimage = (ImageView) findViewById(R.id.saomiaoimage);
		contentlist = (ListView) findViewById(R.id.contentlist);
		contentlabel = (TextView) findViewById(R.id.contentlabel);
		contentlabel.setText(ScanTestActivity.this
				.getString(R.string.saomiaorucount) + count.toString());
		adapter = new ScanTestAdapter();
		fadmlistdata = new ArrayList<String>();
		contentlist.setAdapter(adapter);
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		Animation translateAnimation = new TranslateAnimation(0.0f, 0.0f, 0.0f,
				100.0f);
		switch (v.getId()) {
		case R.id.saomiaobtn:
			translateAnimation.setRepeatCount(Integer.MAX_VALUE);
			translateAnimation.setRepeatMode(Animation.RESTART);
			translateAnimation.setDuration(1000);
			saomiaoimage.startAnimation(translateAnimation);
			App.goScan(this, 1000, true);
			issaomiaogoing=true;
			break;
		case R.id.saomiaobtn_cancel:
			saomiaoimage.clearAnimation();
			App.stopScan();
			issaomiaogoing=false;
			break;
		default:
			break;
		}
	}

	@Override
	protected void onRestart() {
		super.onRestart();
		if(issaomiaogoing){
			App.goScan(this, 1000, true);
		}
		else{
			App.stopScan();
		}
	}

	@Override
	protected void onStop() {
		super.onStop();
		issaomiaogoing = false;
		App.stopScan();
	}

	class ScanTestAdapter extends BaseAdapter {

		class ViewHolder {
			public TextView ewmText;
		}

		ViewHolder twoholder;

		@Override
		public int getCount() {
			return fadmlistdata.size();
		}

		@Override
		public Object getItem(int position) {
			return position;
		}

		@Override
		public long getItemId(int position) {
			return position;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			final ViewHolder holder;
			if (convertView == null) {
				holder = new ViewHolder();
				TextView tv = new TextView(ScanTestActivity.this);
				tv.setTextColor(ScanTestActivity.this.getResources().getColor(
						R.drawable.black));
				convertView = tv;
				holder.ewmText = tv;
				convertView.setTag(holder);
			} else {
				holder = (ViewHolder) convertView.getTag();
			}
			holder.ewmText.setText(fadmlistdata.get(position));
			return convertView;
		}
	}

	@Override
	public void onScanResult(final String ewm) {
		runOnUiThread(new Runnable() {
			@Override
			public void run() {
				if (ewm == null || ewm.isEmpty()) {
					return ;
				}
//				for (int i = 0; i < fadmlistdata.size(); i++) {
//					if (ewm.equals(fadmlistdata.get(i))) {
//						return ;
//					}
//				}
				fadmlistdata.add(ewm);
				count++;
				contentlabel.setText(ScanTestActivity.this
						.getString(R.string.saomiaorucount)
						+ count.toString());
				adapter.notifyDataSetChanged();
			}
		});
	}

}
