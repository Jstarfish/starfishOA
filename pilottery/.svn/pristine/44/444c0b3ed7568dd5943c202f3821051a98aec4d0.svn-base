package com.huacai.assist.common;

import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.text.DecimalFormat;

import android.app.AlertDialog;
import android.app.Application;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.widget.Toast;

import com.huacai.assist.R;
import com.langcoo.barcodescanner.Barcord;
import com.langcoo.serialport.ReceiveDataListener;

public class App extends Application {
	public static App c=null;
	
	public static String getResRawString(int id) {
		try {
			InputStream is = c.getResources().openRawResource(id);
			int len = is.available();
			byte[] data = new byte[len];
			is.read(data);
			String s = new String(data, "UTF-8");
			return s;
		} catch (IOException e) {
			e.printStackTrace();
		}
		return "";
	}
	private static ProgressDialog mProgressDialog = null;
	private static int showCount = 0;
	static Handler mainHandler = null;
	static DecimalFormat numberFormat = null;
	
	public static String getPriceFormated(long price) {
		if (numberFormat == null) {
			numberFormat = new DecimalFormat();
			numberFormat.applyPattern(",###");
		}
		return numberFormat.format(price);
	}
	public static Toast toast = null;
	public static void showToast(int resId) {
		showToast(getResString(resId));
	}
	public static void showToastShort(int resId) {
		showToastShort(getResString(resId));
	}
	public static void cancelToast() {
		if (toast != null) {
			toast.cancel();
		}
	}
	public static void showToast(String s) {
		if (toast == null) {
			toast = Toast.makeText(c, s, Toast.LENGTH_LONG);
		}
		toast.setText(s);
		toast.setDuration(Toast.LENGTH_LONG);
		toast.show();
	}
	public static void showToastShort(String s) {
		if (toast == null) {
			toast = Toast.makeText(c, s, Toast.LENGTH_SHORT);
		}
		toast.setText(s);
		toast.setDuration(Toast.LENGTH_SHORT);
		toast.show();
	}
	
	public static void postRun(Runnable r, long ms) {
		mainHandler.postDelayed(r, ms);
	}
	
	public static void hideProgressDialog() {
		mainHandler.post(new Runnable() {
			@Override
			public void run() {
				showCount--;
				if (showCount <=0) {
					showCount=0;
					ProgressDialog dlg = mProgressDialog;
					mProgressDialog = null;
					if (dlg != null && dlg.isShowing()) {
						try {
							dlg.dismiss();
						} catch (Exception e) {
						}
					}
				}
			}
		});
	}
	
	public static void showProgressDialogIfNeccesary() {
		mainHandler.post(new Runnable() {
			@Override
			public void run() {
				showCount++;
				if (mProgressDialog == null) {
					ProgressDialog pDlg;
					pDlg = new CustomProgressDialog(BaseActivity.b);
					pDlg.setCancelable(false);
					pDlg.setCanceledOnTouchOutside(false);
					pDlg.setIndeterminate(true);
					try {
						pDlg.show();
						mProgressDialog = pDlg;
					} catch (Exception e) {
					}
				}
			}
		});
	}
	
	public static class CustomProgressDialog extends ProgressDialog{  
		  
	    public CustomProgressDialog(Context context) {  
	        super(context);  
	    }  
	      
	    public CustomProgressDialog(Context context, int theme) {  
	        super(context, theme);  
	    }  
	  
	    @Override  
	    protected void onCreate(Bundle savedInstanceState) {  
	        super.onCreate(savedInstanceState);  
//	        getWindow().setType(WindowManager.LayoutParams.TYPE_SYSTEM_ALERT);
	        setContentView(R.layout.dialog_progress);
	    }  
	      
	    public static CustomProgressDialog show(Context ctx){  
	        CustomProgressDialog d = new CustomProgressDialog(ctx);  
	        d.show();  
	        return d;  
	    }  
	}
	
	public static String getResString(int resid) {
		return c.getResources().getString(resid);
	}
	public static void showMessage(int msg, int title,DialogInterface.OnClickListener event) { 
		showMessage(getResString(msg), getResString(title), event);
	}
	public static void showMessage(int errId, int msg, int title) { 
		showMessage(getResString(msg), getResString(title));
		if (errId != 0) {
			showMessage(getResString(msg)+" ("+errId+")", getResString(title), null);
		} else {
			showMessage(getResString(msg), getResString(title), null);
		}
	}
	public static void showMessage(int msg, int title) { 
		showMessage(getResString(msg), getResString(title));
	}
	public static void showMessage(final String msg, final String title) {
		showMessage(msg, title, null);
	}
	public static void showMessage(final int errId, final String msg, final String title) {
		if (errId != 0) {
			showMessage(msg+" ("+errId+")", title, null);
		} else {
			showMessage(msg, title, null);
		}
	}
	public static void showMessage(final String msg, final String title, 
			DialogInterface.OnClickListener event) {
		if (event == null) {
			event = new DialogInterface.OnClickListener() {//添加确定按钮  
		         @Override  
		         public void onClick(DialogInterface dialog, int which) {//确定按钮的响应事件  
		        	 	dialog.dismiss();
		         }  
		     };
		}
		final DialogInterface.OnClickListener onClick = event;
		mainHandler.post(new Runnable() {
			@Override
			public void run() {
				AlertDialog dlg = new AlertDialog.Builder(BaseActivity.b)
				 .setTitle(title)//设置对话框标题  
			     .setMessage(msg)//设置显示的内容  
			     .setPositiveButton(R.string.string_comfirm,onClick)
			     .setCancelable(false).create();
//				dlg.getWindow().setType(WindowManager.LayoutParams.TYPE_SYSTEM_ALERT);
			    dlg.show();//在按键响应事件中显示此对话框 
			}
		});
	}

