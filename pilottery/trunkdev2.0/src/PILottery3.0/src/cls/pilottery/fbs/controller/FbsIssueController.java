package cls.pilottery.fbs.controller;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.*;
import cls.pilottery.fbs.form.FbsIssueForm;
import cls.pilottery.fbs.form.FbsMatchForm;
import cls.pilottery.fbs.model.FbsIssue;
import cls.pilottery.fbs.model.FbsMatch;
import cls.pilottery.fbs.msg.PublishIssueReq12007;
import cls.pilottery.fbs.msg.PublishIssueRsp12008;
import cls.pilottery.fbs.service.FbsIssueService;
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

import static java.lang.System.out;

/**
 * Created by Reno Main on 2016/6/1.
 */
@Controller
@RequestMapping("/fbsIssue")
public class FbsIssueController {

    private Logger logger = Logger.getLogger(FbsIssueController.class);

    @Autowired
    private FbsIssueService fbsIssueService;
    @Autowired
    private LogService logService;


    @RequestMapping(params = "method=listFbsIssue")
    public String queryFbsIssueList(HttpServletRequest request, ModelMap model, FbsIssueForm fbsIssueForm) {

        Integer listCount = fbsIssueService.queryFbsIssueCount(fbsIssueForm);
        List<FbsIssue> fbsIssueList = new ArrayList<FbsIssue>();
        int pageIndex = PageUtil.getPageIndex(request);
        if (listCount != null && listCount > 0) {
            fbsIssueForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
            fbsIssueForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
            fbsIssueList = fbsIssueService.queryFbsIssueList(fbsIssueForm);
        }
        model.addAttribute("pageDataList", fbsIssueList);
        model.addAttribute("pageStr", PageUtil.getPageStr(request, listCount));
        model.addAttribute("fbsIssueForm", fbsIssueForm);
        return LocaleUtil.getUserLocalePath("oms/fbs/fbsissue/fbsissuelist", request);
    }

    @RequestMapping(params = "method=issueAdd")
    public String releaseNewFbsIssue(HttpServletRequest request, ModelMap model) {
        int maxIssue = fbsIssueService.getMaxIssueNumber();
        Date maxIssueCodeDate = fbsIssueService.getMaxIssueDate();
        Calendar now = Calendar.getInstance();
        String yearStr = String.valueOf(now.get(Calendar.YEAR));
        if (maxIssue == 0) {
            maxIssue = Integer.parseInt(yearStr + "0001");
            model.addAttribute("maxIssue", maxIssue);
        } else {
            String maxIssueStr = String.valueOf(maxIssue);
            if (!maxIssueStr.substring(0, 4).equals(yearStr)) {
                maxIssue = Integer.parseInt(yearStr + "0001");
                model.addAttribute("maxIssue", maxIssue);
            } else {
                model.addAttribute("maxIssue", maxIssue + 1);
            }
        }
        model.addAttribute("maxIssueCodeDate", DateUtil.getDateTime("yyyy-MM-dd", maxIssueCodeDate) + " 24:00:00");
        return LocaleUtil.getUserLocalePath("oms/fbs/fbsissue/fbsIssueAdd", request);
    }

    public static void main(String args[]) {
        Integer maxIssue = 20160101;

        Calendar now = Calendar.getInstance();
        String yearStr = String.valueOf(now.get(Calendar.YEAR));
        String maxIssueStr = String.valueOf(maxIssue);
        if (!maxIssueStr.substring(0, 4).equals(yearStr)) {
            maxIssue = Integer.parseInt(yearStr + "0001");
        } else {
            maxIssue = maxIssue+1;
        }
        out.println("maxIssue=" + maxIssue);
    }


    @RequestMapping(params = "method=submitAdd")
    public String submitReleaseFbsIssue(HttpServletRequest request, ModelMap model,
                                        FbsIssueForm fbsIssueForm) {
        try {
            fbsIssueService.insertFbsIssue(fbsIssueForm);
            return LocaleUtil.getUserLocalePath("common/successTip", request);
        } catch (Exception e) {
            e.printStackTrace();
            return LocaleUtil.getUserLocalePath("common/errorTip", request);
        }
    }

    @RequestMapping(params = "method=detailIssue")
    public String queryIssueDetails(HttpServletRequest request, ModelMap model, FbsMatchForm fbsMatchForm) {
        String issueNumber = request.getParameter("fbsIssueNumber");
        Long issueCode = Long.parseLong(issueNumber);

        fbsMatchForm.setIssueCode(issueNumber);

        FbsIssue fbsIssue = fbsIssueService.queryFbsIssueByIssueCode(issueCode);

        Integer matchCount = fbsIssueService.queryIssueMatchCount(fbsMatchForm);

        int pageIndex = PageUtil.getPageIndex(request);
        List<FbsMatch> fbsMatchList = new ArrayList<FbsMatch>();
        if (matchCount != null && matchCount > 0) {
            PageUtil.pageSize = 10;
            fbsMatchForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
            fbsMatchForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);

            fbsMatchList = fbsIssueService.queryIssueMatchList(fbsMatchForm);
        }
        //期次编号
        model.addAttribute("issueNumber", issueNumber);
        //期次开始时间
        model.addAttribute("issueTime", fbsIssue.getFbsIssueStart());

        model.addAttribute("pageDataList", fbsMatchList);
        model.addAttribute("pageStr", PageUtil.getPageStr(request, matchCount));
        model.addAttribute("matchForm", fbsMatchForm);

