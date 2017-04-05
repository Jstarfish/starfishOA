package cls.pilottery.web.area.model;

public class AreaParent implements java.io.Serializable{
	
	private static final long serialVersionUID = -7098632617821994267L;
	
	private Long code;
	private String name;
	
	public AreaParent(){
		
	}
	
	public AreaParent(Long code,String name){
		this.code = code;
		this.name = name;
	}
	
	public Long getCode() {
		return code;
	}
	
	public void setCode(Long code) {
		this.code = code;
	}
	
	public String getName() {
		return name;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public String toString(){
		if(name != null)
			return name;
		if(code != null)
			return String.valueOf(code);
		return "-";
	}
}