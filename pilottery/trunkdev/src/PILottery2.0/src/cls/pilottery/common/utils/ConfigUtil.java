package cls.pilottery.common.utils;

import java.io.IOException;
import java.io.InputStream;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Map.Entry;
import java.util.Properties;

public class ConfigUtil {

	private static Properties config = null;
	private static Hashtable<String, String> issueconfig = null;

	public static void init(String fileName) {
		try {
			InputStream in = ConfigUtil.class.getClassLoader().getResourceAsStream(fileName);
			config = new Properties();
			config.load(in);
			in.close();
		} catch (IOException e) {
			e.printStackTrace();
			System.err.println("PropertiesUtil.init(String fileName) ->" + e.toString());
		}
	}

	// 根据key读取value
	public static String readValue(String key) {
		try {
			String value = config.getProperty(key);
			return value;
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("PropertiesUtil.readValue(String key) ->" + e.toString());
			return "";
		}
	}

	// 读取properties的全部信息

	public static void readAllProperties() {
		try {
			Enumeration<?> en = config.propertyNames();
			while (en.hasMoreElements()) {
				String key = (String) en.nextElement();
				String Property = config.getProperty(key);
				System.out.println(key + " : " + Property);
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("PropertiesUtil.readAllProperties() ->" + e.toString());
		}
	}

	public static void main(String args[]) {
		ConfigUtil.readAllProperties();
	}

	/*
	 * 加载排期配置信息
	 */
	public static Hashtable<String, String> loadIssueParam() {

		if (issueconfig == null || issueconfig.size() <= 0) {
			issueconfig = new Hashtable<String, String>();
			Properties pro = null;
			try {
				pro = new Properties();
				pro.load(ConfigUtil.class.getResourceAsStream("/config/quickCreateIssueConfig.properties"));

				Iterator<Entry<Object, Object>> it = pro.entrySet().iterator();
				while (it.hasNext()) {
					Entry<Object, Object> entry = it.next();
					Object key = entry.getKey();
					Object value = entry.getValue();
					issueconfig.put(key.toString(), value.toString());
				}

			} catch (IOException e) {
				e.printStackTrace();
			} finally {
				pro.clear();
				pro = null;
			}
		}
		return issueconfig;
	}

	/*
	 * 获取排次参数
	 */
	public static String getIssusPltPara(String p) {

		if (issueconfig == null || issueconfig.size() <= 0) {
			loadIssueParam();
		}
		return issueconfig.get(p);
	}
}
