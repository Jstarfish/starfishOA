package cls.pilottery.web.plans.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
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
import cls.pilottery.web.plans.model.BatchPublisher;
import cls.pilottery.web.plans.model.Plan;
import cls.pilottery.web.plans.model.PlanPublisher;
import cls.pilottery.web.plans.model.Publisher;
import cls.pilottery.web.plans.service.PlanService;
import cls.pilottery.web.system.model.User;

import com.alibaba.fastjson.JSONArray;

/**
 * @ClassName ItemTypeController
 * @Description
 * @author Wang Qingxiang
 * @date 2015-09-10
 */
@Controller
@RequestMapping("/plans")
public class PlanController {

	static Logger logger = Logger.getLogger(PlanController.class);

	@Autowired
	private PlanService planService;

	/* 获得方案查询记录 */
	@RequestMapping(params = "method=listPlans")
	public String listPlans(HttpServletRequest request , ModelMap model , @ModelAttribute("planForm")
	PlanForm planForm) throws Exception {

		String insCode = ((User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION)).getInstitutionCode();
		Integer count = planService.getPlanCount(planForm);
		int pageIndex = PageUtil.getPageIndex(request);
		List<PlanPublisher> planList = new ArrayList<PlanPublisher>();
		if (count != null && count.intValue() != 0) {
			planForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			planForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			planList = planService.getPlanList(planForm);
		}
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", planList);
		model.addAttribute("planForm", planForm);
		model.addAttribute("insCode", insCode);
		return LocaleUtil.getUserLocalePath("inventory/plans/listPlans", request);
	}

	// 新增方案初始化
	@RequestMapping(params = "method=addPlanInit")
	public String addPlanInit(HttpServletRequest request , ModelMap model) throws Exception {

		List<Publisher> publisherList = new ArrayList<Publisher>();
		publisherList = planService.getPublisherList();
		model.addAttribute("publisherList", publisherList);
		return LocaleUtil.getUserLocalePath("inventory/plans/addPlan", request);
	}

	// 新增方案
	@RequestMapping(params = "method=addPlan")
	public String addPlan(HttpServletRequest request , ModelMap model , Plan plan) throws Exception {

		planService.addPlan(plan);
		return LocaleUtil.getUserLocalePath("common/successTip", request);
	}

	// 修改方案初始化
	@RequestMapping(params = "method=modifyInit")
	public String modyInit(HttpServletRequest request , ModelMap model) throws Exception {

		String planCode = request.getParameter("planCode");
		PlanForm planForm = new PlanForm();
		int pageIndex = PageUtil.getPageIndex(request);
		planForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
		planForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
		planForm.setPlanCodeQuery(planCode);
		List<PlanPublisher> planList = planService.getPlanList(planForm);
		model.addAttribute("plan", planList.get(0));
		List<Publisher> publisherList = planService.getPublisherList();
		Iterator<Publisher> iterator = publisherList.iterator();
		Integer exitPlanCode = planList.get(0).getPublisherCode();
		while (iterator.hasNext()) {
			Publisher next = iterator.next();
			if (exitPlanCode.equals(next.getPublisherCode())) {
				iterator.remove();
			}
		}
		model.addAttribute("publisherList", publisherList);
		return LocaleUtil.getUserLocalePath("inventory/plans/modifyPlan", request);
	}

	// 修改方案
	@RequestMapping(params = "method=modifyPlan")
	public String modifyPlan(HttpServletRequest request , ModelMap model , Plan plan) throws Exception {

		planService.modifyPlan(plan);
		return LocaleUtil.getUserLocalePath("common/successTip", request);
	}

	// 删除方案
	@ResponseBody
	@RequestMapping(params = "method=deletePlan")
	public String deleteOutlets(HttpServletRequest request) {

		String planCode = request.getParameter("planCode");
		Map<String, String> map = new HashMap<String, String>();
		Integer haveBatch = planService.haveBatch(planCode);
		if (haveBatch != 0) {
			map.put("reservedSuccessMsg", "This plan have batch,do not allowed delete!");
			return JSONArray.toJSONString(map);
		}
		Plan plan = new Plan();
		plan.setPlanCode(planCode);
		try {
			this.planService.deletePlan(plan);
			this.planService.deleteBackup(plan);
			map.put("reservedSuccessMsg", "");
		} catch (Exception e) {
			logger.error("errmsgs" + e.getMessage());
			map.put("reservedSuccessMsg", "Delete failed");
		}
		return JSONArray.toJSONString(map);
	}

	// 展示批次信息
	@RequestMapping(params = "method=listBatchDetails")
	public String listBatchDetails(HttpServletRequest request , ModelMap model) throws Exception {

		String planCode = request.getParameter("planCode");
		List<BatchPublisher> batchDetails = planService.getBatchDetails(planCode);
		Map<Integer, String> local = LocaleUtil.getUserLocaleEnum("batchStatus", request);
		if (batchDetails != null) {
			for (BatchPublisher batchPublisher : batchDetails) {
				batchPublisher.setStatusen(local.get((int) batchPublisher.getStatus()));
			}
			model.addAttribute("batchDetails", batchDetails);
			return LocaleUtil.getUserLocalePath("inventory/plans/detailsBatch", request);
		}
		return LocaleUtil.getUserLocalePath("inventory/plans/detailsBatch", request);
	}
	

	@RequestMapping(params = "method=importBatchInit")
	public String importBatchInit(HttpServletRequest request , ModelMap model) throws Exception {

		String planCode = request.getParameter("planCode");
		model.addAttribute("planCode", planCode);
		return LocaleUtil.getUserLocalePath("inventory/plans/importBatch", request);
	}

	/**
	 * 导入批次
	 * 
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params = "method=importBatch")
	public String importBatch(HttpServletRequest request , ModelMap model) throws Exception {

		String planCode = request.getParameter("planCode");
		String batch = request.getParameter("batch");
		long userid = ((User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION)).getId();
		BatchPublisher batchPub = new BatchPublisher();
		batchPub.setBatchNo(batch);
		batchPub.setPlanCode(planCode);
		batchPub.setUserId(userid);
		try {
			logger.info("planCode" + ":" + batchPub.getPlanCode() + "," + "batch" + ":" + batchPub.getBatchNo());
			this.planService.importBatch(batchPub);
			if (batchPub.getErrorCode() == 0) {
				return LocaleUtil.getUserLocalePath("common/successTip", request);
			} else {
				logger.error("批次导入失败："+batchPub.getErrorMessage());
				model.addAttribute("system_message", "don't find file or input avalided batch no!");
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			}
		} catch (Exception e) {
			logger.error("导入批次异常" + e.getMessage());
			model.addAttribute("system_message", "don't find file or input avalided batch no!");
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
	}
}
