package cls.taishan.app.model.userCenter;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Req1001Msg implements java.io.Serializable{
	private static final long serialVersionUID = -8730274217192061023L;
	private String userName;
	private String phoneNumber;
	private String validCode;
	private String password;
}
