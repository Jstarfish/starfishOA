package cls.pilottery.oms.game.dao;

import java.util.List;

import cls.pilottery.oms.game.form.FundManagementForm;
import cls.pilottery.oms.game.model.FundAdj;
import cls.pilottery.oms.game.model.FundAdjHistory;
import cls.pilottery.oms.game.model.FundAdjHistoryVo;
import cls.pilottery.oms.game.model.GovernmentCommision;

public interface FundManagementDao {

	Integer getFundAdjListCount(FundManagementForm fundManagementForm);
	List<FundAdjHistory> getFundAdjList(FundManagementForm fundManagementForm);
	void insertFundAdj(FundAdj fa);
	
	Integer getGovernmentCommisionListCount(FundManagementForm fundManagementForm);
	List<GovernmentCommision> getGovernmentCommisionList(FundManagementForm fundManagementForm);
	
	Integer getFundAdjHistoryListCount(FundManagementForm vo);
	List<FundAdjHistoryVo> getFundAdjHistoryList(FundManagementForm vo);
}