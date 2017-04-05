package cls.pilottery.web.teller.model;

import cls.pilottery.common.EnumConfig;

/*1=普通销售员；2=销售站经理；3=兑奖员；4=培训员*/
public class TellerType implements java.io.Serializable{

	private static final long serialVersionUID = -8809108623049250155L;
	
	private Integer value;
	private String  name;
	
	public TellerType(){
		
	}
	
	public TellerType(Integer v,String n){
		value = v;
		name = n;
	}
	
	public TellerType(Integer v){
		switch(v){
		case 1:
			value = v;
			name = EnumConfig.tellerTypes.get(1);
			break;
		case 2:
			value = v;
			name = EnumConfig.tellerTypes.get(2);
			break;
		/*case 3:
			value = v;
			name = "兑奖员";
			break;*/
		case 3:
			value = v;
			name = EnumConfig.tellerTypes.get(3);
			break;
		default:
			value = 1;
			name = EnumConfig.tellerTypes.get(1);
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
