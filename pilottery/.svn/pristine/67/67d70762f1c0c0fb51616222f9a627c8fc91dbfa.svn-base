package cls.pilottery.web.goodsreceipts.controller;

import java.util.ArrayList;
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
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.web.goodsIssues.form.GoodsIssuesForm;
import cls.pilottery.web.goodsIssues.model.GoodsIssueDetailVo;
import cls.pilottery.web.goodsIssues.service.GoodsIssuesService;
import cls.pilottery.web.goodsreceipts.form.GoodsReceiptsForm;
import cls.pilottery.web.goodsreceipts.model.DamageVo;
import cls.pilottery.web.goodsreceipts.model.GameBatchImport;
import cls.pilottery.web.goodsreceipts.model.GameBatchImportDetail;
import cls.pilottery.web.goodsreceipts.model.GamePlanVo;
import cls.pilottery.web.goodsreceipts.model.GamePlans;
import cls.pilottery.web.goodsreceipts.model.GoodReceiptParamt;
import cls.pilottery.web.goodsreceipts.model.GoodsReceiptTrans;
import cls.pilottery.web.goodsreceipts.model.GoodsStruct;
import cls.pilottery.web.goodsreceipts.model.RetrurnVo;
import cls.pilottery.web.goodsreceipts.model.ReturnRecoder;
import cls.pilottery.web.goodsreceipts.model.ReturnResult;
import cls.pilottery.web.goodsreceipts.model.WhGoodsReceipt;
import cls.pilottery.web.goodsreceipts.model.WhGoodsReceiptDetail;
import cls.pilottery.web.goodsreceipts.service.GoodsReceiptsService;
import cls.pilottery.web.goodsreceipts.service.GoodsReturnService;
import cls.pilottery.web.goodsreceipts.service.GoodsTransferService;
import cls.pilottery.web.sales.entity.StockTransfer;
/**
 * 
    * @ClassName: GoodsReceiptsController
    * @Description: 批量入库
    * @author yuyuanhua
    * @date 2015年9月10日
    *
 */
import cls.pilottery.web.sales.entity.StockTransferDetail;
import cls.pilottery.web.system.model.User;
@Controller
@RequestMapping("/goodsReceipts")
public class GoodsReceiptsController {
	static Logger logger = Logger.getLogger(GoodsReceiptsController.class);
	@Autowired
	private GoodsReceiptsService goodsReceiptsService;
	@Autowired
	private GoodsTransferService goodsTransferService;
	@Autowired
	private GoodsReturnService goodsReturnService;
	@Autowired
	private GoodsIssuesService goodsIssuesService;
	private Map<Integer,String> goodsReceiptStatus = EnumConfigEN.goodsReceiptStatus;
	private Map<Integer,String> goodsReceiptType = EnumConfigEN.goodsReceiptType;
	
	/*
	 * 准备数据-枚举定义
	 */
	@ModelAttribute("goodsReceiptStatus")
	public Map<Integer,String> getmaporgType(HttpServletRequest request)
	{
		/*if(request != null)
			this.maporgType =LocaleUtil.getUserLocaleEnum("orgType", request);*/
		
		return goodsReceiptStatus;
	}
	/*
	 * 准备数据-枚举定义
	 */
	@ModelAttribute("goodsReceiptType")
	public Map<Integer,String> goodsReceiptType(HttpServletRequest request)
	{
		/*if(request != null)
			this.maporgType =LocaleUtil.getUserLocaleEnum("orgType", request);*/
		
		return goodsReceiptType;
	}
	/**
	 * 
	    * @Title: listGoodsReceipts
	    * @Description: 入库查询
	    * @param @param request
	    * @param @param model
	    * @param @param goodsReceiptsForm
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=listGoodsReceipts")
	public String listGoodsReceipts(HttpServletRequest request, ModelMap model,
			@ModelAttribute("goodsReceiptsForm") GoodsReceiptsForm goodsReceiptsForm){
		String houseCode="";
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		
			houseCode=currentUser.getInstitutionCode();
	
		goodsReceiptsForm.setHouseCode(houseCode);
		Integer count =this.goodsReceiptsService.getGoodsReceiptCount(goodsReceiptsForm);
		int pageIndex = PageUtil.getPageIndex(request);
		List<WhGoodsReceipt> goodsReceiptList=new ArrayList<WhGoodsReceipt>();
		if (count != null && count.intValue() != 0) {
			goodsReceiptsForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			goodsReceiptsForm.setEndNum((pageIndex - 1) * PageUtil.pageSize
					+ PageUtil.pageSize);

			goodsReceiptList =this.goodsReceiptsService.getGoodsReceiptList(goodsReceiptsForm);
		}
		model.addAttribute("goodsReceiptsForm", goodsReceiptsForm);
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", goodsReceiptList);
		return "inventory/goodsReceipts/listGoodsReceipts";
	}
	/**
	 * 
	    * @Title: getGoodsDetailBysgrNo
	    * @Description: 入库单详情
	    * @param @param request
	    * @param @param model
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=getGoodsDetailBysgrNo")
	public String getGoodsDetailBysgrNo(HttpServletRequest request, ModelMap model){
		String sgrNo=request.getParameter("sgrNo");
		String refNo=request.getParameter("refNo");
		WhGoodsReceipt vo=this.goodsReceiptsService.getGoodsReceiptsPrintByrefNo(refNo);
		List<WhGoodsReceiptDetail> detail=this.goodsReceiptsService.getGoodsReceiptDetailBysgrNo(sgrNo);
		List<WhGoodsReceiptDetail> listdetail=this.goodsReceiptsService.getGoodsReceiptsDetailInfoByRefNo(refNo);
		WhGoodsReceiptDetail detailsum=this.goodsReceiptsService.getGoodsReceiptDetailsumBysgrNo(sgrNo);
		Long differencesAmount=vo.getReceiptTickets()-vo.getActReceiptTickets();
		model.addAttribute("detail", detail);
		model.addAttribute("detailsum", detailsum);
		model.addAttribute("detailsum", detailsum);
		model.addAttribute("differencesAmount", differencesAmount);
		model.addAttribute("vo", vo);
		model.addAttribute("listdetail", listdetail);
		return "inventory/goodsReceipts/goodsReceiptsDetail";
	}
	/**
	 * 
	    * @Title: receiptByBatch
	    * @Description: 初始化批量入库
	    * @param @param request
	    * @param @param model
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */

