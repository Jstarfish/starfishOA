package cls.taishan.system.model;


public class PrivilegeTree  implements Comparable<PrivilegeTree> {
	private Long id;
	private Long pId; // 父id
	private String name;
	private String remark;
	private boolean checked;  
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getpId() {
		return pId;
	}
	public void setpId(Long pId) {
		this.pId = pId;
	}
	public void setChecked(boolean checked) {
		this.checked = checked;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public boolean isChecked() {
		return checked;
	}
	@Override
	public int compareTo(PrivilegeTree o) {
		if(this.id > o.id){
			return 1;
		}else if(this.id <o.id){  
            return -1; 
		}
		return 0;
	}
}
