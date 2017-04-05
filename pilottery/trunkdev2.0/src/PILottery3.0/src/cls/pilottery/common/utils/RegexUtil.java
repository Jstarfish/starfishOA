package cls.pilottery.common.utils;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class RegexUtil {
	public static String queryFilter(String str) {
		String regEx = "[“‘%#？*&’”_]";
		Pattern p = Pattern.compile(regEx);
		Matcher m = p.matcher(str);
		return m.replaceAll("").trim();
	}
	public static String StringFilter(String str) {
		String regEx = "[`~!@#$%^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]";
		Pattern p = Pattern.compile(regEx);
		Matcher m = p.matcher(str);
		return m.replaceAll("").trim();
	}
	public static String getStringNoBlank(String str) {      
        if(str!=null && !"".equals(str)) {      
            Pattern p = Pattern.compile("\\s*|\t|\r|\n");      
            Matcher m = p.matcher(str);      
            String strNoBlank = m.replaceAll("");      
            return strNoBlank;      
        }else {      
            return str;      
        }           
    }  
	public static int[] getString2intArr(String str) {   
		String s[] = str.split(",");  
		int[] array = new int[s.length];  
		for(int i=0;i<s.length;i++){  
		    array[i]=Integer.parseInt(s[i]);
		}
		return array;
	}
}