	public Tone mTone;

	public Barcord mBarcord;
	
	@Override
	public void onCreate() {
		super.onCreate();
		c=(App) getApplicationContext();
		mainHandler = new Handler(Looper.getMainLooper());
		mTone = new Tone(this);
		String bitRate = CommonTools.getPerferences(this, appData.bitRateName, "9600");
		appData.bitRate = Integer.parseInt(bitRate);
		// 初始化
		mBarcord = new Barcord();
		mBarcord.setBaudrate(appData.bitRate);
		mBarcord.open();
//		mBarcord.scan(receiveDataListener);
	}
	
	public static void restartScan() {
		if (c.mBarcord != null) {
			c.mBarcord.close();
			c.mBarcord = new Barcord();
			c.mBarcord.setBaudrate(appData.bitRate);
			c.mBarcord.open();
		}
	}
	
	public static void stopScan() {
		c.mBarcord.stop();
		onScanResult = null;
	}
	static public abstract interface IScanResult {
		public void onScanResult(String s);
	}
	private static IScanResult onScanResult = null;

	private static boolean playTone = false;
	public static void goScan(IScanResult isr, final long ms, boolean tone) {
		playTone = tone;
		onScanResult = isr;
		c.mBarcord.scan(c.receiveDataListener);
		App.postRun(new Runnable(){
			@Override
			public void run() {
				if (onScanResult != null) {
					goScan(onScanResult, ms, playTone);
				}
		}}, ms);
	}
	public static void goScan(IScanResult isr, final long ms) {
		goScan(isr, ms, false);
	}
	public ReceiveDataListener receiveDataListener = new ReceiveDataListener() {

		@Override
		public void receive(byte[] data) {
			System.out.println("码值接收到了，其字符集长度为："
					+ (data != null ? data.length : "空"));
			Log.e("yyc", "码值接收到了，其字符集长度为：" + (data != null ? data.length : "空"));
			String re = "";
			try {
				re = new String(data, "utf-8");
				Log.e("yyc", "码值接收到了，是(字符集为UTF-8)：" + re);
				if (playTone) {
					c.mTone.Start();
				}
				if (onScanResult != null) {
					onScanResult.onScanResult(re);
				}
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
		}
	};
	
	/**
	 * 提示音播放.<br>
	 * <br>
	 * CreateDate: 2013-10-18<br>
	 * Copyright: Copyright(c) 2013-10-18<br>
	 * <br>
	 * 
	 * @since v1.0.0
	 * @Description 2013-10-18::::创建此类</br>
	 */
	static class Tone {
		/** ownersContext 上下文 */
		Context ownersContext;
		/** mBarcodeMediaPlayer 声音播放 */
		public MediaPlayer mBarcodeMediaPlayer;

		/**
		 * 构造方法.<br>
		 * <br>
		 * 
		 * @param context
		 * @Description 2013-10-18::::创建此构造方法</br>
		 */
		public Tone(Context context) {
			ownersContext = context;
			mBarcodeMediaPlayer = MediaPlayer.create(ownersContext,
					R.raw.barcodeaudiosucced);
		}

		/**
		 * 释放.<br>
		 * <br>
		 * 
		 * @return
		 * @Description 2013-10-18::::创建此方法</br>
		 */
		public boolean Des() {
			// mBarcodeMediaPlayer.release();
			mBarcodeMediaPlayer = null;
			return true;
		}

		/**
		 * 判断是否静音.<br>
		 * <br>
		 * 
		 * @return
		 * @Description 2013-10-18::::创建此方法</br>
		 */
		private boolean IsSilence() {
			AudioManager mAudioManager = (AudioManager) ownersContext
					.getSystemService(Context.AUDIO_SERVICE);
			int statusFlag = (mAudioManager.getRingerMode() == AudioManager.RINGER_MODE_SILENT) ? 1
					: 0;
			int int1 = 1;
			if (statusFlag == int1) {
				return true;
			}
			return false;
		}

		/**
		 * 提示音开启.<br>
		 * <br>
		 * 
		 * @return
		 * @Description 2013-10-18::::创建此方法</br>
		 */
		boolean Start() {
			if (IsSilence() == true) {
				return true;
			}
			boolean bRet = false;

			if (mBarcodeMediaPlayer != null) {
				mBarcodeMediaPlayer.start();
				bRet = true;
			}
			return bRet;
		}

	}
}
