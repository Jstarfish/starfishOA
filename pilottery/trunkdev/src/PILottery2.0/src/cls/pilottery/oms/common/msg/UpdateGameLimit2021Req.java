package cls.pilottery.oms.common.msg;

import java.io.Serializable;

public class UpdateGameLimit2021Req implements Serializable {

	private static final long serialVersionUID = 3834084842819720860L;
	public Short gameCode;    // u8
	public Long  saleLimit;   //u64
	public Long  payLimit;    //u64
	public Long  cancelLimit; //u64
	
	public Short getGameCode() {
		return gameCode;
	}
	public void setGameCode(Short gameCode) {
		this.gameCode = gameCode;
	}
	
	public Long getSaleLimit() {
		return saleLimit;
	}
	public void setSaleLimit(Long saleLimit) {
		this.saleLimit = saleLimit;
	}
	
	public Long getPayLimit() {
		return payLimit;
	}
	public void setPayLimit(Long payLimit) {
		this.payLimit = payLimit;
	}
	
	public Long getCancelLimit() {
		return cancelLimit;
	}
	public void setCancelLimit(Long cancelLimit) {
		this.cancelLimit = cancelLimit;
	}
}
