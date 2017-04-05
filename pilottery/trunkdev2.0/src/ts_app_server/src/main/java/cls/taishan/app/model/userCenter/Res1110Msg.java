package cls.taishan.app.model.userCenter;

import cls.taishan.common.model.BaseResponse;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class Res1110Msg extends BaseResponse{
	private static final long serialVersionUID = -5251843490477341110L;
	private int hasSetTranPwd;
	private int hasSetSecuQues;
}
