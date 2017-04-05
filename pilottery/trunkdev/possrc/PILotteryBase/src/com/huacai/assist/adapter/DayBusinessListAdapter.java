package com.huacai.assist.adapter;

import java.util.ArrayList;
import java.util.List;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ListAdapter;
import android.widget.ListView;

import com.huacai.assist.R;
import com.huacai.assist.model.DayBusinessListItem;

public class DayBusinessListAdapter extends BaseAdapter{
	/** 用来接收使用此适配器的Activity对象 */
	private final Context mContext;
	/** 条目中的子列表对应list */
	private List<DayBusinessListItem> list=new ArrayList<DayBusinessListItem>();
	/** 条目中的子列表 */
	private ListView lv;
	/** 条目中的子列表条目的布局 */
	private int id=R.layout.day_business_item_item;

	public DayBusinessListAdapter(Context context,List<DayBusinessListItem> list)
	{
		mContext = context;//接收传入的context
		this.list = list;//接收传入的list
		
	}
	
	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return list.size();
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
	public View getView(int position,View convertView, ViewGroup parent) {
		View view;
		if(convertView==null){//如果缓存中没有条目实例
			view = LayoutInflater.from(mContext).inflate(R.layout.day_business_item, null);//convertView赋值
		}
		else{//如果有
			view= convertView;//缓存中的条目实例赋值给view
		}
		
		lv=(ListView)view.findViewById(R.id.list_list);
		ThreeTvAdapter adapter=new ThreeTvAdapter(mContext,list.get(position).getData(),//构建子列表适配器
				list.get(position).getName(),
				list.get(position).getMoney(),
				id);
		lv.setAdapter(adapter);//设置子列表适配器
		setListViewHeightBasedOnChildren(lv);//动态改变子列表高度
		return view;
	}
	public  void setListViewHeightBasedOnChildren(ListView listView) {  //ScrollView中嵌套ListView需重新计算并设置ListView高度
        ListAdapter listAdapter = listView.getAdapter();   
        if (listAdapter == null) {   
            return;  
        }  
  
        int totalHeight = 0;  
        for (int i = 0; i < listAdapter.getCount(); i++) {  
            View listItem = listAdapter.getView(i, null, listView);
	               // NOTE: the layout params set here should be of the  
	               // {ParentView}.LayoutParams  
            listItem  
            .setLayoutParams(new ListView.LayoutParams(  
                    ListView.LayoutParams.WRAP_CONTENT,  
                    ListView.LayoutParams.WRAP_CONTENT));
            listItem.measure(0, 0);  
            totalHeight += listItem.getMeasuredHeight();  
        }  
  
        ViewGroup.LayoutParams params = listView.getLayoutParams();  
        params.height = totalHeight + (listView.getDividerHeight() * listAdapter.getCount() );  
        listView.setLayoutParams(params);  
    } 
}
