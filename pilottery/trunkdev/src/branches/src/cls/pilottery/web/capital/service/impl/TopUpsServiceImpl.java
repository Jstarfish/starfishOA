package cls.pilottery.web.capital.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.capital.dao.TopUpsDao;
import cls.pilottery.web.capital.form.TopUpsForm;
import cls.pilottery.web.capital.model.InstitutionAccount;
import cls.pilottery.web.capital.model.paymodel.TopUps;
import cls.pilottery.web.capital.service.TopUpsService;
import cls.pilottery.web.institutions.model.InfOrgs;

@Service
public class TopUpsServiceImpl implements TopUpsService {

	@Autowired
	private TopUpsDao topUpsDao;

	@Override
	public Integer getTopUpsCount(TopUpsForm topUpsForm) {
		return topUpsDao.getTopUpsCount(topUpsForm);
	}

	@Override
	public List<TopUps> getTopUpsList(TopUpsForm topUpsForm) {
		return topUpsDao.getTopUpsList(topUpsForm);
	}

	@Override
	public List<TopUps> getTopUpsInfo(String aoCode) {
		return topUpsDao.getTopUpsInfo(aoCode);
	}

	@Override
	public InfOrgs getOrgInfoByOrgCode(String orgCode) {
		return topUpsDao.getOrgInfoByOrgCode(orgCode);
	}

	@Override
	public InstitutionAccount getOrgBalanceByOrgCode(String orgCode) {
		return topUpsDao.getOrgBalanceByOrgCode(orgCode);
	}

	@Override
	public void insititutionTopUps(TopUpsForm topUpsForm) {
		if (topUpsDao == null)
			return;
		topUpsDao.insititutionTopUps(topUpsForm);
	}

	@Override
	public TopUps getTopUpsByPk(String fundNo) {
		return topUpsDao.getTopUpsByPk(fundNo);
	}

}
