package com.langcoo.barcodescanner;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;

/**
 * Shell����.<br>
 * <br>
 * CreateDate: 2013-9-5<br>
 * Copyright: Copyright(c) 2013-9-5<br>
 * <br>
 * 
 * @since v1.0.0
 * @Description 2013-9-5::::��������</br>
 */
public final class CommunicateShell {
	private final static String TAG = "CommunicateShell";

	/**
	 * Shell�ύ.<br>
	 * <br>
	 * 
	 * @param strCommand
	 *            Shell����
	 * @return �ύ���?
	 * @Description 2013-9-5::::�����˷���</br>
	 */
	public final static List<String> postShellComm(String strCommand)
			throws IOException {
		return postShellComm(strCommand, null);
	}

	/**
	 * Shell �ύ.<br>
	 * <br>
	 * 
	 * @param strCommand
	 *            Shell����
	 * @param handler
	 *            ��Ϣ������
	 * @return �ύ���?
	 * @Description 2013-9-5::::�����˷���</br>
	 */
	public final static List<String> postShellComm(String strCommand,
			Handler handler) throws IOException {
		String strRet = null;
		List<String> listShellRet = new ArrayList<String>();

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
		StringBuilder s = new StringBuilder();

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
		return listShellRet;
	}

}
