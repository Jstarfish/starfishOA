package cls.taishan.demo.form;

import cls.taishan.common.entity.BaseForm;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class DemoForm extends BaseForm{
	private static final long serialVersionUID = -4290787248278194681L;
	private String orgCode;
	private String userName;
	private String startDate;
	private String endDate;
}
