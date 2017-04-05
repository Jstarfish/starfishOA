package com.huacai.assist.main;

import java.util.ArrayList;

import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.huacai.assist.R;
import com.huacai.assist.common.BaseActivity;
import com.huacai.assist.expiry.ExpiryActivity;

public class ExpiryAdapter extends BaseAdapter {

	class ViewHolder {

		public TextView winAmount;
		public TextView winState;
		public TextView ticketNo;
	}

	ViewHolder twoholder;
	
	BaseActivity context = null;
	ArrayList<String[]> fadmlistdata;
	public ExpiryAdapter(BaseActivity activity, ArrayList<String[]> texts) {
		context = activity;
		fadmlistdata = texts;
	}

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
		if (convertView == null) {//如果convertView不是被复用的view就新建布局
			holder = new ViewHolder();
			convertView = LayoutInflater.from(context).inflate(
					R.layout.expiryitem, null);
			holder.winAmount = (TextView) convertView
					.findViewById(R.id.lottery_win_amount);
			holder.winState = (TextView) convertView
					.findViewById(R.id.lottery_win_state);
			holder.ticketNo = (TextView) convertView
					.findViewById(R.id.lottery_ticket_no);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}
		String[] texts = fadmlistdata.get(position);
		holder.ticketNo.setText(texts[0]);
		holder.winAmount.setText(texts[1]);
		holder.winState.setText(texts[2]);
		if (texts.length >= 4 && texts[3].equals("old")) {
			convertView.setBackgroundColor(0xff90e3fb);
		} else {
			convertView.setBackgroundColor(Color.TRANSPARENT);
		}
		if (texts.length >= 5 && texts[4].equals("1")) {
			holder.winState.setTextColor(0xff000000);
		} else {
			holder.winState.setTextColor(0xffff0000);
		}
		return convertView;
	}
}
