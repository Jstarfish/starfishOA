package cls.pilottery.oms.common.msg;

import java.io.Serializable;

public class UpdateGameSaleControl2011Req implements Serializable {

	private static final long serialVersionUID = -6999738270930097228L;
	public Short gameCode;
	public Short canSale;
	
	public Short getGameCode() {
		return gameCode;
	}
	public void setGameCode(Short gameCode) {
		this.gameCode = gameCode;
	}
	
	public Short getCanSale() {
		return canSale;
	}
	public void setCanSale(Short canSale) {
		this.canSale = canSale;
	}
}
