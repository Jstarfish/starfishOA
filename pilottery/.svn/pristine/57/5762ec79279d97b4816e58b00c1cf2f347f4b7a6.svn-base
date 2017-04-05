package com.huacai.assist.common;

import org.json.JSONObject;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.PopupMenu;
import android.widget.PopupMenu.OnMenuItemClickListener;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.huacai.assist.R;
import com.huacai.assist.login.LoginActivity;
import com.huacai.assist.login.ModifyPasswordActivity;
import com.huacai.assist.net.Http;

interface Action {
	public void initData();

	public void initView();

	public void initHandle();
}

public class BaseActivity extends Activity implements Action {
	private RelativeLayout titleBar = null;
	public static int titleColor = 0xfff40000;
	protected Button menu;
	public Button goback;
	private PopupMenu popupMenu;
	private Menu popMenu;
	public static Handler mainHandler = null;
	public static boolean isfirstEWm;
	public static BaseActivity b = null;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		b = this;
		setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
	}
	@Override
	protected void onRestart() {
		super.onRestart();
		Log.e("yyc", "yyc onRestart "+this.getClass().getSimpleName());
		b = this;
	}
	@Override
	public void initData() {
	}

	@Override
	public void initView() {
	}

	@Override
	public void initHandle() {
	}
	
	public void initActivity(final Activity activity, int resId) {
		activity.requestWindowFeature(Window.FEATURE_CUSTOM_TITLE);
		activity.setContentView(resId);
		activity.getWindow().setFeatureInt(Window.FEATURE_CUSTOM_TITLE,
				R.layout.title_bar);
		titleBar = (RelativeLayout) activity.getWindow().findViewById(
				R.id.titlebar);
		titleBar.setBackgroundColor(titleColor);

		goback = (Button) titleBar.findViewById(R.id.goback);
		menu = (Button) titleBar.findViewById(R.id.all_setting);
		if (this instanceof LoginActivity) {
			menu.setBackgroundResource(R.drawable.net_setting);
		}

		popupMenu = new PopupMenu(this, menu);
		popMenu = popupMenu.getMenu();
		// 通过XML文件添加菜单项
		MenuInflater menuInflater = getMenuInflater();
		menuInflater.inflate(R.menu.login_menu, popMenu);
		goback.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				InputMethodManager imm = (InputMethodManager) getSystemService(Activity.INPUT_METHOD_SERVICE);
				imm.hideSoftInputFromWindow(v.getWindowToken(), 0);
				if (onBack != null) {
					onBack.onClick(v);
				}
				finish();
			}
		});
		menu.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				popupMenu.show();
			}
		});
		popupMenu.setOnMenuItemClickListener(new OnMenuItemClickListener() {
			@Override
			public boolean onMenuItemClick(MenuItem item) {
				switch (item.getItemId()) {
				case R.id.menu_modify_login_password: {
					ModifyPasswordActivity.isTradePassword = false;
					Intent intent = new Intent(BaseActivity.this,
							ModifyPasswordActivity.class);
					BaseActivity.this.startActivity(intent);
				}
					break;
				case R.id.menu_modify_trade_password: {
					ModifyPasswordActivity.isTradePassword = true;
					Intent intent = new Intent(BaseActivity.this,
							ModifyPasswordActivity.class);
					BaseActivity.this.startActivity(intent);
				}
					break;
				case R.id.menu_action_exit://签退二次确认
					new AlertDialog.Builder(BaseActivity.this)
					.setTitle(R.string.com_tishi)
					.setMessage(R.string.confirm_exit)
					.setPositiveButton(R.string.string_comfirm, new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						JSONObject jo = new JSONObject();
						Http.request(Http.LOGOUT, jo, null);
						appData.reset();
						Intent intent = new Intent(BaseActivity.this, LoginActivity.class);
						startActivity(intent);
					}})
					.setNegativeButton(R.string.com_cancel,null)
					.show();
					break;
				}
				return false;
			}
		});
	}

	public void setSettingGone() {
		if (menu.getVisibility() == View.VISIBLE)
			menu.setVisibility(View.GONE);
	}

	public void setGoBackGone() {
		if (goback.getVisibility() == View.VISIBLE)
			goback.setVisibility(View.GONE);
	}

	public OnClickListener onBack = null;

	public void setGoBack(OnClickListener v) {
		if (goback.getVisibility() == View.GONE)
			goback.setVisibility(View.VISIBLE);
		onBack = v;
	}

	public void setMiddleText(int resid) {
		if (titleBar == null)
			return;

		TextView title = (TextView) titleBar.findViewById(R.id.title);
		title.setText(resid);
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		mainHandler = null;
		titleBar = null;
		// 关闭设备
	}
	public void hideKeyboard(View v) {
		InputMethodManager imm = (InputMethodManager) getSystemService(Activity.INPUT_METHOD_SERVICE);
		imm.hideSoftInputFromWindow(v.getWindowToken(), 0);
	}
	public void hideKeyboard() {
		InputMethodManager imm = (InputMethodManager) getSystemService(Activity.INPUT_METHOD_SERVICE);
		imm.hideSoftInputFromWindow(goback.getWindowToken(), 0);
	}
	
	@Override
	public void onBackPressed() {
		super.onBackPressed();
		hideKeyboard();
		if (onBack != null) {
			onBack.onClick(goback);
		}
		this.finish();
	}
	
}
