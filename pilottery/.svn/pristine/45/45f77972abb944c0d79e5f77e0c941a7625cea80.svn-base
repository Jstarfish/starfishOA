package cls.pilottery.oms.business.model;

public class TerminalType implements java.io.Serializable {
	
	private static final long serialVersionUID = 5853488798725201945L;
	private Integer typeCode;
	private String  typeName;
	
	public TerminalType(){
		
	}
	
	public TerminalType(String name,int v){
		typeName = name;
		typeCode = v;
	}
	
	public TerminalType(int v){
		switch(v){
		case 1:
			typeCode = v;
			typeName = "ST300";
			break;
		case 2:
			typeCode = v;
			typeName = "GDS688-3";
			break;
		default:
			
		}
	}
	
	public String toString(){
		String str ="";
		if(typeCode != null)
			str += String.valueOf(typeCode);
		if(typeName != null){
			str +="/";
			str += typeName;
		}
		return str;
	}
	
	public Integer getTypeCode() {
		return typeCode;
	}
	
	public void setTypeCode(Integer typeCode) {
		this.typeCode = typeCode;
	}
	
	public String getTypeName() {
		return typeName;
	}
	
	public void setTypeName(String typeName) {
		this.typeName = typeName;
	}
}
