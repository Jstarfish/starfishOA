package com.huacai.assist.adapter;

import java.util.ArrayList;
import java.util.List;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.CheckBox;
import android.widget.ListAdapter;
import android.widget.ListView;
import com.huacai.assist.R;
import com.huacai.assist.model.FormListItem;


/**
 * 新增出货单AddFormList
 * 
 * 第一个列表的适配器
 */
public class AddFormAdapter extends BaseAdapter{
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
	private final Context mContext;
	private List<FormListItem> list=new ArrayList<FormListItem>();//存储条目信息的list
//	private CheckBox cb;//条目中的复选框
//	private ListView lv;//条目中还有一个listview
//	private String[] string;//存储订单编号
	private int id=R.layout.add_formlist_item_item;//条目中还有一个listview其对应条目的布局
	private CheckBoxClickListener doneListener = null;

	public AddFormAdapter(Context context,List<FormListItem> list)
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
		View view;
		if (convertView == null)//如果listview缓存中没有条目实例
		{	
			view= LayoutInflater.from(mContext).inflate(R.layout.add_formlist_item, null);//view初始化
		}
		else {//如果有
			view=convertView;//缓存中的条目实例赋值给view
			
		}
		final CheckBox cb=(CheckBox) view.findViewById(R.id.check_box);//组件赋值
		ListView lv=(ListView)view.findViewById(R.id.list_list);
		String[] string=new String[list.get(position).getName().length];
		cb.setChecked(list.get(position).isChecked());
		string=new String[list.get(position).getName().length];//日期数组初始化
		for (int i = 0; i < list.get(position).getName().length; i++) {//安排好日期的排列关系（每个单元第一行写日期，其他行不写）
		
			string[i]="";
			string[0]=list.get(position).getNum();
		}
		ThreeTvAdapter adapter=new ThreeTvAdapter(mContext,string,//初始化子ListView适配器
			list.get(position).getName(),
			list.get(position).getQuantity(),
			id);
		lv.setAdapter(adapter);//设置适配器
		setListViewHeightBasedOnChildren(lv);//动态设置子ListView高度
		cb.setOnClickListener(new OnClickListener() {//设置CheckBox点击事件
			public void onClick(View v) {
				list.get(position).setChecked(cb.isChecked());//点击的时候把大条目对应CheckBox状态改变
            	doneListener.onDone(cb.isChecked(),list.get(position));//点击之后应该处理的其他东西放在onDone函数里参数值传入
			}
			});
		return view;
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
