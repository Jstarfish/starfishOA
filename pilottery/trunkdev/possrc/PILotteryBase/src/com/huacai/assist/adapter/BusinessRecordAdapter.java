package com.huacai.assist.adapter;

import com.huacai.assist.R;

import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;
/**
 * 拥有三个TextView的
 * 
 * ListView适配器
 * 
 */
public class BusinessRecordAdapter extends BaseAdapter{
	/** 列表条目第一列*/
	private TextView date;
	/** 列表条目第二列*/
	private TextView type;
	/** 列表条目第三列*/
	private TextView site;
	private TextView money;
	/** 列表布局*/
	private int id;
	/** 调用适配器的Activity对象*/
	private Context mContext;
	/** 列表第一列对应数组*/
	private String[] string1;
	/** 列表第二列对应数组*/
	private String[] string2;
	/** 列表第三列对应数组*/
	private String[] string3;
	/** 列表第4个对应数组*/
	private String[] string4;
	/** 列表第5个对应数组*/
	private String[] string5;
	public BusinessRecordAdapter(Context context,String[] string1,String[] string2,String[] string3,String[] string4)
	{
		mContext = context;//传入数据赋值到本地
		this.string1 = string1;
		this.string2 = string2;
		this.string3 = string3;
		this.string4 = string4;
		
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
			view=  LayoutInflater.from(mContext).inflate(R.layout.business_record_item, null);;//convertView赋值
		}
		else{//如果有
			view= convertView;//缓存中的条目实例赋值给view
		}
		date=(TextView) view.findViewById(R.id.date);//组件赋值
		type=(TextView)view.findViewById(R.id.type);
		site=(TextView)view.findViewById(R.id.site);
		money=(TextView)view.findViewById(R.id.money);
		date.setText(string1[arg0]);//显示条目第一列
		
		type.setText(string2[arg0]);//显示条目第二列
		
		site.setText(string3[arg0]);//显示条目第三列
		money.setText(string4[arg0]);//显示条目第三列
		return view;
	}
	
}
