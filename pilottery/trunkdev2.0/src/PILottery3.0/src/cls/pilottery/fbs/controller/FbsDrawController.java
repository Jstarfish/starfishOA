package cls.pilottery.fbs.controller;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.*;
import cls.pilottery.fbs.form.FbsDrawForm;
import cls.pilottery.fbs.form.FbsMatchForm;
import cls.pilottery.fbs.model.FbsMatch;
import cls.pilottery.fbs.model.FbsMatchDraw;
import cls.pilottery.fbs.model.FbsResult;
import cls.pilottery.fbs.msg.DrawConfirmReq12023;
import cls.pilottery.fbs.msg.DrawConfirmRsp12024;
import cls.pilottery.fbs.msg.FbsDrawReq12021;
import cls.pilottery.fbs.msg.FbsDrawRsp12022;
import cls.pilottery.fbs.service.FbsDrawService;
import cls.pilottery.oms.common.entity.BaseMessageReq;
import cls.pilottery.oms.common.service.LogService;
import cls.pilottery.oms.common.utils.ResustConstant;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.system.model.UserLanguage;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.net.URLEncoder;
import java.util.*;

/**
 * Created by Reno Main on 2016/6/1.
 */
@Controller
@RequestMapping("/fbsDraw")
public class FbsDrawController {

    private Logger logger = Logger.getLogger(FbsDrawController.class);

    @Autowired
    private FbsDrawService fbsDrawService;
    @Autowired
    private LogService logService;

    @RequestMapping(params = "method=initFbsDraw")
    public String queryFbsIssueList(HttpServletRequest request, ModelMap model, FbsDrawForm fbsDrawForm) {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);

        Integer listCount = fbsDrawService.queryEndedMatchCount(fbsDrawForm);
        List<FbsMatch> fbsDrawList = new ArrayList<FbsMatch>();
        int pageIndex = PageUtil.getPageIndex(request);
        if (listCount != null && listCount > 0) {
            fbsDrawForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
            fbsDrawForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
            fbsDrawList = fbsDrawService.queryEndedMatchList(fbsDrawForm);
        }
        model.addAttribute("userId", user.getId());

