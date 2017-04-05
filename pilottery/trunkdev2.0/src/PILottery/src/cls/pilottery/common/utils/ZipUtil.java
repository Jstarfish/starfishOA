package cls.pilottery.common.utils;

import java.io.ByteArrayOutputStream;
import java.util.Arrays;
import java.util.zip.DataFormatException;
import java.util.zip.Deflater;
import java.util.zip.Inflater;

public class ZipUtil {
	/**
	 * 压缩
	 * @param input
	 * @return
	 */
	public static byte[] deflater(byte[] input) {
		Deflater compresser = new Deflater();
		// compresser.setLevel(Deflater.DEFAULT_COMPRESSION);
		compresser.setInput(input);
		compresser.finish();
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		byte[] buffer = new byte[1024];
		int writen = compresser.deflate(buffer);
		while (writen > 0) {
			baos.write(buffer, 0, writen);
			writen = compresser.deflate(buffer);
		}
		return baos.toByteArray();
	}

	/**
	 * 解压缩
	 * @param input
	 * @return
	 */
	public static byte[] infater(byte[] input) {
		Inflater decompresser = new Inflater();
		decompresser.setInput(input);
		int writen = 0;
		try {
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			byte[] buffer = new byte[1024];
			while (!decompresser.finished()) {
				writen = decompresser.inflate(buffer);
				if (writen > 0) {
					baos.write(buffer, 0, writen);
				}
			}
			decompresser.end();
			return baos.toByteArray();
		} catch (DataFormatException e) {
			e.printStackTrace();
		}
		return null;
	}

	public static void main(String[] args) {
		String json = "原始json串：d503e29ff00fddee3c9d27c4e8432694{\"method\":\"22222\",\"msn\":1,\"param\":\"test\",\"token\":\"256F7E779A787C7798FE7\",\"when\":1442645907}";
		
		System.out.println(Arrays.toString(json.getBytes()));
		
		byte[] arr1 = deflater(json.getBytes());
		
		System.out.println(Arrays.toString(arr1));
		
		byte[] arr2 = infater(arr1);
		
		System.out.println(Arrays.toString(arr2));
		
	}
	
}
