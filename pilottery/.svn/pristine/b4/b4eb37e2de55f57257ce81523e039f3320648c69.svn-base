package cls.pilottery.web.warehouses.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.web.plans.form.PlanForm;
import cls.pilottery.web.plans.model.Plan;
import cls.pilottery.web.plans.service.PlanService;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.warehouses.model.DamageInfo;
import cls.pilottery.web.warehouses.service.DamageService;

/**
 * 
 * @describe:损毁查询的Controller
 * 
 */
@Controller
@RequestMapping("/damagedGoods")
public class DamageHousesController {

	static Logger logger = Logger.getLogger(DamageHousesController.class);

	@Autowired
	private DamageService damageService;

	@Autowired
	private PlanService planService;

	public DamageService getDamageService() {

		return damageService;
	}

	public void setDamageService(DamageService damageService) {

		this.damageService = damageService;
	}

	public PlanService getPlanService() {

		return planService;
	}

	public void setPlanService(PlanService planService) {

		this.planService = planService;
	}

	@RequestMapping(params = "method=listDamagedGoods")
	public String initTermimnateBatch(HttpServletRequest request , ModelMap model , @ModelAttribute("planForm")
	PlanForm planForm) throws Exception {

		String insCode = ((User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION))
				.getInstitutionCode();
		if (planForm == null) {
			planForm = new PlanForm();
		}
		planForm.setInsCode(insCode);
		Integer count = damageService.getDamageCount(planForm);
		int pageIndex = PageUtil.getPageIndex(request);
		List<DamageInfo> damagedList = new ArrayList<DamageInfo>();
		List<Plan> planList = planService.getPlanList();
		if (count != null && count.intValue() != 0) {
			planForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			planForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			damagedList = damageService.getDamageList(planForm);
		}
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", damagedList);
		model.addAttribute("planForm", planForm);
		model.addAttribute("planList", planList);
		return LocaleUtil.getUserLocalePath("inventory/warehouses/listDamage", request);
	}

	@RequestMapping(params = "method=detailsDamaged")
	public String detailsDamaged(HttpServletRequest request , ModelMap model) throws Exception {

		String record = request.getParameter("record").trim();
		List<DamageInfo> damages = damageService.getDamageDetails(record);
		Map<Integer, String> localeEnum = LocaleUtil.getUserLocaleEnum("pecification", request);
		long totalNum=0;
		for (DamageInfo info : damages) {
			info.setPecificationValue(localeEnum.get(info.getPecification()));
			totalNum+=info.getDamageNum();
		}
		model.addAttribute("backup", damages.get(0).getBackup());
		model.addAttribute("damageList", damages);
		model.addAttribute("record", record);
		model.addAttribute("totalNum", totalNum);
		return LocaleUtil.getUserLocalePath("inventory/warehouses/damageDetail", request);
	}

	@ResponseBody
	@RequestMapping(params = "method=liandong")
	public List<String> getFirstCode(HttpServletRequest request) {
		String planCode = request.getParameter("planCode");
		if(planCode == ""){
			return null;
		}
		return planService.getBatch(planCode);
	}
}
