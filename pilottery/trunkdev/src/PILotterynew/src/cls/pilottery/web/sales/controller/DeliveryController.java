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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.pilottery.common.EnumConfigEN;
import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.web.sales.entity.DeliveryOrder;
import cls.pilottery.web.sales.entity.PurchaseOrder;
import cls.pilottery.web.sales.form.DeliveryForm;
import cls.pilottery.web.sales.model.PlanModel;
import cls.pilottery.web.sales.service.DeliveryService;
import cls.pilottery.web.sales.service.OrderService;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.system.model.UserLanguage;

/**
 * 出货单管理
 * 
 * @author huangchy
 * 
 */
@Controller
@RequestMapping("delivery")
public class DeliveryController {
	Logger log = Logger.getLogger(DeliveryController.class);

	@Autowired
	private DeliveryService deliveryService;
	
	@Autowired 
	private OrderService orderService;
	private Map<Integer,String> deliveryOrderStatus = EnumConfigEN.deliveryOrderStatus;
	@ModelAttribute("deliveryOrderStatus")
	public Map<Integer,String> getDeliveryOrderStatus(HttpServletRequest request)
	{
	if(request != null)
			this.deliveryOrderStatus =LocaleUtil.getUserLocaleEnum("deliveryOrderStatus", request);
		
		return deliveryOrderStatus;
	}
	/*
	 * 出货单列表_申请人使用
	 */
	@RequestMapping(params = "method=listDeliveryByApplyUser")
	public String listDeliveryByApplyUser(HttpServletRequest request, ModelMap model, DeliveryForm form) {
		List<DeliveryOrder> list = null;
		int count = 0;
		try {
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			form.setCuserOrg(currentUser.getInstitutionCode());
			int pageIndex = PageUtil.getPageIndex(request);
			count = deliveryService.getDeliveryCount(form);
			if (count > 0) {
				form.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
				form.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
				list = deliveryService.getDeliveryList(form);
			}
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("查询出货单列表功能发生异常！", e);
			/*return "common/errorTip";*/
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", list);
		model.addAttribute("form", form);
		return LocaleUtil.getUserLocalePath("sales/deliveryOrder/listDeliveryOrders", request);
//		return "sales/deliveryOrder/listDeliveryOrders";
	}
	
	/*
	 * 出货单列表_查询出货单信息
	 */
	@RequestMapping(params = "method=listDeliveryForInquery")
	public String listDeliveryForInquery(HttpServletRequest request, ModelMap model, DeliveryForm form) {
		List<DeliveryOrder> list = null;
		int count = 0;
		try {
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			form.setCuserOrg(currentUser.getInstitutionCode());
			int pageIndex = PageUtil.getPageIndex(request);
			count = deliveryService.getDeliveryCountForInquery(form);
			if (count > 0) {
				form.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
				form.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
				list = deliveryService.getDeliveryListForInquery(form);
			}
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("查询出货单列表功能发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
//			return "common/errorTip";
		}
		
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", list);
		model.addAttribute("form", form);
		return LocaleUtil.getUserLocalePath("sales/deliveryOrder/listDeliveryOrderForInquery", request);
//		return "sales/deliveryOrder/listDeliveryOrderForInquery";
	}
	
	@RequestMapping(params = "method=initDeliveryOrderAdd")
	public String initDeliveryOrderAdd(HttpSession session, ModelMap model,HttpServletRequest request) {
		try {
			//获得当前登陆用户申请的订单
			User currentUser = (User)session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("userId", currentUser.getId().shortValue());
			List<PurchaseOrder> orderList = orderService.getOrderListByUser(map);
			model.addAttribute("orderList",orderList);
			
			//查询当前用户订单所关联的方案
			List<PlanModel> orderPlanList = orderService.getOrderPlanList(map);
			model.addAttribute("orderPlanList",orderPlanList);
			
			//当前可用的方案
			List<PlanModel> planList = orderService.getPlanList();
			model.addAttribute("planList",planList);
			
			String doNo = deliveryService.getDeliveryOrderSeq();
			model.addAttribute("doNo", doNo);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("初始化出货单新建页面发生异常！", e);
//			return "common/errorTip";
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("sales/deliveryOrder/addDeliveryOrder", request);
//		return "sales/deliveryOrder/addDeliveryOrder";
	}
	
	@RequestMapping(params = "method=saveDeliveryOrder")
	public String saveDeliveryOrder(HttpSession session,ModelMap model, DeliveryOrder order,HttpServletRequest request) {
		try {
			User currentUser = (User)session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			order.setApplyAdmin(currentUser.getId().shortValue());
			int result = deliveryService.saveDeliveryOrder(order);
			if(result == -1){
				model.addAttribute("system_message", "Account balance is insufficient");
				log.info("出货单保存失败，账户:"+currentUser.getLoginId()+" 余额不足");
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			}
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("保存出货单功能发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		model.addAttribute("reservedHrefURL","delivery.do?method=listDelivery");
		return LocaleUtil.getUserLocalePath("common/successTip", request);
//		return "common/successTip";
	}
	
	@RequestMapping(params = "method=deliveryDetail")
	public String deliveryDetail(HttpServletRequest request, ModelMap model) {
		DeliveryOrder order = null;
		try {
			String deliveryOrderNo = request.getParameter("deliveryOrderNo");
			order = deliveryService.getDeliveryDetail(deliveryOrderNo);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("查询出货单详情发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		model.addAttribute("order",order);
		return LocaleUtil.getUserLocalePath("sales/deliveryOrder/deliveryOrderDetail", request);
//		return "sales/deliveryOrder/deliveryOrderDetail";
	}
	
	@ResponseBody
	@RequestMapping(params = "method=cancelDeliveryOrder")
	public String cancelDeliveryOrder(HttpServletRequest request, ModelMap model) {
		String deliveryOrderNo = request.getParameter("deliveryOrderNo");
		User user = (User) request.getSession().getAttribute(
				SysConstants.CURR_LOGIN_USER_SESSION);
		String result = null;
		try{
			//修改订单状态为2(已撤销)
			//int updateCount = deliveryService.modifyDeliveryOrderStatus(deliveryOrderNo,2);
			int updateCount = deliveryService.cancelDeliveryOrder(deliveryOrderNo);
			if(updateCount !=1){
				log.warn("撤销出货单单出现异常,撤销出货单编号:"+deliveryOrderNo+",撤销记录数:"+updateCount);
				if (user != null) {
					UserLanguage lg = user.getUserLang();
					if (lg == UserLanguage.ZH) {
						result="撤销失败!";

					} else if (lg == UserLanguage.EN) {
						result="Cancel Failed!";
					}
				}
//				result="Cancel Failed!";
			}
		}catch(Exception e){
			log.error("撤销出货单出现异常,异常信息:"+e.getMessage());
			result = "Cancel Failed : System Error！";
			if (user != null) {
				UserLanguage lg = user.getUserLang();
				if (lg == UserLanguage.ZH) {
					result="撤销失败系统异常!";

				} else if (lg == UserLanguage.EN) {
					result="Cancel Failed: System Error！";
				}
			}
		}
		return result;
	}
	
	@RequestMapping(params = "method=initDeliveryOrderEdit")
	public String initDeliveryOrderEdit(HttpSession session,HttpServletRequest request, ModelMap model) {
		DeliveryOrder order = null;
		try {
			User currentUser = (User)session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			//获得当前登陆用户申请的订单
			String doNo = request.getParameter("deliveryOrderNo");
			order = deliveryService.getDeliveryDetail(doNo);
			model.addAttribute("order", order);
			//当前可用的方案
			List<PlanModel> planList = orderService.getPlanList();
			model.addAttribute("planList",planList);
			
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("userId", currentUser.getId().shortValue());
			map.put("deliveryOrderNo", doNo);
			List<PurchaseOrder> orderList = orderService.getOrderListByUser(map);
			model.addAttribute("orderList",orderList);
			//查询当前用户订单所关联的方案
			List<PlanModel> orderPlanList = orderService.getOrderPlanList(map);
			model.addAttribute("orderPlanList",orderPlanList);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("初始化出货单修改页面发生异常！", e);
 //			return "common/errorTip";
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("sales/deliveryOrder/editDeliveryOrder", request);
//		return "sales/deliveryOrder/editDeliveryOrder";
	}
	
	@RequestMapping(params = "method=editDeliveryOrder")
	public String editDeliveryOrder(HttpSession session,ModelMap model, DeliveryOrder order,HttpServletRequest request) {
		try {
			User currentUser = (User)session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			order.setApplyAdmin(currentUser.getId().shortValue());
			int result = deliveryService.modifyDeliveryOrder(order);
			if(result == -1){
				model.addAttribute("system_message", "Account balance is insufficient");
				log.info("出货单保存失败，账户:"+currentUser.getLoginId()+" 余额不足");
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			}
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("保存出货单功能发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		model.addAttribute("reservedHrefURL","delivery.do?method=listDelivery");
		return LocaleUtil.getUserLocalePath("common/successTip", request);
//		return "common/successTip";
	}
	
}
