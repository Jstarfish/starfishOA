package cls.taishan.cncp.cmi.model;

import cls.taishan.common.model.BaseResponse;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

/**
 * Created by Reno Main on 2016/9/13.
 */
@Getter
@Setter
@AllArgsConstructor
public class Req1004Msg {
    private static final long serialVersionUID = 4709082406848329294L;
    private String game;
    private Integer issue;
}
