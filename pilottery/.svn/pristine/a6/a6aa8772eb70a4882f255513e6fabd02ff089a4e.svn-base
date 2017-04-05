package com.huacai.assist.site;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.json.JSONException;
import org.json.JSONObject;

import android.graphics.Typeface;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.huacai.assist.R;
import com.huacai.assist.common.App;
import com.huacai.assist.common.BaseActivity;
import com.huacai.assist.common.appData;
import com.huacai.assist.net.Http;
import com.huacai.assist.net.NetResult;
import com.huacai.assist.net.RequestListener;

/**
 * 站点充值
 */
public class RechargeActivity extends BaseActivity implements OnClickListener, RequestListener{
	/**  确认按钮 */
	private Button ensure;
	/**  显示站点编号 */
	private TextView num;
	/**  充值金额输入框 */
	private EditText fund;
	/**  交易密码输入框 */
	private EditText keywords;
	@Override
	public void initView() {
		// TODO Auto-generated method stub
		super.initView();
		setMiddleText(R.string.title_activity_recharge);//设置标题
		//组件赋值
		ensure=(Button)findViewById(R.id.ensure);//确认
		num=(TextView)findViewById(R.id.num);//站点号
		fund=(EditText)findViewById(R.id.money);//充值金额
		keywords=(EditText)findViewById(R.id.key_word);//密码
		ensure.setOnClickListener(this);//确认按钮添加点击事件
		keywords.setTypeface(Typeface.DEFAULT);//设置密码字体风格为普通
		num.setText(this.getString(R.string.withdraw_station_code)+" "+appData.stationCode);//显示当前站点号
	}
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		initActivity(this,R.layout.activity_recharge);//初始化Activity
		initData();//初始化数据
		initView();//初始化视图
		initHandle();//初始化Handle
		
		
	}
	/**
	 * 点确定，发送充值请求
	 */
	public void sendReChargeMsg(){
		JSONObject jo = new JSONObject();//新建数据包
		
		try {
			jo.put("outletCode", appData.stationCode);//站点号加入数据包
			jo.put("transPassword", keywords.getText().toString());//站点密码加入数据包
			jo.put("amount", fund.getText().toString());//充值金额加入数据包
			
			
		} catch (JSONException e) {
			e.printStackTrace();
		}
		Http.request(Http.RECHARGE, jo, this);//发送数据
	}
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch (v.getId()) {
			case R.id.ensure://如果点击确定按钮
				String amount;//充值金额
				amount=fund.getText().toString();//显示充值金额
				if(isInteger(amount)){//如果充值金额符合规则
					if(amount.length()>10){
						App.showMessage(RechargeActivity.this.getString(R.string.please_enter_right_money), RechargeActivity.this.getString(R.string.wrong_money));//弹出错误提示消息
					}
					else
					sendReChargeMsg();//发送充值请求
				}
				else//如果充值金额不符合规则
				{
					App.showMessage(RechargeActivity.this.getString(R.string.please_enter_right_recharge), RechargeActivity.this.getString(R.string.wrong_money));//弹出错误提示消息
				}
				break;
		}
	}
	@Override
	public void onComplete(NetResult res) {//接收返回消息
		// TODO Auto-generated method stub
		Log.e("yyc", "onComplete "+res.errorStr);
		if (res.jsonObject != null) {//如果内容不为空
			try {
				int errCode = res.jsonObject.getInt("errcode");//错误码，0为无错误
				
				if (res.errorCode == 0 && errCode == 0) {//errorCode为0意味着返回了正确结果
					this.runOnUiThread(new Runnable() {//开启新线程更新UI
						@Override
						public void run() {
							Toast.makeText(RechargeActivity.this, RechargeActivity.this.getString(R.string.recharge_success),
								     Toast.LENGTH_SHORT).show();//充值成功后提示消息
							RechargeActivity.this.finish();//关闭当前Activity
						}
					});
				}
			} catch (JSONException e) {
				e.printStackTrace();
			}
	}
	}
	/**
	 * 判断输入的充值金额是否符合规则（正整数）
	 * @param str
	 * 		金额
	 * @return
	 * 		true 符合 ，false 不符合
	 */
    public  boolean isInteger(String str) {
        Pattern pattern = Pattern.compile("[1-9]\\d*$");//正则表达式，要求充值金额为正整数
        Matcher isNum = pattern.matcher(str);//充值金额规则与要判断的字符串绑定
        if(isNum.matches()) {//如果充值金额符合规则
            return true;
        } else {
            return false;
        }
    }
}
