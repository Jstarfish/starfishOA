package cls.pilottery.web.capital.dao;

import java.util.List;

import cls.pilottery.web.capital.form.ManagerAcctForm;
import cls.pilottery.web.capital.model.ManagerAccount;
import cls.pilottery.web.capital.model.ManagerAccountModel;

public interface ManagerAcctDao {

	// 总记录数
	public Integer getManagerAcctCount(ManagerAcctForm managerAcctForm);

	// 每页显示的List
	public List<ManagerAccount> getManagerAcctList(
			ManagerAcctForm managerAcctForm);

	// 获取修改所需信息
	public ManagerAccountModel getManagerAcctInfo(String marketAdmin);

	// 更新信用额度
	public void updateLimit(ManagerAccount managerAccount);

	// 更新密码
	public void updatetransPass(ManagerAccount managerAccount);

	// 删除账户
	public int deleteupdeSatus(String marketAdmin);

}
