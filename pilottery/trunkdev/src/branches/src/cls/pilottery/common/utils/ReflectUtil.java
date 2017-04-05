package cls.pilottery.common.utils;

import java.io.File;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;

import cls.pilottery.pos.common.annotation.PosMethod;
import cls.pilottery.pos.common.annotation.PosService;
import cls.pilottery.pos.common.model.MethodInfo;
import cls.pilottery.web.system.controller.LoginController;

/*
 * 用于反射的工具类
 * add by dzg 2015-9-8
 */
public class ReflectUtil {
	private static Logger log = Logger.getLogger(LoginController.class);

	public static Map<String, MethodInfo> getMethodList(String packageName) {
		List<Class<?>> classList = getPosServiceClasses(packageName);
		Map<String, MethodInfo> resultMap = new HashMap<String, MethodInfo>();
		for (Class<?> clazz : classList) {
			Method[] methods = clazz.getMethods();
			for (Method m : methods) {
				PosMethod pos = m.getAnnotation(PosMethod.class);
				if (pos != null) {
					MethodInfo info = new MethodInfo();
					info.setClassName(clazz);
					info.setMethodCode(pos.code());
					info.setMethodName(m.getName());
					resultMap.put(pos.code(), info);
				}
			}
		}
		return resultMap;
	}

	public static Object invokeMethod(Object service, String methodName, Object paramObject) throws Exception {
		Class<?> posClass = service.getClass();
		Method method = posClass.getMethod(methodName, Object.class);
		return method.invoke(service, paramObject);
	}

	public static List<Class<?>> getPosServiceClasses(String packageName) {
		List<Class<?>> posServiceList = new ArrayList<Class<?>>();
		try {
			List<String> list = getClassName(packageName);
			for (String className : list) {
				Class<?> clazz = Class.forName(className);
				if (clazz.getAnnotation(PosService.class) != null) {
					posServiceList.add(clazz);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error("扫描pos业务类出现异常", e);
		}
		return posServiceList;
	}

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

	public static void main(String[] args) {
		Map<String, MethodInfo> map = getMethodList("cls.pilottery.pos.system.service");
		System.out.println(map.size());
		Set<String> set = map.keySet();
		for (String s : set) {
			System.out.println(s);
			System.out.println(map.get(s));
		}
	}
}
