package cls.pilottery.web.capital.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cls.pilottery.web.capital.dao.ManagerAcctDao;
import cls.pilottery.web.capital.form.ManagerAcctForm;
import cls.pilottery.web.capital.model.ManagerAccount;
import cls.pilottery.web.capital.model.ManagerAccountModel;
import cls.pilottery.web.capital.service.ManagerAcctService;

@Service
public class ManagerAcctServiceImpl implements ManagerAcctService {

	@Autowired
	private ManagerAcctDao managerAcctDao;

	@Override
	public Integer getManagerAcctCount(ManagerAcctForm managerAcctForm) {
		return managerAcctDao.getManagerAcctCount(managerAcctForm);
	}

	@Override
	public List<ManagerAccount> getManagerAcctList(
			ManagerAcctForm managerAcctForm) {
		return managerAcctDao.getManagerAcctList(managerAcctForm);
	}

	@Override
	public ManagerAccountModel getManagerAcctInfo(String marketAdmin) {
		return managerAcctDao.getManagerAcctInfo(marketAdmin);
	}

	// 修改管理员账户信息
	@Transactional(rollbackFor = { Exception.class })
	@Override
	public void updateManagerAccount(ManagerAccount managerAccount) {
		this.updateManagerLimit(managerAccount);
		managerAcctDao.updatetransPass(managerAccount);
	}

	private void updateManagerLimit(ManagerAccount managerAccount) {
		managerAcctDao.updateLimit(managerAccount);
	}

	@Override
	public int deleteupdeSatus(String marketAdmin) {
		return managerAcctDao.deleteupdeSatus(marketAdmin);

	}

}
