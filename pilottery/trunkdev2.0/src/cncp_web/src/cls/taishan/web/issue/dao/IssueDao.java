package cls.taishan.web.issue.dao;

import java.util.List;

import cls.taishan.web.issue.form.IssueForm;
import cls.taishan.web.issue.model.Issue;

public interface IssueDao {

	List<Issue> getIssueList(IssueForm form);

	int getIssueCount(IssueForm form);

}
