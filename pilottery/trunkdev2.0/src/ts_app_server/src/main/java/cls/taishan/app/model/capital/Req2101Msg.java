package cls.taishan.app.model.capital;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class Req2101Msg implements java.io.Serializable{
	private static final long serialVersionUID = -1974911433494676782L;
	/*
	 * 1、充值卡2、Wing
	 */
	private int inchargeType;
	private String cardPassword;
	private double amount;
}
