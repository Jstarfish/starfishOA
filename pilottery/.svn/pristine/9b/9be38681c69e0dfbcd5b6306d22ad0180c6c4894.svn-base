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
import cls.pilottery.web.report.form.NetSalesForm;
import cls.pilottery.web.report.form.SaleReportForm;
import cls.pilottery.web.report.model.AuthDetailModel;
import cls.pilottery.web.report.model.InstitutionFundVO;
import cls.pilottery.web.report.model.InstitutionModel;
import cls.pilottery.web.report.model.NetSalesModel;
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
			form.setCurrentUserId(currentUser.getId().intValue());
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
			form.setCurrentUserId(currentUser.getId().intValue());
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
			log.error("查未销售站点统计报表发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("report/analysis/noSaleOutlets", request);
	}
	
	/*
	 * 可根据彩票类型（即开票或电脑票）查询部门站点统计
	 */
	@RequestMapping(params = "method=instFundReportByLotType")
	public String getInstFundReportByLotType(HttpServletRequest request, ModelMap model,SaleReportForm form) {
		try {
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			form.setCuserOrg(currentUser.getInstitutionCode());
			if(form==null || StringUtils.isEmpty(form.getBeginDate())){
				Calendar cld = Calendar.getInstance(); 
				String defaultDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
				form.setBeginDate(defaultDate);
				form.setEndDate(defaultDate);
				form.setTjType(0);
			}
			
			List<InstitutionFundVO> list = analysisStatisticsService.getInstFundReportByLotTypeList(form);
			model.addAttribute("list",list);
			if(list!=null &&list.size()> 0){
				InstitutionFundVO sum = analysisStatisticsService.getInstFundReportByLotTypeSum(form);
				model.addAttribute("sum",sum);
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
			log.error("analysis.do?method=instFundReportByLotType发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("report/analysis/instFundReportByLotType", request);
	
	}
	
	/*
	 * 可根据彩票类型（即开票或电脑票）查询部门站点统计
	 */
	@RequestMapping(params = "method=agentFundReportByLotType")
	public String getAgentFundReportByTjtype(HttpServletRequest request, ModelMap model,SaleReportForm form) {
		try {
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			form.setCuserOrg(currentUser.getInstitutionCode());
			if(form==null || StringUtils.isEmpty(form.getBeginDate())){
				Calendar cld = Calendar.getInstance(); 
				String defaultDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
				form.setBeginDate(defaultDate);
				form.setEndDate(defaultDate);
				form.setTjType(0);
			}
			
			List<InstitutionFundVO> list = analysisStatisticsService.getAgentFundReportByLotTypeList(form);
			model.addAttribute("list",list);
			if(list!=null &&list.size()> 0){
				InstitutionFundVO sum = analysisStatisticsService.getAgentFundReportByLotTypeSum(form);
				model.addAttribute("sum",sum);
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
			log.error("analysis.do?method=agentFundReport发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("report/analysis/agentFundReportByLotType", request);
	
	}
	
	@RequestMapping(params = "method=ctgAuthDetail")
	public String ctgAuthDetail(HttpServletRequest request, ModelMap model) throws Exception {
		String agencyCode = request.getParameter("agencyCode");
		List<AuthDetailModel> authDetails = analysisStatisticsService.getCtgAuthDetail(agencyCode);
		model.addAttribute("authDetails", authDetails);
		return LocaleUtil.getUserLocalePath("report/analysis/ctgAuthDetail", request);
	}
	
	@RequestMapping(params = "method=pilAuthDetail")
	public String pilAuthDetail(HttpServletRequest request, ModelMap model) throws Exception {
		String agencyCode = request.getParameter("agencyCode");
		List<AuthDetailModel> authDetails = analysisStatisticsService.getPilAuthDetail(agencyCode);
		model.addAttribute("authDetails", authDetails);
		return LocaleUtil.getUserLocalePath("report/analysis/pilAuthDetail", request);
	}
	
	/**
	 * 
	 * @description:净销售额汇总日报表
	 * @author: star
	 * @time:2016年8月17日 上午10:07:45
	 */

	@RequestMapping(params = "method=netSalesStatistcs")
	public String netSalesStatistcs(HttpServletRequest request,ModelMap model,NetSalesForm form){
		try {
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			form.setCuserOrg(currentUser.getInstitutionCode());
			if(form==null || StringUtils.isEmpty(form.getBeginDate())){
				Calendar cld = Calendar.getInstance(); 
				cld.add(Calendar.DATE, -1);
				String defaultDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
				form.setBeginDate(defaultDate);
				form.setEndDate(defaultDate);
			}
			
			List<NetSalesModel> list = analysisStatisticsService.getNetSalesList(form);
			model.addAttribute("list",list);
			if(list!=null &&list.size()> 0){
				NetSalesModel sum = analysisStatisticsService.getNetSalesSum(form);
				model.addAttribute("sum",sum);
			}
			
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
			log.error("analysis.do?method=netSalesStatistcs发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		
		return LocaleUtil.getUserLocalePath("report/analysis/netSalesStatistcsReport", request);
		
	}
	
}
