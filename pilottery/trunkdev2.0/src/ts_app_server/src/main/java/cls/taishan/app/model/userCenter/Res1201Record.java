package cls.taishan.app.model.userCenter;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Res1201Record implements java.io.Serializable{
	private static final long serialVersionUID = 5472948741336919976L;
	private String giftId;
	private String giftTitle;
	private String giftPicUrl;
	private String sendTime;
	private String giftEventRemark;
	private int giftStatus;
}
