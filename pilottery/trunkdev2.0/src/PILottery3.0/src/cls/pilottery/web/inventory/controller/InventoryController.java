package cls.pilottery.web.inventory.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.pilottery.common.EnumConfigEN;
import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.web.goodsreceipts.model.DamageVo;
import cls.pilottery.web.goodsreceipts.model.GameBatchImport;
import cls.pilottery.web.goodsreceipts.model.GamePlanVo;
import cls.pilottery.web.goodsreceipts.model.GamePlans;
import cls.pilottery.web.goodsreceipts.service.GoodsReceiptsService;
import cls.pilottery.web.inventory.form.CheckPointForm;
import cls.pilottery.web.inventory.form.InventoryForm;
import cls.pilottery.web.inventory.model.CheckPointInfoVo;
import cls.pilottery.web.inventory.model.CheckPointParmat;
import cls.pilottery.web.inventory.model.CheckPointResult;
import cls.pilottery.web.inventory.model.CheckPointVo;
import cls.pilottery.web.inventory.model.CheckStruct;
import cls.pilottery.web.inventory.model.InventoryVo;
import cls.pilottery.web.inventory.model.MMCheckDetailVO;
import cls.pilottery.web.inventory.model.MMCheckVO;
import cls.pilottery.web.inventory.model.ResulstMessage;
import cls.pilottery.web.inventory.model.WhInfoVo;
import cls.pilottery.web.inventory.service.CheckPointService;
import cls.pilottery.web.inventory.service.InventoryService;
import cls.pilottery.web.report.model.InstitutionModel;
import cls.pilottery.web.report.model.WarehouseModel;
import cls.pilottery.web.report.service.SaleReportService;
import cls.pilottery.web.system.model.User;

@Controller
@RequestMapping("/inventory")
public class InventoryController {
	static Logger logger = Logger.getLogger(InventoryController.class);
	@Autowired
	private GoodsReceiptsService goodsReceiptsService;
	@Autowired
	private InventoryService inventoryService;
	@Autowired
	private SaleReportService saleReportService;
	@Autowired
	private CheckPointService checkPointService;
	private Map<Integer, String> checkPointStatus = EnumConfigEN.checkPointStatus;
	private Map<Integer, String> checkResult = EnumConfigEN.checkResult;

	/*
	 * 准备数据-枚举定义
	 */
	@ModelAttribute("checkPointStatus")
	public Map<Integer, String> getCheckPointStatus(HttpServletRequest request) {
		if(request != null) 
			 this.checkPointStatus=LocaleUtil.getUserLocaleEnum("checkPointStatus", request);
			 

			return checkPointStatus;
	}

	/*
	 * 准备数据-枚举定义
	 */
	@ModelAttribute("checkResult")
	public Map<Integer, String> getCheckResult(HttpServletRequest request) {
		 if(request != null) 
			 this.checkResult=LocaleUtil.getUserLocaleEnum("checkResult", request);
			 


		return checkResult;
	}

	/**
	 * 
	 * @Title: listInventoryInfo
	 * @Description:库存查询
	 * @param @param request
	 * @param @param model
	 * @param @param inventoryForm
	 * @param @return 参数
	 * @return String 返回类型
	 * @throws
	 */
	@RequestMapping(params = "method=listInventoryInfo")
	public String listInventoryInfo(HttpServletRequest request, ModelMap model,
			@ModelAttribute("inventoryForm") InventoryForm inventoryForm) {
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);

		String orgCode = String.valueOf(currentUser.getInstitutionCode());

		List<GamePlans> listplan = this.goodsReceiptsService.getAllGamePlan();
		inventoryForm.setOrgCode(orgCode);
		List<WhInfoVo> listwh = this.inventoryService.getWhListByorgCodeList(inventoryForm);
		InventoryVo vo = new InventoryVo();
		//inventoryForm.setWhcode(currentUser.getWarehouseCode());
		
