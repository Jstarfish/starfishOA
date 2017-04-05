package com.langcoo.barcodescanner;

import java.io.File;
import java.io.IOException;

import android.util.Log;

import com.langcoo.serialport.ReceiveDataListener;
import com.langcoo.serialport.SerialPort;

/**
 * 扫描.<br>
 * <br>
 * CreateDate: 2013-10-24<br>
 * Copyright: Copyright(c) 2013-10-24<br>
 * <br>
 * 
 * @since v1.0.0
 * @Description 2013-10-24::::创建此类</br>
 */
public class Barcord {
	private ModeType type = ModeType.ST309;
	private boolean isZD = false;
	private SerialPort mSerialPort;
	private int baudrate = 9600;
	private static Barcord barcord;

	public Barcord() {

	}

	public static Barcord getInstance() {
		if (barcord == null) {
			barcord = new Barcord();
		}

		return barcord;
	}

	public int getBaudrate() {
		return baudrate;
	}

	public void setBaudrate(int baudrate) {
		this.baudrate = baudrate;
	}

	/**
	 * 打开扫描设备.<br>
	 * 开启电源和串口<br>
	 * 
	 * @Description 2013-10-24::::创建此方法</br>
	 */
	public void open() {
		// 打开电源
		powerOn();
		// 打开串口
		// mSerialPort = SerialPort.getInstance();
		mSerialPort = new SerialPort();
		try {
			if (type == ModeType.LC727) {
				baudrate = 115200;
				System.out.println("baudrate is " + baudrate);
				mSerialPort.openSerialPort(new File("/dev/ttysWK1"), baudrate);// 115200,9600
			} else if (type == ModeType.LC707NEW) {
				System.out.println("baudrate is " + baudrate);
				mSerialPort.openSerialPort(new File("/dev/ttyHSL0"), baudrate);// 115200,9600
			} else if (type == ModeType.LC707NEW1) {
				System.out.println("baudrate is " + baudrate + ",/dev/ttysWK1");
				mSerialPort.openSerialPort(new File("/dev/ttysWK1"), baudrate);// 115200,9600
			} else {
				mSerialPort.openSerialPort(new File("/dev/ttyHS1"), baudrate);// 115200,9600
			}
			// 暂停
			try {
				Thread.sleep(100);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			if (isZD) {
				//
				// mSerialPort.sendData(new byte[] { (byte) 0xFF, 0x4D, 0x0D,
				// '9',
				// '9', '9', '0', '0', '1', '0', 0x3B, '9', '0', '2', '0',
				// '0', '2', '1', 0x3B, '9', '2', '4', '0', '0', '1', '1',
				// 0x3B, '9', '3', '0', '0', '0', '1', '1', 0x3B, '8', '6',
				// '1', '0', '0', '2', '3', 0x3B, '8', '0', '8', '0', '0',
				// '2', 0x21 });
				// 另一个版本参数
				mSerialPort.sendData(new byte[] { (byte) 0xFF, 0x4D, 0x0D, '9',
						'9', '9', '0', '0', '1', '0', 0x3b, '9', '0', '2', '0',
						'0', '2', '1', 0x3b, '9', '2', '4', '0', '0', '1', '1',
						0x3b, '9', '3', '0', '0', '0', '1', '1', 0x3b, '8',
						'6', '1', '0', '0', '2', '0', 0x3b, '8', '0', '8', '0',
						'0', '2', 0x21 });
				try {
					Thread.sleep(100);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
				mSerialPort.sendData(new byte[] { (byte) 0xFF, 0x4D, 0x0D, 'E',
						'N', 'S', 'C', 'A', 'N', 0x2E });
			}
		} catch (SecurityException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public byte[] sendCommand(byte[] cmd) {
		byte[] re = null;
		if (mSerialPort != null) {
			re = mSerialPort.sendData(cmd);
		}
		return re;
	}

	public void sendCommand(byte[] cmd, ReceiveDataListener receiveDataListener) {
		if (mSerialPort != null) {
			mSerialPort.sendData(cmd, receiveDataListener);
		}
	}

	/**
	 * 扫描.<br>
	 * <br>
	 * 
	 * @param receiveDataListener
	 * @Description 2013-10-24::::创建此方法</br>
	 */
	public void scan(ReceiveDataListener receiveDataListener) {
		if (mSerialPort != null) {
			if (type == ModeType.LC727) {
				try {
					// CommunicateShell
					// .postShellComm("echo on > /sys/class/se955_scaner/start_scan");
					// Thread.sleep(800);
					CommunicateShell
							.postShellComm("echo off > /sys/class/se955_scaner/scan_start");
				} catch (Exception e1) {
					e1.printStackTrace();
				}
			} else if (type == ModeType.LC707NEW1) {
				try {
					CommunicateShell
							.postShellComm("echo on >/sys/devices/soc.0/scan_se955.68/start_scan");
					Thread.sleep(800);
				} catch (Exception e1) {
					e1.printStackTrace();
				}
			}
			mSerialPort.setReceiveDataListener(receiveDataListener);

			// 拼写开始扫描指令
			String[] effects2 = new String[3];
			effects2[0] = "sh";
			effects2[1] = "-c";

			if (type == ModeType.LC727) {
				// effects2[2] =
				// "echo off > /sys/class/se955_scaner/start_scan";
				effects2[2] = "echo on > /sys/class/se955_scaner/scan_start";
			} else if (type == ModeType.LC707NEW || type == ModeType.LC707NEW1) {
				System.out.println("scan On");
				effects2[2] = "echo off >/sys/devices/soc.0/scan_se955.68/start_scan";
			} else {
				effects2[2] = "echo on > /sys/devices/platform/scan_se955/start_scan";
			}

			try {
				// 发送指令
				Runtime.getRuntime().exec(effects2);
			} catch (IOException e) {
				Log.e("SerialPortService", "onCreate Error->" + e);
			}
		}
	}

	public void scan(byte[] data, ReceiveDataListener receiveDataListener) {
		if (mSerialPort != null) {
			if (type == ModeType.LC727) {
				try {
					// CommunicateShell
					// .postShellComm("echo on > /sys/class/se955_scaner/start_scan");
					// Thread.sleep(800);
					CommunicateShell
							.postShellComm("echo off > /sys/class/se955_scaner/scan_start");
				} catch (Exception e1) {
					e1.printStackTrace();
				}
			} else if (type == ModeType.LC707NEW1) {
				try {
					CommunicateShell
							.postShellComm("echo on >/sys/devices/soc.0/scan_se955.68/start_scan");
					Thread.sleep(800);
				} catch (Exception e1) {
					e1.printStackTrace();
				}
			}
			mSerialPort.setReceiveDataListener(receiveDataListener);

			// 拼写开始扫描指令
			String[] effects2 = new String[3];
			effects2[0] = "sh";
			effects2[1] = "-c";

			if (type == ModeType.LC727) {
				// effects2[2] =
				// "echo off > /sys/class/se955_scaner/start_scan";
				effects2[2] = "echo on > /sys/class/se955_scaner/scan_start";
			} else if (type == ModeType.LC707NEW || type == ModeType.LC707NEW1) {
				System.out.println("scan On");
				effects2[2] = "echo off >/sys/devices/soc.0/scan_se955.68/start_scan";
			} else {
				effects2[2] = "echo on > /sys/devices/platform/scan_se955/start_scan";
			}

			try {
				// 发送指令
				Runtime.getRuntime().exec(effects2);
			} catch (IOException e) {
				Log.e("SerialPortService", "onCreate Error->" + e);
			}
			mSerialPort.sendData(data, receiveDataListener);
		}
	}

	/**
	 * 停止扫描.<br>
	 * <br>
	 * 
	 * @Description 2013-10-24::::创建此方法</br>
	 */
	public boolean stop() {
		boolean re = false;
		// 拼写停止扫描指令
		String[] effects3 = new String[3];
		effects3[0] = "sh";
		effects3[1] = "-c";

		if (type == ModeType.LC727) {
			// effects3[2] = "echo on > /sys/class/se955_scaner/start_scan";
			effects3[2] = "echo off > /sys/class/se955_scaner/scan_start";
		} else if (type == ModeType.LC707NEW || type == ModeType.LC707NEW1) {
			System.out.println("scan stop");
			effects3[2] = "echo on >/sys/devices/soc.0/scan_se955.68/start_scan";
		} else {
			effects3[2] = "echo off >/sys/devices/platform/scan_se955/start_scan";
		}
		try {
			// 发送停止扫描指令
			Runtime.getRuntime().exec(effects3);
			re = true;
		} catch (IOException e) {
			Log.e("SerialPortService", "onDestroy Error->" + e);
		}
		return re;
	}

	/**
	 * 关闭扫描设备.<br>
	 * 关闭串口和电源<br>
	 * 
	 * @Description 2013-10-24::::创建此方法</br>
	 */
	public void close() {
		if (mSerialPort != null) {
			mSerialPort.closeSerialPort();
		}
		powerOff();
	}

	private void powerOn() {

		// 拼写扫描电源打开指令
		String[] effects = new String[3];
		effects[0] = "sh";
		effects[1] = "-c";
		if (type == ModeType.LC727) {
			// effects[2] = "echo on > /sys/class/se955_scaner/power_status";
			effects[2] = "echo on > /sys/class/se955_scaner/scan_en";
		} else if (type == ModeType.LC707NEW || type == ModeType.LC707NEW1) {
			System.out.println("powerOn");
			effects[2] = "echo on >/sys/devices/soc.0/scan_se955.68/power_status";
		} else {
			effects[2] = "echo on > /sys/devices/platform/scan_se955/power_status";
		}
		try {
			// 打开电源
			Runtime.getRuntime().exec(effects);
		} catch (IOException e) {
			Log.e("SerialPortService", "onCreate Error->" + e);
		}
	}

	private void powerOff() {
		String[] effectsBack = new String[3];
		effectsBack[0] = "sh";
		effectsBack[1] = "-c";
		if (type == ModeType.LC727) {
			// effectsBack[2] =
			// "echo off > /sys/class/se955_scaner/power_status";
			effectsBack[2] = "echo off > /sys/class/se955_scaner/scan_en";
		} else if (type == ModeType.LC707NEW || type == ModeType.LC707NEW1) {
			System.out.println("powerOff");
			effectsBack[2] = "echo off >/sys/devices/soc.0/scan_se955.68/power_status";
		} else {
			effectsBack[2] = "echo off > /sys/devices/platform/scan_se955/power_status";
		}
		try {
			Runtime.getRuntime().exec(effectsBack);
		} catch (IOException e) {
			Log.e("SerialPortService", "onDestroy Error->" + e);
		}
	}
}
