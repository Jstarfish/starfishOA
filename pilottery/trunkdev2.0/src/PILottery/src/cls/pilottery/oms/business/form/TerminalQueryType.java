package cls.pilottery.oms.business.form;

public class TerminalQueryType {

	private int typeValue;
	private String typeName;
	
	public TerminalQueryType(){
		
	}
	
	public TerminalQueryType(int t,String s){
		typeValue = t;
		typeName = s;
	}
	
	public int getTypeValue() {
		return typeValue;
	}
	
	public void setTypeValue(int typeValue) {
		this.typeValue = typeValue;
	}

	public String getTypeName() {
		return typeName;
	}
	
	public void setTypeName(String typeName) {
		this.typeName = typeName;
	}
}
