package cls.taishan.web.dealer.form;

import cls.taishan.common.entity.BaseForm;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class DealerForm extends BaseForm{

	private static final long serialVersionUID = 1596974620307847478L;
	
	private String dealerCode;
	private String dealerName;
	private String startDate;
	private String endDate;
	
	
}
