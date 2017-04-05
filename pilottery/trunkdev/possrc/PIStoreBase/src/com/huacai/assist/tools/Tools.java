package com.huacai.assist.tools;

import java.text.DecimalFormat;

public class Tools {
	public static String showTheTypeOfMoney(int money){//转换金额显示格式--->100,000
		DecimalFormat myformat = new DecimalFormat();
		myformat.applyPattern("##,###.000");
		return myformat.format(money);
	}
}
