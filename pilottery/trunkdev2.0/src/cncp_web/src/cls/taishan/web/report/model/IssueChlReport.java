package cls.taishan.web.report.model;

import cls.taishan.common.entity.BaseForm;
import lombok.Getter;
import lombok.Setter;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

/**
 * Created by Reno Main on 2016/10/9.
 */
@Setter
@Getter
public class IssueChlReport extends BaseForm implements java.io.Serializable {
    private static final long serialVersionUID = -6423459813714054665L;

    private Integer gameCode;
    private String gameName;
    private String issueCode; // 期次编号
    private String dealerName; // 渠道商名称

    private int orderCount; // 订单数
    private Double saleAmount;//销售金额

    private int bingoCount;//中奖订单数
    private Double bingoAmount;//中奖金额

    private int rwardCount;//派奖订单数
    private Double rwardAmount;//派奖金额

}