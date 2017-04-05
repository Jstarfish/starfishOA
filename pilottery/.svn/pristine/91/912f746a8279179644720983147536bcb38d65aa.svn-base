package com.huacai.assist.common;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;

import com.langcoo.serialport.ReceiveDataListener;
import com.langcoo.serialport.SerialPort;

public class BCReader {
	private SerialPort mySerialPort;//串口
	private int scanMode=0;//扫描模式
	private String TAG="BCRclass";
	private boolean isopen=false;
	private Handler bcrHandler=null;

	//构造传入串口
	public BCReader(SerialPort serialPort,Handler handler) {
		this.mySerialPort=serialPort;
		this.bcrHandler=handler;
	}
	//获取串口状态`
	public boolean getserialstatus()
	{
		return isopen;
	}
	//打开串口
	private boolean openSerialPort() {
		if (mySerialPort != null) {
			try {
				mySerialPort.openSerialPort(new File("/dev/ttyHS1"), 115200);
				Log.i(TAG, "Powestarton");
				powerOn();
				Log.i(TAG, "Poweron");
				isopen = true;
				return true;
			} catch (SecurityException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				Log.i(TAG, e.toString());
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				Log.i(TAG, e.toString());

			}
		} else {
			Log.i(TAG, "serialport getinstance failed!");
			isopen = false;
		}
		return false;
	}

	//打开阅读器
	public void open() {
		if (openSerialPort()) {
			Log.i(TAG, "now open bcr");
			senCommond(new byte[] { (byte) 0xFF, 0x4D,0x0D, 'E', 'N', 'S', 'C', 'A', 'N', 0x2E });
		}
	}

	//开始扫描
	public void start(){
		if (isopen) {
			senCommond(new byte[] { (byte) 0xFF, 0x54, 0x0D },
					new ReceiveDataListener() {
				@Override
				public void receive(byte[] arg0) {
					//Log.i("startreceiveDataListener", "iscallback"+ byteArryToString(arg0));
					Message msg = new Message();
					msg.what = 2;
					msg.obj =byteArryToString(arg0);
					bcrHandler.sendMessage(msg);//传出二维码数据
				}
			});
		}
	}

	//停止扫描
	public void stop() {
		if (isopen) {
			senCommond(new byte[] { (byte) 0xFF, 0x55, 0x0D });
		}

	}

	//设置扫描模式
	public void setScanMode(int mode){

		final String retString[]={null};
		if (isopen) {

			if(mode==0)
			{
				senCommond(new byte[] { (byte) 0xFF, 0x4D, 0x0D, 0x38, 0x30, 0x31,0x30, 0x33, 0x30, 0x21 }, new ReceiveDataListener() {

					@Override
					public void receive(byte[] arg0) {
						Log.i("manuscanreceiveDataListener", "iscallback"+ byteArryToString(arg0));
						scanMode=0;
					}
				}); 
			}
			else if(mode==1)
			{
				senCommond(new byte[] { (byte) 0xFF, 0x4D, 0x0D, 0x38, 0x30, 0x31,0x30, 0x33, 0x35, 0x21 }, new ReceiveDataListener() {
					@Override
					public void receive(byte[] arg0) {
						Log.i("autoscanreceiveDataListener", "iscallback"+ byteArryToString(arg0));
						scanMode=1;
						retString[0]=byteArryToString(arg0);
						Message msg = new Message();
						msg.what = 1;
						msg.obj = retString[0];
						bcrHandler.sendMessage(msg);//传出二维码数据

					}
				});
			}
		}
		//return retString[0];
	}


	public void getBarcodeinfo()
	{

	}

	//获取扫描械模式
	public int getScanMode(){
		return scanMode;
	}

	//关闭阅读器
	public void close() {
		if (isopen) {
			senCommond(new byte[] { (byte) 0xFF, 0x4D,0x0D, 'D', 'I', 'S', 'C', 'A', 'N', 0x2E });
		}
		powerOff();
	}


