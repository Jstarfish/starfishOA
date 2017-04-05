package cls.taishan.app.model.userCenter;

import java.math.BigDecimal;

import cls.taishan.common.model.BaseResponse;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class Res1002Msg extends BaseResponse{
	private static final long serialVersionUID = -4294568124256347487L;
	private String userName;
	private String headPicUrl;
	private BigDecimal balance;
	private BigDecimal gold;
	private BigDecimal points;
}
