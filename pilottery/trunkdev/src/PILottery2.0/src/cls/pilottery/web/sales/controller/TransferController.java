package cls.pilottery.web.sales.controller;

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
import org.springframework.web.bind.annotation.ResponseBody;

import cls.pilottery.common.EnumConfigEN;
import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.web.institutions.model.InfOrgs;
import cls.pilottery.web.institutions.service.InstitutionsService;
import cls.pilottery.web.sales.entity.StockTransfer;
import cls.pilottery.web.sales.form.TransferForm;
import cls.pilottery.web.sales.model.PlanModel;
import cls.pilottery.web.sales.service.OrderService;
import cls.pilottery.web.sales.service.TransferService;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.system.model.UserLanguage;

/**
 * 调拨单管理
 * @author huangchy
 */
@Controller
@RequestMapping("transfer")
public class TransferController {
	Logger log = Logger.getLogger(TransferController.class);
	
	@Autowired
	private TransferService transferService;
	
	@Autowired
	private OrderService orderService;
	
	@Autowired
	private InstitutionsService institutionsService;

	private Map<Integer,String> stockTransferStatus = EnumConfigEN.purchaseOrderStatus;
	@ModelAttribute("stockTransferStatus")
	public Map<Integer,String> getStockTransferStatus(HttpServletRequest request)
	{
	if(request != null)
			this.stockTransferStatus =LocaleUtil.getUserLocaleEnum("stockTransferStatus", request);
		
		return 	stockTransferStatus;
	}
	@RequestMapping(params = "method=listTransferByApplyUser")
	public String listTransferByApplyUser(HttpServletRequest request, ModelMap model,TransferForm form) {
		List<StockTransfer> list = null;
		int count = 0 ;
		try {
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			form.setCuserOrg(currentUser.getInstitutionCode());
			int pageIndex = PageUtil.getPageIndex(request);
			count = transferService.getTransferCount(form);
			if (count > 0) {
				form.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
				form.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
				list = transferService.getTransferList(form);
			}

		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("查询调拨单列表功能发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
//			return "_common/errorTip";
		}
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", list);
		model.addAttribute("form",form);
		return LocaleUtil.getUserLocalePath("sales/stockTransfer/listStockTransfers", request);
//		return "sales/stockTransfer/listStockTransfers";
	}
	
	@RequestMapping(params = "method=listTransferForInquery")
	public String listTransferForInquery(HttpServletRequest request, ModelMap model,TransferForm form) {
		List<StockTransfer> list = null;
		int count = 0 ;
		try {
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			form.setCuserOrg(currentUser.getInstitutionCode());
			int pageIndex = PageUtil.getPageIndex(request);
			count = transferService.getTransferCountForInquery(form);
			if (count > 0) {
				form.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
				form.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
				list = transferService.getTransferListForInquery(form);
			}
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("查询调拨单列表功能发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", list);
		model.addAttribute("form",form);
		return LocaleUtil.getUserLocalePath("sales/stockTransfer/listStockTransferForApproval", request);
//		return "sales/stockTransfer/listStockTransferForApproval";
	}
	
	/*
	 * 初始化新增调拨单页面
	 */
	@RequestMapping(params = "method=initStockTransferAdd")
	public String initStockTransferAdd(HttpServletRequest request, ModelMap model) {
		try {
			List<PlanModel> planList = orderService.getPlanList();
			List<InfOrgs> orgList = institutionsService.getAllInstitutionsInfo();
			model.addAttribute("planList",planList);
			model.addAttribute("orgList", orgList);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("初始化调拨单新增页面发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
//			return "common/errorTip";
		}
		model.addAttribute("oper",1);
		return LocaleUtil.getUserLocalePath("sales/stockTransfer/addStockTransfer", request);
//		return "sales/stockTransfer/addStockTransfer";
	}
	
	
	 /*
	  * 保存調撥單
	  */
	@RequestMapping(params = "method=saveStockTransfer")
	public String saveStockTransfer(HttpSession session, ModelMap model,StockTransfer order,HttpServletRequest request) {
		try {
			User currentUser = (User)session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			order.setApplyAdmin(currentUser.getId().shortValue());
			transferService.saveStockTransfer(order);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("保存调拨单功能发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("common/successTip", request);
//		return "common/successTip";
	}
	
	 /*
	  *  撤销调拨单
	  */
	@ResponseBody
	@RequestMapping(params="method=cancelStockTransfer")
	public String cancelStockTransfer(HttpServletRequest request){
		String stbNo=request.getParameter("stbNo");
		String result = null;
		User user = (User) request.getSession().getAttribute(
				SysConstants.CURR_LOGIN_USER_SESSION);
		try{
			//修改订单状态为2(已撤销)
			int updateCount = transferService.modifyStockTransferStatus(stbNo,2);
			if(updateCount !=1){
				log.warn("撤销调拨单出现异常,调拨单编号:"+stbNo+",撤销记录数:"+updateCount);
				
				
				if (user != null) {
					UserLanguage lg = user.getUserLang();
					if (lg == UserLanguage.ZH) {
						result="撤销失败!";

					} else if (lg == UserLanguage.EN) {
						result="Cancel Failed!";
					}
				}
			}
		}catch(Exception e){
			log.error("撤销调拨单出现异常,异常信息:"+e.getMessage());
			
			if (user != null) {
				UserLanguage lg = user.getUserLang();
				if (lg == UserLanguage.ZH) {
					result="撤销失败：系统异常!";

				} else if (lg == UserLanguage.EN) {
					result = "Cancel Failed : System Error！";
				}
			}
		}
		return result;
	}
	
	 /*
	  * 调拨单明细
	  */
	@RequestMapping(params = "method=stockTransferDetail")
	public String stockTransferDetail(HttpServletRequest request, ModelMap model) {
		StockTransfer order = null;
		try {
			String stbNo = request.getParameter("stbNo");
			order = transferService.getTransferDetail(stbNo);
			List<PlanModel> planList = orderService.getPlanList();
			model.addAttribute("planList",planList);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("查询订单详情发生异常！", e);
//			return "common/errorTip";
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		model.addAttribute("order",order);
		return LocaleUtil.getUserLocalePath("sales/stockTransfer/stockTransferDetail", request);
//		return "sales/stockTransfer/stockTransferDetail";
	}
	
	/*
	 * 初始化新增调拨单页面
	 */
	@RequestMapping(params = "method=initStockTransferEdit")
	public String initStockTransferEdit(HttpServletRequest request, ModelMap model) {
		StockTransfer order = null;
		try {
			String stbNo = request.getParameter("stbNo");
			order = transferService.getTransferDetail(stbNo);
			List<PlanModel> planList = orderService.getPlanList();
			List<InfOrgs> orgList = institutionsService.getAllInstitutionsInfo();
			model.addAttribute("planList",planList);
			model.addAttribute("orgList", orgList);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("初始化调拨单修改页面发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		model.addAttribute("order",order);
		return LocaleUtil.getUserLocalePath("sales/stockTransfer/editStockTransfer", request);
//		return "sales/stockTransfer/editStockTransfer";
	}
	
	
	 /*
	  * 保存調撥單
	  */
	@RequestMapping(params = "method=updateStockTransfer")
	public String updateStockTransfer(HttpSession session, ModelMap model,StockTransfer order,HttpServletRequest request) {
		try {
			User currentUser = (User)session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			order.setApplyAdmin(currentUser.getId().shortValue());
			transferService.updateStockTransfer(order);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("修改调拨单功能发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("common/successTip", request);
//		return "common/successTip";
	}
	
	/*
	 * 初始化调拨单审批页面
	 */
	@RequestMapping(params = "method=initAproveStockTransfer")
	public String initAproveStockTransfer(HttpServletRequest request, ModelMap model) {
		StockTransfer order = null;
		try {
			String stbNo = request.getParameter("stbNo");
			order = transferService.getTransferDetail(stbNo);
			//List<InfOrgs> orgList = institutionsService.getInstitutionsInfo();
			//model.addAttribute("orgList", orgList);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("初始化调拨单审批页面发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		model.addAttribute("order",order);
		return LocaleUtil.getUserLocalePath("sales/stockTransfer/approveStockTransfer", request);
//		return "sales/stockTransfer/approveStockTransfer";
	}
	
	@RequestMapping(params = "method=approveStockTransfer")
	public String approveStockTransfer(HttpServletRequest request,HttpSession session, ModelMap model,StockTransfer order) {
		try {
			User currentUser = (User)session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			order.setApproveAdmin(currentUser.getId().shortValue());
			int flag = transferService.updateStockTransferAproval(order);
			
			if(flag != 0){
				model.addAttribute("system_message", "Approval refused: Account balance is insufficient!");
				log.info("调拨单审批未通过,账户余额不足,调拨单编号:"+order.getStbNo());
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("修改调拨单功能发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("common/successTip", request);
//		return "common/successTip";
	}

}
