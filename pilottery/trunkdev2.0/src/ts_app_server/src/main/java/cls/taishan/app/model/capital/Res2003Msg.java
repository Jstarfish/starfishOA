package cls.taishan.app.model.capital;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class Res2003Msg implements java.io.Serializable {
	private static final long serialVersionUID = -1942437730125483618L;
	private int withdrawType;
	private String tranTime;
	private String applyTime;
	private double tranAmount;
	private String payedInstitution;
}
