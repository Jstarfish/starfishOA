package cls.taishan.cncp.cmi.model;

import lombok.Data;

@Data
public class Req1101Notify {
	
	private String game;
	private Long issue;
	private String startTime;
	private String stopTime;
	private String status;
	private String drawCode;
	private Long salesAmount;
	private Long bonusAmount;
	
}
