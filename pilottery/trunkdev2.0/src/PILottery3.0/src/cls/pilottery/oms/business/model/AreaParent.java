package cls.pilottery.oms.business.model;

public class AreaParent implements java.io.Serializable{
	
	private static final long serialVersionUID = -7098632617821994267L;
	
	private String code;
	private String name;
	
	public AreaParent(){
		
	}
	
	public AreaParent(String code,String name){
		this.code = code;
		this.name = name;
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
	
	public String toString(){
		if(name != null)
			return name;
		if(code != null)
			return String.valueOf(code);
		return "-";
	}
}