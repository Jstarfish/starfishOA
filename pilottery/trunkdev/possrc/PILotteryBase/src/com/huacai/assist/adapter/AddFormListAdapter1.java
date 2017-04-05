package com.huacai.assist.adapter;

import java.util.ArrayList;
import java.util.List;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.ListAdapter;
import android.widget.ListView;

import com.huacai.assist.R;
import com.huacai.assist.model.FormListItem;


/**
 * 新增出货单AddFormList
 * 
 * 第一个列表的适配器
 */
public class AddFormListAdapter1 extends BaseAdapter{
	/**
	 * 
	 * 监听checkBox点击事件
	 * 
	 * @author niyifeng
	 *
	 */
	public interface CheckBoxClickListener {
			public abstract void onDone(boolean isChecked, FormListItem fli);
		}
	private int p;
	private final Context mContext;
	private List<FormListItem> list=new ArrayList<FormListItem>();//存储条目信息的list
	private CheckBox cb;//条目中的复选框
	private ListView lv;//条目中还有一个listview
	private String[] string;//存储订单编号
	private int id=R.layout.add_formlist_item_item;//条目中还有一个listview其对应条目的布局
	private CheckBoxClickListener doneListener = null;

	public AddFormListAdapter1(Context context,List<FormListItem> list)
	{
		mContext = context;
		this.list = list;
		
		
	}
	
	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return list.size();
	}

	@Override
	public Object getItem(int position) {
		// TODO Auto-generated method stub
		return list.get(position);
	}

	@Override
	public long getItemId(int position) {
		// TODO Auto-generated method stub
		return position;
	}
	public final class OrderItem {
		public CheckBox cb;
		public ListView lv;
		public String[] string={};
	}
	@Override
	public View getView(final int position,View convertView, ViewGroup parent) {
		p=position;
		OrderItem wi = null;
//		if (convertView == null)
		{	
			wi = new OrderItem();
			convertView = LayoutInflater.from(mContext).inflate(R.layout.add_formlist_item, null);
			wi.cb=(CheckBox) convertView.findViewById(R.id.check_box);
			wi.lv=(ListView)convertView.findViewById(R.id.list_list);
			wi.string=new String[list.get(position).getName().length];
//			convertView.setTag(wi);
		}
//		else {
//			wi = (OrderItem) convertView.getTag();
//			wi=new OrderItem();
//			wi.cb=(CheckBox) convertView.findViewById(R.id.check_box);
//			wi.lv=(ListView)convertView.findViewById(R.id.list_list);
//			wi.string=new String[list.get(position).getName().length];
//			convertView.setTag(wi);
			
//		}
		wi.cb.setChecked(list.get(position).isChecked());
		wi.string=new String[list.get(position).getName().length];
		for (int i = 0; i < list.get(position).getName().length; i++) {
			
			wi.string[i]="";
			wi.string[0]=list.get(position).getNum();
		}
		
		ThreeTvAdapter adapter=new ThreeTvAdapter(mContext,wi.string,
			list.get(position).getName(),
			list.get(position).getQuantity(),
			id);
		wi.lv.setAdapter(adapter);
		setListViewHeightBasedOnChildren(wi.lv);
		
		
		
		wi.cb.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener(){ 
            @Override 
            public void onCheckedChanged(CompoundButton buttonView, 
                    boolean isChecked) { 
                // TODO Auto-generated method stub 
            	list.get(position).setChecked(isChecked);
            	doneListener.onDone(isChecked,list.get(position));

            } 
        }); 
    	
		
		
//    	OrderItem wi = null;
//		if (convertView == null) {
//			wi = new OrderItem();
//			convertView = LayoutInflater.from(mList).inflate(res_id, null);
//			wi.tv1=(TextView) convertView.findViewById(R.id.order_date);
//			wi.tv2=(TextView)convertView.findViewById(R.id.order_lottery_name);
//			wi.tv3=(TextView)convertView.findViewById(R.id.order_lotter_price);
//			wi.tv4=(TextView)convertView.findViewById(R.id.order_state);
//			convertView.setTag(wi);
//		} else {
//			wi = (OrderItem) convertView.getTag();
//		}
//		if (itemData == null) {
//			return convertView;
//		}
//		OrderItemData oid = itemData.get(n);
//		wi.tv1.setText(oid.strDate);
//		wi.tv2.setText(oid.strName);
//		wi.tv3.setText(oid.strCount);
//		wi.tv4.setText(oid.strState);
//		return convertView;
		return convertView;
	}
	public void setDoneListener(CheckBoxClickListener dl) {
		doneListener = dl;
	}
	/**
	 * 
	 * ScrollView中嵌套ListView需重新计算并设置ListView高度
	 * 
	 * @param listView
	 * 		
	 * 		需要计算高度的listview
	 * 
	 */
	public  void setListViewHeightBasedOnChildren(ListView listView) {  
        ListAdapter listAdapter = listView.getAdapter();   
        if (listAdapter == null) {   
            return;  
        }  
  
        int totalHeight = 0;  
        for (int i = 0; i < listAdapter.getCount(); i++) {  
            View listItem = listAdapter.getView(i, null, listView);  
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
