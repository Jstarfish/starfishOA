/*
 * author:yuanshiyue
 * date:2015/10/15
 * verson:v1.0
 */
package com.huacai.assist.store;

import java.util.ArrayList;
import java.util.Timer;
import java.util.TimerTask;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.content.DialogInterface;
import android.content.Intent;
import android.media.AudioManager;
import android.media.SoundPool;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import cls.pilottery.packinfo.EunmPackUnit;
import cls.pilottery.packinfo.PackHandleFactory;
import cls.pilottery.packinfo.PackInfo;

import com.huacai.assist.R;
import com.huacai.assist.adapter.PutInStorage1Adapter;
import com.huacai.assist.adapter.PutInStorage1Adapter.ViewHolder;
import com.huacai.assist.common.App;
import com.huacai.assist.common.App.IScanResult;
import com.huacai.assist.common.BaseActivity;
import com.huacai.assist.common.appData;
import com.huacai.assist.expiry.ExpiryActivity;
import com.huacai.assist.net.Http;
import com.huacai.assist.net.NetResult;
import com.huacai.assist.net.RequestListener;

public class PutInStorage1 extends BaseActivity implements OnItemClickListener, IScanResult, OnClickListener {
	private int storagetype = 0;// 入库1，兑奖2，退票3

	private TextView zhangdianbianhaovalue;// 站点编号
	private TextView zhanghuyuevalue;// 余额
	private Button saomiaobtn;// 扫描入库
	private ListView list1;// 第一个列表
	public TextView zfzjevalue;// 总金额
	private Button rukuokbtn;// 入库完成
	private ListView list2;// 第二个列表
	private ImageView saomiaoimageback;// 扫描动画背景
	private ImageView saomiaoimage;// 扫描动画背景
	private ImageView saomiaoimage1;// 扫描动画背景
	private boolean backKeyS=true;
	private ArrayList<PackInfo> fabhlistdata1;// 列表数据，每个页面的列表共用的数据
	private PutInStorage1Adapter adapter;
	private Handler startEWMHandler = null;
	private Animation translateAnimation=null;
	public Long totalcount = 0l;// 列表下边的总计，在入库和退票中表示金额，在兑奖中表示张数
	private boolean clicked=false;
	private SoundPool soundPool;// 声音播放
	private Timer timer = null;
	private TimerTask task = null;
	private View showFinish;
	private View hideFinish;
	private View finishPanel;

	@Override
	protected void onRestart() {
		// TODO Auto-generated method stub
		super.onRestart();
//		App.stopScan();
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

	@Override
	protected void onDestroy() {
		super.onDestroy();
	}

	/* 兑奖成功时返回到兑奖页面要清空兑奖列表
	 */
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		switch (requestCode) {
		case 1:
			fabhlistdata1.clear();
			adapter.notifyDataSetChanged();
			App.goScan(PutInStorage1.this, 1000, false);
			break;
		default:
			break;
		}
	}

	@Override
	public void initData() {
		super.initData();
		fabhlistdata1 = new ArrayList<PackInfo>();
		// fabhlistdata2 = new ArrayList<PackInfo>();
		storagetype = getIntent().getIntExtra("storagetype", 0);
		
		soundPool= new SoundPool(10,AudioManager.STREAM_SYSTEM,5);
		soundPool.load(this,R.raw.barcodeaudiosucced,1);
		soundPool.load(this,R.raw.error,1);
	}

