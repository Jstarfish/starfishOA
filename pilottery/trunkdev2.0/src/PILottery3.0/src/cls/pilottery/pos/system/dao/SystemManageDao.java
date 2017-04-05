package cls.pilottery.pos.system.dao;

import cls.pilottery.pos.system.model.OutletLoginModel;

public interface SystemManageDao {

	OutletLoginModel getOutletInfoByLogin(String loginId);

	void updateLoginPwd(OutletLoginModel newOutlet);

	String getParamValueById(int id);

}
