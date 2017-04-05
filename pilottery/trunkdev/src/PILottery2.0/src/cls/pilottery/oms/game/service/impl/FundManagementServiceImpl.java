package cls.pilottery.oms.game.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.oms.game.dao.FundManagementDao;
import cls.pilottery.oms.game.form.FundManagementForm;
import cls.pilottery.oms.game.model.FundAdj;
import cls.pilottery.oms.game.model.FundAdjHistory;
import cls.pilottery.oms.game.model.FundAdjHistoryVo;
import cls.pilottery.oms.game.model.GovernmentCommision;
import cls.pilottery.oms.game.service.FundManagementService;

@Service
public class FundManagementServiceImpl implements FundManagementService{
	
	@Autowired
	private FundManagementDao fundManagementDao;

	public Integer getFundAdjListCount(FundManagementForm fundManagementForm) {
		return fundManagementDao.getFundAdjListCount(fundManagementForm);
	}

	public List<FundAdjHistory> getFundAdjList(FundManagementForm fundManagementForm) {
		return fundManagementDao.getFundAdjList(fundManagementForm);
	}

	public void insertFundAdj(FundAdj fa) {
		fundManagementDao.insertFundAdj(fa);
	}

	public Integer getGovernmentCommisionListCount(FundManagementForm fundManagementForm) {
		return fundManagementDao.getGovernmentCommisionListCount(fundManagementForm);
	}

	public List<GovernmentCommision> getGovernmentCommisionList(FundManagementForm fundManagementForm) {
		return fundManagementDao.getGovernmentCommisionList(fundManagementForm);
	}
	
	public Integer getFundAdjHistoryListCount(FundManagementForm vo) {
		return fundManagementDao.getFundAdjHistoryListCount(vo);
	}

	public List<FundAdjHistoryVo> getFundAdjHistoryList(FundManagementForm vo) {
		return fundManagementDao.getFundAdjHistoryList(vo);
	}
}
