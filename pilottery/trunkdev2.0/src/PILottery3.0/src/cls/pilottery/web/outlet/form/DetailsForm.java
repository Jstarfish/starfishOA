package cls.pilottery.web.outlet.form;

public class DetailsForm extends AddOutlet {

	private static final long serialVersionUID = 1L;

	private String storeType;

	private String bankName;

	private String orgName;

	private String areaName;

	private String marketName;
	
	private long balance;

	public String getMarketName() {

		return marketName;
	}

	public void setMarketName(String marketName) {

		this.marketName = marketName;
	}

	public String getStoreType() {

		return storeType;
	}

	public void setStoreType(String storeType) {

		this.storeType = storeType;
	}

	public String getBankName() {

		return bankName;
	}

	public void setBankName(String bankName) {

		this.bankName = bankName;
	}

	public String getOrgName() {

		return orgName;
	}

	public void setOrgName(String orgName) {

		this.orgName = orgName;
	}

	public String getAreaName() {

		return areaName;
	}

	public void setAreaName(String areaName) {

		this.areaName = areaName;
	}

	public DetailsForm() {

	}

	public long getBalance() {
		return balance;
	}

	public void setBalance(long balance) {
		this.balance = balance;
	}
}
