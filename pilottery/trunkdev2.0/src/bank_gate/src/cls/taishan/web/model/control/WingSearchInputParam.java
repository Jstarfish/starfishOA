package cls.taishan.web.model.control;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class WingSearchInputParam {
	private String euser;
	private String account;
	private String reqFlow;
	private int transType;

	@Override
	public String toString() {
		return "WingSearchInputDao [eUser=" + euser + ", account=" + account + ", reqFlow=" + reqFlow + ", transType="
				+ transType + "]";
	}

}
