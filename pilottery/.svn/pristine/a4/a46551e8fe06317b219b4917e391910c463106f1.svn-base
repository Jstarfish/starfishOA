package cls.pilottery.fbs.service;

import cls.pilottery.fbs.form.FbsIssueForm;
import cls.pilottery.fbs.form.FbsMatchForm;
import cls.pilottery.fbs.model.FbsIssue;
import cls.pilottery.fbs.model.FbsMatch;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Created by Reno Main on 2016/6/1.
 */
@Component
public interface FbsIssueService {

    public Integer queryFbsIssueCount(FbsIssueForm fbsIssueForm);

    public List<FbsIssue> queryFbsIssueList(FbsIssueForm fbsIssueForm);

    public void insertFbsIssue(FbsIssueForm fbsIssueForm);

    public void updateFbsIssue(FbsIssueForm fbsIssueForm);

    public void deleteFbsIssue(Long issueCode);

    public void publishFbsIssue(Long issueCode);

    public int getMaxIssueNumber();
    public Date getMaxIssueDate();

    public FbsIssue queryFbsIssueByIssueCode(Long issueCode);

    public Integer queryIssueMatchCount(FbsMatchForm fbsMatchForm);

    public List<FbsMatch> queryIssueMatchList(FbsMatchForm fbsMatchForm);

    public boolean checkIssueCode(Long issueCode);

    public boolean queryIssueByIssueDate(String issueDate);

}
