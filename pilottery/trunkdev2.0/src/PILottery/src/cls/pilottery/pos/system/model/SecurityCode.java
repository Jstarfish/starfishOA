package cls.pilottery.pos.system.model;

import java.io.Serializable;

public class SecurityCode implements Serializable {
	private static final long serialVersionUID = 4634553518127800821L;
	private String securityCode;

	public String getSecurityCode() {
		return securityCode;
	}

	public void setSecurityCode(String securityCode) {
		this.securityCode = securityCode;
	}
}
