package cls.pilottery.oms.business.model;

public class AgencyBank implements java.io.Serializable{
	
	private static final long serialVersionUID = 8879796575678673184L;

	private Long bankId;
	private String bankName;
	
	public AgencyBank(){
		
	}
	
	public AgencyBank(Long id,String name){
		bankId = id;
		bankName = name;
	}
	
	public Long getBankId() {
		return bankId;
	}
	
	public void setBankId(Long bankId) {
		this.bankId = bankId;
	}
	
	public String getBankName() {
		return bankName;
	}
	
	public void setBankName(String bankName) {
		this.bankName = bankName;
	}
}
