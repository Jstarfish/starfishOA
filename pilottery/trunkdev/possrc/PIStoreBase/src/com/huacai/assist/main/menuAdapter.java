package com.huacai.assist.main;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.huacai.pistore.R;

public class menuAdapter extends BaseAdapter {
	class ViewHolder{  
		  public ImageView logo;
		  public TextView menu_name;
	}
	
	private final Context mContext;
	private String[] menu_name = null;
	private int[] menu_logo = null;
	
	ViewHolder twoholder;

	public menuAdapter(Context context,String[] menu_name,int[] menu_logo)
	{
		mContext = context;
		this.menu_name = menu_name;
		this.menu_logo = menu_logo;
	}
	
	@Override
	public int getCount() {
		return menu_name.length;
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
	public View getView(int position,View convertView, ViewGroup parent) {
        final ViewHolder holder;
        
		if (convertView == null) {
			holder = new ViewHolder();
			convertView = LayoutInflater.from(mContext).inflate(R.layout.menu_item, null);
			holder.logo = (ImageView) convertView.findViewById(R.id.logo); 
			holder.menu_name = (TextView) convertView.findViewById(R.id.menu_name);
			convertView.setTag(holder);
		}
		else{  
		    holder = (ViewHolder)convertView.getTag(); 
	    } 
		
		holder.logo.setImageResource(menu_logo[position]);
		holder.menu_name.setText(menu_name[position]);
		
		return convertView;
	}

}
