
package com.huacai.assist.model;

import com.huacai.assist.R;
import com.huacai.assist.common.App;

/**
 * 资金日结DayBusiness
 * 
 * 列表条目
 */
public class DayBusinessListItem {
	private String[] data=new String[7];//日期
	private String[] name={App.getResString(R.string.sale),App.getResString(R.string.sale_commission),App.getResString(R.string.payout),
			App.getResString(R.string.payout_commission),App.getResString(R.string.topup),App.getResString(R.string.withdrawn),App.getResString(R.string.returned),App.getResString(R.string.return_commission)};//资金流动原因return_commission
	private String[] money=new String[7];;//流动金额
	private String[] lotteryAmount;
	private String[] lotteryName;
	private String[] name1;
	private String[] money1;
	private String data1;
	private boolean checked=false;
	
	public DayBusinessListItem(String[] data,String[] money){
		this.data=data;
		this.money=money;
	}
	public DayBusinessListItem(String date1,String[] money1,String[] lotA,String[] lotN){
		this.data1=date1;
		this.money1=new String[money1.length];
		this.lotteryAmount=new String[lotA.length];
		this.lotteryName=new String[lotN.length];
		this.money1=money1;
		this.lotteryAmount=lotA;
		this.lotteryName=lotN;
		
	}
	public String[] getLotteryAmount() {
		return lotteryAmount;
	}
	public void setLotteryAmount(String[] lotteryAmount) {
		this.lotteryAmount = lotteryAmount;
	}
	public String[] getLotteryName() {
		return lotteryName;
	}
	public void setLotteryName(String[] lotteryName) {
		this.lotteryName = lotteryName;
	}
	public String[] getName1() {
		return name1;
	}
	public void setName1(String[] name1) {
		this.name1 = name1;
	}
	public String[] getMoney1() {
		return money1;
	}
	public void setMoney1(String[] money1) {
		this.money1 = money1;
	}
	public String getData1() {
		return data1;
	}
	public void setData1(String data1) {
		this.data1 = data1;
	}
	public String[] getName() {
		return name;
	}
	public void setName(String[] name) {
		this.name = name;
	}
	public String[] getData() {
		return data;
	}
	public void setDate(String[] data) {
		this.data = data;
	}
	public String[] getMoney() {
		return money;
	}
	public void setMoney(String[] money) {
		this.money = money;
	}
	
}
