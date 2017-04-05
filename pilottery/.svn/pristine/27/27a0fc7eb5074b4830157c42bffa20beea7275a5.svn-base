package cls.pilottery.oms.monitor.controller;

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

import com.alibaba.fastjson.JSON;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.oms.monitor.form.OperateLogForm;
import cls.pilottery.oms.monitor.form.OperateTypeForm;
import cls.pilottery.oms.monitor.model.OperateLog;
import cls.pilottery.oms.monitor.model.OperateType;
import cls.pilottery.oms.monitor.service.OperateLogService;
import cls.pilottery.web.area.model.GameAuth;
import cls.pilottery.web.capital.model.InstitutionAccountModel;
import cls.pilottery.web.capital.model.ManagerAccountModel;
import cls.pilottery.web.capital.model.OutletAccountModel;
import cls.pilottery.web.institutions.model.InfOrgs;
import cls.pilottery.web.institutions.service.InstitutionsService;
import cls.pilottery.web.system.model.User;

@Controller
@RequestMapping("/operateLog")
public class OperateLogController {

	Logger logger = Logger.getLogger(OperateLogController.class);
	
	@Autowired
	private OperateLogService operateLogService;
	@Autowired
	private InstitutionsService institutionsService;

	@RequestMapping(params = "method=listOperateLog")
	public String listOperateLog(HttpServletRequest request, ModelMap model, OperateLogForm form) {
		try {
			User currentUser = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCuserOrg(currentUser.getInstitutionCode());
			List<OperateType> operateTypeList = operateLogService.getAllOperateType();
			List<OperateLog> list = null;
			if (form == null || StringUtils.isEmpty(form.getStartTime())) {
				Calendar cld = Calendar.getInstance();
				String defaultDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
				form.setStartTime(defaultDate);
				form.setEndTime(defaultDate);
			}
			Integer count = operateLogService.getOperateLogCount(form);
			int pageIndex = PageUtil.getPageIndex(request);
			if (count != null && count.intValue() > 0) {
				form.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
				form.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
				list = operateLogService.getOperateLogList(form);
			}
			List<InfOrgs> orgList = institutionsService.getAllInstitutionsInfo();
			model.addAttribute("orgList", orgList);
			model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
			model.addAttribute("pageDataList", list);
			model.addAttribute("operateTypeList", operateTypeList);
			model.addAttribute("form", form);

		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}

		return LocaleUtil.getUserLocalePath("oms/monitor/operateLog/operateLogList", request);
	}

	/**
	 * @description:操作类型设置列表
	 * @exception:
	 * @author: star
	 * @time:2016年11月8日 下午1:38:19
	 */
	@RequestMapping(params = "method=listOperateType")
	public String listOperateType(HttpServletRequest request, ModelMap model, OperateTypeForm form) {
		try {
			List<OperateType> list = null;
			Integer count = operateLogService.getOperateTypeCount(form);
			int pageIndex = PageUtil.getPageIndex(request);
			if (count != null && count.intValue() > 0) {
				form.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
				form.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
				list = operateLogService.getOperateTypeList(form);
			}
			model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
			model.addAttribute("pageDataList", list);

		} catch (Exception e) {
			e.printStackTrace();
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}

		return LocaleUtil.getUserLocalePath("oms/monitor/operateLog/operateTypeList", request);
	}

	@RequestMapping(params = "method=initModifyOperateType")
	public String initModifyOperateType(HttpServletRequest request, ModelMap model, String operModeId) {
		OperateType operateType = operateLogService.getOperateTypeInfo(operModeId);
		model.addAttribute("operateType", operateType);
		return LocaleUtil.getUserLocalePath("oms/monitor/operateLog/operateTypeModify", request);
	}

	@RequestMapping(params = "method=modifyOperateType")
	public String modifyOperateType(HttpServletRequest request, ModelMap model, OperateType operateType) {
		try {
			operateLogService.updateOperateType(operateType);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("更新操作类型功能发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("common/successTip", request);
	}

	/**
	 * 
	 * @description:站点、部门、市场管理员账户修改日志详情
	 * @author: star
	 * @time:2016年11月16日 上午11:27:23
	 */
	@RequestMapping(params = "method=outletAccountLogDetail")
	public String outletAccountLogDeatils(HttpServletRequest request, ModelMap model, String operNo) {
		String jsonStr = operateLogService.getOperateContent(operNo);
		List<OutletAccountModel> OutletAccts = JSON.parseArray(jsonStr, OutletAccountModel.class);
		model.addAttribute("OutletAccts", OutletAccts);
		return LocaleUtil.getUserLocalePath("oms/monitor/operateLog/outletAccountLog", request);
	}

	@RequestMapping(params = "method=orgAccountLogDetail")
	public String orgAccountLogDetails(HttpServletRequest request, ModelMap model, String operNo) {
		String jsonStr = operateLogService.getOperateContent(operNo);
		List<InstitutionAccountModel> OrgAccts = JSON.parseArray(jsonStr, InstitutionAccountModel.class);
		model.addAttribute("OrgAccts", OrgAccts);
		return LocaleUtil.getUserLocalePath("oms/monitor/operateLog/orgAccountLog", request);
	}

	@RequestMapping(params = "method=mmAccountLogDetail")
	public String mmAccountLogDetails(HttpServletRequest request, ModelMap model, String operNo) {
		String jsonStr = operateLogService.getOperateContent(operNo);
		ManagerAccountModel managerAccts = JSON.parseObject(jsonStr, ManagerAccountModel.class);
		model.addAttribute("managerAccts", managerAccts);
		return LocaleUtil.getUserLocalePath("oms/monitor/operateLog/mmAccountLog", request);
	}

	@RequestMapping(params = "method=outletGameAuthLogDetail")
	public String outletGameAuthLogDetails(HttpServletRequest request, ModelMap model, String operNo) {
		String jsonStr = operateLogService.getOperateContent(operNo);
		List<GameAuth> games2 = JSON.parseArray(jsonStr, GameAuth.class);
		model.addAttribute("games", games2);
		return LocaleUtil.getUserLocalePath("oms/monitor/operateLog/outletGameAuthLog", request);
	}

}
