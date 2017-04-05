package com.huacai.assist.store;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.huacai.assist.R;
import com.huacai.assist.adapter.PreDFGAdapter;
import com.huacai.assist.common.App;
import com.huacai.assist.common.BaseActivity;
import com.huacai.assist.model.Lottery;
import com.huacai.assist.net.Http;
import com.huacai.assist.net.NetResult;
import com.huacai.assist.net.RequestListener;
/**
 * 确认还货页面
 * 
 * @author niyifeng
 *
 */
public class ERGActivity extends BaseActivity implements RequestListener,OnClickListener{
	/** 确认出货页列表 */
	private ListView lv;
	/** 确认键 */
	private Button ensure;
	/** 列表lv的适配器 */
	private PreDFGAdapter upAdapter;
	private TextView tv_amount;
	private TextView tv_quantity;
	/** 总金额 */
	private long amount;
	/** 总数 */
	private long quantity;
	/** 从QueryStockActivity传来的预出货列表对应list*/
	private List<Lottery> mylist=new ArrayList<Lottery>();
	@Override
	public void initView() {
		// TODO Auto-generated method stub
		super.initView();
		setMiddleText(R.string.ensure_return);//设置标题
		lv=(ListView)findViewById(R.id.list);//页面列表赋值
		ensure=(Button)findViewById(R.id.ensure);//确认键赋值
		tv_amount=(TextView)findViewById(R.id.amount);//确认键赋值
		tv_quantity=(TextView)findViewById(R.id.money);//确认键赋值
		ensure.setOnClickListener(this);//确认键点击事件
		upAdapter=new PreDFGAdapter(this,mylist, R.layout.ensure_dfg_item);//构建页面列表适配器
		lv.setAdapter(upAdapter);//设置页面列表适配器
		for(int i=0;i<mylist.size();i++){
			amount+=Long.valueOf(mylist.get(i).getMoney());
			quantity+=Long.valueOf(mylist.get(i).getQuantity());
		}
		tv_amount.setText(App.getResString(R.string.total_sum)+" "+App.getPriceFormated(amount)+App.getResString(R.string.com_unit));
		tv_quantity.setText(App.getResString(R.string.total_num)+" "+String.valueOf(quantity));
	}
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		initActivity(this,R.layout.activity_erg);//初始化Activity
		initData();//初始化数据
		initView();//初始化视图
		initHandle();//初始化Handle
	}
	/**
	 * 发送还货申请
	 */
	public void sendMakeListMsg(){
		JSONObject jo = null;//要发送的数据包
//		JSONObject jo = new JSONObject();//要发送的数据包
		Http.request(Http.RETURN_GOODS, jo, this);//发送确认出货的消息
	}
	@SuppressWarnings("unchecked")
	public void initData(){
		Intent intent=getIntent();//获取AddFormListActivity传入的intent
        mylist = (List<Lottery>)intent.getSerializableExtra("list");//获得上面intent中的预出货列表并赋值给本类对应list
	};
	@Override
	public void onComplete(NetResult res) {//接收返回数据
		// TODO Auto-generated method stub
		Log.e("yyc", "onComplete "+res.errorStr);
		if (res.jsonObject != null) {//如果传回的数据包不为空
			try {
				int errCode = res.jsonObject.getInt("errcode");//错误码赋值
				if (res.errorCode == 0 && errCode == 0) {//如果错误码为0
					
					this.runOnUiThread(new Runnable() {//开启新的UI线程
						@Override
						public void run() {
							App.showToast(R.string.return_success);//出货单提交成功显示的消息
							Intent intent=new Intent(ERGActivity.this,QueryStockActivity.class);//构建跳转到FormListActivity的intent
				            intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);//设置跳转到FormListActivity的方式为启动堆栈中已有的Activity
				            ERGActivity.this.startActivity(intent);//跳转到FormListActivity
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
		new AlertDialog.Builder(this).setTitle(App.getResString(R.string.return_tips)).setMessage(App.getResString(R.string.ensure_return1))
		.setPositiveButton(App.getResString(R.string.string_comfirm), new DialogInterface.OnClickListener() {
		public void onClick(DialogInterface dialog, int which) {
			sendMakeListMsg();//发送还货申请
		}})
		.setNegativeButton(App.getResString(R.string.com_cancel),null)
		.show();
//		if(arg0==ensure){//点击确认键之后
//			
//		}
	}
}
