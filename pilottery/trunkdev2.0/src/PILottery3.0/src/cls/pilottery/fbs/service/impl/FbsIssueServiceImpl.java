package cls.pilottery.fbs.service.impl;

import cls.pilottery.fbs.dao.FbsIssueDao;
import cls.pilottery.fbs.form.FbsIssueForm;
import cls.pilottery.fbs.form.FbsMatchForm;
import cls.pilottery.fbs.model.FbsIssue;
import cls.pilottery.fbs.model.FbsMatch;
import cls.pilottery.fbs.service.FbsIssueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Reno Main on 2016/6/1.
 */
@Component
public class FbsIssueServiceImpl implements FbsIssueService {

    @Autowired
    FbsIssueDao fbsIssueDao;

    @Override
    public Integer queryFbsIssueCount(FbsIssueForm fbsIssueForm) {
        return fbsIssueDao.queryFbsIssueCount(fbsIssueForm);
    }

    @Override
    public List<FbsIssue> queryFbsIssueList(FbsIssueForm fbsIssueForm) {
        return fbsIssueDao.queryFbsIssueList(fbsIssueForm);
    }

    @Override
    public void insertFbsIssue(FbsIssueForm fbsIssueForm) {
        fbsIssueDao.insertFbsIssue(fbsIssueForm);
    }

    @Override
    public void updateFbsIssue(FbsIssueForm fbsIssueForm) {
        fbsIssueDao.updateFbsIssue(fbsIssueForm);
    }

    @Override
    public void deleteFbsIssue(Long issueCode) {
        fbsIssueDao.deleteMatchsByIssueCode(issueCode);
        fbsIssueDao.deleteFbsIssue(issueCode);
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRED)
    public void publishFbsIssue(Long issueCode) {
        Map paraMap = new HashMap();
        Map paraRes = new HashMap();
        List<FbsMatch> matchList = fbsIssueDao.getIssueMatch(String.valueOf(issueCode));
        if (matchList != null && matchList.size() > 0) {
            for (int i = 0; i < matchList.size(); i++) {
                for (int j = 1; j < 7; j++) {
                    paraMap.put("gameCode", 14);
                    paraMap.put("matchCode", matchList.get(i).getMatchCode());
                    paraMap.put("subType", String.valueOf(j));
                    fbsIssueDao.publishIssueResult(paraMap);
                }
                paraRes.put("gameCode", 14);
                paraRes.put("matchCode", matchList.get(i).getMatchCode());
                paraRes.put("issueCode", issueCode);
                paraRes.put("matchComp", matchList.get(i).getMatchComp());
                fbsIssueDao.publishMatchResult(paraRes);
            }
        }
        fbsIssueDao.publishFbsMatch(issueCode);
        Map curParam = new HashMap();
        curParam.put("gameCode",14);
        curParam.put("issueCode",issueCode);
        fbsIssueDao.insertCurrentParam(curParam);
        fbsIssueDao.publishFbsIssue(issueCode);
    }

    @Override
    public int getMaxIssueNumber() {
        Integer maxIssue = fbsIssueDao.getMaxIssueNumber();
        if (maxIssue == null)
            return 0;
        else
            return maxIssue.intValue();
    }

    @Override
    public Date getMaxIssueDate() {
        Date maxIssue = fbsIssueDao.getMaxIssueDate();
        if (maxIssue == null)
            return null;
        else
            return maxIssue;
    }

    @Override
    public List<FbsMatch> queryIssueMatchList(FbsMatchForm fbsMatchForm) {
        return fbsIssueDao.queryIssueMatchList(fbsMatchForm);
    }

    @Override
    public Integer queryIssueMatchCount(FbsMatchForm fbsMatchForm) {
        return fbsIssueDao.queryIssueMatchCount(fbsMatchForm);
    }

    @Override
    public FbsIssue queryFbsIssueByIssueCode(Long issueCode) {
        return fbsIssueDao.queryFbsIssueByIssueCode(issueCode);
    }

    @Override
    public boolean checkIssueCode(Long issueCode) {
        Integer count = fbsIssueDao.checkIssueCode(issueCode);
        return count > 0 ? true : false;
    }

    @Override
    public boolean queryIssueByIssueDate(String issueDate) {
        Integer count = fbsIssueDao.checkIssueDate(issueDate);
        return count > 0 ? true : false;
    }
}
