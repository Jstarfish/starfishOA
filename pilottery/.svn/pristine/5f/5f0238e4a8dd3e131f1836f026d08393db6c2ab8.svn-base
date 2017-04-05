package com.huacai.assist.common;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import android.util.Log;

public class Crypto {
	public static String getMd5Hash(String str) {
		try {
			byte[] message = str.getBytes();
			MessageDigest md5 = MessageDigest.getInstance("MD5");
			byte[] output = md5.digest(message);
			return bin2hex(output);
		} catch (NoSuchAlgorithmException e) {
			Log.d("yyc", "MD5 error: NoSuchAlgorithmException");
		}
		return "";
	}
	public static String bin2hex(byte[] bin) {
		StringBuilder sb = new StringBuilder();
		try{
			for (int i=0; i<bin.length; i++) {
				sb.append(Integer.toHexString((bin[i] & 0xff) | 0x100).substring(1));
			}
			return sb.toString();			
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}
	public static byte[] hex2bin(String hex)  
    {  
        int m=0,n=0;  
        int l=hex.length()/2;
        byte[] ret = new byte[l];  
        for (int i = 0; i < l; i++)
        {  
            m=i*2+1;  
            n=m+1; 
            String s = "" + hex.substring(i*2, m) + hex.substring(m,n);
            ret[i] = (byte) Integer.parseInt(s, 16);  
        }  
        return ret;  
    }
}

