package cls.pilottery.web.system.model;

import java.io.Serializable;
import java.util.List;

/**
 * @describe: 权限实体类
 */
public class Privilege implements Serializable {

	private static final long serialVersionUID = 7971581635875211154L;

	private Long id;              

	private String name;         

	private String code;       //权限系统标识   

	private Integer isCenterPri;      //是否中心专用    

	private Long parentId;             

	private String url;           

	private Integer level;          
	
	private String remark;
	
	private String comment;
	
	private String order;

	private List<Privilege> subPrivilege;
	
	public List<Privilege> getSubPrivilege() {
		return subPrivilege;
	}

	public void setSubPrivilege(List<Privilege> subPrivilege) {
		this.subPrivilege = subPrivilege;
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

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public Long getParentId() {
		return parentId;
	}

	public void setParentId(Long parentId) {
		this.parentId = parentId;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public Integer getLevel() {
		return level;
	}

	public void setLevel(Integer level) {
		this.level = level;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

	public String getOrder() {
		return order;
	}

	public void setOrder(String order) {
		this.order = order;
	}

	public Integer getIsCenterPri() {
		return isCenterPri;
	}

	public void setIsCenterPri(Integer isCenterPri) {
		this.isCenterPri = isCenterPri;
	}
	
}
