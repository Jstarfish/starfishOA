package cls.pilottery.web.sales.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.web.sales.entity.PurchaseOrder;
import cls.pilottery.web.sales.form.OrderForm;
import cls.pilottery.web.sales.model.PlanModel;
import cls.pilottery.web.sales.service.OrderService;
import cls.pilottery.web.system.model.User;

/**
 * 订单管理
 * @author huangchy
 *
 */
@Controller
@RequestMapping("order")
public class OrderController {
	Logger log = Logger.getLogger(OrderController.class);
	
	@Autowired
	private OrderService orderService;
	
	@RequestMapping(params="method=listOrderByApplyUser")
	public String listOrderByApplyUser(HttpServletRequest request, ModelMap model,OrderForm form) {
		List<PurchaseOrder> list = null;
		int count = 0;
		try {
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			form.setCuserOrg(currentUser.getInstitutionCode());
			int pageIndex = PageUtil.getPageIndex(request);
			count = orderService.getOrderCount(form);
			if (count > 0) {
				form.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
				form.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
				list = orderService.getOrderList(form);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message",e.getMessage());
			log.error("查询订单列表功能发生异常！", e);
			return "_common/errorTip";
		}
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", list);
		model.addAttribute("form",form);
		return LocaleUtil.getUserLocalePath("sales/purchaseOrder/listPurchaseOrders", request);
		
	}
	
	@RequestMapping(params="method=listOrderForInquery")
	public String listOrderForInquery(HttpServletRequest request, ModelMap model,OrderForm form) {
		List<PurchaseOrder> list = null;
		int count = 0;
		try {
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			form.setCuserOrg(currentUser.getInstitutionCode());
			int pageIndex = PageUtil.getPageIndex(request);
			count = orderService.getOrderCountForInquery(form);
			if (count > 0) {
				form.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
				form.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
				list = orderService.getOrderListForInquery(form);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message",e.getMessage());
			log.error("查询订单列表功能发生异常！", e);
			return "_common/errorTip";
		}
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", list);
		model.addAttribute("form",form);
		return LocaleUtil.getUserLocalePath("sales/purchaseOrder/listPurchaseOrderForInquery", request);
	
	}
	
	/*
	 * 撤销订单
	 */
	@ResponseBody
	@RequestMapping(params="method=cancelOrder")
	public String cancelOrder(HttpServletRequest request){
		String purchaseOrderNo=request.getParameter("purchaseOrderNo");
		String result = null;
		try{
			//修改订单状态为2(已撤销)
			int updateCount = orderService.modifyOrderStatus(purchaseOrderNo,2);
			if(updateCount !=1){
				log.warn("撤销订单出现异常,撤销订单编号:"+purchaseOrderNo+",撤销记录数:"+updateCount);
				result="Cancel Failed!";
			}
		}catch(Exception e){
			log.error("撤销订单出现异常,异常信息:"+e.getMessage());
			result = "Cancel Failed : System Error！";
		}
		return result;
	}
	
	/*
	 * 初始化新增订单页面
	 */
	@RequestMapping(params = "method=initPurchaseOrder")
	public String initPurchaseOrderAdd(HttpServletRequest request, ModelMap model) {
		try {
			List<PlanModel> planList = orderService.getPlanList();
			model.addAttribute("planList",planList);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("初始化订单新增页面发生异常！", e);
			return "common/errorTip";
		}
		model.addAttribute("oper",1);
		return LocaleUtil.getUserLocalePath("sales/purchaseOrder/addPurchaseOrder", request);
		
	}
	
	/*
	 * 保存订单
	 */
	@RequestMapping(params = "method=savePurchaseOrder")
	public String savePurchaseOrder(HttpSession session, ModelMap model,PurchaseOrder order,HttpServletRequest request) {
		try {
			User currentUser = (User)session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			order.setApplyAdmin(currentUser.getId().shortValue());
			orderService.savePurchaseOrder(order);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("保存订单功能发生异常！", e);
			
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		//model.addAttribute("reservedHrefURL","delivery.do?method=listDelivery");
	
		return LocaleUtil.getUserLocalePath("common/successTip", request);
	}
	
	/*
	 * 订单明细
	 */
	@RequestMapping(params = "method=purchaseDetail")
	public String purchaseDetail(HttpServletRequest request, ModelMap model) {
		PurchaseOrder order = null;
		try {
			String purchaseOrderNo = request.getParameter("purchaseOrderNo");
			order = orderService.getPurchaseDetail(purchaseOrderNo);
			List<PlanModel> planList = orderService.getPlanList();
			model.addAttribute("planList",planList);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("查询订单详情发生异常！", e);
			return "common/errorTip";
		}
		model.addAttribute("order",order);
		
		return LocaleUtil.getUserLocalePath("sales/purchaseOrder/purchaseOrderDetails", request);
	}
	
	/**
	 * 初始化修改订单页面
	 */
	@RequestMapping(params = "method=initPurchaseOrderEdit")
	public String initPurchaseOrderEdit(HttpServletRequest request, ModelMap model) {
		PurchaseOrder order = null;
		try {
			String purchaseOrderNo = request.getParameter("purchaseOrderNo");
			order = orderService.getPurchaseDetail(purchaseOrderNo);
			List<PlanModel> planList = orderService.getPlanList();
			model.addAttribute("planList",planList);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("初始化订单编辑页面发生异常！", e);
			
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		model.addAttribute("order",order);

		return LocaleUtil.getUserLocalePath("sales/purchaseOrder/editPurchaseOrder", request);
	}
	
	@RequestMapping(params = "method=updatePurchaseOrder")
	public String updatePurchaseOrder(HttpServletRequest request, ModelMap model,PurchaseOrder order) {
		try {
			orderService.updatePurchaseOrder(order);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("更新订单功能发生异常！", e);
		
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("common/successTip", request);
		
	}

	@ResponseBody
	@RequestMapping(params = "method=checkOutletCodeExsit")
	public String checkOutletCodeExsit(HttpServletRequest request,String outletCode){
		User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("userId", currentUser.getId());
		map.put("outletCode", outletCode);
		int count = orderService.getOutletCountByUser(map);
		if(count <= 0){
			return "false";
		}
		return "true";
	}
}
