package com.huacai.assist.form;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ListAdapter;
import android.widget.ListView;
import com.huacai.assist.R;
import com.huacai.assist.adapter.AddFormAdapter;
import com.huacai.assist.adapter.AddFormAdapter.CheckBoxClickListener;
import com.huacai.assist.adapter.PreDFGAdapter;
import com.huacai.assist.common.App;
import com.huacai.assist.common.BaseActivity;
import com.huacai.assist.model.FormListItem;
import com.huacai.assist.model.Lottery;
import com.huacai.assist.net.Http;
import com.huacai.assist.net.NetResult;
import com.huacai.assist.net.RequestListener;

/**
 * 
 * 新增出货单
 * 
 * @author niyifeng
 *
 */
 
public class AddFormListActivity extends BaseActivity implements  RequestListener{
	
	/** 确认按钮 */
	private Button ensure;
	/** 界面上方待出货单列表 */
	private ListView listDown;
	/** 界面下方列表 */
	private ListView listUp;
	/** 支持订单列表，即界面上方列表 */
	private List<FormListItem> list=new ArrayList<FormListItem>();
	/** 支持显示被选中的各个彩票的列表，即预出货列表、界面上方列表 */
	private List<Lottery> pitchOnLot=new ArrayList<Lottery>();
	/** 对应于上方列表每个条目的下标 */
	private int pl=0;
	/** 上方列表适配器*/
	private PreDFGAdapter upAdapter;
	/** 方案名称，并且对应页面上方列表第二列*/
	private String[] testStrAry1={};
	/** 方案对应彩票数量，并且对应页面上方列表三列*/
	private String[] testStrAry2={};
	/** 方案编码，并且对应页面上方列表一列*/
	private String[] testStrAry3={};
	/** 此方案对应彩票总价格*/
	private String[] testStrAry4={};
	
