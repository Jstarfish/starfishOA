package cls.facebook.utils;

/**
 * 类名      		DateUtil.java
 * 说明   		description of the class
 * 创建日期 		2008-7-11
 * 作者  			
 * 版权  			huacai.cn 2008-2100 All Copyright(C) 
 * 更新时间  		$Date: 2008/08/15 02:46:24 $
 * 标签   		$Name: No2_boss $
 * CVS版本  		$Revision: 1.16 $
 * 最后更新者 		$Author: bosszj $
 * 审核人     
 */

/**
 * 功能说明：日期相关工具函数
 */
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Properties;
import java.util.regex.Pattern;

import org.apache.commons.lang3.StringUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.core.Logger;
import org.apache.logging.log4j.core.config.Loggers;

import cls.facebook.config.SysParameter;

import facebook4j.internal.logging.LoggerFactory;

/**
 * Date Utility Class This is used to convert Strings to Dates and Timestamps
 * 
 * <p>
 * <a href="DateUtil.java.html"><i>View Source</i></a>
 * </p>
 * 
 * @author <a href="mailto:matt@raibledesigns.com">Matt Raible</a> Modified by
 *         <a href="mailto:dan@getrolling.com">Dan Kibler </a> to correct time
 *         pattern. Minutes should be mm not MM (MM is month).
 * @version $Revision: 1.16 $ $Date: 2008/08/15 02:46:24 $
 */
public class DateUtil {
	// ~ Static fields/initializers
	// =============================================

	private static org.apache.logging.log4j.Logger log = LogManager.getLogger(DateUtil.class);

	private static String defaultDatePattern = "yyyy-MM-dd HH:mm:ss";

	private static String timePattern = "HH:mm";

	public static String GetDateFromDateTime(String str)
	{
		String strRet = "";
		if(str != null && str != "")
		{
			if(str.length() > "yyyy-MM-dd".length())
				strRet = str.substring(0, "yyyy-MM-dd".length());
		}
		
		return strRet;
	}
	
	// ~ Methods
	// ================================================================

	/**
	 * This method attempts to convert an Oracle-formatted date in the form
	 * dd-MMM-yyyy to mm/dd/yyyy.
	 * 
	 * @param aDate
	 *            date from database as a string
	 * @return formatted string for the ui
	 */
	public static final String getDate(Date aDate) {
		SimpleDateFormat df = null;
		String returnValue = "";

		if (aDate != null) {
			df = new SimpleDateFormat(defaultDatePattern);
			returnValue = df.format(aDate);
		}

		return (returnValue);
	}


	/**
	 * This method generates a string representation of a date/time in the
	 * format you specify on input
	 * 
	 * @param aMask
	 *            the date pattern the string is in
	 * @param strDate
	 *            a string representation of a date
	 * @return a converted Date object
	 * @see java.text.SimpleDateFormat
	 * @throws ParseException
	 */
	public static final Date convertStringToDate(String aMask, String strDate) throws ParseException {
		SimpleDateFormat df = null;
		Date date = null;
		df = new SimpleDateFormat(aMask);
		try {
			date = df.parse(strDate);
		} catch (ParseException pe) {
			// log.error("ParseException: " + pe);
			throw new ParseException(pe.getMessage(), pe.getErrorOffset());
		}

		return (date);
	}

	/**
	 * This method returns the current date time in the format: MM/dd/yyyy HH:MM
	 * a
	 * 
	 * @param theTime
	 *            the current time
	 * @return the current date/time
	 */
	public static String getTimeNow(Date theTime) {
		return getDateTime(timePattern, theTime);
	}

	/**
	 * 返回时间戳 (忽略毫秒)
	 * 
	 * @param date
	 * @return
	 */
	public static int getTimestamp(Date date) {
		if (null == date) {
			return 0;
		}
		return Integer.parseInt(date.getTime() / 1000 + "");
	}

