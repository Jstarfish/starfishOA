package cls.pilottery.common.utils;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.web.servlet.LocaleResolver;

public class SpringContextUtil implements ApplicationContextAware {

	private static ApplicationContext springContext;

	@Override
	public void setApplicationContext(ApplicationContext context)
			throws BeansException {
		springContext = context;
	}

	public static ApplicationContext getApplicationContext() {
		return springContext;
	}

	public static String getMessage(String code, HttpServletRequest request) {
		Locale locale = springContext.getBean(LocaleResolver.class)
				.resolveLocale(request);
		return springContext.getMessage(code, null, "", locale);
	}

	public static String getMessage(String code, Object[] args,
			HttpServletRequest request) {
		Locale locale = springContext.getBean(LocaleResolver.class)
				.resolveLocale(request);
		return springContext.getMessage(code, args, "", locale);
	}

	public static Locale getLocal(HttpServletRequest request) {
		Locale locale = springContext.getBean(LocaleResolver.class)
				.resolveLocale(request);
		return locale;
	}

	public static <T> T getBean(Class<T> clazz) {
		return springContext.getBean(clazz);
	}

}
