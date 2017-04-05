package cls.taishan.app.model.capital;

import java.util.List;

import cls.taishan.common.model.BasePageResponse;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class Res2001Msg extends BasePageResponse {
	private static final long serialVersionUID = -5883739546686678840L;
	private List<Res2001Record> transInfos ;
}