	/**
	 * This method returns the current date in the format: MM/dd/yyyy
	 * 
	 * @return the current date
	 * @throws ParseException
	 */
	public static Calendar getToday() throws ParseException {
		Date today = new Date();
		SimpleDateFormat df = new SimpleDateFormat(defaultDatePattern);

		// This seems like quite a hack (date -> string -> date),
		// but it works ;-)
		String todayAsString = df.format(today);
		Calendar cal = new GregorianCalendar();
		cal.setTime(convertStringToDate(todayAsString));

		return cal;
	}

	/**
	 * This method generates a string representation of a date's date/time in
	 * the format you specify on input
	 * 
	 * @param aMask
	 *            the date pattern the string is in
	 * @param aDate
	 *            a date object
	 * @return a formatted string representation of the date
	 * 
	 * @see java.text.SimpleDateFormat
	 */
	public static final String getDateTime(String aMask, Date aDate) {
		SimpleDateFormat df = null;
		String returnValue = "";

		if (aDate == null) {
			log.error("aDate is null!");
		} else {
			df = new SimpleDateFormat(aMask);
			returnValue = df.format(aDate);
		}

		return (returnValue);
	}

	/**
	 * This method generates a string representation of a date based on the
	 * System Property 'dateFormat' in the format you specify on input
	 * 
	 * @param aDate
	 *            A date to convert
	 * @return a string representation of the date
	 */
	public static final String convertDateToString(Date aDate) {
		return getDateTime(defaultDatePattern, aDate);
	}

	/**
	 * This method converts a String to a date using the datePattern
	 * 
	 * @param strDate
	 *            the date to convert (in format MM/dd/yyyy)
	 * @return a date object
	 * 
	 * @throws ParseException
	 */
	public static Date StringToDate(String format, String strDate) throws ParseException {
		Date aDate = null;

		try {
			aDate = convertStringToDate(format, strDate);
		} catch (ParseException pe) {
			pe.printStackTrace();
			throw new ParseException(pe.getMessage(), pe.getErrorOffset());

		}

		return aDate;
	}

	/**
	 * This method converts a String to a date using the datePattern
	 * 
	 * @param strDate
	 *            the date to convert (in format MM/dd/yyyy)
	 * @return a date object
	 * 
	 * @throws ParseException
	 */
	public static Date convertStringToDate(String strDate) throws ParseException {
		Date aDate = null;

		try {
			aDate = convertStringToDate(defaultDatePattern, strDate);
		} catch (ParseException pe) {
			pe.printStackTrace();
			throw new ParseException(pe.getMessage(), pe.getErrorOffset());
		}
		return aDate;
	}

	static {
		Properties props = System.getProperties();
		props.setProperty("user.timezone", "GMT+8");
	}

	/**
	 * 得到今天的时间,并格式化.
	 * 
	 * @param format
	 *            格式
	 * @return 今天的日期。
	 */
	public static String today(String format) {
		DateFormat df = new SimpleDateFormat(format);
		return df.format(new java.util.Date());
	}

	public static String today() {
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		return df.format(new java.util.Date());
	}

	public static long todayTime() {
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		return getTime(df.format(new java.util.Date()));
	}

	public static String getUnixTime() {
		return String.valueOf(new Date().getTime() / 1000);
	}

	public static String yesterday(String format) {
		Date date = new Date();
		date.setTime(date.getTime() - 86400000);
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat(format);
		return simpleDateFormat.format(date);
	}

	public static String yesterday() {
		Date date = new Date();
		date.setTime(date.getTime() - 86400000);
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
		return simpleDateFormat.format(date);
	}

	public static Date yesterdayDate() {
		Date date = new Date();
		date.setTime(date.getTime() - 86400000);
		return date;
	}

	public static String tomorrow() {
		Date date = new Date();
		date.setTime(date.getTime() + 86400000);
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
		return simpleDateFormat.format(date);
	}

	public static Date tomorrowDate() {
		Date date = new Date();
		date.setTime(date.getTime() + 86400000);
		return date;
	}
	
	public static Date nextDate(Date d) {
		d.setTime(d.getTime() + 86400000);
		return d;
	}
	
