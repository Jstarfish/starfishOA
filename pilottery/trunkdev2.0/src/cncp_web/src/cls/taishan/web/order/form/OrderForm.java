package cls.taishan.web.order.form;

import cls.taishan.common.entity.BaseForm;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class OrderForm extends BaseForm {

	private static final long serialVersionUID = 3443304419364417073L;

	private String saleFlow;
	private Integer gameCode;
	private String gameName;
	private String issueNumber;
	private String dealerCode;
	private String dealerName;
	private Integer orderStatus;

	private String endDate;
	private String startDate;
}