		Integer count = inventoryService.getInventoryCount(inventoryForm);
		int pageIndex = PageUtil.getPageIndex(request);
		List<InventoryVo> inventList = new ArrayList<InventoryVo>();
		if (count != null && count.intValue() != 0) {
			inventoryForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			inventoryForm.setEndNum((pageIndex - 1) * PageUtil.pageSize
					+ PageUtil.pageSize);

			inventList = inventoryService.getInventoryList(inventoryForm);
			vo = this.inventoryService.getSum(inventoryForm);
		}
		/*List<GameBatchImport> listbatch = this.inventoryService.getBatchInfo();*/

		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", inventList);
		model.addAttribute("vo", vo);
		model.addAttribute("inventoryForm", inventoryForm);
		// List<InventoryVo>
		// listgroup=this.inventoryService.getGroupByCode(batchNo);
		model.addAttribute("listplan", listplan);
		model.addAttribute("listwh", listwh);
		/*model.addAttribute("listbatch", listbatch);*/
		
		return  LocaleUtil.getUserLocalePath("inventory/inventory/listInventoryInfo", request);
	}
	@ResponseBody
	@RequestMapping(params = "method=getBatchListByPlanCode")
	public List<GameBatchImport>getBatchListByPlanCode(HttpServletRequest request){
		String planCode=request.getParameter("planCode");
		List<GameBatchImport>listbatch=this.inventoryService.getBatchListByPlanCode(planCode);
		return listbatch;
	}

	/**
	 * 
	 * @Title: getGroup
	 * @Description: 获取奖组
	 * @param @param request
	 * @param @return 参数
	 * @return List<InventoryVo> 返回类型
	 * @throws
	 */
	@ResponseBody
	@RequestMapping(params = "method=getGroup")
	public List<InventoryVo> getGroup(HttpServletRequest request) {
		String batchNo = request.getParameter("batchNo");
        String planCode=request.getParameter("planCode");
		InventoryVo vo = new InventoryVo();
		vo.setBatchNo(batchNo);
        vo.setPlanCode(planCode);
		List<InventoryVo> listgroup = this.inventoryService.getGroupByCode(vo);
		return listgroup;
	}

	/**
	 * 
	 * @Title: listInventoryCheck
	 * @Description: 盘点查询
	 * @param @param request
	 * @param @param model
	 * @param @param inventoryForm
	 * @param @return 参数
	 * @return String 返回类型
	 * @throws
	 */
	@RequestMapping(params = "method=listInventoryCheck")
	public String listInventoryCheck(HttpServletRequest request,
			ModelMap model,
			@ModelAttribute("checkPointForm") CheckPointForm checkPointForm) {
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);

		String orgCode = String.valueOf(currentUser.getInstitutionCode());
		List<User> listuser = this.checkPointService.getCpCheckUserList(orgCode);
		List<WhInfoVo> listwh=new ArrayList<WhInfoVo>();
		if(orgCode.equals("00")){
	      listwh = this.checkPointService.getWhouseList();
		}
		else{
		listwh = this.inventoryService.getWhListByorgCode(orgCode);
		}
		checkPointForm.setOrgCode(orgCode);
		Integer count = checkPointService.getCheckCount(checkPointForm);
		
		int pageIndex = PageUtil.getPageIndex(request);
		List<CheckPointVo> listvo = new ArrayList<CheckPointVo>();
		if (count != null && count.intValue() != 0) {
			checkPointForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			checkPointForm.setEndNum((pageIndex - 1) * PageUtil.pageSize+ PageUtil.pageSize);

			listvo = checkPointService.getCheckList(checkPointForm);
		}
		model.addAttribute("checkPointForm", checkPointForm);
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", listvo);
		model.addAttribute("listuser", listuser);
		model.addAttribute("listwh", listwh);
		return  LocaleUtil.getUserLocalePath("inventory/inventory/listInventoryCheck", request);
		
	}

	/**
	 * 
	 * @Title: addInit
	 * @Description: 初始化新建盘点
	 * @param @param request
	 * @param @param model
	 * @param @return 参数
	 * @return String 返回类型
	 * @throws
	 */
	@RequestMapping(params = "method=addInit")
	public String addInit(HttpServletRequest request, ModelMap model) {
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		List<User> listuser = this.checkPointService.getCpCheckUserList(currentUser.getInstitutionCode());
		List<GamePlans> listplan = this.goodsReceiptsService.getAllGamePlan();
		model.addAttribute("listuser", listuser);
		model.addAttribute("listplan", listplan);
		return  LocaleUtil.getUserLocalePath("inventory/inventory/addCheckPoit", request);
	
	}

	/**
	 * 
	 * @Title: getBatchList
	 * @Description: 获取批次
	 * @param @param request
	 * @param @return 参数
	 * @return List<GameBatchImport> 返回类型
	 * @throws
	 */
	@ResponseBody
	@RequestMapping(params = "method=getBatchList")
	public List<GameBatchImport> getBatchList(HttpServletRequest request) {
		String planCode = "";
		planCode = request.getParameter("planCode");
		GameBatchImport gameBatchImport = new GameBatchImport();
		gameBatchImport.setPlanCode(planCode);
		List<GameBatchImport> listvo = this.checkPointService.getGameBatchListBCode(gameBatchImport);
		return listvo;
	}

	/**
	 * 
	 * @Title: addCheckPoint
	 * @Description: 新建盘点
	 * @param @param request
	 * @param @param model
	 * @param @param checkPointParmat
	 * @param @return 参数
	 * @return String 返回类型
	 * @throws
	 */
	@RequestMapping(params = "method=addCheckPoint", method = RequestMethod.POST)
	public String addCheckPoint(HttpServletRequest request, ModelMap model,
			CheckPointParmat checkPointParmat) {
		try {
			this.checkPointService.addCheckPoint(checkPointParmat);
			if (checkPointParmat.getCerrorcode() == 0) {
				
				return  LocaleUtil.getUserLocalePath("common/successTip", request);
			} else {
				throw new Exception(checkPointParmat.getCerrormesg());
			}
		} catch (Exception e) {
			logger.error("新建盘点失败：" + e.getMessage());
			model.addAttribute("system_message", e.getMessage());
			return  LocaleUtil.getUserLocalePath("common/errorTip", request);
			
		}

	}

	/**
	 * 
	 * @Title: processCheckPointInt
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param @param request
	 * @param @param model
	 * @param @return 参数
	 * @return String 返回类型
	 * @throws
	 */
	@RequestMapping(params = "method=processCheckPointInt")
	public String processCheckPointInt(HttpServletRequest request,
			ModelMap model) {
		String cpNo = request.getParameter("cpNo");
		CheckPointInfoVo vo = this.checkPointService.getProcessCheckInfoByCode(cpNo);
	
		model.addAttribute("vo", vo);
		return  LocaleUtil.getUserLocalePath("inventory/inventory/processCheckPointFirst", request);
		
	}

	/**
	 * 
	 * @Title: processCheckPointDelete
	 * @Description: 删除盘点
	 * @param @param request
	 * @param @param model
	 * @param @return 参数
	 * @return String 返回类型
	 * @throws
	 */
	@ResponseBody
	@RequestMapping(params = "method=processCheckPointDelete")
	public ResulstMessage processCheckPointDelete(HttpServletRequest request,
			ModelMap model) {
		ResulstMessage message=new ResulstMessage();
		String cpNo = request.getParameter("cpNo");
		try{
		this.checkPointService.deleteChckpoin(cpNo);
		}catch(Exception e){
			e.printStackTrace();
			logger.debug(e.getMessage());
			message.setMessage("Delete failed");
		}

		return message;
	}

	@RequestMapping(params = "method=checkPointSecond", method = RequestMethod.POST)
	public String checkPointSecond(HttpServletRequest request, ModelMap model,
			CheckPointParmat checkPointParmat) {
	try {
			CheckStruct cstruct = this.checkPointService.addCheckPointBatch(checkPointParmat);
			if (cstruct.getC_errorcode() != 0) {
				throw new Exception(cstruct.getC_errormesg());
			} else {
				
				CheckPointResult result = new CheckPointResult();
				result.setCpNo(checkPointParmat.getCpNo());
				result.setLastStep(0);
				try {
					this.checkPointService.checkPointomplete(result);
					if (result.getCerrorcode() != 0) {
						model.addAttribute("system_message", result.getCerrormesg());
						logger.error("errMessage" + result.getCerrormesg());
						// log.error("查询角色数据发生异常！", e);
						
						return  LocaleUtil.getUserLocalePath("common/errorTip", request);
					}
								
				} catch (Exception e) {
					e.printStackTrace();
					logger.error("errMessage" + e.getMessage());
					model.addAttribute("system_message", e.getMessage());
					return "common/errorTip";
				}
				model.addAttribute("result", result);
				model.addAttribute("differencesAmount",
						result.getCafterNum() - result.getCbeforeNum());
				return  LocaleUtil.getUserLocalePath("inventory/inventory/processCheckPointSencod", request);
			
			}

		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			// log.error("查询角色数据发生异常！", e);
			return  LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		
	}

	/**
	 * 
	 * @Title: checkPointNext
	 * @Description: 继续盘点
	 * @param @param request
	 * @param @param model
	 * @param @param checkPointParmat
	 * @param @return 参数
	 * @return String 返回类型
	 * @throws
	 */
	@RequestMapping(params = "method=checkPointNext")
	public String checkPointNext(HttpServletRequest request, ModelMap model) {
		String cpNo = request.getParameter("cpNo");
		CheckPointInfoVo vo = this.checkPointService.getProcessCheckInfoByCode(cpNo);
		model.addAttribute("vo", vo);
		return LocaleUtil.getUserLocalePath("inventory/inventory/processCheckPointFirst", request);
	
	}

	@RequestMapping(params = "method=checkPointThird", method = RequestMethod.POST)
	public String checkPointThird(HttpServletRequest request, ModelMap model,
			CheckPointParmat checkPointParmat) {
		CheckPointResult result=this.checkPointService.getCheckPointSum(checkPointParmat.getCpNo());
		model.addAttribute("checkPointParmat", checkPointParmat);
		
	
		model.addAttribute("result", result);
		return  LocaleUtil.getUserLocalePath("inventory/inventory/processCheckPointThird", request);

	}

	@RequestMapping(params = "method=checkPointFinish")
	public String checkPointFinish(HttpServletRequest request, ModelMap model) {
		String cpNo = request.getParameter("cpNo");
		String remark = request.getParameter("remark");
		String[] seqs = request.getParameterValues("recordId");
	

		if (seqs != null && seqs.length > 0) {
			try {
				HttpSession session = request.getSession();
				User currentUser = (User) session
						.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
				DamageVo damageVo = new DamageVo();
				damageVo.setOpradmin(currentUser.getId());
				damageVo.setChecktype(3);
				damageVo.setRefcode(cpNo);
				damageVo.setRemark(remark);
				damageVo.setExtendarg(StringUtils.join(seqs, ","));
				this.goodsReceiptsService.addDamage(damageVo);
				if (damageVo.getC_errcode() != 0) {
					throw new Exception(LocaleUtil.getUserLocaleErrorMsg(damageVo.getC_errmsg(), request));
				}
			} catch (Exception e) {
				logger.error("盘点完成： errmsgs" + e.getMessage());
				model.addAttribute("system_message", e.getMessage());
				return  LocaleUtil.getUserLocalePath("common/errorTip", request);
				
			}
		}

		return "redirect:inventory.do?method=listInventoryCheck";

	}
	

	@RequestMapping(params = "method=checkPointForth", method = RequestMethod.POST)
	public String checkpointForth(HttpServletRequest request, ModelMap model,
			CheckPointParmat checkPointParmat) {
		String cpNo = checkPointParmat.getCpNo();
		CheckPointResult result = new CheckPointResult();
		result.setCpNo(cpNo);
		result.setLastStep(0);
		try {
			this.checkPointService.checkPointomplete(result);
			if (result.getCerrorcode() != 0) {
				model.addAttribute("system_message", result.getCerrormesg());
				logger.error("errMessage" + result.getCerrormesg());
				// log.error("查询角色数据发生异常！", e);
				return  LocaleUtil.getUserLocalePath("common/errorTip", request);
				
			}
			
			List<CheckPointResult>  list = this.checkPointService.getCheckPointDetailList(cpNo);
			model.addAttribute("itemList", list);
			
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("errMessage" + e.getMessage());
			model.addAttribute("system_message", e.getMessage());
			// log.error("查询角色数据发生异常！", e);
			return  LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		model.addAttribute("result", result);
		model.addAttribute("differencesAmount",
				result.getCafterNum() - result.getCbeforeNum());
		return  LocaleUtil.getUserLocalePath("inventory/inventory/processCheckPointForth", request);

	}
	@RequestMapping(params = "method=addDamagedInit")
	public String addDamagedInit(HttpServletRequest request, ModelMap model,
			CheckPointParmat checkPointParmat) {
		String cpNo =request.getParameter("cpNo");
		List<CheckPointResult> listrest = this.checkPointService.getCpnormaiList(cpNo);
		model.addAttribute("listrest", listrest);
		return  LocaleUtil.getUserLocalePath("inventory/inventory/addDamaged", request);
//		return "inventory/inventory/addDamaged";
	}
 
	@RequestMapping(params = "method=getCheckPointDetail")
	public String getCheckPointDetail(HttpServletRequest request, ModelMap model) {

		try {
			String cpNo = request.getParameter("cpNo");
			CheckPointInfoVo vo = this.checkPointService.getProcessCheckInfoByCode(cpNo);
			model.addAttribute("vo", vo);
			
			List<CheckPointResult>  list = this.checkPointService.getCheckPointDetailList(cpNo);
			model.addAttribute("itemList", list);
			return  LocaleUtil.getUserLocalePath("inventory/inventory/processCheckPointDetail", request);
			
		} catch (Exception e) {
			logger.error("获取盘点详情失败：" + e.getMessage());
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			return  LocaleUtil.getUserLocalePath("common/errorTip", request);
		
		}
	}
	@RequestMapping(params = "method=checkFinsh")
	public String checkFinsh(HttpServletRequest request, ModelMap model){
		String cpNo = request.getParameter("cpNo");
		String remark=request.getParameter("remark");
		CheckPointResult result = new CheckPointResult();
		result.setCpNo(cpNo);
		result.setLastStep(1);
		result.setRemark(remark);
		try {
			this.checkPointService.checkPointomplete(result);
			if (result.getCerrorcode() != 0) {
				model.addAttribute("system_message", result.getCerrormesg());
				logger.error("errMessage" + result.getCerrormesg());
				// log.error("查询角色数据发生异常！", e);
				return  LocaleUtil.getUserLocalePath("common/errorTip", request);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("errMessage" + e.getMessage());
			model.addAttribute("system_message", e.getMessage());
			// log.error("查询角色数据发生异常！", e);
			return  LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		  return "redirect:inventory.do?method=listInventoryCheck";
	}
	@ResponseBody
	@RequestMapping(params = "method=getGamsListCheck")
	public List<GamePlanVo>getGamsListCheck(HttpServletRequest request){
		String cpNo=request.getParameter("cpNo");
		List<GamePlanVo>listplan=new ArrayList<GamePlanVo>();
		listplan=this.checkPointService.getGamsListCheck(cpNo);
		return listplan;
	}
	
	@RequestMapping(params = "method=checkPointComplete", method = RequestMethod.POST)
	public String checkPointComplete(HttpServletRequest request, ModelMap model,CheckPointParmat checkPointParmat){
		
		String cpNo = checkPointParmat.getCpNo();
		CheckPointResult result = new CheckPointResult();
		result.setCpNo(cpNo);
		result.setLastStep(1);
		try {
			this.checkPointService.checkPointomplete(result);
			if (result.getCerrorcode() != 0) {
				model.addAttribute("system_message", result.getCerrormesg());
				logger.error("errMessage" + result.getCerrormesg());
				// log.error("查询角色数据发生异常！", e);
				return  LocaleUtil.getUserLocalePath("common/errorTip", request);
			}
			
			//盘亏==2,不等于盘亏则完成
			if(result.getCresult() != 2 )
			{
				return "redirect:inventory.do?method=listInventoryCheck";
			}
			
			List<CheckPointResult>  list = this.checkPointService.getCheckPointDetailList(cpNo);
			model.addAttribute("itemList", list);
			
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("errMessage" + e.getMessage());
			model.addAttribute("system_message", e.getMessage());
			// log.error("查询角色数据发生异常！", e);
			return  LocaleUtil.getUserLocalePath("common/errorTip", request);
		
		}
		model.addAttribute("result", result);
		model.addAttribute("differencesAmount",result.getCafterNum() - result.getCbeforeNum());
		return  LocaleUtil.getUserLocalePath("inventory/inventory/processCheckPointThird", request);

	}
	
	@RequestMapping(params = "method=listInventoryCheckInquiry")
	public String listInventoryCheckInquiry(HttpServletRequest request,ModelMap model,@ModelAttribute("checkPointForm") CheckPointForm checkPointForm) {
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		checkPointForm.setOrgCode(currentUser.getInstitutionCode());
		checkPointForm.setCurrentUserId(currentUser.getId().intValue());
		
		//modify by huangchy 20161008 增加登录人管辖区域的数据权限
		List<InstitutionModel> institutionList = null;
		if(currentUser.getInstitutionCode().equals("00")){
			institutionList = saleReportService.getInstitutionList(currentUser.getInstitutionCode());
		}else{
			institutionList = saleReportService.getManageOrgsByUserId(currentUser.getId().intValue());
		}
		model.addAttribute("institutionList",institutionList);
		if(StringUtils.isNotEmpty(checkPointForm.getInstitutionCode())){
			List<WarehouseModel> warehouseList = saleReportService.getWarehouseList(checkPointForm.getInstitutionCode());
			model.addAttribute("warehouseList",warehouseList);
		}
		
		Integer count = checkPointService.getCheckInquiryCount(checkPointForm);
		
		int pageIndex = PageUtil.getPageIndex(request);
		List<CheckPointVo> listvo = new ArrayList<CheckPointVo>();
		if (count != null && count.intValue() != 0) {
			checkPointForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			checkPointForm.setEndNum((pageIndex - 1) * PageUtil.pageSize+ PageUtil.pageSize);

			listvo = checkPointService.getCheckInquiryList(checkPointForm);
		}
		model.addAttribute("checkPointForm", checkPointForm);
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", listvo);
		//model.addAttribute("listuser", listuser);
		//model.addAttribute("listwh", listwh);
		return  LocaleUtil.getUserLocalePath("inventory/inventory/listInventoryCheckInquiry", request);
		
	}
	
	@RequestMapping(params = "method=listMMInventoryCheck")
	public String listMMInventoryCheck(HttpServletRequest request,ModelMap model,CheckPointForm checkPointForm) {
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		checkPointForm.setOrgCode(currentUser.getInstitutionCode());
		checkPointForm.setCurrentUserId(currentUser.getId().intValue());
		
		List<InstitutionModel> institutionList = null;
		if(currentUser.getInstitutionCode().equals("00")){
			institutionList = saleReportService.getInstitutionList(currentUser.getInstitutionCode());
		}else{
			institutionList = saleReportService.getManageOrgsByUserId(currentUser.getId().intValue());
		}
		model.addAttribute("institutionList",institutionList);
		
		Integer count = checkPointService.getMMCheckInquiryCount(checkPointForm);
		
		int pageIndex = PageUtil.getPageIndex(request);
		List<MMCheckVO> listvo = null;
		if (count != null && count.intValue() != 0) {
			checkPointForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			checkPointForm.setEndNum((pageIndex - 1) * PageUtil.pageSize+ PageUtil.pageSize);

			listvo = checkPointService.getMMCheckInquiryList(checkPointForm);
		}
		model.addAttribute("checkPointForm", checkPointForm);
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", listvo);
		return  LocaleUtil.getUserLocalePath("inventory/inventory/listMMInventoryCheck", request);
	}
	
	@RequestMapping(params = "method=getMMInventoryCheckDetail")
	public String getMMInventoryCheckDetail(HttpServletRequest request, ModelMap model) {
		try {
			String cpNo = request.getParameter("cpNo");
			List<MMCheckDetailVO> list = this.checkPointService.getMMInventoryCheckDetail(cpNo);
			model.addAttribute("itemList", list);
			return LocaleUtil.getUserLocalePath("inventory/inventory/mmInventoryCheckDetail", request);
		} catch (Exception e) {
			logger.error("获取盘点详情失败：" + e.getMessage());
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
	}

}