	/**
	 * 根据一个时间戳(长整形字符串)生成指定格式时间字符串
	 * 
	 * @param time
	 *            时间戳(长整形字符串)
	 * @param format
	 *            格式字符串如yyyy-MM-dd
	 * @return 时间字符串
	 */
	public static String getDate(long time, String format) {
		if(time==0){
			return "";
		}
		Date d = new Date();
		d.setTime(time);
		DateFormat df = new SimpleDateFormat(format);
		return df.format(d);
	}

	/**
	 * 根据一个时间戳(长整形字符串)生成指定格式时间字符串
	 * 
	 * @param time
	 *            时间戳(长整形字符串)
	 * @param format
	 *            格式字符串如yyyy-MM-dd
	 * @return 时间字符串
	 */
	public static String getDate(String time, String format) {
		Date d = new Date();
		long t = Long.parseLong(time);
		d.setTime(t);
		DateFormat df = new SimpleDateFormat(format);
		return df.format(d);
	}

	/**
	 * 
	 * @param date
	 *            字符型时间 "2008-08-08"
	 * @param format
	 *            格式化形式 "yyyy-MM-dd"
	 * @return
	 */
	public static Date getFormatDate(String date, String format) {
		DateFormat df = new SimpleDateFormat(format);
		Date d;
		try {
			d = df.parse(date);
		} catch (ParseException e) {
			e.printStackTrace();
			d = new Date();
		}
		return d;
	}

	/**
	 * 根据一个时间戳(长整形字符串)生成指定格式时间字符串
	 * 
	 * @param time
	 *            时间戳(长整形字符串)
	 * @param format
	 *            格式字符串如yyyy-MM-dd
	 * @return 时间字符串
	 */
	public static String getDate(Date date, String format) {
		String formatDate = "";
		if (date != null) {
			DateFormat df = new SimpleDateFormat(format);
			formatDate = df.format(date);
		}
		return formatDate;
	}

	/**
	 * 得到日期的时间戳
	 * 
	 * @param date
	 *            八位或十位日期，格式：yyyy-MM-dd或yyyyMMdd
	 * @return 时间戳
	 */
	public static long getTime(String date) {
		long time = 0;
		if (date == null || date.length() < 8) {
			return 0;
		}
		if (date.length() == 8) {
			date = DateUtil.format(date);
		}
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		try {
			time = df.parse(date).getTime();
		} catch (ParseException e) {
			System.out.println("parse error " + e.getMessage());
		}
		return time;
	}

	/**
	 * 得到日期的时间戳
	 * 
	 * @param date
	 *            八位或十位日期，格式：yyyy-MM-dd或yyyyMMdd
	 * @return 时间戳
	 */
	public static Date getDate(String date) {
		Date returnDate = null;
		if (date == null || date.length() < 8) {
			return null;
		}
		if (date.length() == 8) {
			date = DateUtil.format(date);
		}
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		try {
			returnDate = df.parse(date);
		} catch (ParseException e) {
			System.out.println("parse error " + e.getMessage());
		}
		return returnDate;
	}

	/**
	 * 得到日期的时间戳
	 * 
	 * @param date
	 *            日期
	 * @param format
	 *            日期格式
	 * @return 时间戳
	 */
	public static long getTime(String date, String format) {
		long time = 0;
		if (date == null || date.length() < 8) {
			return 0;
		}
		if (date.length() == 8) {
			date = DateUtil.format(date);
		}
		DateFormat df = new SimpleDateFormat(format);
		try {
			time = df.parse(date).getTime();
		} catch (ParseException e) {
			System.out.println("parse error " + e.getMessage());
		}
		return time;
	}

	/**
	 * 日期的指定域加减
	 * 
	 * @param time
	 *            时间戳(长整形字符串)
	 * @param field
	 *            加减的域,如date表示对天进行操作,month表示对月进行操作,其它表示对年进行操作
	 * @param num
	 *            加减的数值
	 * @return 操作后的时间戳(长整形字符串)
	 */
	public static String addDate(String time, String field, int num) {
		int fieldNum = Calendar.YEAR;
		if (field.equals("month")) {
			fieldNum = Calendar.MONTH;
		}
		if (field.equals("date")) {
			fieldNum = Calendar.DATE;
		}
		Calendar cal = Calendar.getInstance();
		cal.setTimeInMillis(Long.parseLong(time));
		cal.add(fieldNum, num);
		return String.valueOf(cal.getTimeInMillis());
	}

