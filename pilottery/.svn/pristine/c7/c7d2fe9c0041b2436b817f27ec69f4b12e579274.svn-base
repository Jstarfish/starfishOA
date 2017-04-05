package cls.pilottery.web.report.controller;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.web.report.form.MonthlyReportForm;
import cls.pilottery.web.report.model.InstitutionModel;
import cls.pilottery.web.report.model.MonthlyReportVo;
import cls.pilottery.web.report.service.MonthlyReportService;
import cls.pilottery.web.report.service.SaleReportService;
import cls.pilottery.web.system.model.User;
import jxl.common.Logger;
@Controller
@RequestMapping("monthlyReport")
public class MonthlyReportController {
	
	static Logger log = Logger.getLogger(MonthlyReportController.class);
	
	@Autowired
	private MonthlyReportService monthlyReportService;
	
	@Autowired
	private SaleReportService saleReportService;
	
	/**
	 * @description:部门销售月报表
	 * @exception:
	 * @author: star
	 * @time:2016年8月8日 下午2:23:32
	 */
	private static Date getLastDate(Date date) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        cal.add(Calendar.MONTH, -1);
        return cal.getTime();
    }
	@RequestMapping(params = "method=listInstMonthlyReport")
	public String getInstitutionFundMonthlyReport(HttpServletRequest request,ModelMap model,MonthlyReportForm form){
		
		try {
			User currentUser = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			form.setCuserOrg(currentUser.getInstitutionCode());
			if(form == null || StringUtils.isEmpty(form.getBeginDate())){
				Date date = new Date();
				String defaultDate = (new SimpleDateFormat("yyyy-MM")).format(getLastDate(date));
				form.setBeginDate(defaultDate);
				form.setEndDate(defaultDate);
				form.setTjType(0);
			}
			//modify 增加登录人管辖区域的数据权限
			List<InstitutionModel> institutionList = null;
			if(currentUser.getInstitutionCode().equals("00")){
				institutionList = saleReportService.getInstitutionList(currentUser.getInstitutionCode());
			}else{
				institutionList = saleReportService.getManageOrgsByUserId(currentUser.getId().intValue());
			}
			model.addAttribute("institutionList",institutionList);
			List<MonthlyReportVo> list = monthlyReportService.getInstitutionFundList(form);
			model.addAttribute("list", list);
			if(list != null && list.size() > 0){
				MonthlyReportVo sum = monthlyReportService.getInstitutionFundSum(form);
				model.addAttribute("sum", sum);
			}
			model.addAttribute("form",form);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("部门销售月结报表发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("report/monthlyReport/institutionFundMonthlyReport", request);
	}
	
	/**
	 * @description:站点销售月报表
	 * @exception:
	 * @author: star
	 * @time:2016年8月8日 下午2:27:23
	 */
	@RequestMapping(params="method=listOutletMonthlyReport")
	public String getAgencyFundMonthlyReport(HttpServletRequest request,ModelMap model,MonthlyReportForm form){
		try {
			User currentUser = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			form.setCuserOrg(currentUser.getInstitutionCode());
			if(form == null || StringUtils.isEmpty(form.getBeginDate())){
				Date date = new Date();
				String defaultDate = (new SimpleDateFormat("yyyy-MM")).format(getLastDate(date));
				form.setBeginDate(defaultDate);
				form.setEndDate(defaultDate);
				form.setTjType(0);
			}
			List<MonthlyReportVo> list = monthlyReportService.getAgencyFundList(form);
			model.addAttribute("list", list);
			if(list != null && list.size() > 0){
				MonthlyReportVo sum = monthlyReportService.getAgencyFundSum(form);
				model.addAttribute("sum", sum);
			}
			//modify 增加登录人管辖区域的数据权限
			List<InstitutionModel> institutionList = null;
			if(currentUser.getInstitutionCode().equals("00")){
				institutionList = saleReportService.getInstitutionList(currentUser.getInstitutionCode());
			}else{
				institutionList = saleReportService.getManageOrgsByUserId(currentUser.getId().intValue());
			}
			model.addAttribute("institutionList",institutionList);
			model.addAttribute("form",form);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("站点销售月结报表发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("report/monthlyReport/agencyFundMonthlyReport", request);
	}

	/**
	 * 
	 * @description:市场管理员销售月报表
	 * @exception:
	 * @author: star
	 * @time:2016年8月8日 下午2:38:23
	 */
	@RequestMapping(params = "method=listMktManagerMonthlyReport")
	public String getcFundMonthlyReport(HttpServletRequest request,ModelMap model,MonthlyReportForm form){
		try {
			User currentUser = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			form.setCuserOrg(currentUser.getInstitutionCode());
			if(form == null || StringUtils.isEmpty(form.getBeginDate())){
				Date date = new Date();
				String defaultDate = (new SimpleDateFormat("yyyy-MM")).format(getLastDate(date));
				form.setBeginDate(defaultDate);
				form.setEndDate(defaultDate);
				form.setTjType(0);
			}
			List<MonthlyReportVo> list = monthlyReportService.getMarketManagerFundList(form);
			model.addAttribute("list", list);
			if(list != null && list.size() > 0){
				MonthlyReportVo sum = monthlyReportService.getMarketManagerFundSum(form);
				model.addAttribute("sum", sum);
			}
			//modify 增加登录人管辖区域的数据权限
			List<InstitutionModel> institutionList = null;
			if(currentUser.getInstitutionCode().equals("00")){
				institutionList = saleReportService.getInstitutionList(currentUser.getInstitutionCode());
			}else{
				institutionList = saleReportService.getManageOrgsByUserId(currentUser.getId().intValue());
			}
			model.addAttribute("institutionList",institutionList);
			model.addAttribute("form",form);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("市场管理员销售月结报表发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("report/monthlyReport/marketManagerFundMonthlyReport", request);
	}
}