	/*
	 * 将扫描的码格式化到PackInfo对象中，并加入到列表的数据集合
	 */
	private void getEWMparam(String ewmdata) {
		// 箱
		// ewmdata = "Q201600001000011001001001010000101000200161013000000119.6abcdef";
		// 盒
		// ewmdata = "Q20160000101010010000000010000010";
		// 本
		// ewmdata = "Q2016000010002000000001100100";
		//
		PackInfo pi = null;
		try {
			if (!ewmdata.isEmpty()) {// 扫描的二维码不能为空
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
				if (storagetype ==  2) {
					boolean tempewm = false;
					// 20 5-5-7-..
					if (ewmdata.length() < 41) {
						Log.e("yyc", "yyc not ticket");
						soundPool.play(2,1, 1, 0, 0, 1);
						return ;
					}
					// 判断重复
					for (int i = 0; i < fabhlistdata1.size(); i++) {
						if (fabhlistdata1.get(i).EWMStr.equals(ewmdata)) {// 集合众存在此二维码则不加入
							tempewm = true;
							App.showToastShort(R.string.string_duplicate);
//							soundPool.play(2,1, 1, 0, 0, 1);
							return ;
						}
					}
					pi = new PackInfo();
					pi.EWMStr = ewmdata;
					// 20 5-5-7-..
//					planCode=J0004;planName=GongXi;batchCode=15905;packUnit=ticket;packUnitCode=136;ticketNum=1;amount=2000;groupCode=null;firstPkgCode=0005588;
//					J0004159050005588136WZSOYGTHLGTJDPVWAH034
//					012345678901234567890
					pi.setPlanCode(ewmdata.substring(0, 5));
					pi.setBatchCode(ewmdata.substring(5, 10));
					pi.setPlanName("oldTicket");
					pi.setPackUnit(EunmPackUnit.ticket);
					pi.setFirstPkgCode(ewmdata.substring(10, 17));
					pi.setPackUnitCode(ewmdata.substring(17, 20));
					pi.setTicketNum(1);
					if (!tempewm) {// 遍历集合后二维码没有重复的才能加入集合
						fabhlistdata1.add(pi);
						if (storagetype == 2) {// 兑奖的总计是张数，入库和退票是金额
							totalcount += pi.getTicketNum();
							zfzjevalue.setText(App.getPriceFormated(totalcount));
						} else {
							totalcount += pi.getAmount();
							zfzjevalue.setText(App.getPriceFormated(totalcount));
						}
						adapter.notifyDataSetChanged();
						// 播放音效
						soundPool.play(1,1, 1, 0, 0, 1);
						return ;
					}
				} else 
				{
					pi = PackHandleFactory.getPackInfo(ewmdata);
					if (pi != null && fabhlistdata1 != null) {// 二维码能够被格式化
						pi.EWMStr = ewmdata;
						Log.e("yyc", "yyc pack info "
								+"getBatchCode "+pi.getBatchCode()
								+", getFirstPkgCode "+pi.getFirstPkgCode()
								+", getPackUnitCode "+pi.getPackUnitCode()
								+", getPlanCode "+pi.getPlanCode()
								+", getTicketNum "+pi.getTicketNum());
						boolean tempewm = false;
						if (storagetype == 2 && pi.getPackUnit() != EunmPackUnit.ticket) {
							// 兑奖，只有票，不管箱盒本
							Log.e("yyc", "yyc not ticket");
							soundPool.play(2,1, 1, 0, 0, 1);
							return ;
						} else if (storagetype != 2 && pi.getPackUnit() == EunmPackUnit.ticket) {
							Log.e("yyc", "yyc must not be ticket");
							soundPool.play(2,1, 1, 0, 0, 1);
							return ;
						}
						// 判断重复
						for (int i = 0; i < fabhlistdata1.size(); i++) {
							if (pi.isSame(fabhlistdata1.get(i))) {// 集合众存在此二维码则不加入
								tempewm = true;
								App.showToastShort(R.string.string_duplicate);
	//							soundPool.play(2,1, 1, 0, 0, 1);
								return ;
							}
						}
						if (!tempewm) {// 遍历集合后二维码没有重复的才能加入集合
							fabhlistdata1.add(pi);
							if (storagetype == 2) {// 兑奖的总计是张数，入库和退票是金额
								totalcount += pi.getTicketNum();
								zfzjevalue.setText(App.getPriceFormated(totalcount));
							} else {
								totalcount += pi.getAmount();
								zfzjevalue.setText(App.getPriceFormated(totalcount));
							}
							adapter.notifyDataSetChanged();
							// 播放音效
							soundPool.play(1,1, 1, 0, 0, 1);
							return ;
						}
					}
				}
			}
		} catch (Exception e) {
			soundPool.play(2,1, 1, 0, 0, 1);
			e.printStackTrace();
		}
	}

