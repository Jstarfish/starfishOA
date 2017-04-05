package cls.pilottery.oms.business.model;

import cls.pilottery.common.EnumConfig;

/**
 * 1=可用；2=已禁用；3=已清退
 * */
public class AgencyStatus implements java.io.Serializable{
	
	private static final long serialVersionUID = -6451284599668570561L;
	
	private Integer value;
	private String  name;

	public static final AgencyStatus ENABLE = new AgencyStatus(1);
	public static final AgencyStatus DISABLE = new AgencyStatus(2);
	public static final AgencyStatus RETURNED = new AgencyStatus(3);
	
	public AgencyStatus(){
		
	}
	
	public AgencyStatus(Integer v,String n){
		value = v;
		name = n;
	}
	
	public AgencyStatus(Integer v){
		switch(v){
		case 1:
			value = v;
			name = EnumConfig.agencyStatusItems.get(v);
			break;
		case 2:
			value = v;
			name = EnumConfig.agencyStatusItems.get(v);
			break;
		case 3:
			value = v;
			name =EnumConfig.agencyStatusItems.get(v);
			break;
		default:
			value = 2;
			name = EnumConfig.agencyStatusItems.get(2);
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
	
	public String toString(){
		return name;
	}
}
