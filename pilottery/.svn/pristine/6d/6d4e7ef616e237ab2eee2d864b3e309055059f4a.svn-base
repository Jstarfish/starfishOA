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
public class TwoTvAdapter extends BaseAdapter{
	/** 列表条目第一列*/
	private TextView tv1;
	/** 列表条目第二列*/
	private TextView tv2;
	/** 列表条目第三列*/
	private TextView tv3;
	/** 列表布局*/
	private int id;
	/** 调用适配器的Activity对象*/
	private Context mContext;
	/** 列表第一列对应数组*/
	private String[] string1;
	/** 列表第二列对应数组*/
	private String[] string2;
	
	private int[] colors;
	public TwoTvAdapter(Context context,String[] string1,String[] string2,int id)
	{
		mContext = context;//传入数据赋值到本地
		this.string1 = string1;
		this.string2 = string2;
		this.id = id;
		
	}
	public void setColors(int[] colors) {
		this.colors = colors;
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
		this.notifyDataSetChanged();//更新列表
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
		tv1=(TextView) view.findViewById(R.id.tv1);//组件赋值
		tv2=(TextView)view.findViewById(R.id.tv2);
		tv1.setText(string1[arg0]);//显示条目第一列
		tv2.setText(string2[arg0]);//显示条目第二列
		if (colors != null) {
			tv2.setTextColor(colors[arg0]);
		}
		return view;
	}
	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return string1.length;
	}
	
}
