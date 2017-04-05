/*
 * author:yuanshiyue
 * date:2015/10/15
 * verson:v1.0
 */
package com.huacai.assist.adapter;

import java.util.ArrayList;

import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.TextView;
import cls.pilottery.packinfo.PackInfo;

import com.huacai.assist.R;
import com.huacai.assist.common.App;
import com.huacai.assist.store.PutInStorage1;
//import com.huacai.assist.store.PutInStorage1;

public class PutInStorage1Adapter extends BaseAdapter {

	public static class ViewHolder {
		public TextView fangandaimaText;
		public TextView shengchanpiciText;
		public TextView zhangshuText;
		public PackInfo data;
	}

	private final PutInStorage1 mContext;
	public ArrayList<PackInfo> fadmlistdata;

	ViewHolder twoholder;

	public PutInStorage1Adapter(PutInStorage1 context, ArrayList<PackInfo> data) {
		mContext = context;
		fadmlistdata = data;
	}

	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return fadmlistdata.size();
	}

	@Override
	public Object getItem(int position) {
		// TODO Auto-generated method stub
		return position;
	}

	@Override
	public long getItemId(int position) {
		// TODO Auto-generated method stub
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ListView lvtemp = (ListView) parent;
		final int listtype = Integer.parseInt(lvtemp.getTag().toString());// 1,2入库的两个列表；3兑奖的列表；5，6退货的两个列表
		final ViewHolder holder;
//		if (convertView == null) {//如果是空就新建布局
			holder = new ViewHolder();
			convertView = LayoutInflater.from(mContext).inflate(
					R.layout.pis1_item, null);
			holder.fangandaimaText = (TextView) convertView
					.findViewById(R.id.col1_fangandaimaItem);
			holder.shengchanpiciText = (TextView) convertView
					.findViewById(R.id.col2_shengchanpiciItem);
			holder.zhangshuText = (TextView) convertView
					.findViewById(R.id.col3_zhangshuItem);
			convertView.setTag(holder);
//		} else {
//			holder = (ViewHolder) convertView.getTag();
//		}
		PackInfo abc = fadmlistdata.get(position);
		if (listtype == 1 || listtype == 3 || listtype == 5) {//如果是入库，兑奖，退票的第一个列表时，就显示删除按钮
			holder.fangandaimaText.setText(abc.getPlanCode());
			holder.shengchanpiciText.setText(abc.getPackUnitCode());
			if (listtype == 3) {//兑奖页面的第二个数据是票号
				holder.shengchanpiciText.setText(abc.getBatchCode());
				String text = abc.getFirstPkgCode()+"-"+abc.getPackUnitCode();
				holder.zhangshuText.setText(text);
			} else {
				holder.zhangshuText.setText(abc.getTicketNum().toString());
			}
			holder.data = abc;
		} else {
			//入库和退票的第二个列表不显示删除按钮
			holder.fangandaimaText.setText(abc.getPlanName());
			holder.shengchanpiciText.setText(abc.getTicketNum().toString());
			holder.zhangshuText.setText(App.getPriceFormated(abc.getAmount()));
		}
		holder.fangandaimaText.setGravity(Gravity.CENTER_HORIZONTAL);
		holder.shengchanpiciText.setGravity(Gravity.CENTER_HORIZONTAL);
		holder.zhangshuText.setGravity(Gravity.RIGHT);
		return convertView;
	}
}
