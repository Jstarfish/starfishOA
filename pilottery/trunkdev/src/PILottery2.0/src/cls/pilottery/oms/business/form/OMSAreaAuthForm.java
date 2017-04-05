package cls.pilottery.oms.business.form;

import java.util.ArrayList;
import java.util.List;

import cls.pilottery.common.entity.AbstractEntity;
import cls.pilottery.oms.business.model.areamodel.OMSAreaAuth;

public class OMSAreaAuthForm extends AbstractEntity {

	private static final long serialVersionUID = -7137990410327880492L;
	private List<OMSAreaAuth> gameAuth = new ArrayList<OMSAreaAuth>();
	
	public List<OMSAreaAuth> getGameAuth() {
		return gameAuth;
	}
	public void setGameAuth(List<OMSAreaAuth> gameAuth) {
		this.gameAuth = gameAuth;
	}
}