	@RequestMapping(params = "method=receiptByBatch", method = RequestMethod.GET)
	public String receiptByBatch(HttpServletRequest request, ModelMap model){
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		String orgCode=currentUser.getInstitutionCode();
		/*if(orgCode.equals("00")){*/
		List<GamePlans>gameList=this.goodsReceiptsService.getAllGamePlan();
	//	String sgrNo=this.goodsReceiptsService.getGoodsReceiptSgrNo();
		model.addAttribute("gameList", gameList);
	//	model.addAttribute("sgrNo",sgrNo);
		return "inventory/goodsReceipts/goodsReceiptsfirstStep";
		/*}
		else{
			model.addAttribute("system_message","Without permission, can not be in storage!");
			// log.error("查询角色数据发生异常！", e);
			return "common/errorTip";
		}*/
	}
	/**
	 * 
	    * @Title: getBatchList
	    * @Description: 批次入库批次级联
	    * @param @param request
	    * @param @return    参数
	    * @return List<GameBatchImport>    返回类型
	    * @throws
	 */
	@ResponseBody
	@RequestMapping(params = "method=getBatchList")
	public List<GameBatchImport>getBatchList(HttpServletRequest request){
		String planCode=request.getParameter("planCode");
		List<GameBatchImport> listBath=this.goodsReceiptsService.getGameBatchInfoBypanCode(planCode);
		return listBath;
	}
	/**
	 * 
	    * @Title: goodsReceiptFirst
	    * @Description:批次入库第一步
	    * @param @param request
	    * @param @param model
	    * @param @param goodReceiptParamt
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=goodsReceiptFirst", method = RequestMethod.POST)
	public String goodsReceiptFirst(HttpServletRequest request,ModelMap model,GoodReceiptParamt goodReceiptParamt){
		
		GameBatchImportDetail detail=this.goodsReceiptsService.getGamePlanOrBatchInfo(goodReceiptParamt);
		model.addAttribute("detail", detail);
		model.addAttribute("param", goodReceiptParamt);
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		String roleCode=currentUser.getInstitutionCode();
	   model.addAttribute("planCode",goodReceiptParamt.getPlanCode());
	   model.addAttribute("planName", goodReceiptParamt.getFullName());
	   model.addAttribute("roleCode", roleCode);
		return "inventory/goodsReceipts/goodsReceiptsSecondstep";
	}
	/**
	 * 
	    * @Title: goodsReceiptSecond
	    * @Description:批次入库第二步
	    * @param @param request
	    * @param @param model
	    * @param @param goodReceiptParamt
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	
	@RequestMapping(params = "method=goodsReceiptSecond", method = RequestMethod.POST)
	public String goodsReceiptSecond(HttpServletRequest request,ModelMap model,GoodReceiptParamt goodReceiptParamt){
		GoodsStruct gstruct=new GoodsStruct();
		
		try {
			
			HttpSession session = request.getSession();
			User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			goodReceiptParamt.setAdminId(currentUser.getId().intValue());
			if(currentUser.getWarehouseCode()!=null){
			goodReceiptParamt.setWarehouseCode(currentUser.getWarehouseCode());
			}else{
				
				model.addAttribute("system_message","Without this warehouse");
				// log.error("查询角色数据发生异常！", e);
				return "common/errorTip";
			}
			gstruct=this.goodsReceiptsService.addCallGoods(goodReceiptParamt);
			//this.goodsReceiptsService.addGoodsBatch(goodReceiptParamt);
           
			if (gstruct.getC_errorcode() != 0) {
				throw new Exception(gstruct.getC_errormesg());
			}else{
				if(goodReceiptParamt.getOperType()==1){
				  goodReceiptParamt.setSgrNo(gstruct.getSgrNo());
				}
			}
			Long sumAmount=new Long(0);
			sumAmount=this.goodsReceiptsService.getGameReceiptAmount(goodReceiptParamt);
			/*GameBatchImportDetail bachdetail=this.goodsReceiptsService.getGamePlanOrBatchInfo(goodReceiptParamt);
			 if(bachdetail!=null){
				 sumAmount=bachdetail.getTicketsEveryBatch();
			 }*/
			 Long receivableAmount=this.goodsReceiptsService.getGameReceiptActAmount(goodReceiptParamt);
			 Long differencesAmount= sumAmount-receivableAmount;
			 model.addAttribute("sumAmount", sumAmount);
			 model.addAttribute("goodReceiptParamt", goodReceiptParamt);
			 
