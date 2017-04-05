package cls.pilottery.web.system.model;


public class PrivilegeTree  implements Comparable<PrivilegeTree> {

	/**
	 * 
	 */

	private Long id;

	private Long pid; // 父id

	private String name;

	private boolean checked;  

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getPid() {
		return pid;
	}

	public void setPid(Long pid) {
		this.pid = pid;
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
