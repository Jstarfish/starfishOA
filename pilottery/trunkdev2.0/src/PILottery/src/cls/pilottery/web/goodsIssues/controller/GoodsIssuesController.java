package cls.pilottery.web.goodsIssues.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

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
import cls.pilottery.web.goodsIssues.form.GoodsIssuesForm;
import cls.pilottery.web.goodsIssues.model.DeleveryOrderInfo;
import cls.pilottery.web.goodsIssues.model.GoodIssuesParamt;
import cls.pilottery.web.goodsIssues.model.GoodsIssueDetailVo;
import cls.pilottery.web.goodsIssues.model.GoodsIssuesStockDetailVo;
import cls.pilottery.web.goodsIssues.model.GoodsIssuesStockVo;
import cls.pilottery.web.goodsIssues.model.GoodsIssuesStruct;
import cls.pilottery.web.goodsIssues.model.GoodsIssuesVo;
import cls.pilottery.web.goodsIssues.model.SaleDeliverOrder;
import cls.pilottery.web.goodsIssues.model.SaleDeliverOrderDetail;
import cls.pilottery.web.goodsIssues.service.GoodsIssuesService;
import cls.pilottery.web.goodsreceipts.model.GamePlanVo;
import cls.pilottery.web.goodsreceipts.model.GoodsReceiptTrans;
import cls.pilottery.web.goodsreceipts.service.GoodsReceiptsService;
import cls.pilottery.web.goodsreceipts.service.GoodsTransferService;
import cls.pilottery.web.institutions.model.InfOrgs;
import cls.pilottery.web.sales.entity.StockTransfer;
import cls.pilottery.web.system.model.User;

@Controller
@RequestMapping("/goodsIssues")
public class GoodsIssuesController {
	static Logger logger = Logger.getLogger(GoodsIssuesController.class);
	@Autowired
	private GoodsIssuesService goodsIssuesService;
	@Autowired
	private GoodsReceiptsService goodsReceiptsService;
	@Autowired
	private GoodsTransferService goodsTransferService;
	private Map<Integer, String> goodsIssuesStatus = EnumConfigEN.goodsReceiptStatus;
	private Map<Integer, String> goodsIssuesType = EnumConfigEN.goodsIssuesType;

	/*
	 * 准备数据-枚举定义
	 */
	@ModelAttribute("goodsIssuesStatus")
	public Map<Integer, String> goodsIssuesStatus(HttpServletRequest request) {
		/*
		 * if(request != null) this.maporgType
		 * =LocaleUtil.getUserLocaleEnum("orgType", request);
		 */
		if(request != null) 
			 this.goodsIssuesStatus=LocaleUtil.getUserLocaleEnum("goodsReceiptStatus", request);
		return goodsIssuesStatus;
		//return goodsIssuesStatus;
	}

	/*
	 * 准备数据-枚举定义
	 */
	@ModelAttribute("goodsIssuesType")
	public Map<Integer, String> goodsIssuesType(HttpServletRequest request) {
		if(request != null) 
			 this.goodsIssuesType=LocaleUtil.getUserLocaleEnum("goodsIssuesType", request);
		return goodsIssuesType;
	}

