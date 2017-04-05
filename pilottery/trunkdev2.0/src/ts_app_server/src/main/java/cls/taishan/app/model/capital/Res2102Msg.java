package cls.taishan.app.model.capital;

import cls.taishan.common.model.BaseResponse;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class Res2102Msg extends BaseResponse  {
	private static final long serialVersionUID = 2709321018175376229L;
	private String tranFlow;
	private double balance;
}