        return LocaleUtil.getUserLocalePath("oms/fbs/fbsissue/issueDetail", request);
    }


    @RequestMapping(params = "method=updateIssue")
    public String updateIssueDetails(HttpServletRequest request, ModelMap model) {
        String issueNumber = request.getParameter("fbsIssueNumber");

        Date maxIssueCodeDate = fbsIssueService.getMaxIssueDate();

        Long issueCode = Long.parseLong(issueNumber);

        FbsIssue fbsIssue = fbsIssueService.queryFbsIssueByIssueCode(issueCode);
        String newDate = fbsIssue.getFbsIssueDate().substring(0, 4) + "-" +
                fbsIssue.getFbsIssueDate().substring(4, 6) + "-" + fbsIssue.getFbsIssueDate().substring(6);
        fbsIssue.setFbsIssueDate(newDate);
        //期次编号
        model.addAttribute("fbsIssue", fbsIssue);

        model.addAttribute("maxIssueCodeDate", DateUtil.convertDateToString(maxIssueCodeDate));
        return LocaleUtil.getUserLocalePath("oms/fbs/fbsissue/issueUpdate", request);
    }

    @RequestMapping(params = "method=submitUpdate")
    public String submitUpdateIssue(HttpServletRequest request, ModelMap model, FbsIssueForm fbsIssueForm) {
        try {
            fbsIssueService.updateFbsIssue(fbsIssueForm);
            return LocaleUtil.getUserLocalePath("common/successTip", request);
        } catch (Exception e) {
            e.printStackTrace();
            return LocaleUtil.getUserLocalePath("common/errorTip", request);
        }
    }

    @RequestMapping(params = "method=joinMatch")
    public String editMatch2Issue(HttpServletRequest request, ModelMap model, FbsMatchForm fbsMatchForm) {
        String issueNumber = request.getParameter("fbsIssueNumber");
        String issueStart = request.getParameter("issueStart");
        String issueEnd = request.getParameter("issueEnd");
        fbsMatchForm.setIssueCode(issueNumber);

        Integer matchCount = fbsIssueService.queryIssueMatchCount(fbsMatchForm);

        int pageIndex = PageUtil.getPageIndex(request);
        List<FbsMatch> fbsMatchList = new ArrayList<FbsMatch>();
        if (matchCount != null && matchCount > 0) {
            PageUtil.pageSize = 10;
            fbsMatchForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
            fbsMatchForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);

            fbsMatchList = fbsIssueService.queryIssueMatchList(fbsMatchForm);
        }

        model.addAttribute("issueNumber", issueNumber);
        model.addAttribute("issueStart", issueStart);
        model.addAttribute("issueEnd", issueEnd);

        model.addAttribute("pageDataList", fbsMatchList);
        model.addAttribute("pageStr", PageUtil.getPageStr(request, matchCount));
        model.addAttribute("matchForm", fbsMatchForm);

        return LocaleUtil.getUserLocalePath("oms/fbs/fbsissue/joinMatch", request);
    }

    @ResponseBody
    @RequestMapping(params = "method=deleteIssue")
    public String deleteFbsIssue(HttpServletRequest request) {
        String issueNumber = request.getParameter("fbsIssueNumber");
        Long issueCode = Long.parseLong(issueNumber);
        Map map = new HashMap();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
        UserLanguage lg = user.getUserLang();
        try {
            fbsIssueService.deleteFbsIssue(issueCode);
            map.put("msg", "");
            return JSONArray.toJSONString(map);
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
            return JSONArray.toJSONString(map);
        }
    }


    @ResponseBody
    @RequestMapping(params = "method=piblishIssue")
    public String publishFbsIssue(HttpServletRequest request) {
        String issueNumber = request.getParameter("fbsIssueNumber");
        Long issueCode = Long.parseLong(issueNumber);
        Map map = new HashMap();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
        UserLanguage lg = user.getUserLang();

        boolean flag = fbsIssueService.checkIssueCode(issueCode);
        if (flag) {
            try {
                if (lg == UserLanguage.ZH) {
                    String message = "请按次序发布期次";
                    map.put("msg", URLEncoder.encode(message, "utf-8"));

                } else if (lg == UserLanguage.EN) {
                    String message = "Please publish issue with the right sequence";
                    map.put("msg", URLEncoder.encode(message, "utf-8"));
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {

            BaseMessageReq breq = new BaseMessageReq(12007, 2);
            PublishIssueReq12007 req = new PublishIssueReq12007();
            req.setGameCode(14l);
            breq.setParams(req);
            long seq = this.logService.getNextSeq();
            breq.setMsn(seq);
            String json = JSONObject.toJSONString(breq);

            logger.debug("向主机发送请求，请求内容：" + json);
            String resJson = HttpClientUtils.postString(PropertiesUtil.readValue("url_host"), json);
            logger.debug("接收到主机的响应，消息内容：" + resJson);
            PublishIssueRsp12008 res = JSON.parseObject(resJson, PublishIssueRsp12008.class);

            int status = res.getRc();
            logger.info("select ticket return status=" + status + ",Is tsn err=" + status);

            try {
                if (status == ResustConstant.OMS_RESULT_TICKET_TSN_ERR ||
                        status == ResustConstant.OMS_RESULT_FAILURE ||
                        status == ResustConstant.OMS_RESULT_BUSY_ERR) {
                    if (lg == UserLanguage.ZH) {
                        String message = "失败";
                        map.put("msg", URLEncoder.encode(message, "utf-8"));

                    } else if (lg == UserLanguage.EN) {
                        String message = "Fail";
                        map.put("msg", URLEncoder.encode(message, "utf-8"));
                    }
                } else {
                    fbsIssueService.publishFbsIssue(issueCode);
                    map.put("msg", "");
                    return JSONArray.toJSONString(map);
                }
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
        }
        return JSONArray.toJSONString(map);
    }


}