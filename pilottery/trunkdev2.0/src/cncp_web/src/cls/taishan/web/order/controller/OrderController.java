package cls.taishan.web.order.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.taishan.common.entity.BasePageResult;
import cls.taishan.common.utils.LocaleUtil;
import cls.taishan.web.capital.service.CapitalService;
import cls.taishan.web.dealer.model.Dealer;
import cls.taishan.web.order.form.OrderForm;
import cls.taishan.web.order.model.Game;
import cls.taishan.web.order.model.Order;
import cls.taishan.web.order.model.TicketDetail;
import cls.taishan.web.order.service.OrderService;

/**
 * @Description:渠道订单管理
 * @author:star
 * @time:2016年10月9日 下午4:23:21
 */
@Controller
@RequestMapping("/order")
public class OrderController {
	@Autowired
	private OrderService orderService;
	
	@Autowired
	private CapitalService capitalService;

	@RequestMapping(params = "method=initDealerOrderList")
	public String initDealerOrderList(HttpServletRequest request,ModelMap model) {
		//获取当前时间和前三天时间
		Date date = new Date();
		Calendar cld = Calendar.getInstance();
		String endDate = (new SimpleDateFormat("yyyy-MM-dd")).format(date);
		//cld.add(Calendar.DATE, -3);
		//String startDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());

		List<Dealer> dealerList = capitalService.getDealerList();
		List<Game> gameList = orderService.getGameList();
		model.addAttribute("startDate", endDate);
		model.addAttribute("endDate", endDate);
		model.addAttribute("dealerList", dealerList);
		model.addAttribute("gameList",gameList);
		return LocaleUtil.getUserLocalePath("order/orderList", request);
	}

	@ResponseBody
	@RequestMapping(params = "method=dealerOrderList")
	public Object dealerOrderList(HttpServletRequest request, ModelMap model, OrderForm form) {
		int totalCount = orderService.getTotalCount(form);
		BasePageResult<Order> result = new BasePageResult<Order>();
		if (totalCount > 0) {
			form.setBeginNum(((form.getPageindex() - 1) * form.getPageSize()));
			form.setEndNum((form.getPageindex() * form.getPageSize()));
		} else {
			form.setBeginNum(0);
			form.setEndNum(0);
		}
		List<Order> orderList = orderService.getOrderList(form);
		result.setResult(orderList);
		result.setTotalCount(totalCount);
		return result;
	}

	@RequestMapping(params = "method=orderDetail")
	public String orderDeatil(HttpServletRequest request, ModelMap model) {
		String saleFlow = request.getParameter("saleFlow");
		Order orderDetail = orderService.getOrderDeatil(saleFlow);
		List<String> list = orderService.getTicketDetail(saleFlow);
		// 拆分获取到的字符串
		List<TicketDetail> ticketDetail = new ArrayList<TicketDetail>();
		for (int i = 0; i < list.size(); i++) {
			TicketDetail detailInfo = new TicketDetail();
			String temp = list.get(i);
			String[] ss = temp.split("-");
			detailInfo.setBettingMethod(ss[0]);
			detailInfo.setPlayName(ss[1]);
			detailInfo.setBettingNum(ss[2]);
			detailInfo.setBetNumber(ss[3]);
			ticketDetail.add(detailInfo);
		}
		model.addAttribute("orderDetail", orderDetail);
		model.addAttribute("ticketDetail", ticketDetail);
		return LocaleUtil.getUserLocalePath("order/orderDetail", request);
	}
	
	@RequestMapping(params="method=orderPrint")
	public String orderPrint(HttpServletRequest request,ModelMap model){
		String saleFlow = request.getParameter("saleFlow");
		Order orderDetail = orderService.getOrderDeatil(saleFlow);
		List<String> list = orderService.getTicketDetail(saleFlow);
		// 拆分获取到的字符串
		List<TicketDetail> ticketDetail = new ArrayList<TicketDetail>();
		for (int i = 0; i < list.size(); i++) {
			TicketDetail detailInfo = new TicketDetail();
			String temp = list.get(i);
			String[] ss = temp.split("-");
			detailInfo.setBettingMethod(ss[0]);
			detailInfo.setPlayName(ss[1]);
			detailInfo.setBettingNum(ss[2]);
			detailInfo.setBetNumber(ss[3]);
			ticketDetail.add(detailInfo);
		}
		model.addAttribute("orderDetail", orderDetail);
		model.addAttribute("ticketDetail", ticketDetail);
		model.addAttribute("date", new Date());
		return LocaleUtil.getUserLocalePath("order/orderCertificate", request);
	}

}