        model.addAttribute("pageDataList", fbsDrawList);
        model.addAttribute("pageStr", PageUtil.getPageStr(request, listCount));
        model.addAttribute("fbsDrawForm", fbsDrawForm);
        model.addAttribute("nowDate", DateUtil.getDate(new Date()));
        return LocaleUtil.getUserLocalePath("oms/fbs/fbsdraw/fbsDrawList", request);
    }

    /*更新销售状态和截止时间*/
    @RequestMapping(params = "method=updatePublishMatch")
    public String updatePublishMatch(HttpServletRequest request, ModelMap model) {
        String matchCode = request.getParameter("matchCode");
        FbsMatch fbsmatch = fbsDrawService.queryMatchByMatchCode(matchCode);
        model.addAttribute("fbsMatch", fbsmatch);
        return LocaleUtil.getUserLocalePath("oms/fbs/fbsdraw/publishMatchUpdate", request);
    }

    /*更新销售状态和截止时间*/
    @RequestMapping(params = "method=submitUpdatMatch")
    public String submitUpdatMatch(HttpServletRequest request, ModelMap model, FbsMatchForm fbsMatchForm) {
        try {
            fbsDrawService.updatePublishMatch(fbsMatchForm);
            return LocaleUtil.getUserLocalePath("common/successTip", request);
        } catch (Exception e) {
            e.printStackTrace();
            return LocaleUtil.getUserLocalePath("common/errorTip", request);
        }
    }

    /*第一次输入比赛结果*/
    @RequestMapping(params = "method=firstFbsDraw")
    public String firstFbsDraw(HttpServletRequest request, ModelMap model) {
        String matchCode = request.getParameter("matchCode");
        FbsMatch fbsmatch = fbsDrawService.queryMatchByMatchCode(matchCode);
        model.addAttribute("fbsMatch", fbsmatch);
        model.addAttribute("matchCode", matchCode);

        String newMatchCode = fbsDrawService.checkDrawMatch(matchCode);
        if (newMatchCode != null && !("").equals(newMatchCode)) {
            model.addAttribute("newmatchCode", newMatchCode);
            return LocaleUtil.getUserLocalePath("oms/fbs/fbsdraw/_error3", request);
        }

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);



        if (fbsmatch.getDrawStatus() == 7 && fbsmatch.getMatchStatus() < 5) {
            return "redirect:/fbsDraw.do?method=showFbsResult&matchCode=" + matchCode;
        }
        if (fbsmatch.getDrawStatus() == 9 && fbsmatch.getMatchStatus() < 5) {
            return LocaleUtil.getUserLocalePath("oms/fbs/fbsdraw/fbsDrawStep4", request);
        }
        if (fbsmatch.getDrawStatus() >= 6 && fbsmatch.getMatchStatus() == 5) {
            return "redirect:/fbsDraw.do?method=queryDrawResult&matchCode=" + matchCode;
        }
        if (fbsmatch.getDrawStatus() == 5 && fbsmatch.getMatchStatus() < 5
                && fbsmatch.getFirstDrawUserId() != user.getId()) {
            return "redirect:/fbsDraw.do?method=secondFbsDraw&matchCode=" + matchCode;
        }
        if ((fbsmatch.getDrawStatus() == 5 || fbsmatch.getDrawStatus() == 6) &&
                fbsmatch.getMatchStatus() < 5
                && fbsmatch.getFirstDrawUserId() == user.getId()) {
            return LocaleUtil.getUserLocalePath("oms/fbs/fbsdraw/fbsDrawStep1Wait", request);
        }
        return LocaleUtil.getUserLocalePath("oms/fbs/fbsdraw/fbsDrawStep1", request);
    }


    /*第二次输入比赛结果*/
    @RequestMapping(params = "method=secondFbsDraw")
    public String secondFbsDraw(HttpServletRequest request, ModelMap model) {
        String matchCode = request.getParameter("matchCode");
        FbsMatch fbsmatch = fbsDrawService.queryMatchByMatchCode(matchCode);
        model.addAttribute("fbsMatch", fbsmatch);
        return LocaleUtil.getUserLocalePath("oms/fbs/fbsdraw/fbsDrawStep2", request);
    }


    /*第一次计算比赛结果*/
    @ResponseBody
    @RequestMapping(params = "method=calculateFbsResult")
    public String calculateFbsResult(HttpServletRequest request, ModelMap model, FbsDrawForm fbsDrawForm) {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
        UserLanguage lg = user.getUserLang();
        String matchCode = fbsDrawForm.getMatchCode();
        FbsMatch fbsmatch = fbsDrawService.queryMatchByMatchCode(matchCode);
        fbsDrawForm.setScore310(fbsmatch.getScore310());
        fbsDrawForm.setScore30(fbsmatch.getScore30());
        Map map = new HashMap();
        try {
            map.put("fullScore", fbsDrawForm.getFirstFullScore());
            map.put("full30Result", fbsDrawForm.getFirstFullWinLosScore());
            map.put("full310Result", fbsDrawForm.getFirstFullWinLevelLosScore());
            map.put("hf310Result", fbsDrawForm.getFirstHalfFullScore());
            map.put("hfSingleDouble", fbsDrawForm.getFirstFhshSingleDouble());
            map.put("singleScore", fbsDrawForm.getFirstSingleScore());
            map.put("msg", "");
        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (lg == UserLanguage.ZH) {
                    String message = "失败";
                    map.put("msg", URLEncoder.encode(message, "utf-8"));
                } else if (lg == UserLanguage.EN) {
                    String message = "Fail";
                    map.put("msg", URLEncoder.encode(message, "utf-8"));
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return JSONArray.toJSONString(map);
    }


             /*第一次提交比赛结果*/
    @RequestMapping(params = "method=submitFirstFbsDraw")
    public String submitFirstFbsDraw(HttpServletRequest request, ModelMap model, FbsDrawForm fbsDrawForm) {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
        try {
            String matchCode = fbsDrawForm.getMatchCode();
            FbsMatch fbsmatch = fbsDrawService.queryMatchByMatchCode(matchCode);
            fbsDrawForm.setGameCode(14L);
            fbsDrawForm.setIssueCode(fbsmatch.getMatchIssue());
            fbsDrawForm.setMatchCompCode(fbsmatch.getMatchCompCode());
            fbsDrawForm.setHomeTeamCode(fbsmatch.getHomeTeamCode());
            fbsDrawForm.setGuestTeamCode(fbsmatch.getGuestTeamCode());
            fbsDrawForm.setFirstDrawUserId(user.getId());
            //比赛取消的话
            if (fbsDrawForm.getMatchResultStatus() == 1) {
                fbsDrawForm.setFirstfhHomeScore(99);
                fbsDrawForm.setFirstfhGuestScore(99);
                fbsDrawForm.setFirstshHomeScore(99);
                fbsDrawForm.setFirstshGuestScore(99);
                fbsDrawForm.setFirstScoreTeam("99");
            }
            boolean flag = fbsDrawService.insertMatchResult(fbsDrawForm);
            model.addAttribute("fbsMatch", fbsmatch);
            model.addAttribute("matchStr", fbsmatch.getHomeTeam() + "VS" + fbsmatch.getGuestTeam());
            model.addAttribute("matchCode", matchCode);
            if (flag) {
                return LocaleUtil.getUserLocalePath("oms/fbs/fbsdraw/fbsDrawStep1Wait", request);
            } else {
                return LocaleUtil.getUserLocalePath("oms/fbs/fbsdraw/_error", request);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return LocaleUtil.getUserLocalePath("oms/fbs/fbsdraw/_error", request);
        }
    }


    /*第二次计算比赛结果*/
    @ResponseBody
    @RequestMapping(params = "method=calculate2FbsResult")
    public String calculate2FbsResult(HttpServletRequest request, ModelMap model, FbsDrawForm fbsDrawForm) {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
        UserLanguage lg = user.getUserLang();
        String matchCode = fbsDrawForm.getMatchCode();
        FbsMatch fbsmatch = fbsDrawService.queryMatchByMatchCode(matchCode);
        fbsDrawForm.setScore310(fbsmatch.getScore310());
        fbsDrawForm.setScore30(fbsmatch.getScore30());
        Map map = new HashMap();
        try {
            map.put("fullScore", fbsDrawForm.getSecondFullScore());
            map.put("full30Result", fbsDrawForm.getSecondFullWinLosScore());
            map.put("full310Result", fbsDrawForm.getSecondFullWinLevelLosScore());
            map.put("hf310Result", fbsDrawForm.getSecondHalfFullScore());
            map.put("hfSingleDouble", fbsDrawForm.getSecondFhshSingleDouble());
            map.put("singleScore", fbsDrawForm.getSecondSingleScore());
            map.put("msg", "");
        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (lg == UserLanguage.ZH) {
                    String message = "失败";
                    map.put("msg", URLEncoder.encode(message, "utf-8"));

                } else if (lg == UserLanguage.EN) {
                    String message = "Fail";
                    map.put("msg", URLEncoder.encode(message, "utf-8"));
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return JSONArray.toJSONString(map);
    }


    /*第二次提交比赛结果*/
    @RequestMapping(params = "method=submitSecondFbsDraw")
    public String submitSecondFbsDraw(HttpServletRequest request, ModelMap model, FbsDrawForm fbsDrawForm) {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
        String matchCode = fbsDrawForm.getMatchCode();
        model.addAttribute("matchCode", matchCode);
        try {
            FbsMatch fbsmatch = fbsDrawService.queryMatchByMatchCode(matchCode);
            fbsDrawForm.setIssueCode(fbsmatch.getMatchIssue());
            fbsDrawForm.setMatchCompCode(fbsmatch.getMatchCompCode());
            fbsDrawForm.setHomeTeamCode(fbsmatch.getHomeTeamCode());
            fbsDrawForm.setGuestTeamCode(fbsmatch.getGuestTeamCode());
            fbsDrawForm.setSecondDrawUserId(user.getId());
            fbsDrawForm.setScore310(fbsmatch.getScore310());
            fbsDrawForm.setScore30(fbsmatch.getScore30());
            if (fbsDrawForm.getMatchResultStatus() == 1) {
                fbsDrawForm.setSecondfhHomeScore(99);
                fbsDrawForm.setSecondfhGuestScore(99);
                fbsDrawForm.setSecondshHomeScore(99);
                fbsDrawForm.setSecondshGuestScore(99);
                fbsDrawForm.setSecondScoreTeam("99");
                fbsDrawForm.setFinalScoreTeam("99");
            }
            boolean flag = fbsDrawService.updateMatch2Result(fbsDrawForm);
            if (flag && fbsDrawForm.getMatchResultStatus() == 1) {
//                return LocaleUtil.getUserLocalePath("common/successTip", request);
                model.addAttribute("fbsMatch", fbsmatch);
                model.addAttribute("matchStr", fbsmatch.getHomeTeam() + "VS" + fbsmatch.getGuestTeam());
                model.addAttribute("matchCode", matchCode);
                model.addAttribute("issueCode", fbsmatch.getMatchIssue());
                model.addAttribute("fbsDrawForm", fbsDrawForm);
                model.addAttribute("firstGoalTeam", '-');
                model.addAttribute("firstGoalTeamCode", fbsDrawForm.getFinalScoreTeam());

                model.addAttribute("fullScore", 99);
                model.addAttribute("full30Result", 99);
                model.addAttribute("full310Result", 99);
                model.addAttribute("hf310Result", "-");
                model.addAttribute("hfSingleDouble", 99);
                model.addAttribute("singleScore", "-");

                return LocaleUtil.getUserLocalePath("oms/fbs/fbsdraw/fbsDrawStep3", request);
            } else if (flag && fbsDrawForm.getMatchResultStatus() != 1) {

                model.addAttribute("fbsMatch", fbsmatch);
                model.addAttribute("matchStr", fbsmatch.getHomeTeam() + "VS" + fbsmatch.getGuestTeam());
                model.addAttribute("matchCode", matchCode);
                model.addAttribute("issueCode", fbsmatch.getMatchIssue());
                model.addAttribute("fbsDrawForm", fbsDrawForm);
                model.addAttribute("firstGoalTeam", fbsDrawForm.getFinalScoreTeam().equals(String.valueOf(fbsmatch.getHomeTeamCode())) ? fbsmatch.getHomeTeam() : fbsmatch.getGuestTeam());
                model.addAttribute("firstGoalTeamCode", fbsDrawForm.getFinalScoreTeam());


                model.addAttribute("fullScore", fbsDrawForm.getSecondFullScore());
                model.addAttribute("fullScoreEum", fbsDrawForm.getFullScoreEnum());
                model.addAttribute("full30Result", fbsDrawForm.getSecondFullWinLosScore());
                model.addAttribute("full310Result", fbsDrawForm.getSecondFullWinLevelLosScore());
                model.addAttribute("hf310Result", fbsDrawForm.getSecondHalfFullScore());
                model.addAttribute("hfSingleDouble", fbsDrawForm.getSecondFhshSingleDouble());
                model.addAttribute("singleScore", fbsDrawForm.getSecondSingleScore());
                model.addAttribute("singleScoreEum", fbsDrawForm.getSingleScoreEnum());

                return LocaleUtil.getUserLocalePath("oms/fbs/fbsdraw/fbsDrawStep3", request);
            } else {
                return LocaleUtil.getUserLocalePath("oms/fbs/fbsdraw/_error2", request);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return LocaleUtil.getUserLocalePath("oms/fbs/fbsdraw/_error2", request);
        }
    }

    public String get310Result(int fScore, int sScore) {
        if (fScore > sScore) {
            return "3";
        } else if (fScore == sScore) {
            return "1";
        } else {
            return "0";
        }
    }

    public int returnFormatResult(String result) {
        if (result.equals("3")) {
            return 1;
        } else if (result.equals("1")) {
            return 2;
        } else {
            return 3;
        }
    }


    /*等待两次比赛结果对比*/
    // ajax请求
    @RequestMapping(params = "method=fbsAsyncData")
    @ResponseBody
    public Object asyncData(HttpServletRequest request, ModelMap model, FbsDrawForm fbsDrawForm) {
        String matchCode = request.getParameter("matchCode");
        FbsMatch fbsmatch = fbsDrawService.queryMatchByMatchCode(matchCode);
        try {
            fbsDrawService.compareMatchResult(matchCode);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return JSONArray.toJSON(fbsmatch).toString();
    }

    /*重新进行第一次开奖*/
    @RequestMapping(params = "method=restartFirstFbsDraw")
    public String restartFirstFbsDraw(HttpServletRequest request, ModelMap model, FbsDrawForm fbsDrawForm) {
        String matchCode = request.getParameter("matchCode");
        FbsMatch fbsmatch = fbsDrawService.queryMatchByMatchCode(matchCode);
        try {
            model.addAttribute("fbsMatch", fbsmatch);
            fbsDrawForm.setMatchCode(matchCode);
            fbsDrawService.reDrawSteps(fbsDrawForm);
            model.addAttribute("matchStr", fbsmatch.getHomeTeam() + "VS" + fbsmatch.getGuestTeam());
            model.addAttribute("matchCode", matchCode);
            return LocaleUtil.getUserLocalePath("oms/fbs/fbsdraw/fbsDrawStep1", request);
        } catch (Exception e) {
            e.printStackTrace();
            return LocaleUtil.getUserLocalePath("oms/fbs/fbsdraw/_error", request);
        }
    }

    /*显示比赛结果*/
    @RequestMapping(params = "method=showFbsResult")
    public String showFbsResult(HttpServletRequest request, ModelMap model, FbsDrawForm fbsDrawForm) {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
        String matchCode = request.getParameter("matchCode");
        try {
            FbsResult result = fbsDrawService.queryMatchResultByCode(matchCode);

            FbsMatch fbsmatch = fbsDrawService.queryMatchByMatchCode(matchCode);
            fbsDrawForm.setIssueCode(fbsmatch.getMatchIssue());
            fbsDrawForm.setMatchCompCode(fbsmatch.getMatchCompCode());
            fbsDrawForm.setHomeTeamCode(fbsmatch.getHomeTeamCode());
            fbsDrawForm.setGuestTeamCode(fbsmatch.getGuestTeamCode());
            fbsDrawForm.setFirstDrawUserId(user.getId());
            fbsDrawForm.setScore310(fbsmatch.getScore310());
            fbsDrawForm.setScore30(fbsmatch.getScore30());

            fbsDrawForm.setFinalScoreTeam(result.getSecondScoreTeam());
            fbsDrawForm.setSecondfhHomeScore(result.getSecondfhHomeScore());
            fbsDrawForm.setSecondfhGuestScore(result.getSecondfhGuestScore());
            fbsDrawForm.setSecondshHomeScore(result.getSecondshHomeScore());
            fbsDrawForm.setSecondshGuestScore(result.getSecondshGuestScore());

            model.addAttribute("fbsMatch", fbsmatch);
            model.addAttribute("matchStr", fbsmatch.getHomeTeam() + "VS" + fbsmatch.getGuestTeam());
            model.addAttribute("issueCode", fbsmatch.getMatchIssue());
            model.addAttribute("fbsDrawForm", fbsDrawForm);
            model.addAttribute("firstGoalTeam",
                    fbsDrawForm.getFinalScoreTeam().equals
                            (String.valueOf(fbsmatch.getHomeTeamCode()))
                            ? fbsmatch.getHomeTeam() :
                            fbsmatch.getGuestTeam());
            model.addAttribute("firstGoalTeamCode", fbsDrawForm.getFinalScoreTeam());

            model.addAttribute("fullScore", fbsDrawForm.getSecondFullScore());
            model.addAttribute("fullScoreEum", fbsDrawForm.getFullScoreEnum());
            model.addAttribute("full30Result", fbsDrawForm.getSecondFullWinLosScore());
            model.addAttribute("full310Result", fbsDrawForm.getSecondFullWinLevelLosScore());
            model.addAttribute("hf310Result", fbsDrawForm.getSecondHalfFullScore());
            model.addAttribute("hfSingleDouble", fbsDrawForm.getSecondFhshSingleDouble());
            model.addAttribute("singleScore", fbsDrawForm.getSecondSingleScore());
            model.addAttribute("singleScoreEum", fbsDrawForm.getSingleScoreEnum());
            
            return LocaleUtil.getUserLocalePath("oms/fbs/fbsdraw/showFbsResult", request);
        } catch (Exception e) {
            e.printStackTrace();
            return LocaleUtil.getUserLocalePath("common/errorTip", request);
        }
    }


    /*将比赛结果发送给SERVER*/
    @RequestMapping(params = "method=submitFbsDraw2Server")
    public String submitFbsDraw2Server(HttpServletRequest request, ModelMap model, FbsDrawForm fbsDrawForm) {
        String matchCode = fbsDrawForm.getMatchCode();

        BaseMessageReq breq = new BaseMessageReq(12021, 2);
        FbsDrawReq12021 req = new FbsDrawReq12021();
        req.setGameCode(14l);
        req.setIssueNumber(Long.parseLong(fbsDrawForm.getIssueCode()));
        req.setMatchCode(Long.parseLong(matchCode));


        Map drawMap = new HashMap();
        if (fbsDrawForm.getSecondfhHomeScore() == 99) {
            drawMap.put(1, 99);
            drawMap.put(2, 99);
            drawMap.put(3, 99);
            drawMap.put(4, 99);
            drawMap.put(5, 99);
            drawMap.put(6, 99);
        } else {
            fbsDrawForm.getSecondFullWinLevelLosScore();
            drawMap.put(1, fbsDrawForm.getWinlevellosResultEnum());
            fbsDrawForm.getSecondFullWinLosScore();
            drawMap.put(2, fbsDrawForm.getWinlosResultEnum());
            fbsDrawForm.getSecondFullScore();
            drawMap.put(3, fbsDrawForm.getFullScoreEnum());
            fbsDrawForm.getSecondSingleScore();
            drawMap.put(4, fbsDrawForm.getSingleScoreEnum());
            fbsDrawForm.getSecondHalfFullScore();
            drawMap.put(5, fbsDrawForm.getHfwinlevellosResultEnum());
            fbsDrawForm.getSecondFhshSingleDouble();
            drawMap.put(6, fbsDrawForm.getHfSingleDoubleEnum());
        }
        req.setDrawResults(JSONArray.toJSONString(drawMap));

        Map matchResMap = new HashMap();
        if (fbsDrawForm.getSecondfhHomeScore() == 99) {
            matchResMap.put(0, 99);
            matchResMap.put(1, 99);
            matchResMap.put(2, 99);
            matchResMap.put(3, 99);
            matchResMap.put(4, 99);
            matchResMap.put(5, 99);
            matchResMap.put(6, 99);
            matchResMap.put(7, 99);
        } else {
            matchResMap.put(0, returnFormatResult(get310Result(fbsDrawForm.getSecondfhHomeScore(), fbsDrawForm.getSecondfhGuestScore())));
            matchResMap.put(1, fbsDrawForm.getSecondfhHomeScore());
            matchResMap.put(2, fbsDrawForm.getSecondfhGuestScore());
            matchResMap.put(3, returnFormatResult(get310Result(fbsDrawForm.getSecondshHomeScore(), fbsDrawForm.getSecondshGuestScore())));
            matchResMap.put(4, fbsDrawForm.getSecondshHomeScore());
            matchResMap.put(5, fbsDrawForm.getSecondshGuestScore());
            matchResMap.put(6, returnFormatResult(get310Result(fbsDrawForm.getSecondfhHomeScore() + fbsDrawForm.getSecondshHomeScore(),
                    fbsDrawForm.getSecondfhGuestScore() + fbsDrawForm.getSecondshGuestScore())));
            matchResMap.put(7, fbsDrawForm.getFinalScoreTeam().equals(String.valueOf(fbsDrawForm.getHomeTeamCode())) ? 1 : 2);

        }
        req.setMatchResult(JSONArray.toJSONString(matchResMap));

        breq.setParams(req);
        long seq = this.logService.getNextSeq();
        breq.setMsn(seq);
        String json = JSONObject.toJSONString(breq);

        logger.debug("向主机发送请求，请求内容：" + json);
        String resJson = HttpClientUtils.postString(PropertiesUtil.readValue("url_host"), json);
        logger.debug("接收到主机的响应，消息内容：" + resJson);
        FbsDrawRsp12022 res = JSON.parseObject(resJson, FbsDrawRsp12022.class);

        int status = res.getRc();
        logger.info("select ticket return status=" + status + ",Is tsn err=" + status);

        model.addAttribute("matchStr", fbsDrawForm.getHomeTeam() + "VS" + fbsDrawForm.getGuestTeam());
        model.addAttribute("matchCode", matchCode);
        try {
            if (status == ResustConstant.OMS_RESULT_TICKET_TSN_ERR ||
                    status == ResustConstant.OMS_RESULT_FAILURE ||
                    status == ResustConstant.OMS_RESULT_BUSY_ERR) {
                return LocaleUtil.getUserLocalePath("oms/fbs/fbsdraw/_error2", request);
            } else {
                boolean flag = fbsDrawService.updateMatchResultSent(fbsDrawForm);
                if (flag) {
                    return LocaleUtil.getUserLocalePath("oms/fbs/fbsdraw/fbsDrawStep4", request);
                } else {
                    return LocaleUtil.getUserLocalePath("oms/fbs/fbsdraw/_error2", request);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return LocaleUtil.getUserLocalePath("oms/fbs/fbsdraw/_error2", request);
        }
    }

    /*等待比赛结果被server更新*/
    @ResponseBody
    @RequestMapping(params = "method=queryMatchStatus")
    public String queryMatchStatus(HttpServletRequest request, ModelMap model) {
        String matchCode = request.getParameter("matchCode");
        FbsMatch fbsmatch = fbsDrawService.queryMatchByMatchCode(matchCode);
        model.addAttribute("fbsMatch", fbsmatch);
        return JSONArray.toJSON(fbsmatch).toString();
    }

    /*查询出算奖结果*/
    @RequestMapping(params = "method=queryDrawResult")
    public String queryDrawResult(HttpServletRequest request, ModelMap model, FbsDrawForm fbsDrawForm) {
        String matchCode = request.getParameter("matchCode");
        FbsMatch fbsmatch = fbsDrawService.queryMatchByMatchCode(matchCode);
        model.addAttribute("fbsMatch", fbsmatch);
        Long poolAmount = fbsDrawService.queryGamePoolAmount(14l);
        model.addAttribute("poolAmount", poolAmount);
        List<FbsMatchDraw> fbsMatchDraw = fbsDrawService.queryMatchResult(matchCode);
        model.addAttribute("fbsMatchDraw", fbsMatchDraw);
        return LocaleUtil.getUserLocalePath("oms/fbs/fbsdraw/fbsDrawStep5", request);
    }

    /*重新开奖*/
    @RequestMapping(params = "method=reDrawSteps")
    public String reDrawSteps(HttpServletRequest request, ModelMap model, FbsDrawForm fbsDrawForm) {
        String matchCode = request.getParameter("matchCode");
        fbsDrawForm.setMatchCode(matchCode);
        fbsDrawService.reDrawSteps(fbsDrawForm);
        return "redirect:/fbsDraw.do?method=initFbsDraw";
    }

    /*结束开奖流程,发送开奖确认*/
    @RequestMapping(params = "method=finishDrawSteps")
    public String finishDrawSteps(HttpServletRequest request, ModelMap model, FbsDrawForm fbsDrawForm) {
        String matchCode = request.getParameter("matchCode");
        FbsMatch fbsmatch = fbsDrawService.queryMatchByMatchCode(matchCode);
        String issusNum = request.getParameter("issueCode");

        model.addAttribute("matchStr", fbsmatch.getHomeTeam() + "VS" + fbsmatch.getGuestTeam());
        model.addAttribute("matchCode", matchCode);

        BaseMessageReq breq = new BaseMessageReq(12023, 2);
        DrawConfirmReq12023 req = new DrawConfirmReq12023();
        req.setGameCode(14l);
        req.setIssueNumber(Long.parseLong(issusNum));
        req.setMatchCode(Long.parseLong(matchCode));

        breq.setParams(req);
        long seq = this.logService.getNextSeq();
        breq.setMsn(seq);
        String json = JSONObject.toJSONString(breq);

        logger.debug("向主机发送请求，请求内容：" + json);
        String resJson = HttpClientUtils.postString(PropertiesUtil.readValue("url_host"), json);
        logger.debug("接收到主机的响应，消息内容：" + resJson);
        DrawConfirmRsp12024 res = JSON.parseObject(resJson, DrawConfirmRsp12024.class);

        int status = res.getRc();
        logger.info("select ticket return status=" + status + ",Is tsn err=" + status);

        try {
            if (status == ResustConstant.OMS_RESULT_TICKET_TSN_ERR ||
                    status == ResustConstant.OMS_RESULT_FAILURE ||
                    status == ResustConstant.OMS_RESULT_BUSY_ERR) {
                return LocaleUtil.getUserLocalePath("oms/fbs/fbsdraw/_error2", request);
            } else {
                fbsDrawForm.setMatchCode(matchCode);
                boolean flag = fbsDrawService.finishDraw(fbsDrawForm);
                if (flag) {
                    model.addAttribute("matchCode", matchCode);
                    model.addAttribute("fbsMatch", fbsmatch);
                    return LocaleUtil.getUserLocalePath("oms/fbs/fbsdraw/fbsDrawStep6", request);
                } else {
                    return LocaleUtil.getUserLocalePath("oms/fbs/fbsdraw/_error2", request);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return LocaleUtil.getUserLocalePath("oms/fbs/fbsdraw/_error2", request);
        }
    }

    /*结束开奖流程,更新开奖状态为完毕*/
    @ResponseBody
    @RequestMapping(params = "method=finishFbsDraw")
    public String finishFbsDraw(HttpServletRequest request, ModelMap model, FbsDrawForm fbsDrawForm) {
        String matchCode = request.getParameter("matchCode");
        model.addAttribute("matchCode", matchCode);
        FbsMatch fbsmatch = fbsDrawService.queryMatchByMatchCode(matchCode);
        fbsDrawService.updateMatch2Finish(matchCode);
        return JSONArray.toJSON(fbsmatch).toString();
    }

    /*开奖公告*/
    @RequestMapping(params = "method=fbsDrawNotice")
    public String fbsDrawNotice(HttpServletRequest request, ModelMap model, FbsDrawForm fbsDrawForm) {
        String matchCode = request.getParameter("matchCode");
        String issueCode = request.getParameter("issueCode");
        model.addAttribute("matchCode", matchCode);
        model.addAttribute("issueCode", issueCode);
        FbsMatch fbsmatch = fbsDrawService.queryMatchByMatchCode(matchCode);
        String matchStr = fbsmatch.getMatchComp() + "  " + fbsmatch.getHomeTeam() + " VS " + fbsmatch.getGuestTeam();
        model.addAttribute("matchStr", matchStr);
        model.addAttribute("fbsmatch", fbsmatch);
        List<FbsMatchDraw> fbsMatchDraw = fbsDrawService.queryMatchResult(matchCode);
        model.addAttribute("fbsMatchDraw", fbsMatchDraw);
        return LocaleUtil.getUserLocalePath("oms/fbs/fbsdraw/fbsDrawPrint", request);
    }

    /*实时数据*/
    @RequestMapping(params = "method=queryMatchMessage")
    public String queryMatchMessage(HttpServletRequest request, ModelMap model, FbsDrawForm fbsDrawForm) {
        String matchCode = request.getParameter("matchCode");
        String matchJson = fbsDrawService.queryMatchMessage(matchCode);
        if (matchJson != null && !("").equals(matchJson)) {
            JSONObject json = JSON.parseObject(matchJson);
            JSONObject jsonWIN = json.getJSONObject("WIN");

            JSONArray arrayWin = jsonWIN.getJSONArray("list");
            if (arrayWin != null) {
                for (int i = 0; i < arrayWin.size(); i++) {
                    JSONObject jsonObj = (JSONObject) arrayWin.get(i);
                    if (jsonObj.getInteger("ret") == 1) {
                        jsonObj.put("ret", "3");
                    } else if (jsonObj.getInteger("ret") == 2) {
                        jsonObj.put("ret", "1");
                    } else if (jsonObj.getInteger("ret") == 3) {
                        jsonObj.put("ret", "0");
                    } else {
                        jsonObj.put("ret", "-");
                    }
                }
            }

            JSONObject jsonHCP = json.getJSONObject("HCP");

            JSONArray arrayHcp = jsonHCP.getJSONArray("list");
            if (arrayHcp != null) {
                for (int i = 0; i < arrayHcp.size(); i++) {
                    JSONObject jsonObj = (JSONObject) arrayHcp.get(i);
                    if (jsonObj.getInteger("ret") == 1) {
                        jsonObj.put("ret", "3");
                    } else if (jsonObj.getInteger("ret") == 2) {
                        jsonObj.put("ret", "0");
                    } else {
                        jsonObj.put("ret", "-");
                    }
                }
            }

            JSONObject jsonTOT = json.getJSONObject("TOT");

            JSONArray arrayTOT = jsonTOT.getJSONArray("list");
            if (arrayTOT != null) {
                for (int i = 0; i < arrayTOT.size(); i++) {
                    JSONObject jsonObj = (JSONObject) arrayTOT.get(i);
                    if (jsonObj.getInteger("ret") == 1) {
                        jsonObj.put("ret", "0");
                    } else if (jsonObj.getInteger("ret") == 2) {
                        jsonObj.put("ret", "1");
                    } else if (jsonObj.getInteger("ret") == 3) {
                        jsonObj.put("ret", "2");
                    } else if (jsonObj.getInteger("ret") == 4) {
                        jsonObj.put("ret", "3");
                    } else if (jsonObj.getInteger("ret") == 5) {
                        jsonObj.put("ret", "4");
                    } else if (jsonObj.getInteger("ret") == 6) {
                        jsonObj.put("ret", "5");
                    } else if (jsonObj.getInteger("ret") == 7) {
                        jsonObj.put("ret", "6");
                    } else if (jsonObj.getInteger("ret") == 8) {
                        jsonObj.put("ret", "7+");
                    } else if (jsonObj.getInteger("ret") == 9) {
                        jsonObj.put("ret", "-");
                    }

                }
            }

            JSONObject jsonSCR = json.getJSONObject("SCR");

            JSONArray arraySCR = jsonSCR.getJSONArray("list");
            if (arraySCR != null) {
                for (int i = 0; i < arraySCR.size(); i++) {
                    JSONObject jsonObj = (JSONObject) arraySCR.get(i);
                    if (jsonObj.getInteger("ret") == 1) {
                        jsonObj.put("ret", "1:0");
                    } else if (jsonObj.getInteger("ret") == 2) {
                        jsonObj.put("ret", "2:0");
                    } else if (jsonObj.getInteger("ret") == 3) {
                        jsonObj.put("ret", "2:1");
                    } else if (jsonObj.getInteger("ret") == 4) {
                        jsonObj.put("ret", "3:0");
                    } else if (jsonObj.getInteger("ret") == 5) {
                        jsonObj.put("ret", "3:1");
                    } else if (jsonObj.getInteger("ret") == 6) {
                        jsonObj.put("ret", "3:2");
                    } else if (jsonObj.getInteger("ret") == 7) {
                        jsonObj.put("ret", "4:0");
                    } else if (jsonObj.getInteger("ret") == 8) {
                        jsonObj.put("ret", "4:1");
                    } else if (jsonObj.getInteger("ret") == 9) {
                        jsonObj.put("ret", "4:2");
                    } else if (jsonObj.getInteger("ret") == 10) {
                        jsonObj.put("ret", "HomeWinOther");
                    } else if (jsonObj.getInteger("ret") == 11) {
                        jsonObj.put("ret", "0:0");
                    } else if (jsonObj.getInteger("ret") == 12) {
                        jsonObj.put("ret", "1:1");
                    } else if (jsonObj.getInteger("ret") == 13) {
                        jsonObj.put("ret", "2:2");
                    } else if (jsonObj.getInteger("ret") == 14) {
                        jsonObj.put("ret", "3:3");
                    } else if (jsonObj.getInteger("ret") == 15) {
                        jsonObj.put("ret", "DrawOther");
                    } else if (jsonObj.getInteger("ret") == 16) {
                        jsonObj.put("ret", "0:1");
                    } else if (jsonObj.getInteger("ret") == 17) {
                        jsonObj.put("ret", "0:2");
                    } else if (jsonObj.getInteger("ret") == 18) {
                        jsonObj.put("ret", "1:2");
                    } else if (jsonObj.getInteger("ret") == 19) {
                        jsonObj.put("ret", "0:3");
                    } else if (jsonObj.getInteger("ret") == 20) {
                        jsonObj.put("ret", "1:3");
                    } else if (jsonObj.getInteger("ret") == 21) {
                        jsonObj.put("ret", "2:3");
                    } else if (jsonObj.getInteger("ret") == 22) {
                        jsonObj.put("ret", "0:4");
                    } else if (jsonObj.getInteger("ret") == 23) {
                        jsonObj.put("ret", "1:4");
                    } else if (jsonObj.getInteger("ret") == 24) {
                        jsonObj.put("ret", "2:4");
                    } else if (jsonObj.getInteger("ret") == 25) {
                        jsonObj.put("ret", "AwayWinOther");
                    } else if (jsonObj.getInteger("ret") == 26) {
                        jsonObj.put("ret", "-");
                    }
                }
            }

            JSONObject jsonHFT = json.getJSONObject("HFT");

            JSONArray arrayHFT = jsonHFT.getJSONArray("list");
            if (arrayTOT != null) {
                for (int i = 0; i < arrayHFT.size(); i++) {
                    JSONObject jsonObj = (JSONObject) arrayHFT.get(i);
                    if (jsonObj.getInteger("ret") == 1) {
                        jsonObj.put("ret", "3-3");
                    } else if (jsonObj.getInteger("ret") == 2) {
                        jsonObj.put("ret", "3-1");
                    } else if (jsonObj.getInteger("ret") == 3) {
                        jsonObj.put("ret", "3-0");
                    } else if (jsonObj.getInteger("ret") == 4) {
                        jsonObj.put("ret", "1-3");
                    } else if (jsonObj.getInteger("ret") == 5) {
                        jsonObj.put("ret", "1-1");
                    } else if (jsonObj.getInteger("ret") == 6) {
                        jsonObj.put("ret", "1-0");
                    } else if (jsonObj.getInteger("ret") == 7) {
                        jsonObj.put("ret", "0-3");
                    } else if (jsonObj.getInteger("ret") == 8) {
                        jsonObj.put("ret", "0-1");
                    } else if (jsonObj.getInteger("ret") == 9) {
                        jsonObj.put("ret", "0-0");
                    } else if (jsonObj.getInteger("ret") == 10) {
                        jsonObj.put("ret", "-");
                    }
                }
            }

            JSONObject jsonOUOD = json.getJSONObject("OUOD");

            model.addAttribute("jsonWIN", jsonWIN);
            model.addAttribute("jsonHCP", jsonHCP);
            model.addAttribute("jsonTOT", jsonTOT);
            model.addAttribute("jsonSCR", jsonSCR);
            model.addAttribute("jsonHFT", jsonHFT);
            model.addAttribute("jsonOUOD", jsonOUOD);
            return LocaleUtil.getUserLocalePath("oms/fbs/fbsdraw/fbsMatchMessage", request);
        } else {
            return LocaleUtil.getUserLocalePath("oms/fbs/fbsdraw/emptyData", request);
        }
    }


}
