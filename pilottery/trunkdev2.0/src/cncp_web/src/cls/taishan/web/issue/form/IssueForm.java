package cls.taishan.web.issue.form;

import cls.taishan.common.entity.BaseForm;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class IssueForm extends BaseForm {

	private static final long serialVersionUID = -2667826905449711747L;
	private Integer gameCode;
	private String issueNumber;
	private Integer issueStatus;
	private String startSaleTime;
}