	@Override
	public void initView() {
		// TODO Auto-generated method stub
		super.initView();

		if (storagetype != 2) {
			showFinish = findViewById(R.id.show_finish);
//			hideFinish = findViewById(R.id.hidden_finish);
			showFinish.setOnClickListener(this);
//			hideFinish.setOnClickListener(this);
			finishPanel = findViewById(R.id.finish_panel);
			zhanghuyuevalue = (TextView) findViewById(R.id.zhanghuyuevalue);
			zhanghuyuevalue.setText(App.getPriceFormated(appData.balance));
		}
		zhangdianbianhaovalue = (TextView) findViewById(R.id.zhangdianbianhaovalue);
		zhangdianbianhaovalue.setText(appData.stationCode);
		
		saomiaobtn = (Button) findViewById(R.id.saomiaobtn);
		list1 = (ListView) findViewById(R.id.list1);
		zfzjevalue = (TextView) findViewById(R.id.zfzjevalue);
		rukuokbtn = (Button) findViewById(R.id.rukuokbtn);
		list2 = (ListView) findViewById(R.id.list2);
		saomiaoimageback = (ImageView) findViewById(R.id.saomiaoimageback);
		saomiaoimage = (ImageView) findViewById(R.id.saomiaoimage);
		saomiaoimage1 = (ImageView) findViewById(R.id.saomiaoimage1);

		saomiaobtn.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {// 扫描
				if (finishPanel == null ||  finishPanel.getVisibility() == View.GONE) {
					saomiaobtn.setVisibility(View.INVISIBLE);
					saomiaoimageback.setVisibility(View.VISIBLE);
					saomiaoimage.setVisibility(View.VISIBLE);
					saomiaoimage1.setVisibility(View.INVISIBLE);
					clicked=true;
//					// 扫描动画
//					translateAnimation = new TranslateAnimation(0.0f,
//							0.0f, 0.0f, 100.0f);
//					translateAnimation.setRepeatCount(Integer.MAX_VALUE);
//					translateAnimation.setRepeatMode(Animation.RESTART);
//					translateAnimation.setDuration(1000);
					saomiaoimage.startAnimation(translateAnimation);
					// 开始扫描
					App.goScan(PutInStorage1.this, 1000, false);
				}
			}
		});
		rukuokbtn.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				if (fabhlistdata1.size() == 0) {
					App.showToast(PutInStorage1.this.getString(R.string.nodata));
					return;
				}
				if (storagetype == 1) {
					// 入库
					ruku();
				} else if (storagetype == 2) {
					// 兑奖
					duijiang();
				} else {
					// 退货
					tuihuo();
				}
				// 扫描完成显示扫描按钮，隐藏扫描动画
