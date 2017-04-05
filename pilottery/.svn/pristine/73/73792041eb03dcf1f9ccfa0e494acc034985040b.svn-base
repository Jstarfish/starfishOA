package com.huacai.assist.adapter;

import java.util.ArrayList;
import java.util.List;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.huacai.assist.R;
import com.huacai.assist.common.App;
import com.huacai.assist.model.Lottery;
/**
 * AddFormListActivity界面上方
 * 
 * 预出货列表Adapter
 * 
 */
public class PreDFGAdapter extends BaseAdapter{
	/** 预出货列表第一列，即方案简称*/
	private TextView tv1;
	/** 预出货列表第二列，即张数*/
	private TextView tv2;
	/** 预出货列表第三列，即总金额*/
	private TextView tv3;
	/** 预出货列表对应list*/
	List<Lottery> list=new ArrayList<Lottery>();
	/** 预出货列表布局*/
	private int id;
	/** 调用此适配器的Activity*/
	private Context mContext;
	public PreDFGAdapter(Context context,List<Lottery> list,int id)
	{
		mContext = context;//传入值赋值到本地
		this.list=list;
		this.id = id;
		
	}
	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return list.size();
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
			view = LayoutInflater.from(mContext).inflate(id, null);//convertView赋值
		}
		else{//如果有
			view= convertView;//缓存中的条目实例赋值给view
		}
		tv1=(TextView)view.findViewById(R.id.tv1);
		tv2=(TextView)view.findViewById(R.id.tv2);
		tv3=(TextView)view.findViewById(R.id.tv3);
		tv1.setText(list.get(arg0).getName());//显示方案简称
		tv2.setText(list.get(arg0).getQuantity());//显示方案对应彩票数量
		tv3.setText(App.getPriceFormated(Long.valueOf(list.get(arg0).getMoney())));//显示方案对应彩票总金额
		return view;
	}
	
}
