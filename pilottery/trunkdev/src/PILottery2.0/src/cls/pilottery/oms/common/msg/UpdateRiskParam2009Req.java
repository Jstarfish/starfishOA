package cls.pilottery.oms.common.msg;

import java.io.Serializable;

public class UpdateRiskParam2009Req implements Serializable {

	private static final long serialVersionUID = 8444805300034173917L;
	private Short   gameCode;
	private String  riskCtrlStr;
	private Long    riskCtrl;
	
	public Short getGameCode() {
		return gameCode;
	}
	public void setGameCode(Short gameCode) {
		this.gameCode = gameCode;
	}
	
	public String getRiskCtrlStr() {
		return riskCtrlStr;
	}
	public void setRiskCtrlStr(String riskCtrlStr) {
		this.riskCtrlStr = riskCtrlStr;
	}
	
	public Long getRiskCtrl() {
		return riskCtrl;
	}
	public void setRiskCtrl(Long riskCtrl) {
		this.riskCtrl = riskCtrl;
	}
}
