package cls.taishan.web.report.form;

import cls.taishan.common.entity.BaseForm;
import lombok.Getter;
import lombok.Setter;

/**
 * Created by Reno Main on 2016/10/9.
 */
@Setter
@Getter
public class ReportForm extends BaseForm {
    private static final long serialVersionUID = -4290787248278194681L;
    private String channelCode;

    //日期，日报表用
    private String startDate;
    private String endDate;

    //月份，月报表用
    private String startMonth;
    private String endMonth;

    //渠道商编码
    private String dealerCode;
    //期次
    private String reportIssue;
    //期次状态
    private String issueStatus;

    private String sortName;
    private String sortOrder = "desc";

    private String gameCode;

}
