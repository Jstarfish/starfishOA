package com.huacai.assist.form;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.AlertDialog.Builder;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;

import com.huacai.assist.R;
import com.huacai.assist.adapter.PreDFGAdapter;
import com.huacai.assist.common.App;
import com.huacai.assist.common.BaseActivity;
import com.huacai.assist.model.FormListItem;
import com.huacai.assist.model.Lottery;
import com.huacai.assist.net.Http;
import com.huacai.assist.net.NetResult;
import com.huacai.assist.net.RequestListener;
/**
 * 新增出货单确认页
 * 
 * @author niyifeng
 *
 */
public class EnsureDFGActivity extends BaseActivity implements RequestListener,OnClickListener{
	/** 确认出货页列表 */
	private ListView lv;
	/** 确认键 */
	private Button ensure;
	/** 列表lv的适配器 */
	private PreDFGAdapter upAdapter;
	/** 从AddFormListActivity传来的预出货列表对应list*/
	private List<Lottery> mylist=new ArrayList<Lottery>();
	/** 从AddFormListActivity传来的订单列表对应list*/
	private List<FormListItem> mylist1=new ArrayList<FormListItem>();
	@Override
	public void initView() {
		// TODO Auto-generated method stub
		super.initView();
		setMiddleText(R.string.title_activity_ensureDfg);//设置标题
		lv=(ListView)findViewById(R.id.list);//页面列表赋值
		ensure=(Button)findViewById(R.id.ensure);//确认键赋值
		ensure.setOnClickListener(this);//确认键点击事件
		upAdapter=new PreDFGAdapter(this,mylist, R.layout.ensure_dfg_item);//构建页面列表适配器
		lv.setAdapter(upAdapter);//设置页面列表适配器
		lv.setOnItemClickListener(new OnItemClickListener(){//设置页面列表点击事件

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1,
					int arg2, long arg3) {
				// TODO Auto-generated method stub
				changeQuantity(mylist,arg2);//改变选中方案对应彩票数量
				
			}
			
		});
	}
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		initActivity(this,R.layout.activity_ensure_dfg);//初始化Activity
		initData();//初始化数据
		initView();//初始化视图
		initHandle();//初始化Handle
	}
	/**
	 * 发送生成出货单的请求
	 */
	public void sendMakeListMsg(){
		JSONObject jo = new JSONObject();//要发送的数据包
		JSONArray plansList = new JSONArray();//方案列表
		JSONArray orderNumList = new JSONArray();//订单列表
		try {
			jo.put("orderList", orderNumList);//订单号列表加入数据包
			jo.put("plansList", plansList);//方案列表加入数据包
			for(int i=0;i<mylist1.size();i++){//遍历AddFormListActivity传入的订单列表对应list
				if(mylist1.get(i).isChecked()){//如果当前订单被选中
					orderNumList.put(mylist1.get(i).getNum());//订单号加入orderList
				}
			}
			for(int i=0;i<mylist.size();i++){//遍历AddFormListActivity传入的预出货列表对应list
				JSONObject jObj = new JSONObject();//每个方案对应的数据包
				jObj.put("planCode", mylist.get(i).getCode());//方案编码加入数据包
				jObj.put("tickets", Long.parseLong(mylist.get(i).getQuantity()));//方案对应彩票数量加入数据包
				plansList.put(jObj);//数据包加入plansList
			}
			
		} catch (JSONException e) {
			e.printStackTrace();
		}
		Http.request(Http.MAKE_FORM_LIST, jo, this);//发送确认出货的消息
	}
	@SuppressWarnings("unchecked")
	public void initData(){
		Intent intent=getIntent();//获取AddFormListActivity传入的intent
        mylist = (List<Lottery>)intent.getSerializableExtra("list");//获得上面intent中的预出货列表并赋值给本类对应list
        mylist1 = (List<FormListItem>)intent.getSerializableExtra("fli");//获得上面intent中的订单列表并赋值给本类对应list
	};
	@Override
	public void onComplete(NetResult res) {//接收返回数据
		Log.e("yyc", "onComplete "+res.errorStr);
//		final JSONObject result;//返回的数据包
//		String deliveryOrder = null;//出货单编号
		if (res.jsonObject != null) {//如果传回的数据包不为空
			try {
				int errCode = res.jsonObject.getInt("errcode");//错误码赋值
				if (res.errorCode == 0 && errCode == 0) {//如果错误码为0
//					result=res.jsonObject.getJSONObject("result");//数据包赋值
//					deliveryOrder=result.getString("deliveryOrder");//出货单编号赋值
					
					this.runOnUiThread(new Runnable() {//开启新的UI线程
						@Override
						public void run() {
							App.showToast(R.string.order_refer_success);//出货单提交成功显示的消息
							Intent intent=new Intent(EnsureDFGActivity.this,FormListActivity.class);//构建跳转到FormListActivity的intent
				            intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);//设置跳转到FormListActivity的方式为启动堆栈中已有的Activity
				            EnsureDFGActivity.this.startActivity(intent);//跳转到FormListActivity
						}
					});
				}
			} catch (JSONException e) {
				e.printStackTrace();
			}
	}
	}
	
	@Override
	public void onClick(View arg0) {
		// TODO Auto-generated method stub
		if(arg0==ensure){//点击确认键之后
			sendMakeListMsg();//发送确认出货的消息
		}
	}
	/**
	 * 
	 * 弹出对话框用于修改方案彩票数量，进而改变总价
	 * 
	 * @param mylist 
	 * 
	 *           整个列表对应的list
	 * 
	 * @param num
	 * 
	 *           所点击的条目对应编号
	 */
	public void changeQuantity(final List<Lottery> mylist,final int num){
		final Long money;//单价
		Long quantity;//数量
		Long total;//总价
		quantity=Long.parseLong(mylist.get(num).getQuantity());//将传入的预出货列表某项对应的方案彩票数赋值
		total=Long.parseLong(mylist.get(num).getMoney());//将传入的预出货列表某项对应的总价格赋值
		if(mylist.get(num).getPrice()==null){//如果mylist中存储的单价为空
			money=total/quantity;//计算出当前方案彩票单价
			mylist.get(num).setPrice(String.valueOf(money));//把初始化的单价存到list对应项中
		}
		else{
			money=Long.valueOf(mylist.get(num).getPrice());//单价赋值给本地变量
		}
		Builder builder1 = new Builder(EnsureDFGActivity.this);//新建修改方案对应彩票数量对话框
		builder1.setTitle(EnsureDFGActivity.this.getString(R.string.change_lottery_num));//设置对话框标题
		View view1 = LayoutInflater.from(EnsureDFGActivity.this).inflate(
				R.layout.order_apply_edit, null);//对话框对应主布局赋值
		final EditText number=(EditText) view1.findViewById(R.id.order_apply_edit);//用来编辑方案彩票数量
		number.setText(mylist.get(num).getQuantity());//设置彩票数量编辑框的当前数值
		builder1.setView(view1);//设置对话框主布局为view1
		builder1.setPositiveButton(R.string.string_comfirm, //对话框对应确认
				new DialogInterface.OnClickListener() {
			@Override
			public void onClick(DialogInterface dlg, int arg1) {
				Long quantity;//彩票数量
				if(number.getText().toString().equals("")){//如果输入的数量为空
					App.showMessage(EnsureDFGActivity.this.getString(R.string.empty_num), EnsureDFGActivity.this.getString(R.string.wrong_input));//弹出错误提示消息
				}
				else{
					quantity=Long.parseLong(number.getText().toString());//将输入的彩票数量赋值
					mylist.get(num).setQuantity(number.getText().toString());//将键盘输入的彩票数加入mylist对应项
					mylist.get(num).setMoney(String.valueOf(money*quantity));//将输入的彩票数总额加入mylist对应项
					upAdapter.notifyDataSetChanged();//更新确认出货页面主列表
				}
				
			}})
	.setNegativeButton(R.string.com_cancel, null).show();;//对话框取消键并展示对话框
		
		
	}
}
