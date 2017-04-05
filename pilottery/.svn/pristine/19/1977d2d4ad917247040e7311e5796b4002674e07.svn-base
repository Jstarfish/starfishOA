package cls.taishan.web.report.controller;

import cls.taishan.common.entity.BasePageResult;
import cls.taishan.common.utils.LocaleUtil;
import cls.taishan.system.form.UserForm;
import cls.taishan.system.model.*;
import cls.taishan.system.service.UserService;
import cls.taishan.web.order.model.Game;
import cls.taishan.web.order.service.OrderService;
import cls.taishan.web.report.form.ReportForm;
import cls.taishan.web.report.model.DayReport;
import cls.taishan.web.report.model.Dealer;
import cls.taishan.web.report.model.IssueChlReport;
import cls.taishan.web.report.model.IssueSysReport;
import cls.taishan.web.report.model.MonthReport;
import cls.taishan.web.report.service.ReportService;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * Created by Reno Main on 2016/10/9.
 */
@Controller
@RequestMapping("/report")
public class ReportController {
    @Autowired
    private ReportService reportService;

    @Autowired
	private OrderService orderService;
    
    @RequestMapping(params = "method=loadDayReport")
    public String loadDayReport(HttpServletRequest request , ModelMap model) {
        List<Dealer> dealerList = reportService.queryDealerList();
        model.addAttribute("dealerList",dealerList);
        return LocaleUtil.getUserLocalePath("report/dayReport", request);
    }

    @ResponseBody
    @RequestMapping(params = "method=dayReport")
    public Object dayReportList(HttpServletRequest request , ModelMap model , ReportForm reportForm) {
        int totalCount = reportService.getChannelDayCount(reportForm);
        BasePageResult<DayReport> result = new BasePageResult<DayReport>();
        if(totalCount > 0){
                reportForm.setBeginNum(((reportForm.getPageindex()-1)*reportForm.getPageSize()));
                reportForm.setEndNum((reportForm.getPageindex()*reportForm.getPageSize()));
            }else{
            	reportForm.setBeginNum(0);
            	reportForm.setEndNum(0);
            }
            List<DayReport> dayReport = reportService.getChannelDayReport(reportForm);
            result.setTotalCount(totalCount);
            result.setResult(dayReport);
        return result;
    }

    @RequestMapping(params = "method=loadMonthReport")
    public String loadMonthReport(HttpServletRequest request , ModelMap model) {
        List<Dealer> dealerList = reportService.queryDealerList();
        model.addAttribute("dealerList",dealerList);
        return LocaleUtil.getUserLocalePath("report/monthReport", request);
    }

    @ResponseBody
    @RequestMapping(params = "method=monthReport")
    public Object monthReportList(HttpServletRequest request , ModelMap model , ReportForm reportForm) {
        int totalCount = reportService.getChannelMonthCount(reportForm);
        BasePageResult<MonthReport> result = new BasePageResult<MonthReport>();
        if(totalCount > 0){
                reportForm.setBeginNum(((reportForm.getPageindex()-1)*reportForm.getPageSize()));
                reportForm.setEndNum((reportForm.getPageindex()*reportForm.getPageSize()));
            }else{
            	reportForm.setBeginNum(0);
            	reportForm.setEndNum(0);
            }
            List<MonthReport> monthReport = reportService.getChannelMonthReport(reportForm);
            result.setTotalCount(totalCount);
            result.setResult(monthReport);
        return result;
    }

    @RequestMapping(params = "method=loadIssueChl")
    public String loadIssueChl(HttpServletRequest request , ModelMap model) {
        List<Dealer> dealerList = reportService.queryDealerList();
        model.addAttribute("dealerList",dealerList);
        List<Game> gameList = orderService.getGameList();
    	model.addAttribute("gameList",gameList);
        return LocaleUtil.getUserLocalePath("report/issueChlReport", request);
    }

    @ResponseBody
    @RequestMapping(params = "method=issueChlReport")
    public Object issueChlList(HttpServletRequest request , ModelMap model , ReportForm reportForm) {
        int totalCount = reportService.getIssueChlCount(reportForm);
        BasePageResult<IssueChlReport> result = new BasePageResult<IssueChlReport>();
        if(totalCount > 0){
                reportForm.setBeginNum(((reportForm.getPageindex()-1)*reportForm.getPageSize()));
                reportForm.setEndNum((reportForm.getPageindex()*reportForm.getPageSize()));
            }else{
            	reportForm.setBeginNum(0);
            	reportForm.setEndNum(0);
            }
            List<IssueChlReport> issueChlReport = reportService.getIssueChlReport(reportForm);
            result.setTotalCount(totalCount);
            result.setResult(issueChlReport);
            return result;
    }

    @RequestMapping(params = "method=loadIssueSys")
    public String loadIssueSys(HttpServletRequest request , ModelMap model) {
    	List<Game> gameList = orderService.getGameList();
    	model.addAttribute("gameList",gameList);
        return LocaleUtil.getUserLocalePath("report/issueSysReport", request);
    }

    @ResponseBody
    @RequestMapping(params = "method=issueSysReport")
    public Object issueSysList(HttpServletRequest request , ModelMap model , ReportForm reportForm) {
        int totalCount = reportService.getIssueSysCount(reportForm);
        BasePageResult<IssueSysReport> result = new BasePageResult<IssueSysReport>();
        if(totalCount > 0){
                reportForm.setBeginNum(((reportForm.getPageindex()-1)*reportForm.getPageSize()));
                reportForm.setEndNum((reportForm.getPageindex()*reportForm.getPageSize()));
            }else{
            	reportForm.setBeginNum(0);
                reportForm.setEndNum(0);
            }
            List<IssueSysReport> report = reportService.getIssueSysReport(reportForm);
            result.setTotalCount(totalCount);
            result.setResult(report);
        return result;
    }
}
