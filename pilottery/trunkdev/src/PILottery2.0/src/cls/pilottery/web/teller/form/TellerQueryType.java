package cls.pilottery.web.teller.form;

public class TellerQueryType {

	private int typeValue;
	private String typeName;

	public TellerQueryType(){
		
	}
	
	public TellerQueryType(int t,String s){
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
