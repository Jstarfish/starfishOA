package cls.pilottery.oms.business.model;

import cls.pilottery.common.EnumConfig;

/* 1=可用；2=禁用；3=退机 */
public class TerminalStatus implements java.io.Serializable{

	private static final long serialVersionUID = 7777482212658365285L;
	
	private Integer value;
	private String  name;
	
	public static final TerminalStatus ENABLE = new TerminalStatus(1);
	public static final TerminalStatus DISABLE = new TerminalStatus(2);
	public static final TerminalStatus RETURNED = new TerminalStatus(3);
	
	public TerminalStatus(){
		
	}
	
	public TerminalStatus(Integer v,String n){
		value = v;
		name = n;
	}
	
	public TerminalStatus(Integer v){
		switch(v){
		case 1:
			value = v;
			name = EnumConfig.terminalStatus.get(1);
			break;
		case 2:
			value = v;
			name = EnumConfig.terminalStatus.get(2);
			break;
		case 3:
			value = v;
			name = EnumConfig.terminalStatus.get(3);
			break;
		default:
			value = 2;
			name = EnumConfig.terminalStatus.get(2);
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
