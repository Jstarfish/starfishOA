package cls.taishan.system.form;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class ChangePwdForm {
	private String loginId;
	private String oldPwd;
	private String newPwd;
	private String newPwdConfirm;
}
