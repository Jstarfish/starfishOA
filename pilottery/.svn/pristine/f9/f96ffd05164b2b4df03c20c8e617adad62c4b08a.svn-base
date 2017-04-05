package com.huacai.assist.main;

import java.util.Timer;
import java.util.TimerTask;

import android.media.AudioManager;
import android.media.SoundPool;
import android.os.Message;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.widget.Button;
import android.widget.ImageView;
import cls.pilottery.packinfo.PackHandleFactory;
import cls.pilottery.packinfo.PackInfo;

import com.huacai.assist.R;
import com.huacai.assist.common.App;
import com.huacai.assist.common.App.IScanResult;
import com.huacai.assist.common.BaseActivity;

abstract class ScanActivity extends BaseActivity implements IScanResult {
	private ImageView saomiaoimage;
	private ImageView saomiaoimageback;// 扫描动画背景
	private ImageView saomiaoimage1;// 扫描动画背景
	protected boolean stopScanFlag = true;
	/**  扫描按钮 */
	private Button saomiaobtn;
	private TranslateAnimation translateAnimation;
	private SoundPool soundPool;// 声音播放
	
	public abstract boolean onScan(PackInfo pi, String s);
	public abstract boolean isSame(PackInfo pi, String s);
	public abstract String checkError(PackInfo pi, String s);
	
	public void initView() {
		super.initView();

		translateAnimation = new TranslateAnimation(0.0f,
				0.0f, 0.0f, 100.0f);
		translateAnimation.setRepeatCount(Integer.MAX_VALUE);
		translateAnimation.setRepeatMode(Animation.RESTART);
		translateAnimation.setDuration(1000);

		soundPool= new SoundPool(10,AudioManager.STREAM_SYSTEM,5);
		soundPool.load(this,R.raw.barcodeaudiosucced,1);
		soundPool.load(this,R.raw.error,1);
		saomiaoimageback = (ImageView) findViewById(R.id.saomiaoimageback);
		saomiaoimage1 = (ImageView) findViewById(R.id.saomiaoimage1);
		saomiaoimage = (ImageView) findViewById(R.id.saomiaoimage);
		saomiaobtn = (Button) findViewById(R.id.saomiaobtn);
		saomiaobtn.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {// 扫描
				saomiaoimage.startAnimation(translateAnimation);
				// 开始扫描
				saomiaobtn.setVisibility(View.INVISIBLE);
				saomiaoimageback.setVisibility(View.VISIBLE);
				saomiaoimage.setVisibility(View.VISIBLE);
				saomiaoimage1.setVisibility(View.INVISIBLE);
				App.goScan(ScanActivity.this, 1000);
			}
		});
	}
	
	public void stopScan() {
		saomiaoimage.clearAnimation();
		saomiaobtn.setVisibility(View.VISIBLE);
		saomiaoimageback.setVisibility(View.INVISIBLE);
		saomiaoimage.setVisibility(View.INVISIBLE);
		saomiaoimage1.setVisibility(View.VISIBLE);
		App.stopScan();
	}
	@Override
	public void onScanResult(final String s) {
		this.runOnUiThread(new Runnable(){

			@Override
			public void run() {
				PackInfo pi = null;
				try {
					if (!s.isEmpty()) {// 扫描的二维码不能为空
						getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
						if (timer != null) {
							task.cancel();
							timer.cancel();
						}
						task = new TimerTask(){  
							public void run() {  
								Log.e("yyc", "yyc set screen off");
								Message message = new Message();      
								message.what = 3;      
								if (mainHandler != null) {
									mainHandler.sendMessage(message);
									task.cancel();
									timer.cancel();
								}
							}  
						};
						timer = new Timer(true);
						timer.schedule(task, 60*1000, 60*1000);
						Log.e("yyc", "yyc do set screen on");
						pi = PackHandleFactory.getPackInfo(s);
						String err = checkError(pi, s);
						if (err != null) {
							App.showToastShort(err);
						} else {
							if (!isSame(pi, s)) {
								if (onScan(pi, s)) {
									soundPool.play(1,1, 1, 0, 0, 1);
								}
							} else {
								App.showToastShort(R.string.string_duplicate);
							}
						}
					}
				} catch (Exception e) {
					stopScanFlag = false;
					Log.e("yyc", "yyc stopScanFlag C "+stopScanFlag);
					soundPool.play(2,1, 1, 0, 0, 1);
					e.printStackTrace();
				}
				if (stopScanFlag) {
					stopScan();
				}
			}
		});
	}
	private Timer timer = null;
	private TimerTask task = null;
	@Override
	protected void onRestart() {
		super.onRestart();
		if (saomiaobtn.getVisibility() == View.INVISIBLE) {
			App.goScan(this, 1000, false);
		}
	}

	@Override
	protected void onStop() {
		super.onStop();
		if (saomiaobtn.getVisibility() == View.INVISIBLE) {
			App.stopScan();
		}
	}
	
}
