package cls.taishan.web.report.model;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

/**
 * Created by Reno Main on 2016/10/9.
 */
@Setter
@Getter
@ToString
public class IssueSysReport implements java.io.Serializable {
    private static final long serialVersionUID = -6423459813714054665L;

    private Integer gameCode;
    private String gameName;

    private String issueCode; // 期次编号

    private Date issueSaleBegin; // 期次开始销售时间
    private Date issueSaleEnd; // 期次销售截止时间

    private Integer issueStatus;//期次状态
    private String awardNumber;//开奖号码

    private Date rewardTime;//派奖时间

    private Double saleAmount;//销售
    private Double bingoAmount;//中奖金额
    private Double rwardAmount;//派奖金额

}