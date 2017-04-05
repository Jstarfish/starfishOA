package cls.pilottery.oms.common.msg;

import java.util.List;

import cls.pilottery.web.area.model.GameAuth;

public class AgencyGameAuthReq5007 implements java.io.Serializable{

	private static final long serialVersionUID = 4185506171524138177L;
	private int ctrlLevel;//u8	 // 0 - contry, 1 - province, 2 - city, 3 -agency
	private String ctrlCode;
	private int gameCount ;
	public List<GameAuth> ctrls;
	private transient int status;
	public int getCtrlLevel() {
		return ctrlLevel;
	}
	public void setCtrlLevel(int ctrlLevel) {
		this.ctrlLevel = ctrlLevel;
	}
	public String getCtrlCode() {
		return ctrlCode;
	}
	public void setCtrlCode(String ctrlCode) {
		this.ctrlCode = ctrlCode;
	}
	public int getGameCount() {
		return gameCount;
	}
	public void setGameCount(int gameCount) {
		this.gameCount = gameCount;
	}
	public List<GameAuth> getCtrls() {
		return ctrls;
	}
	public void setCtrls(List<GameAuth> ctrls) {
		this.ctrls = ctrls;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	
}
