package cls.pilottery.fbs.dao;

import cls.pilottery.fbs.form.FbsDrawForm;
import cls.pilottery.fbs.form.FbsMatchForm;
import cls.pilottery.fbs.model.FbsMatch;
import cls.pilottery.fbs.model.FbsMatchDraw;
import cls.pilottery.fbs.model.FbsResult;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

/**
 * Created by Reno Main on 2016/6/23.
 */
@Component
public interface FbsDrawDao {

    public Integer queryEndedMatchCount(FbsDrawForm fbsDrawForm);

    public List<FbsMatch> queryEndedMatchList(FbsDrawForm fbsDrawForm);

    public FbsMatch queryMatchByMatchCode(String matchCode);

    public void updatePublishMatch(FbsMatchForm fbsMatchForm);

    public void updateMatchResult(FbsDrawForm fbsDrawForm);

    public int updateMatchStatus(FbsDrawForm fbsDrawForm);

    public void updateMatch2Result(FbsDrawForm fbsDrawForm);

    public int updateMatch2StatusOver(FbsDrawForm fbsDrawForm);

    public int updateMatchResultSent(FbsDrawForm fbsDrawForm);

    public int updateMatch2Finish(String matchCode);

    public void updateMatch2StatusBegin(FbsDrawForm fbsDrawForm);

    public FbsResult queryMatchResultByCode(String matchCode);

    public void updateMatchWinResult(FbsDrawForm fbsDrawForm);

    public void updateDelMatchWinResult(FbsDrawForm fbsDrawForm);

    public List<FbsMatchDraw> queryMatchResult(String matchCode);

    public Long queryGamePoolAmount(Long gameCode);

    public int updateFinishDrawSteps(FbsDrawForm fbsDrawForm);

    public String queryMatchMessage(String matchCode);

    public int updateResultStatus(Map resultOk);

    public String checkDrawMatch(String matchCode);

    public int updateMatchResult2Begin(FbsDrawForm fbsDrawForm);
}