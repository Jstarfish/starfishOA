package cls.pilottery.fbs.service;

import cls.pilottery.fbs.form.FbsDrawForm;
import cls.pilottery.fbs.form.FbsMatchForm;
import cls.pilottery.fbs.model.FbsMatch;
import cls.pilottery.fbs.model.FbsMatchDraw;
import cls.pilottery.fbs.model.FbsResult;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * Created by Reno Main on 2016/6/23.
 */
@Component
public interface FbsDrawService {
    public Integer queryEndedMatchCount(FbsDrawForm fbsDrawForm);

    public List<FbsMatch> queryEndedMatchList(FbsDrawForm fbsDrawForm);

    public FbsMatch queryMatchByMatchCode(String  matchCode);

    public boolean insertMatchResult(FbsDrawForm  fbsDrawForm);

    public boolean updateMatch2Result(FbsDrawForm  fbsDrawForm);

    public List<FbsMatchDraw> queryMatchResult(String  matchCode);

    public Long queryGamePoolAmount(Long gameCode);

    public void reDrawSteps(FbsDrawForm  fbsDrawForm);

    public void updatePublishMatch(FbsMatchForm fbsMatchForm);

    public boolean finishDraw(FbsDrawForm  fbsDrawForm);

    public String queryMatchMessage(String matchCode);

    public boolean updateMatchResultSent(FbsDrawForm  fbsDrawForm);

    public boolean updateMatch2Finish(String matchCode);

    public boolean compareMatchResult(String matchCode);

    public FbsResult queryMatchResultByCode(String matchCode);

    public String checkDrawMatch(String matchCode);

}