			 model.addAttribute("receivableAmount", receivableAmount);
			 model.addAttribute("differencesAmount", differencesAmount);
			 model.addAttribute("sgrNo", goodReceiptParamt.getSgrNo());
			 model.addAttribute("planCode", goodReceiptParamt.getPlanCode());
			 model.addAttribute("batchNo",goodReceiptParamt.getBatchNo());

		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			// log.error("查询角色数据发生异常！", e);
			return "common/errorTip";
		}

	
		 
		
		return "inventory/goodsReceipts/goodsReceiptThirdstep";
	}

	/**
	 * 
	    * @Title: goodsReceiptNext
	    * @Description: 入库下一步
	    * @param @param request
	    * @param @param model
	    * @param @param goodReceiptParamt
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=goodsReceiptNext", method = RequestMethod.POST)
	public String goodsReceiptNext(HttpServletRequest request,ModelMap model,GoodReceiptParamt goodReceiptParamt){
		HttpSession session = request.getSession();
		goodReceiptParamt.setOperType(2);
		GameBatchImportDetail detail=this.goodsReceiptsService.getGamePlanOrBatchInfo(goodReceiptParamt);
		model.addAttribute("detail", detail);
		model.addAttribute("param", goodReceiptParamt);
		GamePlans game=this.goodsReceiptsService.getGamePlanInfoByCode(goodReceiptParamt.getPlanCode());
		model.addAttribute("planCode", goodReceiptParamt.getPlanCode());
		if(game!=null && game.getFullName()!=null){
			   model.addAttribute("planName", game.getFullName());
		   }
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		String roleCode=currentUser.getInstitutionCode();
		String refNo=goodReceiptParamt.getSgrNo();
		Integer sumtickts=this.goodsReceiptsService.getGoodsReceiptsSumTickts(refNo);
		model.addAttribute("roleCode", roleCode);
		model.addAttribute("sumtickts", sumtickts);
		return "inventory/goodsReceipts/goodsReceiptsSecondstep";
	}
	/**
	 * 
	    * @Title: goodsReceiptThird
	    * @Description: 批次入库第三步
	    * @param @param request
	    * @param @param model
	    * @param @param goodReceiptParamt
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=goodsReceiptThird", method = RequestMethod.POST)
	public String goodsReceiptThird(HttpServletRequest request,ModelMap model,GoodReceiptParamt goodReceiptParamt){
		goodReceiptParamt.setOperType(3);
		String sgrNo=goodReceiptParamt.getSgrNo();
		WhGoodsReceiptDetail detail=this.goodsReceiptsService.getGoodetailPlancodeByreNO(sgrNo);
		Long sumAmount=new Long(0);
		sumAmount=this.goodsReceiptsService.getGameReceiptAmount(goodReceiptParamt);
		
		 Long receivableAmount=this.goodsReceiptsService.getGameReceiptActAmount(goodReceiptParamt);
		 Long differencesAmount= sumAmount-receivableAmount;
		 model.addAttribute("sumAmount", sumAmount);
		 model.addAttribute("goodReceiptParamt", goodReceiptParamt);
		 
		 model.addAttribute("receivableAmount", receivableAmount);
		 model.addAttribute("differencesAmount", differencesAmount);
		goodReceiptParamt.setPlanCode(detail.getPlanCode());
		goodReceiptParamt.setBatchNo(detail.getBatchNo());
		
		model.addAttribute("goodReceiptParamt", goodReceiptParamt);
		GoodsStruct gstruct=new GoodsStruct();
		try{
			HttpSession session = request.getSession();
			User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			goodReceiptParamt.setAdminId(currentUser.getId().intValue());
			goodReceiptParamt.setWarehouseCode(currentUser.getWarehouseCode());
			gstruct=this.goodsReceiptsService.addCallGoods(goodReceiptParamt);
			//this.goodsReceiptsService.addGoodsBatch(goodReceiptParamt);

			if (gstruct.getC_errorcode() != 0) {
				throw new Exception(gstruct.getC_errormesg());
			}
		}catch(Exception e){
			logger.error("errmsgs"+e.getMessage());
			model.addAttribute("system_message", e.getMessage());
			return "common/errorTip";
		}
	   return "inventory/goodsReceipts/goodsReceiptsFourthstep";	
	}
	/**
	 * 
	    * @Title: goodsReceiptForth
	    * @Description: 批次入库完成
	    * @param @param request
	    * @param @param model
	    * @param @param goodReceiptParamt
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=goodsReceiptForth", method = RequestMethod.POST)
	public String goodsReceiptForth(HttpServletRequest request,ModelMap model,GoodReceiptParamt goodReceiptParamt){
		Long differencesAmount=goodReceiptParamt.getDifferencesAmount();
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		
		if(differencesAmount>0){
			DamageVo damageVo=new DamageVo();
			damageVo.setOpradmin(currentUser.getId());
			damageVo.setChecktype(1);
			damageVo.setRefcode(goodReceiptParamt.getSgrNo());
			damageVo.setRemark(goodReceiptParamt.getRemarks());
			try{
			this.goodsReceiptsService.addDamage(damageVo);
			if(damageVo.getC_errcode()!=0)
			{
				throw new Exception(damageVo.getC_errmsg());
			}
			}catch(Exception e){
				logger.error("errmsgs"+e.getMessage());
				model.addAttribute("system_message", e.getMessage());
				return "common/errorTip";
			}
		}
	
		return "redirect:goodsReceipts.do?method=listGoodsReceipts";
	}
	/**
	 * 
	    * @Title: continueGoodreceipt
	    * @Description: 完成的入库，继续入库
	    * @param @param request
	    * @param @param mode
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=continueGoodreceipt", method = RequestMethod.GET)
	public String continueGoodreceipt(HttpServletRequest request,ModelMap model){
		GoodReceiptParamt goodReceiptParamt=new GoodReceiptParamt();
		String sgrNo=request.getParameter("sgrNo");
		WhGoodsReceiptDetail wd=new WhGoodsReceiptDetail();
		List<WhGoodsReceiptDetail> wh=this.goodsReceiptsService.getGoodsReceiptDetailBysgrNo(sgrNo);
		if(wh!=null && wh.size()>0)
			wd=wh.get(0);
		String refNo=request.getParameter("refNo");
		//goodReceiptParamt.setSgrNo(refNo);
		goodReceiptParamt.setPlanCode(wd.getPlanCode());
		goodReceiptParamt.setBatchNo(wd.getBatchNo());
		goodReceiptParamt.setOperType(2);
		goodReceiptParamt.setStbNo(refNo);
		GameBatchImportDetail detail=this.goodsReceiptsService.getGamePlanOrBatchInfo(goodReceiptParamt);
		model.addAttribute("detail", detail);
		model.addAttribute("param", goodReceiptParamt);
		GamePlans game=this.goodsReceiptsService.getGamePlanInfoByCode(goodReceiptParamt.getPlanCode());
		model.addAttribute("planCode", goodReceiptParamt.getPlanCode());
		model.addAttribute("batchNo", wd.getBatchNo());
		model.addAttribute("operType", 2);
		model.addAttribute("refNo", refNo);
		Integer sumtickts=this.goodsReceiptsService.getGoodsReceiptsSumTickts(refNo);
		model.addAttribute("batchNo", wd.getBatchNo());
		if(game!=null && game.getFullName()!=null){
			   model.addAttribute("sumtickts", sumtickts);
		   }
		return "inventory/goodsReceipts/goodsReceiptsContune";
	}
	/**
	 * 
	    * @Title: receiptByStockTransfer
	    * @Description: 初始化调拨单入库
	    * @param @param request
	    * @param @param model
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	
	@RequestMapping(params = "method=receiptByStockTransfer", method = RequestMethod.GET)
	public String receiptByStockTransfer(HttpServletRequest request,ModelMap model){
	//	String sgrNo=this.goodsReceiptsService.getGoodsReceiptSgrNo();
		GoodsIssuesForm giform=new GoodsIssuesForm();
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		String houseCode="";
		if(currentUser.getWarehouseCode()!=null)
			houseCode=currentUser.getWarehouseCode();
		giform.setHouseCode(houseCode);
		String orgCode=currentUser.getInstitutionCode();
		List<StockTransfer> translerList=this.goodsReceiptsService.getReciveStrockByorgCode(orgCode);
		//model.addAttribute("sgrNo",sgrNo);
		model.addAttribute("translerList",translerList);
		return "inventory/goodsReceipts/goodsTransferfirstStep";
	}
	/**
	 * 
	    * @Title: getSaltranserDitalList
	    * @Description: 根据调拨单id查询调拨单详情列表
	    * @param @param request
	    * @param @return    参数
	    * @return List<StockTransferDetail>    返回类型
	    * @throws
	 */
	@ResponseBody
	@RequestMapping(params = "method=getSaltranserDitalList")
	public List<StockTransferDetail>getSaltranserDitalList(HttpServletRequest request){
		String stbNo=request.getParameter("stbNo");
		return this.goodsTransferService.getSaltranserDitalList(stbNo);
	}
	@ResponseBody
	@RequestMapping(params = "method=getReturnDitalList")
	public ReturnResult getReturnDitalList(HttpServletRequest request){
		ReturnResult reulst=new ReturnResult();
		String returnNo=request.getParameter("returnNo");
		RetrurnVo vo=this.goodsReturnService.getReturnSaleReturner(returnNo);
		List<RetrurnVo> listvo=this.goodsReturnService.getReturnSaleReturnerList(returnNo);
		if(vo!=null){
			if(vo.getMarketManager()!=null &&!"".equals(vo.getMarketManager()) ){
				reulst.setMarketManager(vo.getMarketManager());
				reulst.setApplyDate(vo.getApplyDate());
				reulst.setOrgName(vo.getOrgName());
			}
			if(vo.getTickets()!=null){
				reulst.setActickets(vo.getTickets());
			}
			
		}
		if(listvo!=null && listvo.size()>0){
			reulst.setRows(listvo);
		}
		return reulst;
	}
	/**
	 * 
	    * @Title: goodsTransterFirst
	    * @Description:初始化调拨单第二步
	    * @param @param request
	    * @param @param model
	    * @param @param goodReceiptParamt
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=goodsTransterFirst", method = RequestMethod.POST)
	public String goodsTransterFirst(HttpServletRequest request,ModelMap model,GoodReceiptParamt goodReceiptParamt){
		
	//String stbNo=request.getParameter("stbNo");
		String stbNo=request.getParameter("stbNo");
		List<GoodsIssueDetailVo> listvo=	this.goodsTransferService.getSaltranserInfoListbyCode(stbNo);
	
		Long sumTickets=new Long(0);
		if(!listvo.isEmpty()){
			for(GoodsIssueDetailVo vo:listvo){
				sumTickets+=vo.getTickets();
			}
			
		}
		model.addAttribute("listvo", listvo);
		model.addAttribute("param",goodReceiptParamt);
		model.addAttribute("sumTickets", sumTickets);
		
		return "inventory/goodsReceipts/goodsTransferSecondStep";
	}
	@ResponseBody
	@RequestMapping(params = "method=getGameBathInfoList")
	public List<GamePlanVo> getGameBathInfoList(HttpServletRequest request){
		List<GamePlanVo> gameList=this.goodsTransferService.getGameBathInfoList();
		//String jsonText = JSON.toJSONString(gameList, true);  
		return gameList;
	}
	/**
	 * 
	    * @Title: goodsTransferSecond
	    * @Description: 调拨单入库
	    * @param @param request
	    * @param @param model
	    * @param @param goodReceiptParamt
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	
	@RequestMapping(params = "method=goodsTransferSecond", method = RequestMethod.POST)
	public String goodsTransferSecond(HttpServletRequest request,ModelMap model,GoodReceiptParamt goodReceiptParamt){
	
		GoodsStruct gstruct=new GoodsStruct();
		try{
			HttpSession session = request.getSession();
			User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			goodReceiptParamt.setAdminId(currentUser.getId().intValue());
			goodReceiptParamt.setWarehouseCode(currentUser.getWarehouseCode());
			String stbNo=goodReceiptParamt.getStbNo();
			gstruct=this.goodsReceiptsService.addGameTranceBatch(goodReceiptParamt);
			if (gstruct.getC_errorcode() != 0) {
				throw new Exception(gstruct.getC_errormesg());
			}
			 List<GoodsIssueDetailVo> listvo=goodsTransferService.getSaltranserInfoListDiffbyCode(stbNo);
			 model.addAttribute("listvo", listvo);
		}catch(Exception e){
			logger.error("errmsgs"+e.getMessage());
			model.addAttribute("system_message", e.getMessage());
			return "common/errorTip";
		}
		Long sumAmount=new Long(0);
		sumAmount=this.goodsReceiptsService.getGameReceiptAmount(goodReceiptParamt);
	
	
		 Long receivableAmount=this.goodsReceiptsService.getGameReceiptActAmount(goodReceiptParamt);
		 Long differencesAmount= sumAmount-receivableAmount;
		/* model.addAttribute("sumAmount", sumAmount);
		 
		 model.addAttribute("receivableAmount", receivableAmount);*/
		 model.addAttribute("differencesAmount", differencesAmount);
		 model.addAttribute("stbNo", goodReceiptParamt.getStbNo());
		/* model.addAttribute("planCode", goodReceiptParamt.getPlanCode());
		 model.addAttribute("batchNo",goodReceiptParamt.getBatchNo());*/
			return "inventory/goodsReceipts/goodsTransferThirdstep";
	}
	/**
	 * 
	    * @Title: goodsTranstertNext
	    * @Description: 调拨单继续入库
	    * @param @param request
	    * @param @param model
	    * @param @param goodReceiptParamt
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=goodsTranstertNext", method = RequestMethod.POST)
	public String goodsTranstertNext(HttpServletRequest request,ModelMap model,GoodReceiptParamt goodReceiptParamt){
	model.addAttribute("goodReceiptParamt",goodReceiptParamt);
		
		model.addAttribute("param",goodReceiptParamt);
        String stbNo=goodReceiptParamt.getStbNo();
        List<GoodsIssueDetailVo> listvo=goodsTransferService.getSaltranserInfoListbyCode(stbNo);
		 model.addAttribute("listvo", listvo);
			Long sumTickets=new Long(0);
			if(!listvo.isEmpty()){
				for(GoodsIssueDetailVo vo:listvo){
					sumTickets+=vo.getTickets();
				}
				
			}
			model.addAttribute("listvo", listvo);
			
			model.addAttribute("sumTickets", sumTickets);
        Integer sumtickts=this.goodsReceiptsService.getGoodsReceiptsSumTickts(stbNo);
		
		model.addAttribute("sumtickts", sumtickts);	 
		
		return "inventory/goodsReceipts/goodsTransferSecondStep";
	}
	/**
	 * 
	    * @Title: goodsTranstertThird
	    * @Description: 调拨单第三步
	    * @param @param request
	    * @param @param model
	    * @param @param goodReceiptParamt
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=goodsTranstertThird", method = RequestMethod.POST)
	public String goodsTranstertThird(HttpServletRequest request,ModelMap model,GoodReceiptParamt goodReceiptParamt){
		
		goodReceiptParamt.setOperType(3);
//		String stbNo=goodReceiptParamt.getStbNo();
		//Long stbTicts=this.goodsIssuesService.getSaleActTicktsByCode(stbNo);
		//model.addAttribute("stbTicts", stbTicts);
		model.addAttribute("goodReceiptParamt", goodReceiptParamt);
		GoodsStruct gstruct=new GoodsStruct();
		try{
			HttpSession session = request.getSession();
			User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			goodReceiptParamt.setAdminId(currentUser.getId().intValue());
			goodReceiptParamt.setWarehouseCode(currentUser.getWarehouseCode());
			String stbNo=goodReceiptParamt.getStbNo();
			gstruct=this.goodsReceiptsService.addGameTranceBatch(goodReceiptParamt);
			if (gstruct.getC_errorcode() != 0) {
				throw new Exception(gstruct.getC_errormesg());
			}
			Long sumAmount=new Long(0);
			sumAmount=this.goodsReceiptsService.getGameReceiptAmount(goodReceiptParamt);
			 List<GoodsIssueDetailVo> listvo=goodsTransferService.getSaltranserInfoListDiffbyCode(stbNo);
			 model.addAttribute("listvo", listvo);
		
			 Long receivableAmount=this.goodsReceiptsService.getGameReceiptActAmount(goodReceiptParamt);
			 Long differencesAmount= sumAmount-receivableAmount;
			/* model.addAttribute("sumAmount", sumAmount);*/
			 model.addAttribute("stbNo", goodReceiptParamt.getStbNo());
			 model.addAttribute("receivableAmount", receivableAmount);
			 model.addAttribute("differencesAmount", differencesAmount);
		}catch(Exception e){
			logger.error("errmsgs"+e.getMessage());
			model.addAttribute("system_message", e.getMessage());
			return "common/errorTip";
		}
		return "inventory/goodsReceipts/goodsTransterFourthstep";	
	}
	/**
	 * 
	    * @Title: goodsReceiptForth
	    * @Description: 批次入库完成
	    * @param @param request
	    * @param @param model
	    * @param @param goodReceiptParamt
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=goodsTransterForth", method = RequestMethod.POST)
	public String goodsTransterForth(HttpServletRequest request,ModelMap model,GoodReceiptParamt goodReceiptParamt){
		Long differencesAmount=goodReceiptParamt.getDifferencesAmount();
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		
		if(differencesAmount>0){
			DamageVo damageVo=new DamageVo();
			damageVo.setOpradmin(currentUser.getId());
			damageVo.setChecktype(2);
			damageVo.setRefcode(goodReceiptParamt.getStbNo());
			damageVo.setRemark(goodReceiptParamt.getRemarks());
			try{
			this.goodsReceiptsService.addDamage(damageVo);
			if(damageVo.getC_errcode()!=0)
			{
				throw new Exception(damageVo.getC_errmsg());
			}
			}catch(Exception e){
				logger.error("errmsgs"+e.getMessage());
				model.addAttribute("system_message", e.getMessage());
				return "common/errorTip";
			}
		}
	   return "redirect:goodsReceipts.do?method=listGoodsReceipts";
	}
	/**
	 * 
	    * @Title: receiptByRetrunDelevery
	    * @Description: 还货入库
	    * @param @param request
	    * @param @param model
	    * @param @param goodReceiptParamt
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=receiptByRetrunDelevery", method = RequestMethod.GET)
	public String receiptByRetrunDelevery(HttpServletRequest request,ModelMap model){
		GoodsReceiptsForm goodsReceiptsForm=new GoodsReceiptsForm ();
		HttpSession session = request.getSession();
		String houseCode="";
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		if(currentUser.getWarehouseCode()!=null){
			houseCode=currentUser.getInstitutionCode();
		}
		goodsReceiptsForm.setHouseCode(houseCode);
		   List<ReturnRecoder> returnList=this.goodsReturnService.getReturnInfoList(goodsReceiptsForm);
		 
		   model.addAttribute("returnList", returnList);
		  return "inventory/goodsReceipts/goodsRetrunfirstStep";
			
		}
	/**
	 * 
	    * @Title: goodsRetrurnFirst
	    * @Description: 换货入库第二步
	    * @param @param request
	    * @param @param model
	    * @param @param goodReceiptParamt
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	
	@RequestMapping(params = "method=goodsRetrurnFirst", method = RequestMethod.POST)
	public String goodsRetrurnFirst(HttpServletRequest request,ModelMap model,GoodReceiptParamt goodReceiptParamt){
	model.addAttribute("param",goodReceiptParamt);
	String returnNo=goodReceiptParamt.getReturnNo();
	List<GoodsIssueDetailVo> listvo=this.goodsReturnService.getReturnListInfoByCode(returnNo);
	 model.addAttribute("listvo", listvo);
		Long sumTickets=new Long(0);
		if(!listvo.isEmpty()){
			for(GoodsIssueDetailVo vo:listvo){
				sumTickets+=vo.getTickets();
			}
			
		}
		model.addAttribute("sumTickets", sumTickets);
		return "inventory/goodsReceipts/goodsRetrunSecondStep";
		
	}
	/**
	 * 
	    * @Title: goodsReturnSecond
	    * @Description: 批次还货入库第二步
	    * @param @param request
	    * @param @param model
	    * @param @param goodReceiptParamt
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=goodsReturnSecond", method = RequestMethod.POST)
	public String goodsReturnSecond(HttpServletRequest request,ModelMap model,GoodReceiptParamt goodReceiptParamt){
		

		GoodsStruct gstruct=new GoodsStruct();
		try{
			HttpSession session = request.getSession();
			User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			goodReceiptParamt.setAdminId(currentUser.getId().intValue());
			if(currentUser.getWarehouseCode()!=null){
			goodReceiptParamt.setWarehouseCode(currentUser.getWarehouseCode());
			}else{
				model.addAttribute("system_message","Without this warehouse");
				// log.error("查询角色数据发生异常！", e);
				return "common/errorTip";
			}
			String returnNo= goodReceiptParamt.getReturnNo();
			gstruct=this.goodsReceiptsService.addGameRetrunBatch(goodReceiptParamt);
			if (gstruct.getC_errorcode() != 0) {
				throw new Exception(gstruct.getC_errormesg());
			}
			 List<GoodsIssueDetailVo> listvo=this.goodsReturnService.getReturnListInfoDiffByCode(returnNo);
			 model.addAttribute("listvo", listvo);
		}catch(Exception e){
			logger.error("errmsgs"+e.getMessage());
			model.addAttribute("system_message", e.getMessage());
			return "common/errorTip";
		}
		Long sumAmount=new Long(0);
		sumAmount=this.goodsReceiptsService.getGameReceiptAmount(goodReceiptParamt);
		 Long receivableAmount=this.goodsReceiptsService.getGameReceiptActAmount(goodReceiptParamt);
		 Long differencesAmount= sumAmount-receivableAmount;
		 model.addAttribute("sumAmount", sumAmount);
		 model.addAttribute("planCode", goodReceiptParamt.getPlanCode());
		 model.addAttribute("receivableAmount", receivableAmount);
		 model.addAttribute("differencesAmount", differencesAmount);
		 model.addAttribute("sgrNo", goodReceiptParamt.getSgrNo());
		 model.addAttribute("returnNo", goodReceiptParamt.getReturnNo());
			return "inventory/goodsReceipts/goodsReturnThirdstep";
	}
	/**
	 * 
	    * @Title: goodsReturnThird
	    * @Description: 批次还货第三步
	    * @param @param request
	    * @param @param model
	    * @param @param goodReceiptParamt
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=goodsReturnThird", method = RequestMethod.POST)
	public String goodsReturnThird(HttpServletRequest request,ModelMap model,GoodReceiptParamt goodReceiptParamt){
		goodReceiptParamt.setOperType(3);
		
	
		 Long sumAmount=new Long(0);
			sumAmount=this.goodsReceiptsService.getGameReceiptAmount(goodReceiptParamt);
			 Long receivableAmount=this.goodsReceiptsService.getGameReceiptActAmount(goodReceiptParamt);
			 Long differencesAmount= sumAmount-receivableAmount;
			 model.addAttribute("sumAmount", sumAmount);
			 model.addAttribute("planCode", goodReceiptParamt.getPlanCode());
			 model.addAttribute("receivableAmount", receivableAmount);
			 model.addAttribute("differencesAmount", differencesAmount);
			 
		model.addAttribute("goodReceiptParamt", goodReceiptParamt);
		String returnNo=goodReceiptParamt.getReturnNo();
		GoodsStruct gstruct=new GoodsStruct();
		try{
			HttpSession session = request.getSession();
			User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			goodReceiptParamt.setAdminId(currentUser.getId().intValue());
			goodReceiptParamt.setWarehouseCode(currentUser.getWarehouseCode());
			gstruct=this.goodsReceiptsService.addGameRetrunBatch(goodReceiptParamt);
			if (gstruct.getC_errorcode() != 0) {
				throw new Exception(gstruct.getC_errormesg());
			}
			 List<GoodsIssueDetailVo> listvo=this.goodsReturnService.getReturnListInfoDiffByCode(returnNo);
			 model.addAttribute("listvo", listvo);
		}catch(Exception e){
			logger.error("errmsgs"+e.getMessage());
			model.addAttribute("system_message", e.getMessage());
			return "common/errorTip";
		}
		return "inventory/goodsReceipts/goodsReturnFourstep";
	}
	/**
	 * 
	    * @Title: goodsReturnForth
	    * @Description: 还货入库完成
	    * @param @param request
	    * @param @param model
	    * @param @param goodReceiptParamt
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=goodsReturnForth", method = RequestMethod.POST)
	public String goodsReturnForth(HttpServletRequest request,ModelMap model,GoodReceiptParamt goodReceiptParamt){
		
		
			
			return "redirect:goodsReceipts.do?method=listGoodsReceipts";
	}
	
	
	/**
	 * 
	    * @Title: continueGoodreceipt
	    * @Description: 调拨单未完成的入库，继续入库
	    * @param @param request
	    * @param @param mode
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=continueGoodTranser")
	public String continueGoodTranser(HttpServletRequest request,ModelMap model){
		GoodReceiptParamt goodReceiptParamt=new GoodReceiptParamt();
		String sgrNo=request.getParameter("sgrNo");
	    String stbNo=this.goodsTransferService.getGameRfeNo(sgrNo);
		Integer sumtickts=this.goodsReceiptsService.getGoodsReceiptsSumTickts(stbNo);
		List<GoodsIssueDetailVo> listvo=	this.goodsTransferService.getSaltranserInfoListbyCode(stbNo);
		
		Long sumTickets=new Long(0);
		if(!listvo.isEmpty()){
			for(GoodsIssueDetailVo vo:listvo){
				sumTickets+=vo.getTickets();
			}
			
		}
		model.addAttribute("listvo", listvo);
		model.addAttribute("sumtickts", sumtickts);	  
		model.addAttribute("sumTickets", sumTickets);	  
	    goodReceiptParamt.setStbNo(stbNo);
	    goodReceiptParamt.setSgrNo(sgrNo);
	    model.addAttribute("stbNo",stbNo);
	    model.addAttribute("sgrNo",sgrNo);
		return "inventory/goodsReceipts/goodsTransferSecondStepcontinue";
		
	}
	/**
	 * 
	    * @Title: continueGoodReturn
	    * @Description: 还货入库继续入库
	    * @param @param request
	    * @param @param model
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=continueGoodReturn")
	public String continueGoodReturn(HttpServletRequest request,ModelMap model){
		GoodReceiptParamt goodReceiptParamt=new GoodReceiptParamt();
		String sgrNo=request.getParameter("sgrNo");
	    String returnNo=this.goodsTransferService.getGameRfeNo(sgrNo);
      Integer sumtickts=this.goodsReceiptsService.getGoodsReceiptsSumTickts(returnNo);
      
  	  List<GoodsIssueDetailVo> listvo=this.goodsReturnService.getReturnListInfoByCode(returnNo);
  	 model.addAttribute("listvo", listvo);
  	 
 	Long sumTickets=new Long(0);
	if(!listvo.isEmpty()){
		for(GoodsIssueDetailVo vo:listvo){
			sumTickets+=vo.getTickets();
		}
		
	}
	model.addAttribute("sumTickets", sumTickets);	  
		model.addAttribute("sumtickts", sumtickts);	    
	    goodReceiptParamt.setReturnNo(returnNo);
	  //  goodReceiptParamt.setSgrNo(sgrNo);;
	    model.addAttribute("param",goodReceiptParamt);
	    model.addAttribute("returnNo",returnNo);
		return "inventory/goodsReceipts/goodsRetrunSecondStepcontinue";
		
	}
	@RequestMapping(params = "method=getGoodsDetailDamagedByNo")
	public String getGoodsDetailDamagedByNo(HttpServletRequest request,ModelMap model){
		String sgrNo=request.getParameter("sgrNo");
		WhGoodsReceipt gpt=this.goodsReceiptsService.getGoodsDamagedByNo(sgrNo);
		gpt.setSgrNo(sgrNo);
		 model.addAttribute("param",gpt);
			return "inventory/goodsReceipts/goodsDamageAdd";
	}

	/**
	 * 
	    * @Title: print
	    * @Description: 批次打印入库单
	    * @param @param request
	    * @param @param model
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=print")
	public String print(HttpServletRequest request,ModelMap model){
		String refNo=request.getParameter("refNo");
		List<WhGoodsReceiptDetail> listvo=this.goodsReceiptsService.getGoodsReceiptsPrintList(refNo);
		WhGoodsReceipt vo=this.goodsReceiptsService.getGoodsReceiptsPrintByrefNo(refNo);
		WhGoodsReceiptDetail vosum=this.goodsReceiptsService.getGoodsReceiptsPrintSumByrefNo(refNo);
		model.addAttribute("listvo", listvo);
		model.addAttribute("vo", vo);
		model.addAttribute("vosum", vosum);
		return "inventory/goodsReceipts/goodsprint";
	}
	/**
	 * 
	    * @Title: printTranstr
	    * @Description: 调拨单入库打印
	    * @param @param request
	    * @param @param model
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=printTranstr")
	public String printTranstr(HttpServletRequest request,ModelMap model){
		String refNo=request.getParameter("refNo");
		List<WhGoodsReceiptDetail> listvo=this.goodsReceiptsService.getGoodsReceiptsPrintList(refNo);
		WhGoodsReceipt vo=this.goodsReceiptsService.getGoodsReceiptsPrintByrefNo(refNo);
		GoodsReceiptTrans tranvo=this.goodsReceiptsService.getGoodsReceiptsTranPrintByStbno(refNo);
		WhGoodsReceiptDetail vosum=this.goodsReceiptsService.getGoodsReceiptsPrintSumByrefNo(refNo);
		model.addAttribute("listvo", listvo);
		model.addAttribute("vo", vo);
		model.addAttribute("vosum", vosum);
		model.addAttribute("tranvo", tranvo);
		return "inventory/goodsReceipts/goodsTransprint";
	}
	/**
	 * 
	    * @Title: printRetrun
	    * @Description: 还货入库打印
	    * @param @param request
	    * @param @param model
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=printRetrun")
	public String printRetrun(HttpServletRequest request,ModelMap model){
		String refNo=request.getParameter("refNo");
		List<WhGoodsReceiptDetail> listvo=this.goodsReceiptsService.getGoodsReceiptsPrintList(refNo);
		WhGoodsReceipt vo=this.goodsReceiptsService.getGoodsReceiptsPrintByrefNo(refNo);
		ReturnRecoder returnvo=this.goodsReceiptsService.getGoodsReceiptsReturnPrintByStbno(refNo);
		WhGoodsReceiptDetail vosum=this.goodsReceiptsService.getGoodsReceiptsPrintSumByrefNo(refNo);
		model.addAttribute("listvo", listvo);
		model.addAttribute("vo", vo);
		model.addAttribute("vosum", vosum);
		model.addAttribute("returnvo", returnvo);
		return "inventory/goodsReceipts/goodsRetrunprint";
	}
	
 @RequestMapping(params = "method=completeGoodreceipt", method = RequestMethod.GET)
  public String completeGoodreceipt(HttpServletRequest request,ModelMap model,GoodReceiptParamt goodReceiptParamt){
	 int type=Integer.parseInt(request.getParameter("type"));
	 String refNo=request.getParameter("refNo");
	 //operType
	 goodReceiptParamt.setOperType(3);
	
	 try{
		 if(type==1){
			 Long sumAmount=new Long(0);
			 goodReceiptParamt.setSgrNo(refNo);
			 sumAmount=this.goodsReceiptsService.getGameReceiptAmount(goodReceiptParamt);
				/*GameBatchImportDetail bachdetail=this.goodsReceiptsService.getGamePlanOrBatchInfo(goodReceiptParamt);
				 if(bachdetail!=null){
					 sumAmount=bachdetail.getTicketsEveryBatch();
				 }*/
				 Long receivableAmount=this.goodsReceiptsService.getGameReceiptActAmount(goodReceiptParamt);
				 Long differencesAmount= sumAmount-receivableAmount;
				 model.addAttribute("sumAmount", sumAmount);
				
				 
				 model.addAttribute("receivableAmount", receivableAmount);
				 model.addAttribute("differencesAmount", differencesAmount);
				
				 
				 WhGoodsReceiptDetail detail=this.goodsReceiptsService.getGoodetailPlancodeByreNO(refNo);
					goodReceiptParamt.setPlanCode(detail.getPlanCode());
					goodReceiptParamt.setBatchNo(detail.getBatchNo());
					model.addAttribute("goodReceiptParamt", goodReceiptParamt);
					GoodsStruct gstruct=new GoodsStruct();
					try{
						HttpSession session = request.getSession();
						User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
						goodReceiptParamt.setAdminId(currentUser.getId().intValue());
						goodReceiptParamt.setWarehouseCode(currentUser.getWarehouseCode());
						gstruct=this.goodsReceiptsService.addCallGoods(goodReceiptParamt);
						//this.goodsReceiptsService.addGoodsBatch(goodReceiptParamt);

						if (gstruct.getC_errorcode() != 0) {
							throw new Exception(gstruct.getC_errormesg());
						}
					}catch(Exception e){
						logger.error("errmsgs"+e.getMessage());
						model.addAttribute("system_message", e.getMessage());
						return "common/errorTip";
					}
				   return "inventory/goodsReceipts/goodsReceiptsFourthstep";	
				//this.goodsReceiptsService.addGoodsBatch(goodReceiptParamt);
	
				
		 }
		  if(type==2){
			 goodReceiptParamt.setStbNo(refNo);
				Long sumAmount=new Long(0);
				sumAmount=this.goodsReceiptsService.getGameReceiptAmount(goodReceiptParamt);
			
			/*	GameBatchImportDetail bachdetail=this.goodsReceiptsService.getGamePlanOrBatchInfoSum(goodReceiptParamt);
				 if(bachdetail!=null){
					 sumAmount=bachdetail.getTicketsEveryBatch();
				 }*/
				 Long receivableAmount=this.goodsReceiptsService.getGameReceiptActAmount(goodReceiptParamt);
				 Long differencesAmount= sumAmount-receivableAmount;
				 model.addAttribute("sumAmount", sumAmount);
				 String stbNo=goodReceiptParamt.getStbNo();
			     Long stbTicts=this.goodsIssuesService.getSaleActTicktsByCode(stbNo);
				 model.addAttribute("stbTicts", stbTicts);
				 model.addAttribute("receivableAmount", receivableAmount);
				 model.addAttribute("differencesAmount", differencesAmount);
				 model.addAttribute("stbNo", goodReceiptParamt.getStbNo());
				 model.addAttribute("goodReceiptParamt", goodReceiptParamt);
				 GoodsStruct gstruct=new GoodsStruct();
					try{
						HttpSession session = request.getSession();
						User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
						goodReceiptParamt.setAdminId(currentUser.getId().intValue());
						goodReceiptParamt.setWarehouseCode(currentUser.getWarehouseCode());
						gstruct=this.goodsReceiptsService.addGameTranceBatch(goodReceiptParamt);
						if (gstruct.getC_errorcode() != 0) {
							throw new Exception(gstruct.getC_errormesg());
						}
						 List<GoodsIssueDetailVo> listvo=goodsTransferService.getSaltranserInfoListDiffbyCode(refNo);
						 model.addAttribute("listvo", listvo);
					}catch(Exception e){
						logger.error("errmsgs"+e.getMessage());
						model.addAttribute("system_message", e.getMessage());
						return "common/errorTip";
					}
			 return "inventory/goodsReceipts/goodsTransterFourthstep";	
		 }
		  if(type==3){
			 
			  goodReceiptParamt.setSgrNo(refNo);
			  goodReceiptParamt.setReturnNo(refNo);
			  Long sumAmount=new Long(0);
				sumAmount=this.goodsReceiptsService.getGameReceiptAmount(goodReceiptParamt);
				 Long receivableAmount=this.goodsReceiptsService.getGameReceiptActAmount(goodReceiptParamt);
				 Long differencesAmount= sumAmount-receivableAmount;
				 model.addAttribute("sumAmount", sumAmount);
				 model.addAttribute("planCode", goodReceiptParamt.getPlanCode());
				 model.addAttribute("receivableAmount", receivableAmount);
				 model.addAttribute("differencesAmount", differencesAmount);
				 
				 model.addAttribute("returnNo", goodReceiptParamt.getReturnNo());
				 model.addAttribute("goodReceiptParamt", goodReceiptParamt);
					GoodsStruct gstruct=new GoodsStruct();
					try{
						HttpSession session = request.getSession();
						User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
						goodReceiptParamt.setAdminId(currentUser.getId().intValue());
						goodReceiptParamt.setWarehouseCode(currentUser.getWarehouseCode());
						gstruct=this.goodsReceiptsService.addGameRetrunBatch(goodReceiptParamt);
						if (gstruct.getC_errorcode() != 0) {
							throw new Exception(gstruct.getC_errormesg());
						}
						 List<GoodsIssueDetailVo> listvo=this.goodsReturnService.getReturnListInfoDiffByCode(refNo);
						 model.addAttribute("listvo", listvo);
					}catch(Exception e){
						logger.error("errmsgs"+e.getMessage());
						model.addAttribute("system_message", e.getMessage());
						return "common/errorTip";
					}
				 return "inventory/goodsReceipts/goodsReturnFourstep";
		  }
		 
	 }catch(Exception e){
		 logger.error("errmsgs"+e.getMessage());
			model.addAttribute("system_message", e.getMessage());
			return "common/errorTip";
	 }
	 return "common/errorTip";
	}
 
 /**
  * 
     * @Title: finishGoodreceipt
     * @Description: 入库损毁
     * @param @param request
     * @param @param model
     * @param @return    参数
     * @return String    返回类型
     * @throws
  */
 @RequestMapping(params = "method=finishGoodreceipt", method = RequestMethod.GET)
 public String finishGoodreceipt(HttpServletRequest request,ModelMap model,GoodReceiptParamt goodReceiptParamt){
	 int type=Integer.parseInt(request.getParameter("type"));
	 String refNo=request.getParameter("refNo");
	 //operType
	 goodReceiptParamt.setOperType(3);
	
	 try{
		 if(type==1){
			 Long sumAmount=new Long(0);
			 goodReceiptParamt.setSgrNo(refNo);
			 sumAmount=this.goodsReceiptsService.getGameReceiptAmount(goodReceiptParamt);
			 Long receivableAmount=this.goodsReceiptsService.getGameReceiptActAmount(goodReceiptParamt);
			 Long differencesAmount= sumAmount-receivableAmount;
			 model.addAttribute("sumAmount", sumAmount);
			
			 
			 model.addAttribute("receivableAmount", receivableAmount);
			 model.addAttribute("differencesAmount", differencesAmount);
			
			 
			 WhGoodsReceiptDetail detail=this.goodsReceiptsService.getGoodetailPlancodeByreNO(refNo);
			 goodReceiptParamt.setPlanCode(detail.getPlanCode());
			 goodReceiptParamt.setBatchNo(detail.getBatchNo());
			 model.addAttribute("goodReceiptParamt", goodReceiptParamt);
			
			 return "inventory/goodsReceipts/goodsReceiptsFourthstep";	

		 }
		  if(type==2){
			  	goodReceiptParamt.setStbNo(refNo);
				Long sumAmount=new Long(0);
				sumAmount=this.goodsReceiptsService.getGameReceiptAmount(goodReceiptParamt);
				 Long receivableAmount=this.goodsReceiptsService.getGameReceiptActAmount(goodReceiptParamt);
				 Long differencesAmount= sumAmount-receivableAmount;
				 model.addAttribute("sumAmount", sumAmount);
				 String stbNo=goodReceiptParamt.getStbNo();
			     Long stbTicts=this.goodsIssuesService.getSaleActTicktsByCode(stbNo);
				 model.addAttribute("stbTicts", stbTicts);
				 model.addAttribute("receivableAmount", receivableAmount);
				 model.addAttribute("differencesAmount", differencesAmount);
				 model.addAttribute("stbNo", goodReceiptParamt.getStbNo());
				 model.addAttribute("goodReceiptParamt", goodReceiptParamt);
				try{					
					 List<GoodsIssueDetailVo> listvo=goodsTransferService.getSaltranserInfoListDiffbyCode(refNo);
					 model.addAttribute("listvo", listvo);
				}catch(Exception e){
					logger.error("errmsgs"+e.getMessage());
					model.addAttribute("system_message", e.getMessage());
					return "common/errorTip";
				}
			 return "inventory/goodsReceipts/goodsTransterFourthstep";	
		 }
	 }catch(Exception e){
		 logger.error("errmsgs"+e.getMessage());
			model.addAttribute("system_message", e.getMessage());
			return "common/errorTip";
	 }
	 return "common/errorTip";
	}
 /**
  * 
     * @Title: printAll
     * @Description: 根据类型打印入库单
     * @param @param request
     * @param @param model
     * @param @return    参数
     * @return String    返回类型
     * @throws
  */
 @RequestMapping(params = "method=printAll")
 public String printAll(HttpServletRequest request,ModelMap model){
	 int type=Integer.parseInt(request.getParameter("type"));
		String refNo=request.getParameter("sgrNo");
	 if(type==1){
		
			List<WhGoodsReceiptDetail> listvo=this.goodsReceiptsService.getGoodsReceiptsPrintList(refNo);
			WhGoodsReceipt vo=this.goodsReceiptsService.getGoodsReceiptsPrintByrefNo(refNo);
			WhGoodsReceiptDetail vosum=this.goodsReceiptsService.getGoodsReceiptsPrintSumByrefNo(refNo);
			model.addAttribute("listvo", listvo);
			model.addAttribute("vo", vo);
			model.addAttribute("vosum", vosum);
			return "inventory/goodsReceipts/goodsprint";
	 }
	 if(type==2){
			List<WhGoodsReceiptDetail> listvo=this.goodsReceiptsService.getGoodsReceiptsPrintList(refNo);
			WhGoodsReceipt vo=this.goodsReceiptsService.getGoodsReceiptsPrintByrefNo(refNo);
			GoodsReceiptTrans tranvo=this.goodsReceiptsService.getGoodsReceiptsTranPrintByStbno(refNo);
			WhGoodsReceiptDetail vosum=this.goodsReceiptsService.getGoodsReceiptsPrintSumByrefNo(refNo);
			model.addAttribute("listvo", listvo);
			model.addAttribute("vo", vo);
			model.addAttribute("vosum", vosum);
			model.addAttribute("tranvo", tranvo);
			return "inventory/goodsReceipts/goodsTransprint";
	 }
	if(type==3){
		List<WhGoodsReceiptDetail> listvo=this.goodsReceiptsService.getGoodsReceiptsPrintList(refNo);
		WhGoodsReceipt vo=this.goodsReceiptsService.getGoodsReceiptsPrintByrefNo(refNo);
		ReturnRecoder returnvo=this.goodsReceiptsService.getGoodsReceiptsReturnPrintByStbno(refNo);
		WhGoodsReceiptDetail vosum=this.goodsReceiptsService.getGoodsReceiptsPrintSumByrefNo(refNo);
		model.addAttribute("listvo", listvo);
		model.addAttribute("vo", vo);
		model.addAttribute("vosum", vosum);
		model.addAttribute("returnvo", returnvo);
		return "inventory/goodsReceipts/goodsRetrunprint";
	 }
	 return "common/errorTip";
 }
 @ResponseBody
 @RequestMapping(params = "method=getTransGameBystbNo")
 public List<GamePlanVo> getTransGameBystbNo(HttpServletRequest request){
	 String stbNo=request.getParameter("stbNo");
	 List <GamePlanVo> listplan=this.goodsTransferService.getSaltranserGame(stbNo);
	 return listplan;
 }
 @ResponseBody
 @RequestMapping(params = "method=getReturnPlanInfoBycode")
 public List<GamePlanVo>getReturnPlanInfoBycode(HttpServletRequest request){
	 String returnNo=request.getParameter("returnNo");
	 List <GamePlanVo> listplan=this.goodsReturnService.getReturnPlanInfoBycode(returnNo);
	 return listplan;
 }

}