	@Override
	public void initView() {
		// TODO Auto-generated method stub
		super.initView();
		setMiddleText(R.string.title_activity_form_new);//页面标题
		ensure=(Button)findViewById(R.id.ensure);//确认按钮
//		listDown=(ListView)findViewById(R.id.list);//页面下方列表，即预出货列表
		listUp=(ListView)findViewById(R.id.list1);//页面上方列表，即订单列表
	}
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		initActivity(this,R.layout.activity_add_formlist);//初始化Activity
		initData();//初始化数据
		initView();//初始化视图
		initHandle();//初始化Handle
//		loadDate();
		sendQueryOrderList();//发送数据请求订单信息
	}
	
	private void loadDate(){
//		testStrAry1[j]=planName;//上值赋值给对应数组的元素
//		testStrAry2[j]=tickets;
//		testStrAry3[j]=planCode;
//		testStrAry4[j]=money;
//	}
		for(int i=0;i<10;i++){
			FormListItem fli1=new FormListItem(false,"win"+i,testStrAry1,testStrAry2,testStrAry4,testStrAry3);//构建FormListItem对象
			list.add(fli1);//上面新建对象加入list
		}
		AddFormAdapter adapter=new AddFormAdapter(AddFormListActivity.this, list);//新建订单列表
		listUp.setAdapter(adapter);//设置订单列表
		adapter.notifyDataSetChanged();//更新上方列表
		setListViewHeightBasedOnChildren(listUp);//调整上方列表高度避免显示错误
		adapter.setDoneListener(new CheckBoxClickListener() {//（CheckBoxClickListener为AddFormListAdapter1中接口）设置点击订单列表CheckBox后所调用的本地资源
			
			@Override
			public void onDone(boolean isChecked, FormListItem fli) {//点击订单列表某个复选框之后
				// TODO Auto-generated method stub
				updateDownList(isChecked,fli);//更新下端列表
			}
			
		
		});
	}
	/**
	 * 
	 * 查询订单列表
	 * 
	 */
	public void sendQueryOrderList(){
		JSONObject jo = new JSONObject();//新建数据包
		try {
			jo.put("outletCode", "");//站点号加入数据包
			jo.put("status", 1);//订单状态加入数据包
			jo.put("follow", "");//查询起始
			jo.put("count", 500);//查询条数
		} catch (JSONException e) {
			e.printStackTrace();
		}
		Http.request(Http.QUERY_ORDER_LIST, jo, this);//发送显示订单列表请求
	}
	/**
	 * 根据是否选中CheckBox动态更新pitchOnLot
	 * 
	 * @param isChecked
	 * 		
	 * 		单个订单条目复选框是否选中
	 * 
	 * @param fli
	 * 		
	 * 		存储这个订单条目数据的对象
	 */
	public void updateDownList(boolean isChecked,FormListItem fli){
		Lottery l = new Lottery("11", "11", 11,"","");//代表下方列表单个条目的对象
		String fName;//FormListItem存的方案名
		@SuppressWarnings("unused")
		String pName;//pitchOnLot存的方案名
		String fCode;//FormListItem存的方案编码
		String pCode;//pitchOnLot存的方案编码
		String fQuantity;//FormListItem存的方案方案彩票数量
		String pQuantity;//pitchOnLot存的方案彩票数量
		String fMoney;//FormListItem存的方案彩票总价
		String pMoney;//pitchOnLot存的方案彩票总价
		long tQ;//用来存储数量增减时的彩票数量值
		long t;//用来存储数量增减时的彩票总价
		if(isChecked){//订单列表单个一项勾选情况
//			fli.setChecked(true);//设置这个条目为选中状态
			for(int i=0;i<fli.getName().length;i++){//遍历条目中的方案
				fName=fli.getName()[i];//将当前方案的名称赋值
				fQuantity=fli.getQuantity()[i];//将当前方案的数量赋值
				fMoney=fli.getMoney()[i];//将当前方案的对应彩票总金额赋值
				fCode=fli.getCode()[i];//将当前方案的对应编码赋值
				if(pitchOnLot.size()>0){//如果用来显示下端列表的list不为空
					int j;
					for( j=0;j<pitchOnLot.size();j++){//遍历这个list
						l=pitchOnLot.get(j);//将list的一个条目赋值给l
						pName=pitchOnLot.get(j).getName();//将当前方案名称赋值
						pQuantity=pitchOnLot.get(j).getQuantity();//将当前方案总数赋值
						pMoney=pitchOnLot.get(j).getMoney();//将当前方案总价格赋值
						pCode=pitchOnLot.get(j).getCode();//将当前方案编码赋值
						if(pCode.equals(fCode)){//选中的订单里某个方案包含在下方的“预出货列表”中
							tQ=Long.parseLong(pQuantity)+Long.parseLong(fQuantity);//这个共有方案对应的数量相加
							pitchOnLot.get(j).setQuantity(String.valueOf(tQ));//上方相加和赋值给pitchOnLot对应项
							t=Long.parseLong(fMoney)+Long.parseLong(pMoney);//这个共有方案对应的金额相加
							pitchOnLot.get(j).setMoney(String.valueOf(t));//上方相加和赋值给pitchOnLot对应项
//							upAdapter.notifyDataSetChanged();//更新下方列表
							break;//已找到共有方案，跳出最近for循环
						}
					}
					if(j>=pitchOnLot.size()){//选中订单中存在下方列表里没有的方案
						pl++;//下标加1
						l = new Lottery(fName, fQuantity, pl,fCode,fMoney);//新建一个pitchOnLot的条目存储新增方案的值
						pitchOnLot.add(l);//新增方案加入ptchtOnLot
//						upAdapter.notifyDataSetChanged();//更新下方列表
						
					}
					
				}
				else{//如果下方列表中还没有数据
						pl=0;//下标初始化
						l.setNum(0);//当前条目下标设置为0
						l.setQuantity(fQuantity);//将当前方案数量赋值到下方列表条目
						l.setMoney(fMoney);//将当前方案总价格赋值到下方列表条目
						l.setName(fName);//将当前方案名称赋值到下方列表条目
						l.setCode(fCode);//将当前方案编码赋值到下方列表条目
						pitchOnLot.add(0,l);//将当前条目添加到pitchOnLot
//						upAdapter=new PreDFGAdapter(this,pitchOnLot, R.layout.dfg_down_item);//新建下方列表适配器对象
//						listDown.setAdapter(upAdapter);//给下方列表设置适配器
					}
//				}
			}
		}
		else{
//			fli.setChecked(false);//如果由选中变为取消
			for(int i=0;i<fli.getName().length;i++){//遍历复选框所在订单中的方案
				fName=fli.getName()[i];//将当前方案的名称赋值
				fQuantity=fli.getQuantity()[i];//将当前方案的数量赋值
				fCode=fli.getCode()[i];//将当前方案的编码赋值
				fMoney=fli.getMoney()[i];//将当前方案的总价格赋值
					int j;
					for( j=0;j<pitchOnLot.size();j++){//遍历下方列表中已有的方案
						l=pitchOnLot.get(j);//取当前方案对应的对象
						pName=pitchOnLot.get(j).getName();//将当前方案的名称赋值
						pQuantity=pitchOnLot.get(j).getQuantity();//将当前方案的数量赋值
						pCode=pitchOnLot.get(j).getCode();//将当前方案的编码赋值
						pMoney=pitchOnLot.get(j).getMoney();//将当前方案的总价格赋值
						if(pCode.equals(fCode)){//如果当前订单遍历的当前方案在下列表已有
							tQ=Long.parseLong(pQuantity)-Long.parseLong(fQuantity);//下列表对应方案与订单对应方案总数做差
							l.setQuantity(String.valueOf(tQ));//上面的差赋值给下列表响应对象
							t=Long.parseLong(pMoney)-Long.parseLong(fMoney);//下列表对应方案与订单对应方案总价格做差
							l.setMoney(String.valueOf(t));//上面的差赋值给下列表响应对象
							if(tQ==0){//如果两对应项有一差额为0
								pitchOnLot.remove(j);//移除下列表对应项
							}
							
							}
						}
					
//					upAdapter.notifyDataSetChanged();//更新下列表

			}
		}
	}
	/**
	 * 
	 * ScrollView或ListView中嵌套ListView需重新计算并设置ListView高度
	 * 
	 * @param listView
	 * 
	 * 		需要重新计算高度的ListView
	 * 
	 */
	public void setListViewHeightBasedOnChildren(ListView listView) {  
        ListAdapter listAdapter = listView.getAdapter();   
        if (listAdapter == null) {   
            return;  
        }  
        int totalHeight = 0;  
        for (int i = 0; i < listAdapter.getCount(); i++) {  
            View listItem = listAdapter.getView(i, null, listView);  
            listItem.measure(0, 0);  
            totalHeight += listItem.getMeasuredHeight();  
        }  
  
        ViewGroup.LayoutParams params = listView.getLayoutParams();  
        params.height = totalHeight + (listView.getDividerHeight() * listAdapter.getCount() );  
        listView.setLayoutParams(params);  
    }
	@Override
	public void onComplete(NetResult res) {
		// TODO Auto-generated method stub
		Log.e("yyc", "onComplete "+res.errorStr);
		final JSONObject result;//接收的数据包
		final JSONArray orderList;//订单列表
		
		if (res.jsonObject != null) {//如果接收的数据包为空
			try {
				int errCode = res.jsonObject.getInt("errcode");//接收的错误码
				if (res.errorCode == 0 && errCode == 0) {
					result=res.jsonObject.getJSONObject("result");//接收的数据包赋值
					orderList=result.getJSONArray("orderList");//订单列表数组
					this.runOnUiThread(new Runnable() {//开启新UI线程
						@Override
						public void run() {
							
							try {
								String orderNo;//订单号
								String planName;//每个订单对应的多个方案的名称
								String planCode;//方案编号
								String tickets;//方案对应彩票数量
								String money;//方案对应彩票总价
								JSONArray detailList;//每个订单对应的一组方案
								
								for(int i=0;i<orderList.length();i++){//遍历接收到的订单列表
									orderNo=orderList.getJSONObject(i).getString("orderNo");//订单号赋值
									detailList=orderList.getJSONObject(i).getJSONArray("detailList");//订单列表
									testStrAry1=new String[detailList.length()];//构建FormListItem对象所用的数组
									testStrAry2=new String[detailList.length()];
									testStrAry3=new String[detailList.length()];
									testStrAry4=new String[detailList.length()];
									for(int j=0;j<detailList.length();j++){//遍历当前订单的方案数组
										planCode=detailList.getJSONObject(j).getString("planCode");//方案编码赋值
										planName=detailList.getJSONObject(j).getString("planName");//方案名称赋值
										tickets=String.valueOf(detailList.getJSONObject(j).getLong("tickets"));//方案对应彩票数赋值
										money=String.valueOf(detailList.getJSONObject(j).getLong("amount"));//方案对赢彩票总价格赋值
										testStrAry1[j]=planName;//上值赋值给对应数组的元素
										testStrAry2[j]=tickets;
										testStrAry3[j]=planCode;
										testStrAry4[j]=money;
									}
									FormListItem fli1=new FormListItem(false,orderNo,testStrAry1,testStrAry2,testStrAry3,testStrAry4);//构建FormListItem对象
									list.add(fli1);//上面新建对象加入list
									
								}
								AddFormAdapter adapter=new AddFormAdapter(AddFormListActivity.this, list);//新建订单列表
								listUp.setAdapter(adapter);//设置订单列表
								adapter.notifyDataSetChanged();//更新上方列表
								setListViewHeightBasedOnChildren(listUp);//调整上方列表高度避免显示错误
								adapter.setDoneListener(new CheckBoxClickListener() {//（CheckBoxClickListener为AddFormListAdapter1中接口）设置点击订单列表CheckBox后所调用的本地资源
									
									@Override
									public void onDone(boolean isChecked, FormListItem fli) {//点击订单列表某个复选框之后
										// TODO Auto-generated method stub
										updateDownList(isChecked,fli);//更新下端列表
									}
									
								
								});
								ensure.setOnClickListener(new OnClickListener() {//设置确认键监听事件
									
									@Override
									public void onClick(View arg0) {
										// TODO Auto-generated method stub
										if(pitchOnLot.size()!=0){//如果下端列表有内容
											Intent intent=new Intent(AddFormListActivity.this,EnsureDFGActivity.class);//构建intent
								            intent.putExtra("list", (Serializable)pitchOnLot);//将下列表对应list传到下一个Activity
								            intent.putExtra("fli", (Serializable)list);//将上列表对应list传到下一个Activity
								            intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);//选择下一Activity的打开方式为打开原有堆栈中的Activity
								            AddFormListActivity.this.startActivity(intent);//启动下一Activity
										}
										else{//如果下端列表没有任何内容
											App.showMessage(AddFormListActivity.this.getString(R.string.at_least_oneOrder), AddFormListActivity.this.getString(R.string.no_order_choose));//弹出错误消息
										}
										     
									}
								});
								
							} catch (JSONException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
//							
						}
					});
				}
			} catch (JSONException e) {
				e.printStackTrace();
			}
	}
	} 
}