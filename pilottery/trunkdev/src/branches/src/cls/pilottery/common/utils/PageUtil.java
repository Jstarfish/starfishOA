package cls.pilottery.common.utils;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.system.model.UserLanguage;

public class PageUtil {

	public static int pageSize = 50;
	public static UserLanguage locale = UserLanguage.EN;

	public static void main(String[] args) {
		System.out.println(PageUtil.getPageStr(null, 5, 110, 10));
	}

	public static String getPageStr(HttpServletRequest request, int totalRecord) {

		int pageIndex = getPageIndex(request);

		int totalPage = totalRecord / pageSize
				+ (totalRecord % pageSize == 0 ? 0 : 1);
		pageIndex = totalPage == 0 ? 0 : pageIndex;

		String queryString = getQueryString(request);
		User user = (User) request.getSession().getAttribute(
				SysConstants.CURR_LOGIN_USER_SESSION);
		UserLanguage lg = user.getUserLang();
		StringBuffer sb = new StringBuffer();
		sb.append("<link rel=\"stylesheet\" type=\"text/css\" href=\"./component/pageUtil/paging.css\" />");

		if (lg==locale.ZH) {
			sb.append("<div id=\"pageDiv\"><span id=\"result\">共 "
					+ totalRecord + " 条记录 &nbsp;第 " + pageIndex + "/"
					+ totalPage + " 页&nbsp;" + "</span>");
		} else {
			sb.append("<div id=\"pageDiv\"><span id=\"result\">Total "
					+ totalRecord + " item(s) &nbsp; Page " + pageIndex
					+ " of " + totalPage + " &nbsp;" + "</span>");
		}

		if (pageIndex <= 1) {
			// sb.append("<span> < </span>");
		} else {
			sb.append("<a href=\"?pageIndex=1"
							+ queryString
							+ "\"> <img src=\"./component/pageUtil/img/firstPage.png\" width=\"14\" height=\"12\"> </a>");
			sb.append("<a href=\"?pageIndex="
							+ (pageIndex - 1)
							+ queryString
							+ "\"> <img src=\"./component/pageUtil/img/last.png\" width=\"8\" height=\"12\"> </a>");
		}

		// 开始页码， 前后各显示几个 3 个页码
		int startNum1 = (pageIndex - 3) > 1 ? (pageIndex - 3) : 1;
		int startNum2 = (totalPage - 6) > 1 ? (totalPage - 6) : 1;

		int startIndex = startNum1 < startNum2 ? startNum1 : startNum2;

		for (int i = startIndex; i < startIndex + 7; i++) {
			if (i == pageIndex) {
				sb.append("<span class=\"current\">" + pageIndex + "</span>");
			} else if (i <= totalPage) {
				sb.append("<a href=\"?pageIndex=" + i + queryString + "\">" + i
						+ "</a>");
			}
		}

		if (pageIndex >= totalPage) {
			// sb.append("<span> > </span>");
		} else {
			sb.append("<a href=\"?pageIndex="
							+ (pageIndex + 1)
							+ queryString
							+ "\"> <img src=\"./component/pageUtil/img/next.png\" width=\"8\" height=\"12\"> </a>");
			sb.append("<a href=\"?pageIndex="
							+ totalPage
							+ queryString
							+ "\"> <img src=\"./component/pageUtil/img/lastPage.png\" width=\"14\" height=\"12\"> </a>");
		}

		sb.append("<span style=\"color:#c7c6c6;\">&nbsp;&nbsp;page <input id=\"pageNum\" name=\"pageNum\" type=\"text\" size=\"2\" "
						+ " onkeyup=\"this.value=this.value.replace(/\\D/g,'')\""
						+ " onafterpaste=\"this.value=this.value.replace(/\\D/g,'')\""
						+ " maxlength=\"3\"/> </span>"
						+ " <span id=\"go\" onclick=\"doGO()\" width=\"30\" height=\"24\">GO</span>");

		sb.append("<script type=\"text/javascript\">"
						+ "function doGO(){var pageNum = document.getElementById(\"pageNum\").value;"
						+ "if(pageNum<1 || pageNum > "
						+ totalPage
						+ "){document.getElementById(\"pageNum\").value=\"\";return;}"
						+ "location.href=\"?pageIndex=\"+pageNum +\""
						+ queryString + "\";}" + "</script></div>");
		return sb.toString();
	}