	/**
	 * 日期的指定域加减
	 * 
	 * @param time
	 *            时间戳(长整形字符串)
	 * @param field
	 *            加减的域,如date表示对天进行操作,month表示对月进行操作,其它表示对年进行操作
	 * @param num
	 *            加减的数值
	 * @return 操作后的时间戳(长整形字符串)
	 */
	public static long addDate(String field, int num) {
		int fieldNum = Calendar.YEAR;
		if (field.equals("month")) {
			fieldNum = Calendar.MONTH;
		}
		if (field.equals("date")) {
			fieldNum = Calendar.DATE;
		}
		Calendar cal = Calendar.getInstance();
		cal.setTimeInMillis(new Date().getTime());
		cal.add(fieldNum, num);

		return cal.getTimeInMillis();
	}

	/**
	 * 得到现在的时间，格式时：分：秒
	 * 
	 * @param format
	 *            格式,如HH:mm:ss
	 * @return 返回现在的时间可用于插入数据库和显示
	 */
	public static String getNowTime(String format) {
		SimpleDateFormat sdf = new SimpleDateFormat(format);
		return sdf.format(new java.util.Date());
	}

	/**
	 * 得到今天的星期
	 * 
	 * @return 今天的星期
	 */
	public static String getWeek() {
		SimpleDateFormat sdf = new SimpleDateFormat("E");
		return sdf.format(new java.util.Date());
	}

	/**
	 * 得到一个日期是否是上午
	 * 
	 * @param date
	 *            日期
	 * @return 日期为上午时返回true
	 */
	public static boolean isAm(Date date) {
		boolean flag = false;
		SimpleDateFormat sdf = new SimpleDateFormat("H");
		if (sdf.format(date).compareTo("12") < 0) {
			flag = true;
		}
		return flag;
	}

	/**
	 * 把八位的格式为yyyyMMdd的日期转换为十位的yyyy-MM-dd格式
	 * 
	 * @param date
	 *            八位的格式为yyyyMMdd的日期
	 * @return 十位的yyyy-MM-dd格式
	 */
	public static String format(String date) {
		String returnDate = null;
		if (date.length() == 8) {
			returnDate = date.substring(0, 4) + "-" + date.substring(4, 6) + "-" + date.substring(6, 8);
		} else {
			returnDate = DateUtil.today("yyyy-MM-dd");
		}
		return returnDate;
	}

	/**
	 * 把八位的格式为yyyyMMdd的日期转换为十位的yyyy-MM-dd格式
	 * 
	 * @param date
	 *            八位的格式为yyyyMMdd的日期
	 * @return 十位的yyyy-MM-dd格式
	 */
	public static String format(Date date, String format) {
		DateFormat df = new SimpleDateFormat(format);
		return df.format(date);
	}

	/**
	 * 把年－月－日的字串转化成日期时间型
	 * 
	 * @param format
	 * @return
	 */
	public static Date getDateTime(String format) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = null;
		try {
			date = sdf.parse(format);
		} catch (ParseException e) {
			date = null;
			e.printStackTrace();
		}