//				saomiaobtn.setVisibility(View.VISIBLE);
//				saomiaoimage1.setVisibility(View.VISIBLE);
//				saomiaoimageback.setVisibility(View.INVISIBLE);
//				saomiaoimage.setVisibility(View.INVISIBLE);
//				saomiaoimage.clearAnimation();
//				App.stopScan();
			}
		});
		list1.setOnItemClickListener(this);
	}

	/*
	 * 入库
	 */
	private void ruku() {
		final AlertDialog myDialog = new AlertDialog.Builder(PutInStorage1.this)
				.create();
		myDialog.show();
		final Window diawindow = myDialog.getWindow();
		diawindow.setContentView(R.layout.put_in_storage_ok);
		((TextView) diawindow.findViewById(R.id.yingfuzongjinevalue))
				.setText(App.getPriceFormated(totalcount));
		diawindow.findViewById(R.id.saomiaobtn).setOnClickListener(
				new View.OnClickListener() {
					@SuppressWarnings("static-access")
					@Override
					public void onClick(View v) {
						String password = ((TextView) diawindow
								.findViewById(R.id.password)).getText()
								.toString();
						if (password == null || password.isEmpty()) {
							App.showToast(R.string.string_site_password_empty);
							return;
						}
						long siteAmount = appData.balance;
//						if (totalcount > siteAmount) {
//							App.showToast(R.string.site_no_money);
//							return;
//						}
						// 入库完成发送网络
						JSONObject jo = new JSONObject();
						try {
							jo.put("outletCode", appData.stationCode);
							jo.put("password", password);
							JSONArray jolist = new JSONArray();
							jo.put("goodsTagList", jolist);
							for (int i = 0; i < fabhlistdata1.size(); i++) {
								JSONObject item = new JSONObject();
								item.put("goodsTag",
										fabhlistdata1.get(i).EWMStr);
								item.put("tickets", fabhlistdata1.get(i)
										.getTicketNum().toString());
								jolist.put(item);
							}
						} catch (JSONException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
						Http.o.request(0x020408, jo, new RequestListener() {
							@Override
							public void onComplete(NetResult response) {
								try {
									int errCode = response.jsonObject
											.getInt("errcode");
									if (errCode == 0) {// 判断网络是否正确,目前只要入库成功返回的code是0，如果在之后调试bug中服务器出现其他code为0的情况，则在此处判断条件即可

										long balance = appData.balance;
										try {
											JSONObject result = response.jsonObject.getJSONObject("result");
											balance = result.getLong("balance");
										} catch (JSONException e) {
											e.printStackTrace();
										}
										appData.balance = balance;
//										final long accountBalance = balance;
										runOnUiThread(new Runnable() {
											public void run() {
//												totalcount = 0l;
//												zhanghuyuevalue.setText(App.getPriceFormated(accountBalance));
//												zfzjevalue.setText(App.getPriceFormated(totalcount));
//												App.showToast(PutInStorage1.this.getString(R.string.ruku_ok));
//												// 入库成功要清空入库列表
//												fabhlistdata1.clear();
//												adapter.notifyDataSetChanged();
												App.showToast(PutInStorage1.this.getString(R.string.ruku_ok));
												finish();
											}
										});

									} else {
										// 没有中奖或已经兑奖,目前在网络层已经提示了，如果网络层不提示需要打开下面代码
										
									}
									myDialog.dismiss();
									return;
								} catch (JSONException e) {
									App.showToast(R.string.ruku_error);
								}
							}
						});
					}
				});
	}

	/*
	 * 兑奖
	 */
	private void duijiang() {
		final AlertDialog myDialog = new AlertDialog.Builder(PutInStorage1.this)
				.create();
		myDialog.show();
		JSONObject jo = new JSONObject();
		try {
			jo.put("outletCode", appData.stationCode);
			JSONArray jolist = new JSONArray();
			jo.put("securityCodeList", jolist);
			/*
			J2016000010000004166DKTSANFUBVYUNAORJ0066  大奖
			J2016000010000004188DKTSANFUBVYUNAORJ0088  中奖
			J2016000010000004199DKTSANFUBVYUNAORJ0099  中奖
			J2016000010000004177DKTSANFUBVYUNAORJ0077  未中奖
			J2016000010000104199DKTSANFUBVYUNAORJ0099  无效票（未销)
			*/
			/*
			JSONObject item = new JSONObject();item.put("securityCode", "J2016000010000004166DKTSANFUBVYUNAORJ0066");jolist.put(item);
			//item = new JSONObject();item.put("securityCode", "J2016000010000004188DKTSANFUBVYUNAORJ0088");jolist.put(item);
			//item = new JSONObject();item.put("securityCode", "J2016000010000004199DKTSANFUBVYUNAORJ0099");jolist.put(item);
			item = new JSONObject();item.put("securityCode", "J2016000010000004177DKTSANFUBVYUNAORJ0077");jolist.put(item);
			item = new JSONObject();item.put("securityCode", "J2016000010000104199DKTSANFUBVYUNAORJ0099");jolist.put(item);
			*/
			for (int i = 0; i < fabhlistdata1.size(); i++) {
				JSONObject item = new JSONObject();
				item.put("securityCode", fabhlistdata1.get(i).EWMStr);
				jolist.put(item);
			}
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Http.request(0x020411, jo, new RequestListener() {
			@Override
			public void onComplete(NetResult response) {
				try {
//					String fackJson = getResRawString(R.raw.winlist);
//					response.jsonObject = new JSONObject(fackJson);
					int errCode = response.jsonObject.getInt("errcode");
					if (errCode == 0) {// 判断网络是否正确
						long winAmount = response.jsonObject.getJSONObject(
								"result").getLong("winAmount");
						int winTickets = 0;
						try { 
							winTickets = response.jsonObject.getJSONObject("result").getInt("winTickets");
						} catch (JSONException e) {
							
						}
						if (winAmount >= 0) {
							JSONArray winningListarr = response.jsonObject
									.getJSONObject("result").getJSONArray(
											"winningList");
//							// 将每个中奖的票加上中奖值
//							for (int i = 0; i < winningListarr.length(); i++) {
//								String ticketCode = ((JSONObject) winningListarr
//										.get(i)).getString("ticketCode");
//								// 将中奖的票奖金加入到数据集合对应的票上
//								for (int j = 0; j < fabhlistdata1.size(); j++) {
//									if (fabhlistdata1.get(j).getPackUnitCode() == ticketCode) {
//										fabhlistdata1.get(j).setPrizeAmount(
//												((JSONObject) winningListarr
//														.get(i))
//														.getLong("amount"));
//										break;
//									}
//								}
//							}
							int count = winningListarr.length();
							ArrayList<String[]> list = new ArrayList<String[]>();
							for (int i=0; i<count; i++) {
								JSONObject jo = winningListarr.getJSONObject(i);
								String[] str = new String[5];
								str[0] = jo.getString("ticketCode");
								str[1] = jo.getString("amount");
								str[2] = jo.getString("payStatusValue");
								str[4] = jo.getString("payStatus");
								if (str[4].equals("1")) {
									str[1] = App.getPriceFormated(Long.parseLong(str[1]));
								} else if (str[4].equals("4")) {
									str[1] = "*";
								} else {
									str[1] = "-";
								}
								str[3] = "";
								try {
									str[3] = jo.getString("ticketFlag");
								} catch (JSONException e) {
								}
								list.add(str);
							}
							
							Intent intent = new Intent(PutInStorage1.this, ExpiryActivity.class);
							intent.putExtra("listdata", list);
							intent.putExtra("totalCount", winTickets);
							intent.putExtra("totalAmount", winAmount);
							PutInStorage1.this.startActivityForResult(intent, 1);
							
							runOnUiThread(new Runnable() {
								public void run() {
									totalcount = 0l;
									zfzjevalue.setText(App.getPriceFormated(totalcount));
									// 兑奖成功要清空兑奖列表
									fabhlistdata1.clear();
									adapter.notifyDataSetChanged();
								}
							});
						} else {
							// 没有中奖或已经兑奖,目前在网络层已经提示了，如果网络层不提示需要打开下面代码
							
						}
					} else {
						// 兑奖失败,目前在网络层已经提示了，如果网络层不提示需要打开下面代码
						
					}
					myDialog.dismiss();
					return;
				} catch (JSONException e) {
					App.showToast(R.string.duijiang_fail);
				}
			}
		});
	}

	/*
	 * 退票
	 */
	private void tuihuo() {
		final AlertDialog myDialog = new AlertDialog.Builder(PutInStorage1.this)
				.create();
		myDialog.show();
		JSONObject jo = new JSONObject();
		try {
			jo.put("outletCode", appData.stationCode);
			JSONArray jolist = new JSONArray();
			jo.put("goodsTagList", jolist);
			for (int i = 0; i < fabhlistdata1.size(); i++) {
				JSONObject item = new JSONObject();
				item.put("goodsTag", fabhlistdata1.get(i).EWMStr);
				item.put("tickets", fabhlistdata1.get(i).getTicketNum()
						.toString());
				jolist.put(item);
			}
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Http.request(0x020410, jo, new RequestListener() {
			@Override
			public void onComplete(NetResult rsp) {
				final NetResult response = rsp;
				try {
					int errCode = response.jsonObject.getInt("errcode");
					if (errCode == 0) {// 判断网络是否正确,目前只要退票成功返回的code是0，如果在之后调试bug中服务器出现其他code为0的情况，则在此处判断条件即可
						runOnUiThread(new Runnable() {
							public void run() {
								
								long balance = appData.balance;
								try {
									JSONObject result = response.jsonObject.getJSONObject("result");
									balance = result.getLong("balance");
								} catch (JSONException e) {
									e.printStackTrace();
								}
								appData.balance = balance;
//								totalcount = 0l;
//								zfzjevalue.setText(App.getPriceFormated(totalcount));
//								zhanghuyuevalue.setText(App.getPriceFormated(balance));
//								App.showToast(R.string.tuihuo_ok);
//								// 退票成功清空退票列表
//								fabhlistdata1.clear();
//								adapter.notifyDataSetChanged();
								App.showToast(R.string.tuihuo_ok);
								finish();
							}
						});
					} else {
						// 没有中奖或已经兑奖,目前在网络层已经提示了，如果网络层不提示需要打开下面代码
					}
					myDialog.dismiss();
					return;
				} catch (JSONException e) {
					runOnUiThread(new Runnable() {
						public void run() {
							App.showToast(R.string.duijiang_fail);
						}
					});
				}
			}
		});
	}

	@Override
	public void initHandle() {
		// TODO Auto-generated method stub
		super.initHandle();
		startEWMHandler = new Handler() {
			@Override
			public void handleMessage(Message msg) {
				super.handleMessage(msg);
			}
		};
		mainHandler = new Handler() {
			@Override
			public void handleMessage(Message msg) {
				super.handleMessage(msg);

				switch (msg.what) {
				default:
					break;
				case 3: // 取消屏幕长亮
					Log.e("yyc", "yyc do set screen off");
					getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
					Log.e("yyc", "yyc do set screen off done");
					break;
				}
				adapter.notifyDataSetChanged();
			}
		};
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		initData();
		if (storagetype == 1) {// 入库
			initActivity(this, R.layout.put_in_storage);
			setMiddleText(R.string.pis_title);
		} else if (storagetype == 2) {// 兑奖
			initActivity(this, R.layout.activity_expiry);
			setMiddleText(R.string.saomiaoduijiang);
		} else if (storagetype == 3) {// 退票
			initActivity(this, R.layout.put_out_storage);
			setMiddleText(R.string.saomiaotuihuo);
		}
		initView();
		// 扫描动画
		translateAnimation = new TranslateAnimation(0.0f,
				0.0f, 0.0f, 100.0f);
		translateAnimation.setRepeatCount(Integer.MAX_VALUE);
		translateAnimation.setRepeatMode(Animation.RESTART);
		translateAnimation.setDuration(1000);
		initHandle();
		// loadList1(1);
		// loadList2(2);
		// getEWMparam("J201500002001281001001001010000101000200150312001270119.6guardz");
		// getEWMparam("J20150000200110010000127210012740");
		// getEWMparam("J2016000010000004166DKTSANFUBVYUNAORJ0066");
//		getEWMparam("J2016000010002000000042100100");
		// getEWMparam("J201500002001281001001001010000101000200150312001270120.6guardz");
		// getEWMparam("J201500002001281001001001010000101000200150312001270121.6guardz");
		adapter = new PutInStorage1Adapter(PutInStorage1.this, fabhlistdata1);
		if (storagetype == 1) {// 入库
			list1.setTag(1);// 用tag来记录list是哪个list，入库页面：第一个list的为1，第二个为2；兑奖页面就一个list为3；退票第一个list的为4，第二个为5
			list2.setTag(2);
			list1.setAdapter(adapter);
			list2.setAdapter(adapter);
		} else if (storagetype == 2) {// 兑奖
			list1.setTag(3);
			list1.setAdapter(adapter);
		} else if (storagetype == 3) {// 退票
			list1.setTag(5);
			list2.setTag(6);
			list1.setAdapter(adapter);
			list2.setAdapter(adapter);
		}
	}

	@Override
	public void onItemClick(AdapterView<?> arg0, View view, int arg2, long arg3) {
		final ViewHolder vh = ((ViewHolder)view.getTag());
		final PackInfo pi = ((ViewHolder)view.getTag()).data;
		AlertDialog.Builder builder = new Builder(this);
		String mess = this.getString(R.string.com_okdel)
				+ " " + vh.shengchanpiciText.getText() //+" "
				+ this.getString(R.string.com_ma);
		if (storagetype == 2) {
			mess = this.getString(R.string.com_okdel)
					+ " " + vh.zhangshuText.getText() //+" "
					+ this.getString(R.string.com_ma);
		}
		builder.setMessage(mess);
		builder.setTitle(R.string.com_tishi);
		builder.setPositiveButton(R.string.string_comfirm,
				new DialogInterface.OnClickListener() {
					@Override
					public void onClick(
							DialogInterface dialog,
							int which) {
						if (storagetype == 2) {//兑奖的时候总计的张数，入库和退票是金额
							PutInStorage1.this.totalcount -= 1;//fadmlistdata.get(delIndex).getTicketNum();
						} else {
							PutInStorage1.this.totalcount -= pi.getAmount();
						}
						PutInStorage1.this.zfzjevalue.setText(App.getPriceFormated(PutInStorage1.this.totalcount));
						adapter.fadmlistdata.remove(pi);
						App.showToast(R.string.del_ok);
						adapter.notifyDataSetChanged();
					}
				});

		builder.setNegativeButton(R.string.com_cancel,
				new DialogInterface.OnClickListener() {
					@Override
					public void onClick(
							DialogInterface dialog,
							int which) {
						dialog.dismiss();
					}
				});
		builder.create().show();
	}

	@Override
	public void onScanResult(final String s) {
		this.runOnUiThread(new Runnable(){
			@Override
			public void run() {
				getEWMparam(s);
			}
		});
	}

	@Override
	public void onClick(View v) {
		if (v == showFinish) {
			if (saomiaobtn.getVisibility() == View.INVISIBLE) {
				App.stopScan();
			}
			saomiaobtn.setVisibility(View.INVISIBLE);
			saomiaoimageback.setVisibility(View.GONE);
			saomiaoimage.setVisibility(View.INVISIBLE);
			saomiaoimage1.setVisibility(View.INVISIBLE);
			list1.setVisibility(View.GONE);
			showFinish.setVisibility(View.GONE);
			finishPanel.setVisibility(View.VISIBLE);
			saomiaoimage.clearAnimation();
			goback.setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {
					if(clicked){
						saomiaoimage.startAnimation(translateAnimation);
						saomiaoimageback.setVisibility(View.VISIBLE);
						saomiaoimage.setVisibility(View.VISIBLE);
						
					}
					else{
						saomiaobtn.setVisibility(View.VISIBLE);
						saomiaoimage1.setVisibility(View.VISIBLE);
						saomiaoimageback.setVisibility(View.INVISIBLE);
						saomiaoimage.setVisibility(View.INVISIBLE);
					}
					if (saomiaobtn.getVisibility() == View.INVISIBLE) {
						App.goScan(PutInStorage1.this, 1000, false);
					}
					
					list1.setVisibility(View.VISIBLE);
					finishPanel.setVisibility(View.GONE);
					showFinish.setVisibility(View.VISIBLE);
					
					backKeyS=true;
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
				}
			});
			backKeyS=false;
		} else if (v == hideFinish) {
			if (saomiaobtn.getVisibility() == View.INVISIBLE) {
				App.goScan(this, 1000, false);
			}
			list1.setVisibility(View.VISIBLE);
			finishPanel.setVisibility(View.GONE);
		}
	}
	public boolean onKeyDown(int keyCode, KeyEvent event) { 
		Log.e("yyc", "onKeyDown "+keyCode+", "+event.getMetaState());
		
		if (keyCode == KeyEvent.KEYCODE_BACK && event.getRepeatCount() == 0) { 
        	if(backKeyS){
        		super.onKeyDown(keyCode, event);
        		return true;
        	}
        	else{
        		if(clicked){
					saomiaoimage.startAnimation(translateAnimation);
					saomiaoimageback.setVisibility(View.VISIBLE);
					saomiaoimage.setVisibility(View.VISIBLE);
				}
				else{
					saomiaobtn.setVisibility(View.VISIBLE);
					saomiaoimage1.setVisibility(View.VISIBLE);
					saomiaoimageback.setVisibility(View.INVISIBLE);
					saomiaoimage.setVisibility(View.INVISIBLE);
				}
	        	if (saomiaobtn.getVisibility() == View.INVISIBLE) {
					App.goScan(this, 1000, false);
				}
				list1.setVisibility(View.VISIBLE);
				finishPanel.setVisibility(View.GONE);
				
				showFinish.setVisibility(View.VISIBLE);
				
				backKeyS=true;
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
        	
            return false; 
        	}
        } 
        return false; 
    }
}
