package cls.taishan.cncp.cmi.dao;

import java.util.List;

import cls.taishan.cncp.cmi.entity.IssueReward;
import cls.taishan.common.model.IssueInfo;

public interface IssueNotifyDao {

	IssueInfo getMaxPresaleIssue(int gameCode);

	IssueInfo getMaxSaleIssue(int gameCode);

	void updateIssueInfo(IssueInfo is);

	void processIssueReward(IssueReward ir);

	void saveIssueInfo(IssueInfo is);

	int isExsitIssueInfo(IssueInfo is);

	List<IssueInfo> getMaxSaleIssueList();

	List<IssueInfo> getMaxPreSaleIssueList();

}
