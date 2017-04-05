package com.huacai.assist.model;

import java.io.Serializable;

/**
 * 代表每种彩票的信息，包括名称、数量、总价等。
 */
public class Lottery implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = -5364585731523603728L;
	private int num;//编号
	private String name;//名称
	private String quantity;//数量
	private String price=null;//单价
	private String code;//彩票方案码
	private String money;//总额
	public int getNum() {
		return num;
	}
	public String getPrice() {
		return price;
	}
	public void setPrice(String price) {
		this.price = price;
	}
	public void setNum(int num) {
		this.num = num;
	}
	
	
	public Lottery(String name, String quantity,int num,String code,String money){
		this.name=name;
		this.quantity=quantity;
		this.num=num;
		this.code=code;
		this.money=money;
	}
	public Lottery(String name, String quantity,String money){
		this.name=name;
		this.quantity=quantity;
		this.money=money;
	}
	public String getMoney() {
		return money;
	}
	public void setMoney(String money) {
		this.money = money;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getQuantity() {
		return quantity;
	}
	public void setQuantity(String quantity) {
		this.quantity = quantity;
	}
	
}