	public static String getPageStr(HttpServletRequest request, int pageIndex,
			int pageSize, int totalRecord) {

		int totalPage = totalRecord / pageSize
				+ (totalRecord % pageSize == 0 ? 0 : 1);
		pageIndex = totalPage == 0 ? 0 : pageIndex;

		String queryString = getQueryString(request);

		StringBuffer sb = new StringBuffer();
		sb.append("<link rel=\"stylesheet\" type=\"text/css\" href=\"./component/pageUtil/paging.css\" />");
		sb.append("<div id=\"pageDiv\"><span id=\"result\">共 " + totalRecord
				+ " 条记录 &nbsp;第 " + pageIndex + "/" + totalPage + " 页&nbsp;"
				+ "</span>");

		if (pageIndex <= 1) {
			// sb.append("<span> < </span>");
		} else {
			sb.append("<a href=\"?pageIndex=1"
							+ queryString
							+ "\"> <img src=\"./component/pageUtil/img/firstPage.png\" width=\"14\" height=\"12\"> </a>");
			sb.append("<a href=\"?pageIndex="
							+ (pageIndex - 1)
							+ queryString
							+ "\"> <img src=\"./component/pageUtil/img/last.png\" width=\"8\" height=\"12\"> </a>");
		}

		// 开始页码， 前后各显示几个 3 个页码
		int startNum1 = (pageIndex - 3) > 1 ? (pageIndex - 3) : 1;
		int startNum2 = (totalPage - 6) > 1 ? (totalPage - 6) : 1;

		int startIndex = startNum1 < startNum2 ? startNum1 : startNum2;

		for (int i = startIndex; i < startIndex + 7; i++) {
			if (i == pageIndex) {
				sb.append("<span class=\"current\">" + pageIndex + "</span>");
			} else if (i <= totalPage) {
				sb.append("<a href=\"?pageIndex=" + i + queryString + "\">" + i
						+ "</a>");
			}
		}

		if (pageIndex >= totalPage) {
			// sb.append("<span> > </span>");
		} else {
			sb.append("<a href=\"?pageIndex="
							+ (pageIndex + 1)
							+ queryString
							+ "\"> <img src=\"./component/pageUtil/img/next.png\" width=\"8\" height=\"12\"> </a>");
			sb.append("<a href=\"?pageIndex="
							+ totalPage
							+ queryString
							+ "\"> <img src=\"./component/pageUtil/img/lastPage.png\" width=\"14\" height=\"12\"> </a>");
		}

		sb.append("<span style=\"color:#c7c6c6;\">&nbsp;&nbsp;跳转到"
						+ " <input id=\"pageNum\" name=\"pageNum\" type=\"text\" size=\"2\" "
						+ " onkeyup=\"this.value=this.value.replace(/\\D/g,'')\""
						+ " onafterpaste=\"this.value=this.value.replace(/\\D/g,'')\""
						+ " maxlength=\"3\"/> 页 </span>"
						+ " <span id=\"go\" onclick=\"doGO()\" width=\"30\" height=\"24\">GO</span>");

		sb.append("<script type=\"text/javascript\">"
						+ "function doGO(){var pageNum = document.getElementById(\"pageNum\").value;"
						+ "if(pageNum<1 || pageNum > "
						+ totalPage
						+ "){document.getElementById(\"pageNum\").value=\"\";return;}"
						+ "location.href=\"?pageIndex=\"+pageNum +\""
						+ queryString + "\";}" + "</script></div>");
		return sb.toString();
	}

	// @SuppressWarnings("unchecked")
	public static String getQueryString(HttpServletRequest request) {
		String queryString = "";
		try {
			Map<?, ?> params = request.getParameterMap();

			for (Object key : params.keySet()) {
				if (!"pageIndex".equals(key.toString())) {
					String[] values = (String[]) params.get(key);
					for (int i = 0; i < values.length; i++) {
						String value = values[i];
						queryString += "&" + key + "=" + value;
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return queryString;
	}

	public static int getPageIndex(HttpServletRequest request) {
		int pageIndex = 0;
		try {
			String str = request.getParameter("pageIndex");
			pageIndex = str == null ? 1 : Integer.parseInt(str);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return pageIndex;
	}

	public static void setPageSize(int pageSize) {
		PageUtil.pageSize = pageSize;
	}

	public static void setLocale(UserLanguage locale) {
		PageUtil.locale = locale;
	}

	public static int getPageIndex1(HttpServletRequest request) {
		int pageIndex = 0;
		try {
			String str = request.getParameter("pageIndex1");
			pageIndex = str == null ? 1 : Integer.parseInt(str);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return pageIndex;
	}

}
