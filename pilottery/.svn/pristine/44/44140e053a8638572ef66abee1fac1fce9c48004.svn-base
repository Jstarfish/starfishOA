package cls.pilottery.web.report.controller;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.web.report.form.AnalysisStatisticsForm;
import cls.pilottery.web.report.model.InstitutionFundVO;
import cls.pilottery.web.report.model.InstitutionModel;
import cls.pilottery.web.report.model.OutletInfoVO;
import cls.pilottery.web.report.service.AnalysisStatisticsService;
import cls.pilottery.web.report.service.SaleReportService;
import cls.pilottery.web.system.model.User;

@Controller
@RequestMapping("analysis")
public class AnalysisStatisticsController {
	Logger log = Logger.getLogger(SaleReportController.class);
	
	@Autowired
	private AnalysisStatisticsService analysisStatisticsService;
	@Autowired
	private SaleReportService saleReportService;
	
	/*
	 * 新增站点统计
	 */
	@RequestMapping(params="method=outletStatistics")
	public String initGoodsReceiptsReport(HttpServletRequest request , ModelMap model , AnalysisStatisticsForm form){
		try {
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCuserOrg(currentUser.getInstitutionCode());
			if(form==null || StringUtils.isEmpty(form.getBeginDate())){
				Calendar cld = Calendar.getInstance(); 
				//cld.add(Calendar.DATE, -1);
				String defaultDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
				form.setBeginDate(defaultDate);
				form.setEndDate(defaultDate);
			}
			
			List<OutletInfoVO> list = analysisStatisticsService.getAgencyInfoList(form);
			model.addAttribute("list",list);
			
			List<InstitutionModel> institutionList = saleReportService.getInstitutionList(currentUser.getInstitutionCode());
			model.addAttribute("institutionList",institutionList);
			model.addAttribute("form",form);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("查询站点信息统计报表发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("report/analysis/outletInfoStatistics", request);
	}
	
	/*
	 * 未销售站点统计
	 */
	@RequestMapping(params="method=getNoSaleOutlets")
	public String getNoSaleOutlets(HttpServletRequest request , ModelMap model , AnalysisStatisticsForm form){
		try {
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCuserOrg(currentUser.getInstitutionCode());
			if(form==null || StringUtils.isEmpty(form.getBeginDate())){
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Calendar cld = Calendar.getInstance(); 
				form.setEndDate(sdf.format(cld.getTime()));
				cld.add(Calendar.DATE, -7);
				form.setBeginDate(sdf.format(cld.getTime()));
			}
			
			List<OutletInfoVO> list = analysisStatisticsService.getNoSaleOutletsList(form);
			model.addAttribute("list",list);
			
			List<InstitutionModel> institutionList = saleReportService.getInstitutionList(currentUser.getInstitutionCode());
			model.addAttribute("institutionList",institutionList);
			model.addAttribute("form",form);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("查未销售站点统计报表发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("report/analysis/noSaleOutlets", request);
		
	}
}
