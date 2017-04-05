package cls.taishan.cncp.cmi.model;

import cls.taishan.common.model.BaseResponse;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
/**
 * Created by Reno Main on 2016/9/13.
 */
@Getter
@Setter
@ToString
public class Req1002Msg extends BaseResponse {
    private static final long serialVersionUID = 4709082406848329294L;
    private String ticketId;
    private String game ;
    private Integer gameCode;
    private Long issue;
    private String dealer;
    private long amount;
    private String betLines;
}
