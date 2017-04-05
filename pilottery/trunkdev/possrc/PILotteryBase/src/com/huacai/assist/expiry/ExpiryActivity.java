/*
 * author:yuanshiyue
 * date:2015/10/15
 * verson:v1.0
 */
package com.huacai.assist.expiry;

import java.util.ArrayList;

import android.os.Bundle;
import android.view.View.OnClickListener;
import android.widget.ListView;
import android.widget.TextView;

import com.huacai.assist.R;
import com.huacai.assist.common.App;
import com.huacai.assist.common.BaseActivity;
import com.huacai.assist.main.ExpiryAdapter;

public class ExpiryActivity extends BaseActivity {

	private TextView count;//数量
	private TextView jinevalue;//金额
	private ListView list1;

	private ArrayList<String[]> fadmlistdata;
	private long totalAmount=0;
	private int totalCount=0;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		initActivity(this, R.layout.activity_expiry_ok);
		initData();
		initView();
	}

	@SuppressWarnings("unchecked")
	@Override
	public void initData() {
		// TODO Auto-generated method stub
		super.initData();
		totalAmount = getIntent().getLongExtra("totalAmount", 0l);
		totalCount = getIntent().getIntExtra("totalCount", 0);
		fadmlistdata = (ArrayList<String[]>) getIntent().
				getSerializableExtra("listdata");
	}

	@Override
	public void setGoBack(OnClickListener v) {
		finish();
		setResult(1);
	}

	@Override
	public void initView() {
		// TODO Auto-generated method stub
		super.initView();
		setMiddleText(R.string.title_expiry);
		count = (TextView) findViewById(R.id.count);
		jinevalue = (TextView) findViewById(R.id.jinevalue);
		list1 = (ListView) findViewById(R.id.list1);
		ExpiryAdapter adapter = new ExpiryAdapter(this, fadmlistdata);
		list1.setAdapter(adapter);

		count.setText(""+totalCount);
		jinevalue.setText(App.getPriceFormated(totalAmount));
	}

	@Override
	public void onBackPressed() {
		// TODO Auto-generated method stub
		super.onBackPressed();
		setResult(RESULT_OK);//返回兑奖第一个界面时，清空兑奖列表数据
	}
}
