package cls.pilottery.web.capital.service;

import java.util.List;

import cls.pilottery.web.capital.form.ManagerAcctForm;
import cls.pilottery.web.capital.model.ManagerAccount;
import cls.pilottery.web.capital.model.ManagerAccountModel;

public interface ManagerAcctService {

	// 总记录数
	public Integer getManagerAcctCount(ManagerAcctForm mMAcctForm);

	// 每页显示的List
	public List<ManagerAccount> getManagerAcctList(ManagerAcctForm mMAcctForm);

	// 获取修改所需信息
	public ManagerAccountModel getManagerAcctInfo(String marketAdmin);

	// 修改市场管理员的信用额度和密码
	public void updateManagerAccount(ManagerAccount managerAccount);

	public int deleteupdeSatus(String marketAdmin);
}
