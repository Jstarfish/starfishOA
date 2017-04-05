package cls.pilottery.oms.common.msg;

import java.io.Serializable;

public class UpdateGamePayControl2013Req implements Serializable {

	private static final long serialVersionUID = 1119311932662073002L;
	public short gameCode;
	public short canPay;
	
	public short getGameCode() {
		return gameCode;
	}
	public void setGameCode(short gameCode) {
		this.gameCode = gameCode;
	}
	
	public short getCanPay() {
		return canPay;
	}
	public void setCanPay(short canPay) {
		this.canPay = canPay;
	}
}
