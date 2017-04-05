package cls.pilottery.oms.common.msg;

import java.io.Serializable;

public class UpdateGameAutoDraw2017Req implements Serializable {

	private static final long serialVersionUID = 1822528113964460743L;
	public Short gameCode;
	public Short canAuto;
	
	public Short getGameCode() {
		return gameCode;
	}
	public void setGameCode(Short gameCode) {
		this.gameCode = gameCode;
	}
	public Short getCanAuto() {
		return canAuto;
	}
	public void setCanAuto(Short canAuto) {
		this.canAuto = canAuto;
	}
}
