package cls.taishan.web.issue.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.taishan.web.issue.dao.IssueDao;
import cls.taishan.web.issue.form.IssueForm;
import cls.taishan.web.issue.model.Issue;
import cls.taishan.web.issue.service.IssueService;

@Service
public class IssueServiceImpl implements IssueService{

	@Autowired
	
	private IssueDao issueDao;
	@Override
	public List<Issue> getIssueList(IssueForm form) {
		return issueDao.getIssueList(form);
	}
	@Override
	public int getIssueCount(IssueForm form) {
		return issueDao.getIssueCount(form);
	}

}
