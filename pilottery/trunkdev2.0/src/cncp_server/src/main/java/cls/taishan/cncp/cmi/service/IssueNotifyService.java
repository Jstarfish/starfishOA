package cls.taishan.cncp.cmi.service;

import java.util.List;

import javax.inject.Inject;
import javax.inject.Singleton;

import cls.taishan.cncp.cmi.dao.IssueNotifyDao;
import cls.taishan.cncp.cmi.entity.IssueReward;
import cls.taishan.common.model.IssueInfo;

@Singleton
public class IssueNotifyService {
    @Inject
    private IssueNotifyDao issueNotifyDao;

	public IssueInfo getMaxPresaleIssue(int gameCode) {
		return issueNotifyDao.getMaxPresaleIssue(gameCode);
	}

	public IssueInfo getMaxSaleIssue(int gameCode) {
		return issueNotifyDao.getMaxSaleIssue(gameCode);
	}

	public void updateIssueInfo(IssueInfo is) {
		issueNotifyDao.updateIssueInfo(is);
	}

	public void processIssueReward(IssueReward ir) {
		issueNotifyDao.processIssueReward(ir);
	}

	public void saveOrUpdateIssueInfo(IssueInfo is) {
		int count = issueNotifyDao.isExsitIssueInfo(is);
		if(count > 0){
			issueNotifyDao.updateIssueInfo(is);
		}else{
			issueNotifyDao.saveIssueInfo(is);
		}
		
	}

	public void saveIssueInfo(IssueInfo is) {
		issueNotifyDao.saveIssueInfo(is);
	}

	public List<IssueInfo> getMaxSaleIssueList() {
		return issueNotifyDao.getMaxSaleIssueList();
	}

	public List<IssueInfo> getMaxPreSaleIssueList() {
		return issueNotifyDao.getMaxPreSaleIssueList();
	}

}
