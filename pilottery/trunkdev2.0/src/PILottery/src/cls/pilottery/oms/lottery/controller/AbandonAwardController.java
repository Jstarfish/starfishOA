package cls.pilottery.oms.lottery.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.oms.game.model.GameInfo;
import cls.pilottery.oms.game.service.GameManagementService;
import cls.pilottery.oms.lottery.model.AbandonAward;
import cls.pilottery.oms.lottery.service.AbandonAwardService;

/**
 * 
 * @Description: 弃奖查询
 * @author: starfish
 * @date: 2016-3-3 下午3:00:37
 * 
 */
@Controller
@RequestMapping("abandon")
public class AbandonAwardController {

	@Autowired
	private AbandonAwardService abandonAwardService;
	@Autowired
	private GameManagementService gameManagementService;

	/**
	 * 加载弃奖信息
	 * 
	 * @param request
	 * @param model
	 * @param abandonAwardForm
	 * @return
	 */
	@RequestMapping(params = "method=abandonAward")
	public String getAbandonAwardInfos(HttpServletRequest request, ModelMap model, AbandonAward abandonAward) {
		List<GameInfo> games = gameManagementService.getGameInfo();
		List<Map<String, Object>> abandonWardList = new ArrayList<Map<String, Object>>();
		Integer count = abandonAwardService.getCount(abandonAward);
		int pageIndex = PageUtil.getPageIndex(request);
		if (count != null && count.intValue() > 0) {
			abandonAward.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			abandonAward.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			abandonWardList = abandonAwardService.getAbandonAwardList(abandonAward);
		}
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", abandonWardList);
		model.addAttribute("games", games);

		return LocaleUtil.getUserLocalePath("oms/abandon/abandonAward", request);
	}

	@RequestMapping(params = "method=detailAbandon")
	public String getDetailAbandonInfo(HttpServletRequest request, ModelMap model, AbandonAward abandonAward) {
		// AbandonAward abandonAward = abandonAwardForm.getInstance();
		int gameCode = new Integer(request.getParameter("gameCode"));
		String issueNumber = request.getParameter("issueNumber");
		String payDate = request.getParameter("payDate");
		abandonAward.setGameCode(gameCode);
		abandonAward.setIssueNumber(issueNumber);
		abandonAward.setPayDate(payDate);

		List<Map<String, Object>> abandonWardDetailList = new ArrayList<Map<String, Object>>();
		abandonWardDetailList = abandonAwardService.getAbandonAwardDetailList(abandonAward);
		model.addAttribute("abandonWardDetailList", abandonWardDetailList);
		return LocaleUtil.getUserLocalePath("oms/abandon/abandonAwardDetail", request);
	}
}
