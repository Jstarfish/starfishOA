package cls.taishan.common.utils;

import java.io.File;
import java.lang.reflect.Field;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

public class ReflectUtil {
	private static Logger log = Logger.getLogger(ReflectUtil.class);

	public static List<String> getClassName(String packageName) {
		List<String> classNames = new ArrayList<String>();
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		try {
			String resourceName = packageName.replaceAll("\\.", "/");
			URL url = loader.getResource(resourceName);
			if (url != null) {
				File urlFile = new File(url.toURI());
				File[] files = urlFile.listFiles();
				for (File f : files)
					getClassName(packageName, f, classNames);
			}
		} catch (URISyntaxException e) {
			e.printStackTrace();
		}
		return classNames;
	}

	private static void getClassName(String packageName, File packageFile, List<String> list) {
		if (packageFile.isFile()) {
			if (packageFile.getName().contains(".class")) {
				list.add(packageName + "." + packageFile.getName().replace(".class", ""));
			}
		} else {
			File[] files = packageFile.listFiles();
			String tmPackageName = packageName + "." + packageFile.getName();
			for (File f : files) {
				getClassName(tmPackageName, f, list);
			}
		}
	}

	/*
	 * 获取静态字段名 className 类名 fieldName 字段名
	 */
	public static Object getStaticProperty(String className, String fieldName) {
		try {
			Class<?> owner = Class.forName(className);
			Field f = owner.getField(fieldName);
			Object o = f.get(owner);
			System.out.print(o);

			return o;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

}
