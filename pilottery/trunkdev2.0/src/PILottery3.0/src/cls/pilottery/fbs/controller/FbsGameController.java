package cls.pilottery.fbs.controller;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.connection.util.DecodeUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.fbs.form.FbsMatchForm;
import cls.pilottery.fbs.model.Competition;
import cls.pilottery.fbs.model.Country;
import cls.pilottery.fbs.model.Match;
import cls.pilottery.fbs.model.Team;
import cls.pilottery.fbs.service.FbsGameService;
import cls.pilottery.web.marketManager.model.GamePlanModel;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.system.model.UserLanguage;

import static java.lang.System.out;

@Controller
@RequestMapping("/fbsGame")
public class FbsGameController {

    static Logger logger = Logger.getLogger(FbsGameController.class);

    @Autowired
    private FbsGameService fbsGameService;

    @RequestMapping(params = "method=listFbsMatch")
    public String listTeam(HttpServletRequest request, ModelMap model, FbsMatchForm form) {

        Integer count = fbsGameService.getMatchCount(form);
        int pageIndex = PageUtil.getPageIndex(request);
        List<Match> matchList = new ArrayList<Match>();
        if (count != null && count.intValue() != 0) {
            form.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
            form.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
            matchList = fbsGameService.getMatchList(form);
        }

        List<Competition> competitionList = fbsGameService.getAllCompetition();

        model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
        model.addAttribute("matchList", matchList);
        model.addAttribute("competitionList", competitionList);
        model.addAttribute("form", form);

        return LocaleUtil.getUserLocalePath("oms/fbs/match/listMatch", request);
    }


    @RequestMapping(params = "method=initAddMatch")
    public String initAddMatch(HttpServletRequest request, ModelMap model) {
        String issueNum = request.getParameter("issueNum");
        String issueStart = request.getParameter("issueStart");
        String issueEnd = request.getParameter("issueEnd");
        List<Competition> competitionList = fbsGameService.getAllCompetition();

        model.addAttribute("competitionList", competitionList);
        model.addAttribute("issueNumber", issueNum);
        model.addAttribute("issueStart", issueStart);
        model.addAttribute("issueEnd", issueEnd);
        return LocaleUtil.getUserLocalePath("oms/fbs/match/addMatch", request);
    }

    @ResponseBody
    @RequestMapping(params = "method=setMatchCode")
    public String setNewMatchCode(HttpServletRequest request, ModelMap model) {
        String matchDate = request.getParameter("matchDate");
        String issueCode = request.getParameter("issueCode");

        String matchBeginDate[] = matchDate.split(" ")[0].split("-");
        String newCode = matchBeginDate[0].substring(2) + matchBeginDate[1] + matchBeginDate[2];

        Integer maxMatchCode = fbsGameService.getMaxMatchCount(issueCode);
        if (null == maxMatchCode || ("").equals(maxMatchCode)) {
            return newCode + "001";
        }
        String numStr = String.valueOf(maxMatchCode + 1);
        if (numStr.length() == 2) {
            numStr = "0" + numStr;
        } else if (numStr.length() == 1) {
            numStr = "00" + numStr;
        } else {
            numStr = numStr;
        }
        String newMatchCode = newCode + numStr;
        return newMatchCode;
    }

    public static void main(String args[]) {

    }

    @RequestMapping(params = "method=addMatch")
    public String addTeam(HttpServletRequest request, ModelMap model, Match match) throws Exception {
        try {
            //int count = fbsGameService.getMatchById();

            fbsGameService.saveMatch(match);
            return LocaleUtil.getUserLocalePath("common/successTip", request);
        } catch (Exception e) {
            logger.error("新增球队异常," + e.getMessage());
            e.printStackTrace();
            return LocaleUtil.getUserLocalePath("common/errorTip", request);
        }
    }

    @RequestMapping(params = "method=getMatchDetail")
    public String getMatchDetail(HttpServletRequest request, ModelMap model) throws Exception {
        String matchCode = request.getParameter("matchCode");
        Match match = fbsGameService.getMatchInfo(matchCode);
        model.addAttribute("match", match);
        return LocaleUtil.getUserLocalePath("oms/fbs/match/matchDetail", request);
    }

    @ResponseBody
    @RequestMapping(params = "method=getTeamsByComptt")
    public String getTeamsByComptt(HttpServletRequest request, ModelMap model) {
        String competition = request.getParameter("competition");
        List<Team> teamList = fbsGameService.getTeamsByComptt(competition);
        String result = JSONObject.toJSONString(teamList);
        try {
            result = new String(result.getBytes("utf-8"), "iso-8859-1");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    @RequestMapping(params = "method=initEditMatch")
    public String initEditMatch(HttpServletRequest request, ModelMap model) {
        String matchCode = request.getParameter("matchCode");
        String issueStart = request.getParameter("issueStart");
        String issueEnd = request.getParameter("issueEnd");
        Match match = fbsGameService.getMatchInfo(matchCode);
        model.addAttribute("match", match);

        List<Team> teamList = fbsGameService.getTeamsByComptt(match.getCompetition().toString());
        model.addAttribute("teamList", teamList);

        List<Competition> competitionList = fbsGameService.getAllCompetition();
        model.addAttribute("competitionList", competitionList);

        model.addAttribute("issueStart", issueStart);
        model.addAttribute("issueEnd", issueEnd);

        return LocaleUtil.getUserLocalePath("oms/fbs/match/editMatch", request);
    }

    @RequestMapping(params = "method=editMatch")
    public String editMatch(HttpServletRequest request, ModelMap model, Match match) throws Exception {
        try {
            fbsGameService.updateMatch(match);
            return LocaleUtil.getUserLocalePath("common/successTip", request);
        } catch (Exception e) {
            logger.error("新增球队异常," + e.getMessage());
            e.printStackTrace();
            return LocaleUtil.getUserLocalePath("common/errorTip", request);
        }
    }

    @ResponseBody
    @RequestMapping(params = "method=deleteMatch")
    public String deleteMatch(HttpServletRequest request) {
        String matchCode = request.getParameter("matchCode");
        Map<String, String> map = new HashMap<String, String>();
        try {
            fbsGameService.deleteMatch(matchCode);
            map.put("reservedSuccessMsg", "");
        } catch (Exception e) {
            logger.error("errmsgs" + e.getMessage());
            map.put("reservedSuccessMsg", "Delete failed");
        }
        return JSONArray.toJSONString(map);
    }
}
