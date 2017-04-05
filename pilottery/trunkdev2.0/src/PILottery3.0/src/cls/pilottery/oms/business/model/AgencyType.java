package cls.pilottery.oms.business.model;

import cls.pilottery.common.EnumConfig;

/**
 * 1=传统终端(预付费)；2=受信终端(后付费)；3=无纸化；4=中心站
 * */
public class AgencyType implements java.io.Serializable{
	
	private static final long serialVersionUID = -4333633359269650902L;

	private Integer value;
	private String  name;
	
	public AgencyType(){
		
	}
	
	public AgencyType(Integer v,String n){
		value = v;
		name = n;
	}
	
	public AgencyType(Integer v){
		switch(v){
		case 1:
			value = v;
			name = EnumConfig.agencyTypes.get(v);
			break;
		case 2:
			value = v;
			name = EnumConfig.agencyTypes.get(v);
			break;
		case 3:
			value = v;
			name = EnumConfig.agencyTypes.get(v);
			break;
		case 4:
			value = v;
			name =EnumConfig.agencyTypes.get(v);
			break;
		default:
			value = 1;
			name =EnumConfig.agencyTypes.get(1);
		}
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
