package com.huacai.assist.form;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ListView;
import android.widget.AdapterView.OnItemClickListener;
import com.huacai.assist.R;
import com.huacai.assist.adapter.ThreeTvAdapter;
import com.huacai.assist.common.BaseActivity;
import com.huacai.assist.net.Http;
import com.huacai.assist.net.NetResult;
import com.huacai.assist.net.RequestListener;
/**
 * 
 * 出货单列表
 * 
 * @author niyifeng
 *
 */

public class FormListActivity extends BaseActivity implements OnClickListener,RequestListener{
	/**  新增出货单按钮 */
	private Button apply;
	/**  出货单列表 */
	private ListView lv;
	/**  出货单列表第一列，即时间 */
	private String[] testStrAry1={};
	/**  出货单列表第二列，即总张数 */
	private String[] testStrAry2={};
	/**  出货单列表第三列，即状态 */
	private String[] testStrAry3={};
	/**  出货单列表  订单号 */
	private String[] testStrAry4={};
	@Override
	public void initView() {
		// TODO Auto-generated method stub
		super.initView();
		setMiddleText(R.string.title_activity_form_list);//设置标题
		apply=(Button)findViewById(R.id.apply);//新增出货单按钮赋值
		lv=(ListView)findViewById(R.id.list);//出货单列表赋值
		lv.setOnItemClickListener(new OnItemClickListener(){//添加出货单列表点击事件
			
			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1,
				int arg2, long arg3) {
				Intent intent=new Intent(FormListActivity.this,FormDetailActivity.class);//构建跳转到FormDetailActivity的intent
				Bundle bundle=new Bundle();//构建Bundle对象 
                bundle.putString("listCode", testStrAry4[arg2]); //将点击项对应的出货单编号发送给FormDetailActivity 
                intent.putExtras(bundle); //将bundle对象放入intent
	            FormListActivity.this.startActivity(intent); //跳转到FormLIstActivity
			}
			});
		apply.setOnClickListener(this);//设置新增出货单按钮点击事件
	}
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		initActivity(this,R.layout.activity_form_list);//初始化Activity
		initData();//初始化数据
		initView();//初始化视图
		initHandle();//初始化Handle
		sendInitialMsg();//发送查询出货单列表的请求数据
	}
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch (v.getId()) {
			case R.id.apply://点击新增出货单按钮
				FormListActivity.this.startActivity(new Intent(FormListActivity.this,AddFormListActivity.class));//跳转到新增出货单页面
				break;
		}
	}
	/**
	 * 刚进入页面时获取出货单列表信息发送的数据
	 */
	public void sendInitialMsg(){
		JSONObject jo = new JSONObject();//构建数据包
		try {
			jo.put("follow", "");//查询起始位置加入数据包
			jo.put("count", 500);//查询条数加入数据包
		} catch (JSONException e) {
			e.printStackTrace();
		}
		Http.request(Http.FORM_LIST, jo, this);//发送查询数据的请求
	}

	@Override
	public void onComplete(NetResult res) {//接收网络数据
		// TODO Auto-generated method stub
		Log.e("yyc", "onComplete "+res.errorStr);
		JSONObject result;//数据包
		final JSONArray deliveryList;//出货单编号
		if (res.jsonObject != null) {//如果返回的数据包为空
			try {
				int errCode = res.jsonObject.getInt("errcode");//返回的错误码
				if (res.errorCode == 0 && errCode == 0) {//如果错误码位0
					result=res.jsonObject.getJSONObject("result");//数据包赋值
					deliveryList=result.getJSONArray("deliveryList");//出货单编号列表
					this.runOnUiThread(new Runnable() {
						@Override
						public void run() {//更新出货单列表
							int listLength=deliveryList.length();//获取下方数组长度
							testStrAry1=new String[listLength];//构建列表所用数组对象
							testStrAry2=new String[listLength];
							testStrAry3=new String[listLength];
							testStrAry4=new String[listLength];//构建订单号数组
							for(int i=0;i<listLength;i++){//根据返回数组构建列表所需本地数组
								try {
									testStrAry1[i]=deliveryList.getJSONObject(i).getString("time");//将查询到的时间赋值给时间列对应项
									testStrAry2[i]=deliveryList.getJSONObject(i).getString("tickets");//将查询到的张数赋值给张数列对应项
									testStrAry3[i]=deliveryList.getJSONObject(i).getString("status");//将查询到的状态赋值给状态列对应项
									testStrAry4[i]=deliveryList.getJSONObject(i).getString("deliveryOrder");//将查询到的出货单编号赋值
								} catch (JSONException e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								}
								
							}
							ThreeTvAdapter adapter=new ThreeTvAdapter(FormListActivity.this, testStrAry1, testStrAry2, testStrAry3, R.layout.form_list_item);//新建出货单列表适配器
							lv.setAdapter(adapter);//设置出货单列表适配器
						}
					});
				}
			} catch (JSONException e) {
				e.printStackTrace();
			}
	}
		
	}
}
