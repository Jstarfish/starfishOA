package cls.taishan.app.model.capital;

import cls.taishan.common.model.BaseResponse;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class Res2101Msg extends BaseResponse  {
	private static final long serialVersionUID = 7104047291937737500L;
	private String tranFlow;
	private double balance;
}
