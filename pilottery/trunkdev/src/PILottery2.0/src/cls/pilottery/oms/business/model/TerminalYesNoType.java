package cls.pilottery.oms.business.model;

import cls.pilottery.common.EnumConfig;

/*  1=是；0=否 */
public class TerminalYesNoType implements java.io.Serializable{

	private static final long serialVersionUID = -2213900780688523681L;
	
	private Integer value;
	private String name;
	
	public TerminalYesNoType(){
		
	}
	
	public TerminalYesNoType(Integer v,String n){
		value = v;
		name = n;
	}
	
	public TerminalYesNoType(Integer v){
		switch(v){
		case 1:
			value = v;
			name = EnumConfig.trainingmode.get(1);
			break;
		case 0:
			value = v;
			name = EnumConfig.trainingmode.get(0);
			break;
		default:
			value = 0;
			name = EnumConfig.trainingmode.get(0);
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
