package cls.taishan.web.report.model;

import lombok.Getter;
import lombok.Setter;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

/**
 * Created by Reno Main on 2016/10/9.
 */
@Setter
@Getter
public class MonthReport implements java.io.Serializable {
    private static final long serialVersionUID = -6423459813714054665L;

    private String reportMonth; // 月份

    private String dealerCode;
    private String dealerName;//渠道名称
    private Double beginAmount;//期初余额
    private Double chargeAmount;//充值
    private Double withdrawAmount;//提现
    private Double saleAmount;//销售
    private Double saleCommAmount;//销售佣金
    private Double refundAmount;//退款
    private Double paidAmount;//返奖
    private Double otherTickets;//其他/调账

    private Double endAmount;//期末余额
}
