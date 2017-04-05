package cls.taishan.web.order.controller;

import java.text.SimpleDateFormat;
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
import cls.taishan.web.order.form.PrizeForm;
import cls.taishan.web.order.model.Game;
import cls.taishan.web.order.model.Prize;
import cls.taishan.web.order.service.OrderService;
import cls.taishan.web.order.service.PrizeService;

/**
 * @Description:中奖查询
 * @author:star
 * @time:2016年10月10日 上午9:46:42
 */

@Controller
@RequestMapping("/win")
public class WinController {
	@Autowired
	private OrderService orderService;
	@Autowired
	private CapitalService capitalService;
	@Autowired
	private PrizeService prizeService;

	@RequestMapping(params = "method=initWinList")
	public String initWinList(HttpServletRequest request, ModelMap model) {
		//获取当前时间和前三天时间
		Date date = new Date();
		Calendar cld = Calendar.getInstance();
		String endDate = (new SimpleDateFormat("yyyy-MM-dd")).format(date);
		cld.add(Calendar.DATE, -3);
		String startDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
		
		List<Dealer> dealerList = capitalService.getDealerList();
		List<Game> gameList = orderService.getGameList();
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		model.addAttribute("dealerList", dealerList);
		model.addAttribute("gameList", gameList);
		return LocaleUtil.getUserLocalePath("order/winList", request);
	}

	@ResponseBody
	@RequestMapping(params = "method=winList")
	public Object winList(HttpServletRequest request, ModelMap model, PrizeForm form) {
		int totalCount = prizeService.getTotalCount(form);
		BasePageResult<Prize> result = new BasePageResult<Prize>();
		if (totalCount > 0) {
			form.setBeginNum(((form.getPageindex() - 1) * form.getPageSize()));
			form.setEndNum((form.getPageindex() * form.getPageSize()));
		} else {
			form.setBeginNum(0);
			form.setEndNum(0);
		}
		List<Prize> prizeList = prizeService.getPrizeList(form);
		result.setResult(prizeList);
		result.setTotalCount(totalCount);
		return result;
	}

	@RequestMapping(params = "method=winDetail")
	public String winDetail(HttpServletRequest request, ModelMap model) {
		String saleFlow = request.getParameter("saleFlow");
		Prize prizeDetail = prizeService.getPrizeDetail(saleFlow);
		model.addAttribute("prizeDetail", prizeDetail);
		return LocaleUtil.getUserLocalePath("order/winDetail", request);
	}

	@RequestMapping(params = "method=winPrint")
	public String winPrint(HttpServletRequest request, ModelMap model) {
		String saleFlow = request.getParameter("saleFlow");
		Prize prizeDetail = prizeService.getPrizeDetail(saleFlow);
		model.addAttribute("prizeDetail", prizeDetail);
		model.addAttribute("date", new Date());
		return LocaleUtil.getUserLocalePath("order/winCertificate", request);
	}
}
