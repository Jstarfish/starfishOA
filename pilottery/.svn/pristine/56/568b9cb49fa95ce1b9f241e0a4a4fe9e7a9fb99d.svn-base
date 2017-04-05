package com.huacai.assist.setting;

import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.util.Enumeration;

import org.apache.http.conn.util.InetAddressUtils;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Bundle;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.widget.TextView;

import com.huacai.assist.R;
import com.huacai.assist.common.BaseActivity;

/**
 * 设备信息
 */
public class DeviceInfoActivity extends BaseActivity{
	/**  设备当前IP */
	private TextView ip;
	/**  此软件版本 */
	private TextView ver;
	/**  手机IMEI */
	private TextView imei;
	/**  设备的WLAN MAC */
	private TextView wlan;
	/**  用于获取设备信息 */
	private TelephonyManager tm;
	@Override
	public void initView() {
		// TODO Auto-generated method stub
		super.initView();
		setMiddleText(R.string.title_activity_device);//设置标题
		//组件赋值
		ip=(TextView)findViewById(R.id.ip);
		ver=(TextView)findViewById(R.id.ver);
		imei=(TextView)findViewById(R.id.imei);
		wlan=(TextView)findViewById(R.id.wlan);
		ver.setText("v"+getVersionName());
		tm = (TelephonyManager) this.getSystemService(TELEPHONY_SERVICE); 
		loadDate();//构建TelephonyManager对象
	}
	private String getVersionName()
	{  
	        // 获取packagemanager的实例  
	        PackageManager packageManager = getPackageManager();  
	        // getPackageName()是你当前类的包名，0代表是获取版本信息  
	        PackageInfo packInfo;
			try {
				packInfo = packageManager.getPackageInfo(getPackageName(),0);
		        String version = packInfo.versionName;  
		        return version; 
			} catch (NameNotFoundException e) {
				e.printStackTrace();
			}  
			return null;
	}
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		initActivity(this,R.layout.activity_device_info);//初始化Activity
		initData();//初始化数据
		initView();//初始化视图
		initHandle();//初始化Handle
	    
	}
	public void loadDate(){//获取基本信息并表达
		
		ip.setText(getLocalHostIp());//获取本地ip
		imei.setText(tm.getDeviceId());//获取IMEI
		wlan.setText(getLocalMac());//获取MAC
	}
	public String getLocalHostIp(){// 获取本地ip
        String ipaddress = "";//存放ip地址
        try
        {
            Enumeration<NetworkInterface> en = NetworkInterface
                    .getNetworkInterfaces();//构建Enumeration
            // 遍历所用的网络接口
            while (en.hasMoreElements())//如果有更多元素
            {
                NetworkInterface nif = en.nextElement();// 得到每一个网络接口绑定的所有ip
                Enumeration<InetAddress> inet = nif.getInetAddresses();
                // 遍历每一个接口绑定的所有ip
                while (inet.hasMoreElements())
                {
                    InetAddress ip = inet.nextElement();
                    if (!ip.isLoopbackAddress()
                            && InetAddressUtils.isIPv4Address(ip
                                    .getHostAddress()))
                    {
                        return ipaddress = ip.getHostAddress();
                    }
                }

            }
        }
        catch (SocketException e)
        {
            Log.e("feige", "获取本地ip地址失败");
            e.printStackTrace();
        }
        return ipaddress;

    }
	public String getLocalMac(){//获取mMAC
        String mac = "";
        // 获取wifi管理器
        WifiManager wifiMng = (WifiManager) getSystemService(Context.WIFI_SERVICE);
        WifiInfo wifiInfor = wifiMng.getConnectionInfo();
        mac =wifiInfor.getMacAddress();
        return mac;
    }
}
