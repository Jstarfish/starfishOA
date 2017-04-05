package cls.taishan.app.model.userCenter;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Req1101Msg implements java.io.Serializable{
	private static final long serialVersionUID = -6503049346842207958L;
	private String oldPassword;
	private String newPassword;
}