	/**
	 * 
	 * @Title: listGoodsIssues @Description: 出库查询 @param @param
	 * request @param @param model @param @param goodsIssuesForm @param @return
	 * 参数 @return String 返回类型 @throws
	 */
	@RequestMapping(params = "method=listGoodsIssues")
	public String listGoodsIssues(HttpServletRequest request, ModelMap model,
			@ModelAttribute("goodsIssuesForm") GoodsIssuesForm goodsIssuesForm) {
		
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
	
		String	orgCode=currentUser.getInstitutionCode();
	
		goodsIssuesForm.setOrgCode(orgCode);
		Integer count = this.goodsIssuesService.getgoodsIssuesCount(goodsIssuesForm);
		int pageIndex = PageUtil.getPageIndex(request);
		List<GoodsIssuesVo> goodsIssuseList = new ArrayList<GoodsIssuesVo>();
		if (count != null && count.intValue() != 0) {
			goodsIssuesForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			goodsIssuesForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);

			goodsIssuseList = this.goodsIssuesService.getgoodsIssuesInfoList(goodsIssuesForm);
		}
		model.addAttribute("goodsIssuesForm", goodsIssuesForm);
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", goodsIssuseList);
		return  LocaleUtil.getUserLocalePath("inventory/goodsIssues/listGoodsIssues", request);
	}

	/**
	 * 
	 * @Title: issueByStockTransfer 
	 * @Description: 出库单初始化 
	 * @param @param
	 * request @param @param model 
	 * @param @return 参数
	 *  @return String 返回类型
	 *   @throws
	 */
	@RequestMapping(params = "method=issueByStockTransfer", method = RequestMethod.GET)
	public String issueByStockTransfer(HttpServletRequest request, ModelMap model) {
 
		List<InfOrgs> orgsList=this.goodsIssuesService.getOrgslList();
		/*List<SaleDeliverOrder> salList = this.goodsIssuesService.getSaleDeliverList();
		model.addAttribute("salList", salList);*/
		String houseCode="";
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		if(currentUser.getWarehouseCode()!=null){
			houseCode=currentUser.getInstitutionCode();
		}
		
		GoodsIssuesForm goodsIssuesForm=new GoodsIssuesForm();
		
		goodsIssuesForm.setHouseCode(houseCode);
		List<StockTransfer> translerList=this.goodsIssuesService.getSaltranserIssueList(goodsIssuesForm);
		model.addAttribute("orgsList", orgsList);
		model.addAttribute("translerList", translerList);
		return  LocaleUtil.getUserLocalePath("inventory/goodsIssues/goodsIssuesStockFirtst", request);
//		return "inventory/goodsIssues/goodsIssuesStockFirtst";
	}
	/**
	 * 
	    * @Title: goodsIssuesStockFirst
	    * @Description: 调拨单出库第二步
	    * @param @param request
	    * @param @param model
	    * @param @param goodIssuesParamt
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=goodsIssuesStockFirst", method = RequestMethod.POST)
    public String goodsIssuesStockFirst(HttpServletRequest request, ModelMap model,GoodIssuesParamt goodIssuesParamt){
		//Integer operType=Integer.parseInt(request.getParameter("operType"));
		//goodIssuesParamt.setOperType(operType);
		List <GoodsIssueDetailVo> listvo=this.goodsIssuesService.getSaletbTicksInfoByCode(goodIssuesParamt);
		Long sumTickets=new Long(0);
		if(!listvo.isEmpty()){
			for(GoodsIssueDetailVo vo:listvo){
				sumTickets+=vo.getTickets();
			}
			
		}
		model.addAttribute("sumTickets",sumTickets);
		model.addAttribute("param",goodIssuesParamt);
		model.addAttribute("listvo",listvo);
		return  LocaleUtil.getUserLocalePath("inventory/goodsIssues/goodsIssuesStockSecond", request);
		//return "inventory/goodsIssues/goodsIssuesStockSecond";
    }
	/**
	 * 
	    * @Title: goodsIssuesStockSecond
	    * @Description: 调拨单出库
	    * @param @param request
	    * @param @param model
	    * @param @param goodIssuesParamt
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=goodsIssuesStockSecond", method = RequestMethod.POST)
	public String goodsIssuesStockSecond(HttpServletRequest request, ModelMap model,GoodIssuesParamt goodIssuesParamt){
		
		Long differencesAmount = new Long(0);
	
		goodIssuesParamt.setSbtNo(request.getParameter("stbNo"));
		GoodsIssuesStruct gstruct = new GoodsIssuesStruct();
		
		try {
			String houseCode="";
			HttpSession session = request.getSession();
			User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			if(currentUser.getWarehouseCode()!=null){
				houseCode=currentUser.getWarehouseCode();
			}
			goodIssuesParamt.setWarehouseCode(houseCode);
			goodIssuesParamt.setAdminId(new Integer(currentUser.getId().toString()));
			gstruct = this.goodsIssuesService.addGoodsIssues(goodIssuesParamt);

			if (gstruct.getC_errorcode() != 0) {
				throw new Exception(gstruct.getC_errormesg());
			}

		} catch (Exception e) {
			e.printStackTrace();
			logger.error("Error", e);
			model.addAttribute("system_message", e.getMessage());
			// log.error("查询角色数据发生异常！", e);
			return "common/errorTip";
		}
		//sgiNo = gstruct.getSgiNo();
		GoodsIssuesVo vo = this.goodsIssuesService.getGoodsIssuesById(request.getParameter("stbNo"));
		if (vo != null) {
			if (vo.getActTickets() != null) {
				differencesAmount = vo.getTickets() - vo.getActTickets();
			}
		}
		List <GoodsIssueDetailVo> listvo=this.goodsIssuesService.getSaleActTicktsDiffByCode(request.getParameter("stbNo"));
		goodIssuesParamt.setSgiNo(request.getParameter("stbNo"));
		goodIssuesParamt.setSbtNo(request.getParameter("stbNo"));
		model.addAttribute("listvo", listvo);
	/*	model.addAttribute("receivableAmount", vo.getTickets());
		model.addAttribute("receivabedAmount", vo.getActTickets())*/;
		model.addAttribute("differencesAmount", differencesAmount);
		model.addAttribute("goodIssuesParamt", goodIssuesParamt);
		return  LocaleUtil.getUserLocalePath("inventory/goodsIssues/goodsIssuesStockThird", request);
		//return "inventory/goodsIssues/goodsIssuesStockThird";
	}
	/**
	 * 
	    * @Title: goodsIssuesStockNext
	    * @Description:调拨单继续出库
	    * @param @param request
	    * @param @param model
	    * @param @param goodIssuesParamt
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=goodsIssuesStockNext", method = RequestMethod.POST)
	public String goodsIssuesStockNext(HttpServletRequest request, ModelMap model,GoodIssuesParamt goodIssuesParamt){
		String stbNo=goodIssuesParamt.getSbtNo();
		goodIssuesParamt.setStbNo(stbNo);
		List <GoodsIssueDetailVo> listvo=this.goodsIssuesService.getSaletbTicksInfoByCode(goodIssuesParamt);
		Long sumTickets=new Long(0);
		if(!listvo.isEmpty()){
			for(GoodsIssueDetailVo vo:listvo){
				sumTickets+=vo.getTickets();
			}
			
		}
		model.addAttribute("sumTickets",sumTickets);
		model.addAttribute("listvo",listvo);
		model.addAttribute("param",goodIssuesParamt);
		return  LocaleUtil.getUserLocalePath("inventory/goodsIssues/goodsIssuesStockSecond", request);
		//return "inventory/goodsIssues/goodsIssuesStockSecond";
	}
	/**
	 * 
	    * @Title: goodsIssuesStockThird
	    * @Description: 调拨单出库第三步
	    * @param @param request
	    * @param @param model
	    * @param @param goodIssuesParamt
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=goodsIssuesStockThird", method = RequestMethod.POST)
	public String goodsIssuesStockThird(HttpServletRequest request, ModelMap model,GoodIssuesParamt goodIssuesParamt){
		goodIssuesParamt.setOperType(3);
		model.addAttribute("goodIssuesParamt", goodIssuesParamt);
		
		String stbNo=goodIssuesParamt.getSbtNo();
		/*Long stbTicts=this.goodsIssuesService.getSaleActTicktsByCode(stbNo);*/
		GoodsIssuesVo vo = this.goodsIssuesService.getGoodsIssuesById(stbNo);
		Long differencesAmount=new Long(0);
		if (vo != null) {
			if (vo.getActTickets() != null) {
				differencesAmount = vo.getTickets() - vo.getActTickets();
			}
		}
		/*model.addAttribute("receivabedAmount", vo.getActTickets());
		model.addAttribute("receivableAmount", vo.getTickets());*/
		model.addAttribute("differencesAmount", differencesAmount);
		/*model.addAttribute("stbTicts", stbTicts);*/
		model.addAttribute("stbNo", stbNo);
		GoodsIssuesStruct gstruct = new GoodsIssuesStruct();
		try{
			String houseCode="";
			HttpSession session = request.getSession();
			User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			if(currentUser.getWarehouseCode()!=null){
				houseCode=currentUser.getWarehouseCode();
			}
			goodIssuesParamt.setWarehouseCode(houseCode);
			goodIssuesParamt.setAdminId(new Integer(currentUser.getId().toString()));
			gstruct = this.goodsIssuesService.addGoodsIssues(goodIssuesParamt);
			

			if (gstruct.getC_errorcode() != 0) {
				throw new Exception(gstruct.getC_errormesg());
			}
			
			List <GoodsIssueDetailVo> listvo=this.goodsIssuesService.getSaleActTicktsDiffByCode(stbNo);
			model.addAttribute("listvo", listvo);
		}catch(Exception e){
			logger.error("errmsgs"+e.getMessage());
			model.addAttribute("system_message", e.getMessage());
			return  LocaleUtil.getUserLocalePath("common/errorTip", request);
			
		}
		return  LocaleUtil.getUserLocalePath("inventory/goodsIssues/goodsIssuesStockFours", request);
		
	}
	@RequestMapping(params = "method=goodsIssuesStockForth", method = RequestMethod.POST)
	public String goodsIssuesStockForth(HttpServletRequest request, ModelMap model,GoodIssuesParamt goodIssuesParamt){
	
		return "redirect:goodsIssues.do?method=listGoodsIssues";
	}
	
	@ResponseBody
	@RequestMapping(params = "method=getSaleDeliverOrderDetailList")
	public Map<String,Object> getSaleDeliverOrderDetailList(HttpServletRequest request) {
		String doNo = request.getParameter("doNo");
		List<SaleDeliverOrderDetail> detaiList = this.goodsIssuesService.getSaleDeliverDitalList(doNo);
		DeleveryOrderInfo orderInfo = goodsIssuesService.getDeliveryOrderInfo(doNo);
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("detaiList", detaiList);
		map.put("orderInfo",orderInfo);
		return map;
	}

	/**
	 * 
	 * @Title: issueByDeliveryOrder
	 *  @Description: 初始化出库 @param @param
	 * 
	 */
	@RequestMapping(params = "method=issueByDeliveryOrder", method = RequestMethod.GET)
	public String issueByDeliveryOrder(HttpServletRequest request, ModelMap model) {
		GoodsIssuesForm goodsIssuesForm=new GoodsIssuesForm();
		String houseCode="";
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		if(currentUser.getInstitutionCode()!=null){
			houseCode=currentUser.getInstitutionCode();
		}
		goodsIssuesForm.setOrgCode(houseCode);
		List<SaleDeliverOrder> salList = this.goodsIssuesService.getSaleDeliverList(goodsIssuesForm);
		model.addAttribute("salList", salList);
		return  LocaleUtil.getUserLocalePath("inventory/goodsIssues/goodsIssuesFirtst", request);
		//return "inventory/goodsIssues/goodsIssuesFirtst";
	}

	/**
	 * 
	 * @Title: issueByDeliveryFirstStep 
	 * @Description: 出库单第一步 
	 * @param 
	 * @
	 * 参数 @return String 返回类型
	 */
	@RequestMapping(params = "method=issueByDeliveryFirstStep", method = RequestMethod.POST)
	public String issueByDeliveryFirstStep(HttpServletRequest request, ModelMap model,
			GoodIssuesParamt goodIssuesParamt) {
		model.addAttribute("param", goodIssuesParamt);
		List<GoodsIssueDetailVo> listvo=this.goodsIssuesService.getGoodsIssuseOutTicksInfoByCode(goodIssuesParamt);
		
		Long sumTickets=new Long(0);
		if(!listvo.isEmpty()){
			for(GoodsIssueDetailVo vo:listvo){
				sumTickets+=vo.getTickets();
			}
			
		}
		model.addAttribute("sumTickets", sumTickets);
		model.addAttribute("listvo", listvo);
		return  LocaleUtil.getUserLocalePath("inventory/goodsIssues/goodsIssuesSecnod", request);
		//return "inventory/goodsIssues/goodsIssuesSecnod";

	}

	/**
	 * 
	 * @Title: issueByDeliverySecondStep @Description:出库单第二步 @param @param
	 * request @param @param model @param @param goodIssuesParamt @param @return
	 * 参数 @return String 返回类型 @throws
	 */
	@RequestMapping(params = "method=issueByDeliverySecondStep", method = RequestMethod.POST)
	public String issueByDeliverySecondStep(HttpServletRequest request, ModelMap model,
			GoodIssuesParamt goodIssuesParamt) {
		String sgiNo = "";
		Long differencesAmount = new Long(0);
	  Integer operType=	Integer.parseInt(request.getParameter("operType"));
		GoodsIssuesStruct gstruct = new GoodsIssuesStruct();
		try {
			String houseCode="";
			HttpSession session = request.getSession();
			User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			if(currentUser.getWarehouseCode()!=null){
				houseCode=currentUser.getWarehouseCode();
			}
			goodIssuesParamt.setOperType(operType);
			goodIssuesParamt.setWarehouseCode(houseCode);
			goodIssuesParamt.setAdminId(new Integer(currentUser.getId().toString()));
			gstruct = this.goodsIssuesService.addCallGoodsIssues(goodIssuesParamt);

			// this.goodsReceiptsService.addGoodsBatch(goodReceiptParamt);

			if (gstruct.getC_errorcode() != 0) {
				throw new Exception(gstruct.getC_errormesg());
			}

		} catch (Exception e) {
			e.printStackTrace();
			logger.error("Error", e);
			model.addAttribute("system_message", e.getMessage());
			// log.error("查询角色数据发生异常！", e);
			return  LocaleUtil.getUserLocalePath("common/errorTip", request);
			//return "common/errorTip";
		}
		sgiNo =goodIssuesParamt.getDoNo();
		GoodsIssuesVo vo = this.goodsIssuesService.getGoodsIssuesById(sgiNo);
		if (vo != null) {
			if (vo.getActTickets() != null) {
				differencesAmount = vo.getTickets() - vo.getActTickets();
			}
		}
		List<GoodsIssueDetailVo> listvo=this.goodsIssuesService.getGoodsIssuseOutTicksInfoDiffByCode(sgiNo);
		/*model.addAttribute("receivabedAmount",vo.getTickets());
		model.addAttribute("receiedAmount", vo.getActTickets());*/
		model.addAttribute("listvo", listvo);
		model.addAttribute("differencesAmount", differencesAmount);
		model.addAttribute("goodIssuesParamt", goodIssuesParamt);
		//return "inventory/goodsIssues/goodsIssuesThird";
		return  LocaleUtil.getUserLocalePath("inventory/goodsIssues/goodsIssuesThird", request);
	}
	/**
	 * 
	    * @Title: goodsIssuesNext
	    * @Description: 继续
	    * @param @param request
	    * @param @param model
	    * @param @param goodIssuesParamt
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=goodsIssuesNext", method = RequestMethod.POST)
	public String goodsIssuesNext(HttpServletRequest request, ModelMap model,
			GoodIssuesParamt goodIssuesParamt){
		model.addAttribute("param", goodIssuesParamt);
		
		List<GoodsIssueDetailVo> listvo=this.goodsIssuesService.getGoodsIssuseOutTicksInfoByCode(goodIssuesParamt);
		Long sumTickets=new Long(0);
		if(!listvo.isEmpty()){
			for(GoodsIssueDetailVo vo:listvo){
				sumTickets+=vo.getTickets();
			}
			
		}
		model.addAttribute("listvo", listvo);
		model.addAttribute("sumTickets", sumTickets);
		//return "inventory/goodsIssues/goodsIssuesSecnod";
		return  LocaleUtil.getUserLocalePath("inventory/goodsIssues/goodsIssuesSecnod", request);
		
	}
	@RequestMapping(params = "method=goodsIssuesThird", method = RequestMethod.POST)
	public String goodsIssuesThird(HttpServletRequest request, ModelMap model,
			GoodIssuesParamt goodIssuesParamt){
		goodIssuesParamt.setOperType(3);
		String sgiNo =goodIssuesParamt.getDoNo();
		Long differencesAmount=new Long(0);
		GoodsIssuesVo vo = this.goodsIssuesService.getGoodsIssuesById(sgiNo);
		if (vo != null) {
			if (vo.getActTickets() != null) {
				differencesAmount = vo.getTickets() - vo.getActTickets();
			}
		}
		
		model.addAttribute("receivableAmount",vo.getTickets());
		model.addAttribute("receiedAmount",vo.getActTickets());
		model.addAttribute("differencesAmount", differencesAmount);
		
		model.addAttribute("goodIssuesParamt", goodIssuesParamt);
		GoodsIssuesStruct gstruct = new GoodsIssuesStruct();
		
		try {
			String houseCode="";
			HttpSession session = request.getSession();
			User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			if(currentUser.getWarehouseCode()!=null){
				houseCode=currentUser.getWarehouseCode();
			}
			goodIssuesParamt.setWarehouseCode(houseCode);
			goodIssuesParamt.setAdminId(new Integer(currentUser.getId().toString()));
			gstruct = this.goodsIssuesService.addCallGoodsIssues(goodIssuesParamt);
			if (gstruct.getC_errorcode() != 0) {
				throw new Exception(gstruct.getC_errormesg());
			}
			List<GoodsIssueDetailVo> listvo=this.goodsIssuesService.getGoodsIssuseOutTicksInfoDiffByCode(goodIssuesParamt.getDoNo());
			model.addAttribute("listvo", listvo);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("Error", e);
			model.addAttribute("system_message", e.getMessage());
			// log.error("查询角色数据发生异常！", e);
			//return "common/errorTip";
			return  LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return  LocaleUtil.getUserLocalePath("inventory/goodsIssues/goodsIssuesFours", request);
		//return "inventory/goodsIssues/goodsIssuesFours";
		
	}
	@RequestMapping(params = "method=goodsIssuesForth", method = RequestMethod.POST)
	public String goodsIssuesForth(HttpServletRequest request, ModelMap model,
			GoodIssuesParamt goodIssuesParamt){
		
			
				return "redirect:goodsIssues.do?method=listGoodsIssues";
	}
	/**
	 * 
	    * @Title: continueGoodsIssues
	    * @Description: 列表调拨单出库未完成的继续
	    * @param @param request
	    * @param @param model
	    * @param @param goodIssuesParamt
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=continueGoodTranser", method = RequestMethod.POST)
	public String continueGoodTranser(HttpServletRequest request, ModelMap model,GoodIssuesParamt goodIssuesParamt){
		model.addAttribute("param", goodIssuesParamt);
		List <GoodsIssueDetailVo> listvo=this.goodsIssuesService.getSaletbTicksInfoByCode(goodIssuesParamt);
		Long sumTickets=new Long(0);
		if(!listvo.isEmpty()){
			for(GoodsIssueDetailVo vo:listvo){
				sumTickets+=vo.getTickets();
			}
			
		}
		model.addAttribute("sumTickets",sumTickets);
		model.addAttribute("listvo", listvo);
		return  LocaleUtil.getUserLocalePath("inventory/goodsIssues/goodsIssuesStockSecond", request);
		//return "inventory/goodsIssues/goodsIssuesStockSecond";
	}
	/**
	 * 
	    * @Title: continueGoodsIssues
	    * @Description: 出库单继续
	    * @param @param request
	    * @param @param model
	    * @param @param goodIssuesParamt
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=continueGoodsIssues", method = RequestMethod.POST)
	public String continueGoodsIssues(HttpServletRequest request, ModelMap model,GoodIssuesParamt goodIssuesParamt){
		model.addAttribute("param", goodIssuesParamt);
		String doNo=request.getParameter("refNo");
		goodIssuesParamt.setDoNo(doNo);
		List<GoodsIssueDetailVo> listvo=this.goodsIssuesService.getGoodsIssuseOutTicksInfoByCode(goodIssuesParamt);
		
		Long sumTickets=new Long(0);
		if(!listvo.isEmpty()){
			for(GoodsIssueDetailVo vo:listvo){
				sumTickets+=vo.getTickets();
			}
			
		}
		model.addAttribute("sumTickets", sumTickets);
		model.addAttribute("listvo", listvo);
		//return "inventory/goodsIssues/goodsIssuesSecnod";
		return  LocaleUtil.getUserLocalePath("inventory/goodsIssues/goodsIssuesSecnod", request);
	}
	/**
	 * 
	    * @Title: getGoodsIssuesDetailBysgiNo
	    * @Description: 调拨单出库详情
	    * @param @param request
	    * @param @param model
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=getGoodsIssuesDetailBysgiNo")
	public String getGoodsIssuesDetailBysgiNo(HttpServletRequest request, ModelMap model){
		String sgiNo=request.getParameter("sgiNo");
		Integer issueType=new Integer(request.getParameter("issueType"));
		GoodsIssuesStockVo vo=this.goodsIssuesService.getGoodsIssuesStockInfoByCode(sgiNo);
		//调拨单信息列表
		List<GoodsIssuesStockDetailVo> listvo=this.goodsIssuesService.getGoodsIssuesStockDetilListByCode(sgiNo);
		//出库汇总列表
		List<GoodsIssueDetailVo> listdevo=this.goodsIssuesService.getGoodsIssuesDetilListByCode(sgiNo);
		//汇总信息
		List<GoodsIssueDetailVo> listdevosum=this.goodsIssuesService.getGoodsIssuesDetilListByCodeSum(sgiNo);
		GoodsIssuesVo gvo=this.goodsIssuesService.getGoodsIssuesByCode(sgiNo);
		Long differencesAmount=new Long(0);
		if(gvo!=null){
			differencesAmount=gvo.getTickets()-gvo.getActTickets();
		}
		model.addAttribute("vo", vo);
		model.addAttribute("listvo", listvo);
		model.addAttribute("listdevo", listdevo);
		model.addAttribute("gvo", gvo);
		model.addAttribute("issueType", issueType);
		model.addAttribute("differencesAmount", differencesAmount);
		model.addAttribute("listdevosum", listdevosum);
		return  LocaleUtil.getUserLocalePath("inventory/goodsIssues/goodsIssuesStockDetail", request);
		//return "inventory/goodsIssues/goodsIssuesStockDetail";
	}
	/**
	 * 
	    * @Title: printStock
	    * @Description: 调拨单出库打印
	    * @param @param request
	    * @param @param model
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=printStock")
	public String printStock(HttpServletRequest request, ModelMap model){
		String refNo=request.getParameter("refNo");
		GoodsIssuesVo vo=this.goodsIssuesService.getGoodsIssuesStockPirnt(refNo);
		GoodsReceiptTrans tranvo=this.goodsReceiptsService.getGoodsReceiptsTranPrintByStbno(refNo);
		List<GoodsIssuesStockDetailVo> listvo=this.goodsIssuesService.getGoodsIssuesStockDetailPirnt(refNo);
		GoodsIssuesStockDetailVo vosum=this.goodsIssuesService.getGoodsIssuesStockSumPirnt(refNo);
		model.addAttribute("vo", vo);
		model.addAttribute("tranvo", tranvo);
		model.addAttribute("vosum", vosum);
		model.addAttribute("listvo", listvo);
		return  LocaleUtil.getUserLocalePath("inventory/goodsIssues/goodsIssuesStockPrint", request);
		//return "inventory/goodsIssues/goodsIssuesStockPrint";
	}
	/**
	 * 
	    * @Title: printOut
	    * @Description: 出货单出库
	    * @param @param request
	    * @param @param model
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=printOut")
	public String printOut(HttpServletRequest request, ModelMap model){
		String refNo=request.getParameter("refNo");
		GoodsIssuesVo vo=this.goodsIssuesService.getGoodsIssuseOutPrint(refNo);
		model.addAttribute("vo", vo);
		List<GoodsIssuesStockDetailVo> listvo=this.goodsIssuesService.getGoodsIssuseOutPrintList(refNo);
		GoodsIssuesStockDetailVo vosum=this.goodsIssuesService.getGoodsIssuseOutPrintListSum(refNo);
		model.addAttribute("vo", vo);

		model.addAttribute("vosum", vosum);
		model.addAttribute("listvo", listvo);
		return  LocaleUtil.getUserLocalePath("inventory/goodsIssues/goodsIssuesOutPrint", request);
		//return "inventory/goodsIssues/goodsIssuesOutPrint";
	}
	/**
	 * 
	    * @Title: completeGoodsIssues
	    * @Description: 出库完成
	    * @param @param request
	    * @param @param model
	    * @param @param goodIssuesParamt
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=completeGoodsIssues", method = RequestMethod.GET)
	public String completeGoodsIssues(HttpServletRequest request, ModelMap model,GoodIssuesParamt goodIssuesParamt){
		
		int type=Integer.parseInt(request.getParameter("type"));
		 String refNo=request.getParameter("refNo");
		String sgiNo=request.getParameter("sgiNo");
		goodIssuesParamt.setOperType(3);
		Long differencesAmount = new Long(0);
		GoodsIssuesVo vo = this.goodsIssuesService.getGoodsIssuesById(refNo);
		if (vo != null) {
			if (vo.getActTickets() != null) {
				differencesAmount = vo.getTickets() - vo.getActTickets();
			}
		}
		goodIssuesParamt.setSgiNo(sgiNo);
		goodIssuesParamt.setSbtNo(refNo);
		Long stbTicts=this.goodsIssuesService.getSaleActTicktsByCode(refNo);
		model.addAttribute("stbTicts", stbTicts);
		model.addAttribute("receivabedAmount", vo.getActTickets());
		model.addAttribute("receivableAmount", vo.getTickets());
		model.addAttribute("differencesAmount", differencesAmount);
		model.addAttribute("goodIssuesParamt", goodIssuesParamt);
		try{
			if(type==1){
				GoodsIssuesStruct gstruct = new GoodsIssuesStruct();
				try{
					String houseCode="";
					HttpSession session = request.getSession();
					User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
					if(currentUser.getWarehouseCode()!=null){
						houseCode=currentUser.getWarehouseCode();
					}
					goodIssuesParamt.setWarehouseCode(houseCode);
					goodIssuesParamt.setAdminId(new Integer(currentUser.getId().toString()));
					gstruct = this.goodsIssuesService.addGoodsIssues(goodIssuesParamt);
					

					if (gstruct.getC_errorcode() != 0) {
						throw new Exception(gstruct.getC_errormesg());
					}
					List <GoodsIssueDetailVo> listvo=this.goodsIssuesService.getSaleActTicktsDiffByCode(refNo);
					model.addAttribute("listvo", listvo);
				}catch(Exception e){
					logger.error("errmsgs"+e.getMessage());
					model.addAttribute("system_message", e.getMessage());
					//return "common/errorTip";
					return  LocaleUtil.getUserLocalePath("common/errorTip", request);
				}
				model.addAttribute("stbNo", refNo);
				//return "inventory/goodsIssues/goodsIssuesStockFours";
				return  LocaleUtil.getUserLocalePath("inventory/goodsIssues/goodsIssuesStockFours", request);
			}
			if(type==2){
				goodIssuesParamt.setDoNo(refNo);
				GoodsIssuesStruct gstruct = new GoodsIssuesStruct();
				model.addAttribute("receiedAmount", vo.getActTickets());
				
				try {
					String houseCode="";
					HttpSession session = request.getSession();
					User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
					if(currentUser.getWarehouseCode()!=null){
						houseCode=currentUser.getWarehouseCode();
					}
					goodIssuesParamt.setWarehouseCode(houseCode);
					goodIssuesParamt.setAdminId(new Integer(currentUser.getId().toString()));
					gstruct = this.goodsIssuesService.addCallGoodsIssues(goodIssuesParamt);
					if (gstruct.getC_errorcode() != 0) {
						throw new Exception(gstruct.getC_errormesg());
					}
					List<GoodsIssueDetailVo> listvo=this.goodsIssuesService.getGoodsIssuseOutTicksInfoDiffByCode(goodIssuesParamt.getDoNo());
					model.addAttribute("listvo", listvo);

				} catch (Exception e) {
					e.printStackTrace();
					logger.error("Error", e);
					model.addAttribute("system_message", e.getMessage());
					// log.error("查询角色数据发生异常！", e);
					return  LocaleUtil.getUserLocalePath("common/errorTip", request);
				}
				//return "inventory/goodsIssues/goodsIssuesFours";
				return  LocaleUtil.getUserLocalePath("inventory/goodsIssues/goodsIssuesFours", request);
			
			}
			
		}catch(Exception e){
			logger.error("Error", e);
			model.addAttribute("system_message", e.getMessage());
			// log.error("查询角色数据发生异常！", e);
			return  LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return  LocaleUtil.getUserLocalePath("common/errorTip", request);
	}
	/**
	 * 
	    * @Title: printGoodsAll
	    * @Description:根据类型打印出库单 
	    * @param @param request
	    * @param @param model
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=printGoodsAll")
	public String printGoodsAll(HttpServletRequest request, ModelMap model){
		int type=Integer.parseInt(request.getParameter("type"));
		 String refNo=request.getParameter("refNo");
		 try{
			if(type==1){
				GoodsIssuesVo vo=this.goodsIssuesService.getGoodsIssuesStockPirnt(refNo);
				GoodsReceiptTrans tranvo=this.goodsReceiptsService.getGoodsReceiptsTranPrintByStbno(refNo);
				List<GoodsIssuesStockDetailVo> listvo=this.goodsIssuesService.getGoodsIssuesStockDetailPirnt(refNo);
				GoodsIssuesStockDetailVo vosum=this.goodsIssuesService.getGoodsIssuesStockSumPirnt(refNo);
				model.addAttribute("vo", vo);
				model.addAttribute("tranvo", tranvo);
				model.addAttribute("vosum", vosum);
				model.addAttribute("listvo", listvo);
			//	return "inventory/goodsIssues/goodsIssuesStockPrint";
				return  LocaleUtil.getUserLocalePath("inventory/goodsIssues/goodsIssuesStockPrint", request);
			}
			else{
				GoodsIssuesVo vo=this.goodsIssuesService.getGoodsIssuseOutPrint(refNo);
				model.addAttribute("vo", vo);
				List<GoodsIssuesStockDetailVo> listvo=this.goodsIssuesService.getGoodsIssuseOutPrintList(refNo);
				GoodsIssuesStockDetailVo vosum=this.goodsIssuesService.getGoodsIssuseOutPrintListSum(refNo);
				model.addAttribute("vo", vo);

				model.addAttribute("vosum", vosum);
				model.addAttribute("listvo", listvo);
				//return "inventory/goodsIssues/goodsIssuesOutPrint";
				return  LocaleUtil.getUserLocalePath("inventory/goodsIssues/goodsIssuesOutPrint", request);
			}
		 }
		 catch(Exception e){
				logger.error("Error", e);
				model.addAttribute("system_message", e.getMessage());
				// log.error("查询角色数据发生异常！", e);
				//return "common/errorTip";
				return  LocaleUtil.getUserLocalePath("common/errorTip", request);
			}
		
	}
	/**
	 * 
	    * @Title: getIssuseTransGameBystbNo
	    * @Description: TODO(这里用一句话描述这个方法的作用)
	    * @param @param request
	    * @param @return    参数
	    * @return List<GamePlanVo>    返回类型
	    * @throws
	 */
	 @ResponseBody
	 @RequestMapping(params = "method=getIssuseTransGameBystbNo")
	public List<GamePlanVo> getIssuseTransGameBystbNo(HttpServletRequest request){
		String stbNo=request.getParameter("stbNo");
		List <GamePlanVo> listplan=this.goodsIssuesService.getIssuseTransGameBystbNo(stbNo);
		return listplan;
	}
	 
	 @ResponseBody
	 @RequestMapping(params = "method=getSaleDeliverOrderGameBystbNo")
	public List<GamePlanVo> getSaleDeliverOrderGameBystbNo(HttpServletRequest request){
		String doNo=request.getParameter("doNo");
		List <GamePlanVo> listplan=this.goodsIssuesService.getSaleDeliverOrderGameBystbNo(doNo);
		return listplan;
	}
}
