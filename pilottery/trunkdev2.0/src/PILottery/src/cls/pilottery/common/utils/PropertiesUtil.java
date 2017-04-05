package cls.pilottery.common.utils;

import java.io.IOException;
import java.io.InputStream;
import java.util.Enumeration;
import java.util.Properties;

public class PropertiesUtil {

    private static Properties config = null;

    public static void init(String fileName) {
        try {
            InputStream in = PropertiesUtil.class.getClassLoader().getResourceAsStream(fileName);
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
        	if(config == null)
        		PropertiesUtil.init("config/config.properties");
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
        PropertiesUtil.readAllProperties();
    }

}