	//发送命令
	private byte[] senCommond(byte[] cmdByte) {
		mySerialPort.setReceiveDataListener(null);
		if (cmdByte != null) {
			byte[] re = mySerialPort.sendData(cmdByte);
			return re;
		} else {
			Log.i(TAG, "sending cmd string is null ");
		}
		return null;
	}

	//异步回调发送命令
	private void senCommond(byte[] cmdByte,
			ReceiveDataListener receiveDataListener) {
		mySerialPort.setReceiveDataListener(null);
		if (cmdByte != null) {
			mySerialPort.sendData(cmdByte, receiveDataListener);
		} else {
			Log.i(TAG, "sending cmd string is null");
		}
	}

	//字节数组转字符串
	private String byteArryToString(byte[] byteArry) {
		String msg = "";
		if((byteArry[0]&0xFF)!=0xFF)
			return msg;
		if((byteArry[5]&0xFF)==2)//返回双码
		{
			int firstbits=byteArry[7]&0xFF+byteArry[8]*256;//第一个二维码的长度
			int secondbitsindex=9+firstbits;//第二个二维码数据长度索引位置
			int secondbits=byteArry[secondbitsindex]&0xff+byteArry[secondbitsindex+1]*256;//第二个二维码数据长度
			byte[] firstbuffbyte=Arrays.copyOfRange(byteArry,9,9+firstbits);//获取第一个二维码字节数据（去掉帧头）
			String firstbarcodeString=new String(firstbuffbyte);//转换成字符串	
			msg+=firstbarcodeString;
			msg+='\n';
			byte[] secondbuffbyte=Arrays.copyOfRange(byteArry,secondbitsindex+2,secondbitsindex+2+secondbits);//获取第一个二维码字节数据（去掉帧尾）
			String secondbarcodeString=new String(secondbuffbyte);//转换成字符串	
			msg+=secondbarcodeString;
		}
		else if((byteArry[3]&0xFF)==2)//过滤掉设定模式后返回的数据
		{
			msg="";
		}
		else//返回单码
		{
			int bits=(byteArry[2]&0xFF+byteArry[1]*256);//获取二维码数据长度
			byte[] buffbyte=Arrays.copyOfRange(byteArry, 5, 5+bits);//获取二维码字节数据（去掉帧头帧尾）
			msg=new String(buffbyte);//转换成字符串			

		}
		/*msg+="\n";
		for (byte a : byteArry)

		{
			msg += String.format("%X ", a);
		}*/
		return msg;
	}

	//阅读器加电
	private void powerOn() {
		postShellComm(
				"echo on > /sys/devices/platform/scan_se955/power_status", null);
	}

	//阅读器减电
	private void powerOff() {
		postShellComm(
				"echo off > /sys/devices/platform/scan_se955/power_status",
				null);
	}


	//调用linux系统命令
	private List<String> postShellComm(String strCommand, Handler handler) {
		// String strRet = null;
		List<String> listShellRet = new ArrayList<String>();

		try {
			String[] strComm = new String[3];
			strComm[0] = "sh";
			strComm[1] = "-c";
			strComm[2] = strCommand;

			Process p = null;

			p = Runtime.getRuntime().exec(strComm);
			BufferedReader in = new BufferedReader(new InputStreamReader(
					p.getInputStream()), 2048);// AZ 2048
			BufferedReader inError = new BufferedReader(new InputStreamReader(
					p.getErrorStream()), 2048);// AZ 2048

			String line = null;

			Message msg = null;

			while ((line = in.readLine()) != null) {
				if (line != null) {

					if (handler != null) {
						msg = new Message();

						msg.what = 1;
						Bundle b = new Bundle();
						b.putString("Result", line);
						msg.setData(b);
						handler.sendMessage(msg);
					}

					listShellRet.add(line);
				}
			}
			while ((line = inError.readLine()) != null) {
				if (line != null) {
					if (handler != null) {
						msg = new Message();
						msg.what = 1;
						Bundle b = new Bundle();
						b.putString("Result", line);
						msg.setData(b);
						handler.sendMessage(msg);
					}

					listShellRet.add(line);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return listShellRet;
	}
}
