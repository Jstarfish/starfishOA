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
import android.widget.TextView;

import com.huacai.assist.R;
import com.huacai.assist.model.DayBusinessListItem;

public class DayBusiness1ListAdapter extends BaseAdapter{
	/** 用来接收使用此适配器的Activity对象 */
	private final Context mContext;
	/** 条目中的子列表对应list */
	private List<DayBusinessListItem> list=new ArrayList<DayBusinessListItem>();
	/** 条目中的子列表对应list */
	private List<DayBusinessListItem> list1=new ArrayList<DayBusinessListItem>();
	/** 条目中的子列表 */
	private ListView lv;
	/** 条目中的子列表 */
	private ListView lv1;
	/** 控制彩票列表的关闭与展开 */
	private CheckBox cb;
	/** 显示每条数据的日期 */
	private TextView tv;
	/** 彩票列表没显示时的提示文本 */
	private TextView lottery;
	/** 条目中的子列表条目的布局 */
	private int id=R.layout.day_business_item_item;
	private int p;
	public DayBusiness1ListAdapter(Context context,List<DayBusinessListItem> list)
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
			view = LayoutInflater.from(mContext).inflate(R.layout.day_business1_item, null);//convertView赋值
		}
		else{//如果有
			view= convertView;//缓存中的条目实例赋值给view
		}
		
		lv=(ListView)view.findViewById(R.id.list_list);
//		lv1=(ListView)view.findViewById(R.id.lottery_list1);
//		cb=(CheckBox)view.findViewById(R.id.more);
		tv=(TextView)view.findViewById(R.id.date);
//		lottery=(TextView)view.findViewById(R.id.lottery);
		String[] testStrAry1=new String[list.get(position).getName().length];
		String[] testStrAry2=new String[list.get(position).getName().length];
			testStrAry1[0]=list.get(position).getData1();
		
		list.get(position).getName()[0]=position+"";
		ThreeTvAdapter adapter=new ThreeTvAdapter(mContext,testStrAry2,//构建子列表适配器
				list.get(position).getName(),
				list.get(position).getMoney1(),
				id);
		ThreeTvAdapter adapter1=new ThreeTvAdapter(mContext,testStrAry1,//构建子列表适配器
				list.get(position).getName(),
				list.get(position).getMoney1(),
				R.layout.day_business1_item_item1);
		lv1.setAdapter(adapter1);
		lv.setAdapter(adapter);//设置子列表适配器
		//设置子列表适配器
		setListViewHeightBasedOnChildren(lv);//动态改变子列表高度
		setListViewHeightBasedOnChildren(lv1);//动态改变子列表高度
//		lv1.setVisibility(View.GONE);
		p=position;
		cb.setOnClickListener(new OnClickListener() {//设置CheckBox点击事件
			public void onClick(View v) {
				if(cb.isChecked()){
					setListViewHeightBasedOnChildren(lv1);
				}
				else{
//					lottery.setVisibility(View.VISIBLE);
					ViewGroup.LayoutParams params = lv1.getLayoutParams();  
					params.height = 0; 
			        lv1.setLayoutParams(params);
//			        lv1.setVisibility(View.GONE);
				}
//				list.get(position).setChecked(cb.isChecked());//点击的时候把大条目对应CheckBox状态改变
//            	doneListener.onDone(cb.isChecked(),list.get(position));//点击之后应该处理的其他东西放在onDone函数里参数值传入
			}
			});
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

