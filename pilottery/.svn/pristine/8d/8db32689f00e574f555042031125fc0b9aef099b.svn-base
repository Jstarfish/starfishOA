package com.huacai.assist.common;

import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.security.Key;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESedeKeySpec;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.style.ForegroundColorSpan;

import com.huacai.assist.R;

public class CommonTools {
	/**
	 * 修改字符串部分字体的颜色
	 * 
	 * @param color
	 *            修改后的颜色
	 * @param start
	 *            起始位置
	 * @param end
	 *            终止位置
	 * @param text
	 *            字符串内容
	 * @return
	 */
	public static SpannableStringBuilder getColorText(int color, int start,
			int end, String text) {

		SpannableStringBuilder builder = new SpannableStringBuilder(text);
		ForegroundColorSpan redSpan = new ForegroundColorSpan(color);
		builder.setSpan(redSpan, start, end, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);

		return builder;
	}

	/**
	 * 根据手机分辨率从dp转成px
	 * 
	 * @param context
	 * @param dpValue
	 * @return
	 */
	public static int dip2px(Context context, float dpValue) {
		final float scale = context.getResources().getDisplayMetrics().density;
		return (int) (dpValue * scale + 0.5f);
	}
	
	/**
	 * 根据手机的分辨率从 px(像素) 的单位 转成为 dp
	 */
	public static int px2dip(Context context, float pxValue) {
		final float scale = context.getResources().getDisplayMetrics().density;
		return (int) (pxValue / scale + 0.5f) - 15;
	}

	public static int px2sp(Context context, float pxValue) {
		final float fontScale = context.getResources().getDisplayMetrics().scaledDensity;
		return (int) (pxValue / fontScale + 0.5f);
	}

	/**
	 * 将sp值转换为px值，保证文字大小不变
	 * 
	 * @param spValue
	 * @param fontScale
	 *            （DisplayMetrics类中属性scaledDensity）
	 * @return
	 */
	public static int sp2px(Context context, float spValue) {
		final float fontScale = context.getResources().getDisplayMetrics().scaledDensity;
		return (int) (spValue * fontScale + 0.5f);
	}

	/**
	 * 获取手机状态栏高度
	 * 
	 * @param context
	 * @return
	 */
	public static int getStatusBarHeight(Context context) {
		Class<?> c = null;
		Object obj = null;
		java.lang.reflect.Field field = null;
		int x = 0;
		int statusBarHeight = 0;
		try {
			c = Class.forName("com.android.internal.R$dimen");
			obj = c.newInstance();
			field = c.getField("status_bar_height");
			x = Integer.parseInt(field.get(obj).toString());
			statusBarHeight = context.getResources().getDimensionPixelSize(x);
			return statusBarHeight;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return statusBarHeight;
	}

	public static boolean isEmpty(String str) {
		return str == null || str.length() == 0 || str.equals("")
				|| str.equals("null");
	}

	@SuppressLint("TrulyRandom")
	public static String Des3Encode(byte[] datasource, String password) {
		Key deskey = null;
		DESedeKeySpec spec = null;
		try {
			spec = new DESedeKeySpec(password.getBytes());
		} catch (InvalidKeyException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		SecretKeyFactory keyfactory = null;

		try {
			keyfactory = SecretKeyFactory.getInstance("desede");
		} catch (NoSuchAlgorithmException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		try {
			deskey = keyfactory.generateSecret(spec);
		} catch (InvalidKeySpecException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		Cipher cipher = null;

		try {
			cipher = Cipher.getInstance("desede/ECB/PKCS5Padding");
		} catch (NoSuchAlgorithmException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (NoSuchPaddingException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		try {
			cipher.init(Cipher.ENCRYPT_MODE, deskey);
		} catch (InvalidKeyException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		byte[] encryptData = null;

		try {
			encryptData = cipher.doFinal(datasource);
		} catch (IllegalBlockSizeException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (BadPaddingException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		String tr = null;

		try {
			tr = new String(encryptData, "ISO-8859-1");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return tr;
	}

	public static String Des3Decode(byte[] datasource, String password) {
		Key deskey = null;
		DESedeKeySpec spec = null;

		try {
			spec = new DESedeKeySpec(password.getBytes());
		} catch (InvalidKeyException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		SecretKeyFactory keyfactory = null;

		try {
			keyfactory = SecretKeyFactory.getInstance("desede");
		} catch (NoSuchAlgorithmException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		try {
			deskey = keyfactory.generateSecret(spec);
		} catch (InvalidKeySpecException e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}

		Cipher cipher = null;

		try {
			cipher = Cipher.getInstance("desede/ECB/PKCS5Padding");
		} catch (NoSuchAlgorithmException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (NoSuchPaddingException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		try {
			cipher.init(Cipher.DECRYPT_MODE, deskey);
		} catch (InvalidKeyException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		byte[] decryptData = null;

		try {
			decryptData = cipher.doFinal(datasource);
		} catch (IllegalBlockSizeException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (BadPaddingException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		String tr = null;

		try {
			tr = new String(decryptData, "ISO-8859-1");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return tr;
	}

	public static String MD5Encode(String string) {
		byte[] hash;
		try {
			hash = MessageDigest.getInstance("MD5").digest(
					string.getBytes("UTF-8"));
		} catch (NoSuchAlgorithmException e) {
			throw new RuntimeException("Huh, MD5 should be supported?", e);
		} catch (UnsupportedEncodingException e) {
			throw new RuntimeException("Huh, UTF-8 should be supported?", e);
		}

		StringBuilder hex = new StringBuilder(hash.length * 2);
		for (byte b : hash) {
			if ((b & 0xFF) < 0x10)
				hex.append("0");
			hex.append(Integer.toHexString(b & 0xFF));
		}
		return hex.toString();
	}

	public static boolean isChinese(char c) {
		boolean ret = false;

		Character.UnicodeBlock ub = Character.UnicodeBlock.of(c);

		if (ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS
				|| ub == Character.UnicodeBlock.CJK_COMPATIBILITY_IDEOGRAPHS
				|| ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS_EXTENSION_A
				|| ub == Character.UnicodeBlock.GENERAL_PUNCTUATION
				|| ub == Character.UnicodeBlock.CJK_SYMBOLS_AND_PUNCTUATION
				|| ub == Character.UnicodeBlock.HALFWIDTH_AND_FULLWIDTH_FORMS)
			ret = true;

		return ret;
	}

	public static boolean isNumeric(String str) {
		if(str==null || str.equals(""))
			return false;
		Pattern pattern = Pattern.compile("[0-9]*");
		Matcher isNum = pattern.matcher(str);
		if (!isNum.matches()) {
			return false;
		}
		return true;
	}
	
	
	/**
	* 保存参数
	*/
	public static void savePerferences(Context context, String name, String value) {
//		验证参数
		if(name == null)
			App.showToast(R.string.key_cant_empty);
		//获得SharedPreferences对象
		SharedPreferences preferences = context.getSharedPreferences("main", Context.MODE_PRIVATE);
		Editor editor = preferences.edit();
//		设置参数
		editor.putString(name, value);
		editor.commit();
	}
	
	/**
	* 获取参数
	* @return
	* name 参数名称
	* def 如果没有此参数，返回的默认值
	*/
	public static String getPerferences(Context context, String name, String def) {
		SharedPreferences preferences = context.getSharedPreferences("main", Context.MODE_PRIVATE);
		return preferences.getString(name, def);
	}
	
}
