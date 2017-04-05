package cn.jiahaixin.oa.test;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

import com.opensymphony.xwork2.ActionContext;

/**
 * 用户
 * 
 * @author tyg
 * @Discretion 用户和角色是多对多关�?
 */
public class User implements java.io.Serializable{
	private Long id;
	private String name; // 真实姓名
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}


}
