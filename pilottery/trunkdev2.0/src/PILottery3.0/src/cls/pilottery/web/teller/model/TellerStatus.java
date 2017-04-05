package cls.pilottery.web.teller.model;

import cls.pilottery.common.EnumConfig;

/* 1=可用；2=已禁用；3=已删除 */
public class TellerStatus implements java.io.Serializable{

	private static final long serialVersionUID = 7290544245182421591L;
	
	private Integer value;
	private String  name;
	
	public static final TellerStatus ENABLE = new TellerStatus(1);
	public static final TellerStatus DISABLE = new TellerStatus(2);
	public static final TellerStatus DELETED = new TellerStatus(3);
	
	public TellerStatus(){
		
	}
	
	public TellerStatus(Integer v,String n){
		value = v;
		name = n;
	}
	
	public TellerStatus(Integer v){
		switch(v){
		case 1:
			value = v;
			name = EnumConfig.tellerStatus.get(1);
			break;
		case 2:
			value = v;
			name = EnumConfig.tellerStatus.get(2);
			break;
		case 3:
			value = v;
			name = EnumConfig.tellerStatus.get(3);
			break;
		default:
			value = 2;
			name = EnumConfig.tellerStatus.get(2);
		}
	}
	
	public String toString(){
		String str ="";
		if(value != null)
			str += String.valueOf(value);
		if(name != null){
			str +="/";
			str += name;
		}
		return str;
	}
	
	public Integer getValue() {
		return value;
	}
	
	public void setValue(Integer value) {
		this.value = value;
	}
	
	public String getName() {
		return name;
	}
	
	public void setName(String name) {
		this.name = name;
	}
}
