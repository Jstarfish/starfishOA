package com.huacai.assist.common;

import java.io.UnsupportedEncodingException;
import java.util.Arrays;

public class TEAUtil {
	private final static int[] KEY = new int[] {// 加密解密所用的KEY
	0x789f5645, 0xf68bd5a4, 0x81963ffa, 0x458fac58 };
	
	private static final String CHAR_SET = "utf-8";
	
	/*
	 * 加密
	 */
    public static byte[] encryptByTea(byte[] temp){
        int n = (8 - temp.length % 8)%8;//若temp的位数不足8的倍数,需要填充的位数
        byte[] encryptStr = new byte[temp.length + n];
        encryptStr[0] = (byte)n;
        System.arraycopy(temp, 0, encryptStr, n, temp.length);
        byte[] result = new byte[encryptStr.length];
        for(int offset = 0; offset < result.length; offset += 8){
            byte[] tempEncrpt = encrypt(encryptStr, offset, KEY, 64);
            System.arraycopy(tempEncrpt, 0, result, offset, 8);
        }
        return result;
    }
    
    public static byte[] encryptByTea(String info) throws UnsupportedEncodingException{
        byte[] temp = info.getBytes(CHAR_SET);
        int n =  (8 - temp.length % 8)%8;//若temp的位数不足8的倍数,需要填充的位数
        byte[] encryptStr = new byte[temp.length + n];
        encryptStr[0] = (byte)n;
        System.arraycopy(temp, 0, encryptStr, n, temp.length);
        byte[] result = new byte[encryptStr.length];
        for(int offset = 0; offset < result.length; offset += 8){
            byte[] tempEncrpt = encrypt(encryptStr, offset, KEY, 64);
            System.arraycopy(tempEncrpt, 0, result, offset, 8);
        }
        return result;
     }
    
    /*
     * 解密
     */
    public static byte[] decryptByTea(byte[] secretInfo) throws UnsupportedEncodingException{
        byte[] decryptStr = null;
        byte[] tempDecrypt = new byte[secretInfo.length];
        for(int offset = 0; offset < secretInfo.length; offset += 8){
            decryptStr = decrypt(secretInfo, offset, KEY, 64);
            System.arraycopy(decryptStr, 0, tempDecrypt, offset, 8);
        }
        
        int n = tempDecrypt[0]%8;
        byte[] result = new byte[tempDecrypt.length-n];
        System.arraycopy(tempDecrypt, n, result, 0, tempDecrypt.length-n);
        //String str = new String(tempDecrypt, n, decryptStr.length - n);
        //return str.getBytes(CHAR_SET);
        return result;
    }
    
    /*
     public static String decryptByTea(byte[] secretInfo){
        byte[] decryptStr = null;
        byte[] tempDecrypt = new byte[secretInfo.length];
        for(int offset = 0; offset < secretInfo.length; offset += 8){
            decryptStr = decrypt(secretInfo, offset, KEY, 64);
            System.arraycopy(decryptStr, 0, tempDecrypt, offset, 8);
        }
        
        int n = tempDecrypt[0];
        return new String(tempDecrypt, n, decryptStr.length - n);
    }*/

	private static byte[] encrypt(byte[] content, int offset, int[] key, int times) {// times为加密轮数
		int[] tempInt = byteToInt(content, offset);
		int y = tempInt[0], z = tempInt[1], sum = 0, i;
		int delta = 0x9e3779b9; // 这是算法标准给的值
		int a = key[0], b = key[1], c = key[2], d = key[3];

		for (i = 0; i < times; i++) {

			sum += delta;
			y += ((z << 4) + a) ^ (z + sum) ^ ((z >> 5) + b);
			z += ((y << 4) + c) ^ (y + sum) ^ ((y >> 5) + d);
		}
		tempInt[0] = y;
		tempInt[1] = z;
		return intToByte(tempInt, 0);
	}
	private static byte[] decrypt(byte[] encryptContent, int offset, int[] key, int times) {
		int[] tempInt = byteToInt(encryptContent, offset);
		int y = tempInt[0], z = tempInt[1], sum = 0, i;
		int delta = 0x9e3779b9; // 这是算法标准给的值
		int a = key[0], b = key[1], c = key[2], d = key[3];
		if (times == 32)
			sum = 0xC6EF3720; /* delta << 5 */
		else if (times == 16)
			sum = 0xE3779B90; /* delta << 4 */
		else
			sum = delta * times;

		for (i = 0; i < times; i++) {
			z -= ((y << 4) + c) ^ (y + sum) ^ ((y >> 5) + d);
			y -= ((z << 4) + a) ^ (z + sum) ^ ((z >> 5) + b);
			sum -= delta;
		}
		tempInt[0] = y;
		tempInt[1] = z;

		return intToByte(tempInt, 0);
	}
	
	// byte[]型数据转成int[]型数据
	private static int[] byteToInt(byte[] content, int offset) {

		int[] result = new int[content.length >> 2];// 除以2的n次方 == 右移n位 即 content.length / 4 ==
		// content.length >> 2
		for (int i = 0, j = offset; j < content.length; i++, j += 4) {
			result[i] = transform(content[j + 3]) | transform(content[j + 2]) << 8 | transform(content[j + 1]) << 16 | (int) content[j] << 24;
		}
		return result;

	}
	// int[]型数据转成byte[]型数据
	private static byte[] intToByte(int[] content, int offset) {
		byte[] result = new byte[content.length << 2];// 乘以2的n次方 == 左移n位 即 content.length * 4 ==
		// content.length << 2
		for (int i = 0, j = offset; j < result.length; i++, j += 4) {
			result[j + 3] = (byte) (content[i] & 0xff);
			result[j + 2] = (byte) ((content[i] >> 8) & 0xff);
			result[j + 1] = (byte) ((content[i] >> 16) & 0xff);
			result[j] = (byte) ((content[i] >> 24) & 0xff);
		}
		return result;
	}
	// 若某字节为负数则需将其转成无符号正数
	private static int transform(byte temp) {
		int tempInt = (int) temp;
		if (tempInt < 0) {
			tempInt += 256;
		}
		return tempInt;
	}

	public static void main(String[] args) throws UnsupportedEncodingException{
//        String info = "http://www.huacai.com/testdf124213?aaa=中国&bbb=sdfkjsadhf";
        
        /*System.out.println(Arrays.toString(info.getBytes()));
        byte[] b = TEAUtil.encryptByTea(info.getBytes());
        System.out.println("加密后：");
        System.out.println(Arrays.toString(b));
        System.out.println("解密后");
        System.out.println(Arrays.toString(TEAUtil.decryptByTea(b)));*/
        
        String str = "111--------------222";
        System.out.println(Arrays.toString(str.getBytes()));
        byte[] b = TEAUtil.encryptByTea(str.getBytes());
        System.out.println("加密后：");
        System.out.println(Arrays.toString(b));
        System.out.println("解密后");
        System.out.println(Arrays.toString(TEAUtil.decryptByTea(b)));
    }
}