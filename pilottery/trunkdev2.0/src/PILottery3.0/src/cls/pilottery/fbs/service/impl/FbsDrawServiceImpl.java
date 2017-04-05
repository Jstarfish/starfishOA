package cls.pilottery.fbs.service.impl;

import cls.pilottery.fbs.dao.FbsDrawDao;
import cls.pilottery.fbs.dao.FbsIssueDao;
import cls.pilottery.fbs.form.FbsDrawForm;
import cls.pilottery.fbs.form.FbsMatchForm;
import cls.pilottery.fbs.model.FbsMatch;
import cls.pilottery.fbs.model.FbsMatchDraw;
import cls.pilottery.fbs.model.FbsResult;
import cls.pilottery.fbs.service.FbsDrawService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Reno Main on 2016/6/24.
 */
@Component
public class FbsDrawServiceImpl implements FbsDrawService {

    @Autowired
    FbsDrawDao fbsDrawDao;

    @Override
    public Integer queryEndedMatchCount(FbsDrawForm fbsDrawForm) {
        return fbsDrawDao.queryEndedMatchCount(fbsDrawForm);
    }

    @Override
    public void updatePublishMatch(FbsMatchForm fbsMatchForm) {
        fbsDrawDao.updatePublishMatch(fbsMatchForm);
    }

    @Override
    public List<FbsMatch> queryEndedMatchList(FbsDrawForm fbsDrawForm) {
        return fbsDrawDao.queryEndedMatchList(fbsDrawForm);
    }

    @Override
    public FbsMatch queryMatchByMatchCode(String matchCode) {
        return fbsDrawDao.queryMatchByMatchCode(matchCode);
    }


    @Override
    @Transactional(propagation = Propagation.REQUIRED)
    public boolean insertMatchResult(FbsDrawForm fbsDrawForm) {
        try {
            int count = fbsDrawDao.updateMatchStatus(fbsDrawForm);
            if (count > 0) {
                fbsDrawDao.updateMatchResult(fbsDrawForm);
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRED)
    public boolean updateMatch2Result(FbsDrawForm fbsDrawForm) {
        if (fbsDrawForm.getMatchResultStatus() != 1) {
            fbsDrawForm.setFullHomeScore(fbsDrawForm.getSecondfhHomeScore() + fbsDrawForm.getSecondshHomeScore());
            fbsDrawForm.setFullGuestScore(fbsDrawForm.getSecondfhGuestScore() + fbsDrawForm.getSecondshGuestScore());
            fbsDrawForm.setFinalScoreTeam(fbsDrawForm.getSecondScoreTeam());
            fbsDrawForm.setFullScore(fbsDrawForm.getSecondFullScore());
            fbsDrawForm.setWinlosResult(fbsDrawForm.getSecondFullWinLosScore());
            fbsDrawForm.setWinlevellosResult(fbsDrawForm.getSecondFullWinLevelLosScore());
            fbsDrawForm.setHfwinlevellosResult(fbsDrawForm.getSecondHalfFullScore());
            fbsDrawForm.setHfSingleDouble(fbsDrawForm.getSecondFhshSingleDouble());
            fbsDrawForm.setHfSingleDoubleString(fbsDrawForm.getSecondFhshSingleDoubleString());
            fbsDrawForm.setSingleScore(fbsDrawForm.getSecondSingleScore());
        }

        fbsDrawDao.updateMatch2Result(fbsDrawForm);
        for (int i = 1; i < 7; i++) {
            fbsDrawForm.setSubTypeCode(i);
            fbsDrawDao.updateMatchWinResult(fbsDrawForm);
        }
        try {
            int count = fbsDrawDao.updateMatch2StatusOver(fbsDrawForm);
            if (count > 0) {
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateMatch2Finish(String matchCode) {
        try {
            int count = fbsDrawDao.updateMatch2Finish(matchCode);
            if (count > 0) {
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<FbsMatchDraw> queryMatchResult(String matchCode) {
        return fbsDrawDao.queryMatchResult(matchCode);
    }

    @Override
    public Long queryGamePoolAmount(Long gameCode) {
        return fbsDrawDao.queryGamePoolAmount(gameCode);
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRED)
    public void reDrawSteps(FbsDrawForm fbsDrawForm) {
        fbsDrawDao.updateMatchResult2Begin(fbsDrawForm);
        fbsDrawDao.updateDelMatchWinResult(fbsDrawForm);
        fbsDrawDao.updateMatch2StatusBegin(fbsDrawForm);
    }

    @Override
    public boolean finishDraw(FbsDrawForm fbsDrawForm) {
        try {
            int count = fbsDrawDao.updateFinishDrawSteps(fbsDrawForm);
            if (count > 0) {
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public String queryMatchMessage(String matchCode) {
        return fbsDrawDao.queryMatchMessage(matchCode);
    }

    @Override
    public boolean updateMatchResultSent(FbsDrawForm fbsDrawForm) {
        try {
            int count = fbsDrawDao.updateMatchResultSent(fbsDrawForm);
            if (count > 0) {
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean compareMatchResult(String matchCode) {
        FbsResult result = fbsDrawDao.queryMatchResultByCode(matchCode);
        if(result==null){
            return false;
        }
        Map paraMap = new HashMap();
        try {
            if (result.getFirstScoreTeam().equals(result.getSecondScoreTeam()) &&//先进球
                    result.getFirstfhHomeScore() == result.getSecondfhHomeScore() &&//上主
                    result.getFirstfhGuestScore() == result.getSecondfhGuestScore() &&//上客
                    result.getFirstshHomeScore() == result.getSecondshHomeScore() &&//下主
                    result.getFirstshGuestScore() == result.getSecondshGuestScore())//下客
            {//开奖号码审批通过
                paraMap.put("matchCode", matchCode);
                paraMap.put("result", 7);
                int count = fbsDrawDao.updateResultStatus(paraMap);
                return count > 0 ? true : false;
            } else {//开奖号码审批失败
                paraMap.put("matchCode", matchCode);
                paraMap.put("result", 8);
                int count = fbsDrawDao.updateResultStatus(paraMap);
                return count > 0 ? true : false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }

    }

    @Override
    public FbsResult queryMatchResultByCode(String matchCode) {
        return fbsDrawDao.queryMatchResultByCode(matchCode);
    }

    @Override
    public String checkDrawMatch(String matchCode) {
        String match = fbsDrawDao.checkDrawMatch(matchCode);
       return match;
    }
}