package cls.taishan.web.dealer.model;

import cls.taishan.common.entity.BaseForm;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class Dealer extends BaseForm{

	private static final long serialVersionUID = -1956312537784522230L;
	
	private int id;
	private String dealerCode;
	private String dealerName;
	private String dealerContact;
	private String dealerPhone;
	private String dealerMail;
	//@DateTimeFormat(pattern = "yyyy-MM-dd")
	/*@JSONField (format="yyyy-MM-dd HH:mm:ss") 
	private Date openTime;*/
	private String openTime;
	private int dealerStatus;
	private String msgUrl;
	
	private long accountBalance;
}
