package com.huacai.assist.model;

import java.io.Serializable;

/**
 * 新增出货单AddFormList
 * 
 * 第二个列表的条目
 */
public class FormListItem implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private boolean isChecked=false;//条目是否被选中
	private String num;//条目编号
	private String[] name;//条目简称
	private String[] quantity;//张数
	private String[] code;//方案编码
	private String[] money;//总金额
	
	public FormListItem(boolean isChecked,String num,String[] name,String[] quantity,String[] code,String[] money){
		this.isChecked=isChecked;
		this.num=num;
		this.name=name;
		this.quantity=quantity;
		this.code=code;
		this.money=money;
	}
	public String[] getMoney() {
		return money;
	}
	public void setMoney(String[] money) {
		this.money = money;
	}
	public String[] getCode() {
		return code;
	}
	public void setCode(String[] code) {
		this.code = code;
	}
	public boolean isChecked() {
		return isChecked;
	}
	public void setChecked(boolean isChecked) {
		this.isChecked = isChecked;
	}
	public String getNum() {
		return num;
	}
	public void setNum(String num) {
		this.num = num;
	}
	public String[] getName() {
		return name;
	}
	public void setName(String[] name) {
		this.name = name;
	}
	public String[] getQuantity() {
		return quantity;
	}
	public void setQuantity(String[] quantity) {
		this.quantity = quantity;
	}
	
}
