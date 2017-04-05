package com.huacai.assist.main;


import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.huacai.pistore.R;
/**
 * 拥有三个TextView的
 * 
 * ListView适配器
 * 
 */
public class LogisticsAdapter extends BaseAdapter{
	private TextView tv1;
	private TextView tv2;
	private TextView tv3;
	private TextView tv4;
	/** 列表布局*/
	private int id;
	/** 调用适配器的Activity对象*/
	private Context mContext;
	private String[] string1;
	private String[] string2;
	private String[] string3;
	private String[] string4;
	public LogisticsAdapter(Context context,String[] string1,String[] string2,String[] string3,String[] string4,int id)
	{
		mContext = context;//传入数据赋值到本地
		this.string1 = string1;
		this.string2 = string2;
		this.string3 = string3;
		this.string4 = string4;
		this.id = id;
		
	}
	/**
	 * 设置本地数组并更新列表
	 * 
	 * @param Column1 列表第一列对应数组
	 * 
	 * @param Column2 列表第二列对应数组	
	 * 
	 * @param Column3 列表第三列对应数组
	 */
	public void setData(String[] Column1, String[] Column2, String[] Column3) {
		string1 = Column1;//传入数据赋值到本地
		string2 = Column2;
		string3 = Column3;
		this.notifyDataSetChanged();//更新列表
	}
	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return string3.length;
	}
	@Override
	public Object getItem(int arg0) {
		// TODO Auto-generated method stub
		return null;
	}
	@Override
	public long getItemId(int arg0) {
		// TODO Auto-generated method stub
		return 0;
	}
	@Override
	public View getView(int arg0, View convertView, ViewGroup arg2) {
		// TODO Auto-generated method stub
		View view;
		if(convertView==null){//如果缓存中没有条目实例
			view=  LayoutInflater.from(mContext).inflate(id, null);;//convertView赋值
		}
		else{//如果有
			view= convertView;//缓存中的条目实例赋值给view
		}
		tv1=(TextView) view.findViewById(R.id.site);//组件赋值
		tv2=(TextView)view.findViewById(R.id.way);
		tv3=(TextView)view.findViewById(R.id.name);
		tv4=(TextView)view.findViewById(R.id.date);
		tv1.setText(string1[arg0]);
		tv2.setText(string2[arg0]);
		tv3.setText(string3[arg0]);
		tv4.setText(string4[arg0]);
		return view;
	}
	
}

