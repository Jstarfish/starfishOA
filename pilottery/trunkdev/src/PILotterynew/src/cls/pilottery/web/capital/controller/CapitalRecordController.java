package cls.pilottery.web.capital.controller;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import cls.pilottery.common.EnumConfigEN;
import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.web.capital.form.CapitalRecordForm;
import cls.pilottery.web.capital.model.CapitalRecord;
import cls.pilottery.web.capital.model.InstitutionCommDetailVO;
import cls.pilottery.web.capital.service.CapitalRecordService;
import cls.pilottery.web.report.model.InstitutionModel;
import cls.pilottery.web.report.service.SaleReportService;
import cls.pilottery.web.system.model.User;

/**
 * 部门资金流水
 */

@Controller
@RequestMapping("/capitalRecord")
public class CapitalRecordController {
	static Logger log = Logger.getLogger(CapitalRecordController.class);

	@Autowired
	private CapitalRecordService capitalRecordService;
	@Autowired
	private SaleReportService saleReportService;
	
	private Map<Integer,String> transFlowType = EnumConfigEN.transFlowType;
	
	@ModelAttribute("transFlowType")
	public Map<Integer,String> getTransFlowType(HttpServletRequest request)
	{
	if(request != null)
			this.transFlowType =LocaleUtil.getUserLocaleEnum("transFlowType", request);
		
		return transFlowType;
	}
	/**
	 * 充值记录列表和查询
	 */
	@RequestMapping(params = "method=listCapitalRecords")
	public String listCapitalRecords(HttpServletRequest request, ModelMap model,CapitalRecordForm form) {
		try {
			HttpSession session = request.getSession();
			User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			if(form == null || StringUtils.isEmpty(form.getCrtorg())){
				if(!currentUser.getInstitutionCode().equals("00")){
					form.setCrtorg(currentUser.getInstitutionCode());
				}
			}
			
			if(form==null || StringUtils.isEmpty(form.getBeginDate())){
				Calendar cld = Calendar.getInstance(); 
				String defaultDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
				form.setBeginDate(defaultDate);
				form.setEndDate(defaultDate);
			}
			List<CapitalRecord> list = null;
			Integer count = capitalRecordService.getCapitalRecordCount(form);
			int pageIndex = PageUtil.getPageIndex(request);

			if (count != null && count.intValue() > 0) {
				form.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
				form.setEndNum((pageIndex - 1) * PageUtil.pageSize
						+ PageUtil.pageSize);
				list = capitalRecordService.getCapitalRecordList(form);
			}
			List<InstitutionModel> institutionList = saleReportService.getInstitutionList(currentUser.getInstitutionCode());
			model.addAttribute("institutionList",institutionList);
			model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
			model.addAttribute("pageDataList", list);
			model.addAttribute("form", form);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("初始化部门资金流水页面发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		
		return LocaleUtil.getUserLocalePath("capital/institutionAccounts/listInstitutionTrans", request);
	}
	
	@RequestMapping(params = "method=getCapitalRecordDetail")
	public String getCapitalRecordDetail(HttpServletRequest request, ModelMap model,CapitalRecordForm form) {
		try {
			String flowNo = request.getParameter("flowNo");
			List<InstitutionCommDetailVO> list = capitalRecordService.getCapitalRecordDetail(flowNo);
			
			InstitutionCommDetailVO detailSum = capitalRecordService.getCapitalRecordDetailSum(flowNo);
			
			model.addAttribute("sum", detailSum);
			model.addAttribute("list", list);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("初始化部门资金流水详情页面发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		
		return LocaleUtil.getUserLocalePath("capital/institutionAccounts/institutionCommTransDetail", request);
	}

	
}
