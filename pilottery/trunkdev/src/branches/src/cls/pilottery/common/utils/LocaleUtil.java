package cls.pilottery.common.utils;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.system.model.UserLanguage;

/*
 * 本地化工具类，主要用于处理本地化相关业务
 * add by dzg 2015-9-8
 */
public class LocaleUtil {

	/*
	 * 根据当登陆用户语言环境，获取枚举值
	 */
	@SuppressWarnings("unchecked")
	public static Map<Integer, String> getUserLocaleEnum(String enumName,
			HttpServletRequest request) {
		if (StringUtils.isNotBlank(enumName)) {
			User user = (User) request.getSession().getAttribute(
					SysConstants.CURR_LOGIN_USER_SESSION);
			if (user != null) {
				Object obj = null;
				UserLanguage lg = user.getUserLang();
				if (lg == UserLanguage.ZH) {
					obj = ReflectUtil.getStaticProperty(
							"cls.pilottery.common.EnumConfigZH", enumName);

				} else if (lg == UserLanguage.EN) {
					obj = ReflectUtil.getStaticProperty(
							"cls.pilottery.common.EnumConfigEN", enumName);
				}

				if (obj != null)
					return (Map<Integer, String>) obj;
			}

		}
		return null;
	}

	/*
	 * 用于POS，根据语言，获取枚举值
	 */
	public static Map<Integer, String> getUserLocaleEnum(String enumName,
			int langid) {
		if (StringUtils.isNotBlank(enumName)) {

			Object obj = null;

			if (langid == 2) {
				obj = ReflectUtil.getStaticProperty(
						"cls.pilottery.common.EnumConfigZH", enumName);

			} else if (langid == 1) {
				obj = ReflectUtil.getStaticProperty(
						"cls.pilottery.common.EnumConfigEN", enumName);
			}

			if (obj != null)
				return (Map<Integer, String>) obj;

		}
		return null;
	}

	/*
	 * 根据当前登陆用户的语言环境选择中英文
	 */
	public static String getUserLocalePath(String basePath,
			HttpServletRequest request) {
		String retpath = basePath;

		if (StringUtils.isNotBlank(basePath)) {
			User user = (User) request.getSession().getAttribute(
					SysConstants.CURR_LOGIN_USER_SESSION);
			if (user != null) {
				UserLanguage lg = user.getUserLang();
				if (lg == UserLanguage.ZH) {
					retpath = retpath.trim() + SysConstants.PAGE_ZH_SUFFIX;

				} else if (lg == UserLanguage.EN) {
					retpath = retpath.trim() + SysConstants.PAGE_EN_SUFFIX;
				}
			}
		}

		return retpath;
	}

	/*
	 * 生成分页信息
	 */
	public static synchronized String getPageString(int count,
			HttpServletRequest request) {
		String retpath = null;

		if (count <= 0) {
			User user = (User) request.getSession().getAttribute(
					SysConstants.CURR_LOGIN_USER_SESSION);
			if (user != null) {
				UserLanguage lg = user.getUserLang();
				PageUtil.setLocale(lg);
				retpath = PageUtil.getPageStr(request, count);

			}
		}

		return retpath;
	}

}
