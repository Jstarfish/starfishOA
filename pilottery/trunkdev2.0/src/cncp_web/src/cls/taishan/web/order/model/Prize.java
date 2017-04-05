package cls.taishan.web.order.model;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class Prize {

	private String saleFlow;
	private String saleTsn;
	private String payFlow;
	private Integer gameCode;
	private String gameName;
	private Long issueNumber;
	private String dealerCode;
	private String dealerName;
	private Integer isPaid;
	private Long orderAmount; // 购票金额
	private Long rewardAmount; // 中奖金额
	private String paidTime;
	private String orderTime;
	
}