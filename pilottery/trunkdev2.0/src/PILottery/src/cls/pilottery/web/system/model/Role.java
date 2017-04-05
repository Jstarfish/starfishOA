package cls.pilottery.web.system.model;

import java.util.List;

import cls.pilottery.common.model.BaseEntity;


/** 
 * @describe:  角色实体类 
 */ 
public class Role extends BaseEntity{

	private static final long serialVersionUID = 4085927066412370882L;

	private Long id;          
	
	private String name;      

	private Integer active;	  //角色是否开通
	
	private String comment;	//备注  
	
	private String code;   	//角色编码
	
	private String users;// add by dzg 仅用于新增用户存储过程传参

	private List<Privilege> privilegeList;
	
	private List<User> userList;

	public List<Privilege> getPrivilegeList() {
		return privilegeList;
	}

	public void setPrivilegeList(List<Privilege> privilegeList) {
		this.privilegeList = privilegeList;
	}

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

	public Integer getActive() {
		return active;
	}

	public void setActive(Integer active) {
		this.active = active;
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public List<User> getUserList() {
		return userList;
	}

	public void setUserList(List<User> userList) {
		this.userList = userList;
	}

	public String getUsers() {
		return users;
	}

	public void setUsers(String users) {
		this.users = users;
	}

}
