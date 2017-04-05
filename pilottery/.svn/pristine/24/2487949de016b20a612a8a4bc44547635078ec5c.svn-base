package cls.taishan.cncp.cmi.service;

import java.util.Map;

import javax.inject.Inject;
import javax.inject.Singleton;

import cls.taishan.cncp.cmi.dao.DataQueryDao;
import cls.taishan.cncp.cmi.model.Res5001Msg;
import cls.taishan.cncp.cmi.model.Res5007Msg;

@Singleton
public class DataQueryService {

	@Inject
	private DataQueryDao dataQueryDao;
	
	public Res5001Msg getAwardPeriodInfo(Map<String, Object> map){
		return dataQueryDao.getAwardPeriodInfo(map);
	}
	
	public String getPresentIssue(int gameCode){
		return dataQueryDao.getPresentIssue(gameCode);
	}

	public String getAccountBalance(String dealerCode) {
		return dataQueryDao.getAccountBalance(dealerCode);
	}

	public Res5007Msg getFundDaliyReport(Map<String, Object> map) {
		return dataQueryDao.getFundDaliyReport(map);
	}
}