		return date;
	}

	/**
	 * 把时：分：秒的字串转化成日期时间型
	 * 
	 * @param format
	 * @return
	 */
	public static Date getTimeForString(String format) {
		SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
		Date date = null;
		try {
			date = sdf.parse(format);
		} catch (ParseException e) {
			date = null;
			e.printStackTrace();
		}

		return date;
	}

	/**
	 * 
	 * @param aDate
	 * @return
	 */
	public static final String getStringForTime(Date aDate, String format) {
		SimpleDateFormat df = null;
		String returnValue = "";

		if (aDate != null) {
			df = new SimpleDateFormat(format);
			returnValue = df.format(aDate);
		}

		return (returnValue);
	}

	/**
	 * 根据类型返回 当前时间的前一周 或者 当前时间的后一周的时间字符串
	 * 
	 * @param format
	 *            表示需要返回的时间字符串的格式, 可以为空 , 默认为：yyyy-MM-dd HH:mm:ss 可参考是时间格式有：
	 *            yyyy-MM-dd, yy-MM-dd
	 * @param type
	 *            0 表示当前时间的前一周 1 表示当前时间的后一周
	 * @return 返回你想要的 时间格式
	 */
	public static final String getBeforeAfterDateWeek(String format, int type) {
		Calendar now = Calendar.getInstance();
		Date date = now.getTime();
		String result = "";
		format = format != null ? format.trim() : null;
		format = (format == null || "".equals(format)) ? "yyyy-MM-dd HH:mm:ss" : format;
		if (type == 0) {
			now.add(Calendar.DATE, -7);
			date = now.getTime();
			result = getDate(date, format);
		} else if (type == 1) {
			now.add(Calendar.DATE, 7);
			date = now.getTime();
			result = getDate(date, format);
		} else {
			result = getDate(date, format);
		}
		return result;
	}

	/**
	 * 根据类型返回 当前时间的前dateNum天 或者 当前时间的后dateNum天的时间字符串
	 * 
	 * @param format
	 *            表示需要返回的时间字符串的格式, 可以为空 , 默认为：yyyy-MM-dd HH:mm:ss 可参考是时间格式有：
	 *            yyyy-MM-dd, yy-MM-dd
	 * @param type
	 *            0 表示当前时间的前dateNum天 1 表示当前时间的后dateNum天
	 * @return 返回format 时间格式的串
	 */
	public static final String getBeforeOrAfterDate(String format, int type, int dateNum) {
		Calendar now = Calendar.getInstance();
		Date date = now.getTime();
		String result = "";
		format = format != null ? format.trim() : null;
		format = (format == null || "".equals(format)) ? "yyyy-MM-dd HH:mm:ss" : format;
		if (type == 0) {
			now.add(Calendar.DATE, -(dateNum));
			date = now.getTime();
			result = getDate(date, format);
		} else if (type == 1) {
			now.add(Calendar.DATE, dateNum);
			date = now.getTime();
			result = getDate(date, format);
		} else {
			result = getDate(date, format);
		}
		return result;
	}

	/**
	 * 返回当前星期对应的数字：0：星期天；1：星期一；2：星期二；3：星期三；4：星期四；5：星期五；6：星期六
	 * 
	 * @return
	 */
	public static final int getCurrentWeek() {
		Calendar c = Calendar.getInstance();
		int week = c.get(Calendar.DAY_OF_WEEK) - 1;
		return week;
	}

	/**
	 * 把当前时间的时：分的字串转化成日期时间型
	 * 
	 * @param format
	 * @return
	 */
	public static Date getTime() {
		SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
		Date date = null;
		date = getTimeByString(sdf.format(new Date()));

		return date;
	}

	/**
	 * 把时：分的字串转化成日期时间型
	 * 
	 * @param format
	 * @return
	 */
	public static Date getTimeByString(String format) {
		SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
		Date date = null;
		try {
			date = (Date) sdf.parse(format);
		} catch (ParseException e) {
			date = null;
			e.printStackTrace();
		}

		return date;
	}

	static {
		Properties props = System.getProperties();
		props.setProperty("user.timezone", "GMT+8");
	}

	public static String tomorrow(String format) {
		Date date = new Date();
		date.setTime(date.getTime() + 86400000);
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat(format);
		return simpleDateFormat.format(date);
	}

	/**
	 * 日期的指定域加减
	 * 
	 * @param time
	 *            时间戳(长整形字符串)
	 * @param field
	 *            加减的域,如date表示对天进行操作,month表示对月进行操作,其它表示对年进行操作
	 * @param num
	 *            加减的数值
	 * @return 操作后的时间戳(长整形字符串)
	 */
	public static Date addDate(Date time, String field, int num) {
		int fieldNum = Calendar.YEAR;
		if (field.equals("month")) {
			fieldNum = Calendar.MONTH;
		}
		if (field.equals("date")) {
			fieldNum = Calendar.DATE;
		}
		Calendar cal = Calendar.getInstance();
		cal.setTimeInMillis(time.getTime());
		cal.add(fieldNum, num);
		return new Date(cal.getTimeInMillis());
	}

	/**
	 * 得到今天的星期
	 * 
	 * @return 今天的星期
	 */
	public static String getWeek(Date date) {
		SimpleDateFormat sdf = new SimpleDateFormat("E");
		return sdf.format(date);
	}

	public static final Date convertStrtoDateIsss(String dateStr) {
		DateFormat f = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date = null;
		try {
			date = f.parse(dateStr);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return date;
	}

	public static final Date convertStrtoDateIsss(String dateStr, String format) {
		DateFormat f = new SimpleDateFormat(format);
		Date date = null;
		try {
			date = f.parse(dateStr);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return date;
	}

	/**
	 * 获得当前日期周的日期
	 * 
	 * @param date
	 *            当前周的日期
	 * @param week
	 *            星期，0表示星期日，1表示星期一，6表示星期六。
	 * @return 星期的日期
	 */
	public static Date getWeek(Date date, int week) {
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		c.set(Calendar.DAY_OF_WEEK, week + 1);
		String dateFmt = new SimpleDateFormat("yyyy-MM-dd").format(c.getTime());
		return new Date(DateUtil.getTime(dateFmt));
	}

	/**
	 * 获得下个星期的日期
	 * 
	 * @param date
	 *            当前周的日期
	 * @return 星期的日期
	 */
	public static Date getNextWeek(Date date) {
		date = new Date(date.getTime() + 604800000);
		String dateFmt = new SimpleDateFormat("yyyy-MM-dd").format(date);
		return new Date(DateUtil.getTime(dateFmt));
	}

	/**
	 * 
	 */
	public static int getLongTime(String time) {
		int longTime = 0;
		String[] tmp = time.split(":");
		if (tmp.length > 1) {
			longTime += Integer.parseInt(tmp[0]) * 3600000;
			longTime += Integer.parseInt(tmp[1]) * 60000;
		}
		return longTime;
	}

	/**
	 * 取得指定月份的最后一天
	 * 
	 * @param strdate
	 *            指定月份的第一天
	 * @return String
	 */
	public static String getMonthEnd(String str) {

		Date date = getFormatDate(str, "yyyy-MM-dd");

		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		calendar.add(Calendar.MONTH, 1);
		calendar.add(Calendar.DAY_OF_YEAR, -1);
		return getDate(calendar.getTime(), "yyyy-MM-dd");
	}
	
	
	/**
	 * 根据类型返回 当前时间的前dateNum天 或者 当前时间的后dateNum天的时间字符串
	 * @param date 要计算的基日期
	 * @param format
	 *            表示需要返回的时间字符串的格式, 可以为空 , 默认为：yyyy-MM-dd HH:mm:ss 可参考是时间格式有：
	 *            yyyy-MM-dd, yy-MM-dd
	 * @param type
	 *            0 表示当前时间的前dateNum天 1 表示当前时间的后dateNum天
	 * @return 返回format 时间格式的串
	 */
	public static final String getBeforeOrAfterDateForDate(Date date, String format, int type, int dateNum) {
		String result = "";
		format = format != null ? format.trim() : null;
		format = (format == null || "".equals(format)) ? "yyyy-MM-dd HH:mm:ss" : format;
		if (type == 0) {
			long t_date = date.getTime() - dateNum * 24 * 60 * 60 * 1000;
			result = getDate(t_date, format);
		} else if (type == 1) {
			long t_date = date.getTime() + dateNum * 24 * 60 * 60 * 1000;
			result = getDate(t_date, format);
		} else {
			result = getDate(date, format);
		}
		return result;
	}
	
	public static void main(String[] args) {
		//System.out.println(DateUtil.getDate(1304919293000L, "yyyy-MM-dd HH:mm:ss"));
		Date date=new Date();
       System.out.println(formatDate(date));
	}

	/**
	 * 返回seconds秒之后的时间 
	 * @param seconds
	 * @return
	 */
	public static Date stepSeconds(Date d,int seconds){
		Calendar c = Calendar.getInstance();  
		c.setTime(d);  
        c.set(Calendar.SECOND, c.get(Calendar.SECOND) + seconds);  
        d = c.getTime() ;
		return d;
	}
	
	/**
	  * 累计当日从0点开始的秒数
	  * @param time 待转换时间
	  * @return 转换后的时间单位：秒
	  */
	public static Long transform(String time) {
	  String[] temp = time.split(":");
	  int hours = Integer.valueOf(temp[0]);
	  int minutes = Integer.valueOf(temp[1]);
	  int seconds = 0;
	  if(temp.length > 2)
		 seconds = Integer.valueOf(temp[2]);
	  int allSeconds = hours * 60 * 60 + minutes * 60 + seconds;
//	  System.out.println("秒数：" + (long)allSeconds);
	  return (long) allSeconds;
	 }
	public static Date getDateMsg(Long datelong){
		
		return new Date(datelong*1000);
	}
	
	/**
     * 判断两个日期是否是同一天
     * 
     * @param date1
     *            date1
     * @param date2
     *            date2
     * @return
     */
    public static boolean isSameDate(Date date1, Date date2) {
        Calendar cal1 = Calendar.getInstance();
        cal1.setTime(date1);

        Calendar cal2 = Calendar.getInstance();
        cal2.setTime(date2);

        boolean isSameYear = cal1.get(Calendar.YEAR) == cal2
                .get(Calendar.YEAR);
        boolean isSameMonth = isSameYear
                && cal1.get(Calendar.MONTH) == cal2.get(Calendar.MONTH);
        boolean isSameDate = isSameMonth
                && cal1.get(Calendar.DAY_OF_MONTH) == cal2
                        .get(Calendar.DAY_OF_MONTH);

        return isSameDate;
    }
    public static String formatDate(Date date) {
    	String format="yyyy-MM-dd HH:mm:ss";
		DateFormat df = new SimpleDateFormat(format);
		return df.format(date);
	}
    
    /**
	 * 检查参数格式是否正确
	 * @param str
	 * @param regex
	 * @return
	 */
	public static boolean mathcFomat(String str, String regex){
		Pattern p = Pattern.compile(regex);
		boolean flag = true;
		for (int i=0; i<str.length(); i++) {
			if (!p.matcher(String.valueOf(str.charAt(i))).matches()) {
				flag = false;
				break;
			}
		}
		return flag;
	}
	
	public static boolean macAddrFomat(String str){
		String regex = "^[A-Fa-f0-9]{2}(:[A-Fa-f0-9]{2}){5}$";
		Pattern p = Pattern.compile(regex);
		boolean b = p.matcher(str).find();
		return b;
	}
	
	public static String[] sqlWords = {" and "," or ","--","=","'","、"};
	
	/**
	 * 
	 * @param str
	 * @return false:无sql关键字
	 */
	public static boolean existSqlWords(String str){
		boolean flag = false;
		str = str.toLowerCase();
		for (String sw : sqlWords) {
			if (str.indexOf(sw) > -1) {
				flag = true;
				break;
			}
		}
		return flag;
	}
	
	/*
	 * 用与排期，用cal的日期，加上timeStr 组合成新的日期：yyyy-MM-dd HH:mm:ss timestr格式：HH:mm:ss
	 */
	public static Date getIssueTime(Calendar cal, String timeStr) {

		if (cal == null || StringUtils.isBlank(timeStr))
			return null;

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String dateCloseStr = sdf.format(cal.getTime());
		sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date reTime = null;
		try {
			reTime = sdf.parse(dateCloseStr + " " + timeStr);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return reTime;
	}
	
	/*
	 * 同上
	 */
	public static Date getIssueTime(Date date, String timeStr) {

		if (date == null || StringUtils.isBlank(timeStr))
			return null;

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String dateCloseStr = sdf.format(date);
		sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date reTime = null;
		try {
			reTime = sdf.parse(dateCloseStr + " " + timeStr);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return reTime;
	}
	
	
}