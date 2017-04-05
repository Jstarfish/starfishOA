package cls.taishan.common.utils;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

public class Dom4jUtil {

	public static <T> T fillConfig(T t, String fileName) {

		try {
			SAXReader reader = new SAXReader();
			// Document document = reader.read(new File(fileName));
			Document document = reader.read(Dom4jUtil.class.getClassLoader()
					.getResourceAsStream(fileName));
			Element rootElement = document.getRootElement();
			// System.out.println(rootElement.elementText("agencyStatusItems"));

			for (Field field : t.getClass().getDeclaredFields()) {
				field.setAccessible(true);

				Element element = rootElement.element(field.getName());
				if (element != null) {
					Map<?, ?> map = fillMap(new HashMap<Integer, String>(),
							element.elements());
					field.set(t, map);
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return t;
	}

	// 根据xml内容填充到map里
	public static Map<Integer, String> fillMap(Map<Integer, String> map,
			List<?> nodes) {
		try {
			for (Iterator<?> it = nodes.iterator(); it.hasNext();) {
				Element elm = (Element) it.next();
				map.put(Integer.parseInt(elm.attributeValue("key")),
						elm.attributeValue("value"));
			}

		} catch (Exception e) {

			e.printStackTrace();
		}
		return map;
	}

	// 根据xml内容，填充Object属性
	public static <T> void fillObj(T t, Element elem) {
		try {
			for (Field field : t.getClass().getFields()) {
				field.set(t, elem.attributeValue(field.getName()));
			}
		} catch (IllegalAccessException e) {

			e.printStackTrace();
		}

	}

}