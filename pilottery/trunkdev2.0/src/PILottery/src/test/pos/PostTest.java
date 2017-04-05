package test.pos;

import java.io.UnsupportedEncodingException;
import java.util.Arrays;

import org.junit.Test;

import cls.pilottery.common.utils.HttpClientUtils;
import cls.pilottery.common.utils.MD5Util;
import cls.pilottery.common.utils.TEAUtil;
import cls.pilottery.common.utils.ZipUtil;

public class PostTest {
	
	@Test
	public void testPost() throws UnsupportedEncodingException{
		String url = "http://localhost:8888/PILottery/pos.do";
		
		String json = "{\"method\":\"22222\",\"msn\":1,\"param\":\"test\",\"token\":\"256F7E779A787C7798FE7\",\"when\":1442645907}";
		
		String md5 = MD5Util.MD5Encode(json);
		
		byte[] paramBytes = (md5+json).getBytes(); 
		
		paramBytes = ZipUtil.deflater(paramBytes);
		
		paramBytes = TEAUtil.encryptByTea(paramBytes);
		
		byte[] result = HttpClientUtils.post(url, paramBytes);
		
		System.out.println(Arrays.toString(result));
		
		/*
		String json = "{\"method\":\"22222\",\"msn\":1,\"param\":\"test\",\"token\":\"256F7E779A787C7798FE7\",\"when\":1442645907}";
		String md5 = MD5Util.MD5Encode(json); 
		byte[] paramByte = (md5+json).getBytes("utf-8"); 
		System.out.println("原始json串："+md5+json);
		System.out.println("原始字节数组："+Arrays.toString(paramByte));
		
		paramByte = ZipUtil.deflater(paramByte);
		System.out.println("压缩后字节数组："+Arrays.toString(paramByte));
		
		paramByte = TEAUtil.encryptByTea(paramByte);
		System.out.println("加密后字节数组："+Arrays.toString(paramByte));
		
		paramByte = TEAUtil.decryptByTea(paramByte);
		System.out.println("解密后字节数组："+Arrays.toString(paramByte));
		
		paramByte = ZipUtil.infater(paramByte);
		System.out.println("解压缩后字节数组："+Arrays.toString(paramByte));
		*/
		
	}

}
