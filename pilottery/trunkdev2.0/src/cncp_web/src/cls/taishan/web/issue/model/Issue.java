package cls.taishan.web.issue.model;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class Issue {

	private Integer gameCode;
	private String gameName;
	private String issueNumber;
	private Integer issueStatus;
	private String startSaleTime;
	private String endSaleTime;
	private String rewardTime;
	private String drawCode;
	private Long saleAmount;
	private Long saleComm;
	private Long winningAmount;
	private Long paidAmount;
	
	
}
