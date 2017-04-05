package cls.pilottery.web.outlet.model;

import java.io.Serializable;

/**
 * 银行类
 * 
 * @author Administrator
 * 
 */
public class Bank implements Serializable {
	private static final long serialVersionUID = 1L;

	private int bankId;

	private String bankName;

	public int getBankId() {
		return bankId;
	}

	public void setBankId(int bankId) {
		this.bankId = bankId;
	}

	public String getBankName() {
		return bankName;
	}

	public void setBankName(String bankName) {
		this.bankName = bankName;
	}

	public Bank() {
	}
}
