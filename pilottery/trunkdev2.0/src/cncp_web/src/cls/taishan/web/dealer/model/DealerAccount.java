package cls.taishan.web.dealer.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class DealerAccount {
	private String dealerCode;
	private String accountStatus;
	private String accountNo;
	private long balance;
	private long credit;
}
