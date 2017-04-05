package cls.pilottery.fbs.dao;

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
public interface FbsIssueDao {

        public Integer queryFbsIssueCount(FbsIssueForm fbsIssueForm);

        public List<FbsIssue> queryFbsIssueList(FbsIssueForm fbsIssueForm);

        public void insertFbsIssue(FbsIssueForm fbsIssueForm);

        public void updateFbsIssue(FbsIssueForm fbsIssueForm);

        public void deleteFbsIssue(Long issueCode);

        public void publishFbsIssue(Long issueCode);

        public void publishFbsMatch(Long issueCode);

        public void deleteMatchsByIssueCode(Long issueCode);

        public Integer getMaxIssueNumber();
        public Date getMaxIssueDate();

        public Integer queryActiveMatchCount(FbsMatchForm fbsMatchForm);

        public List<FbsMatch> queryActiveMatchList(FbsMatchForm fbsMatchForm);

        public void joinMatch2Issue(Map<String, Object> paraMap);

        public Integer queryIssueMatchCount(FbsMatchForm fbsMatchForm);

        public List<FbsMatch> queryIssueMatchList(FbsMatchForm fbsMatchForm);

        public FbsIssue queryFbsIssueByIssueCode(Long issueCode);

        public void publishIssueResult(Map<String, Object> paraMap);

        public void publishMatchResult(Map<String, Object> paraMap);

        public List getIssueMatch(String issueCode);

        public Integer checkIssueCode(Long issueCode);

        public Integer checkIssueDate(String issueDate);

        public void insertCurrentParam(Map<String, Object> paraMap);

}