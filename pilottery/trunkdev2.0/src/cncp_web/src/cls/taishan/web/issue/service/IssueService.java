package cls.taishan.web.issue.service;

import java.util.List;

import cls.taishan.web.issue.form.IssueForm;
import cls.taishan.web.issue.model.Issue;

public interface IssueService {

	List<Issue> getIssueList(IssueForm form);

	int getIssueCount(IssueForm form);

}
