package cls.pilottery.oms.monitor.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.oms.monitor.model.GameIssue;
import cls.pilottery.oms.monitor.model.GameIssueDetail;
import cls.pilottery.oms.monitor.model.Games;
import cls.pilottery.oms.monitor.model.xmlEntity.HightPrize;
import cls.pilottery.oms.monitor.model.xmlEntity.Location;
import cls.pilottery.oms.monitor.model.xmlEntity.Prize;
import cls.pilottery.oms.monitor.service.MGameIssueService;
import cls.pilottery.oms.monitor.service.MGamesService;
import cls.pilottery.oms.monitor.util.XmlUtil;

@Controller
@RequestMapping("/gameIssue")
public class GameIssueController {

	static Logger log = Logger.getLogger(GameIssueController.class);
	@Autowired
	MGameIssueService gameIssueService;

	@Autowired
	MGamesService gameService;

	@RequestMapping(params = "method=listGameIssue")
	public String listGameIssue(HttpServletRequest request, ModelMap model, GameIssue queryInfo) {

		try {
			List<Games> gameList = gameService.queryGames();
			List<GameIssue> list = null;
			if (request.getParameter("gameCode") != null) {
				long gameCode = Long.valueOf(request.getParameter("gameCode"));
				queryInfo.setGameCode(gameCode);
			} else {
				queryInfo.setGameCode(gameList.get(0).getGameCode());
				queryInfo.setIssueStatus(0);
			}

			Integer count = gameIssueService.listCount(queryInfo);
			int pageIndex = PageUtil.getPageIndex(request);
			if (count != null && count.intValue() > 0) {
				queryInfo.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
				queryInfo.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
				list = gameIssueService.listGameIssue(queryInfo);
			}
			model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
			model.addAttribute("pageDataList", list);
			model.addAttribute("gameList", gameList);
			model.addAttribute("queryInfo", queryInfo);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return LocaleUtil.getUserLocalePath("oms/monitor/gameIssueList", request);
	}

	@RequestMapping(params = "method=details")
	public String details(HttpServletRequest request, ModelMap model) {
		try {
			long issueNumber = Long.parseLong(request.getParameter("issueNumber"));
			long gameCode = Long.parseLong(request.getParameter("gameCode"));
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("issueNumber", issueNumber);
			map.put("gameCode", gameCode);
			GameIssue gameIssue = gameIssueService.findGameIssueByCode(map);

			GameIssueDetail gid = new GameIssueDetail();
			gid.setGameCode(gameCode);
			gid.setIssueNumber(issueNumber);

			List<Location> hightPrizeList = new ArrayList<Location>();
			List<Prize> issuePrizelist = new ArrayList<Prize>();

			if (gid != null) {
				GameIssueDetail gameIssueDetail = gameIssueService.queryGameIssueDetail(gid);
				GameIssueDetail gameIssueDetail2 = new GameIssueDetail();
				if (gameIssueDetail != null) {
					gameIssueDetail2 = XmlUtil.readXml(gameIssueDetail.getXmlContent(), gameIssueDetail);
					if (gameIssueDetail2 != null) {
						issuePrizelist = Arrays.asList(gameIssueDetail2.getPrizes());
						if (gameIssueDetail2.getHigh_prizes() != null) {
							for (int i = 0; i < gameIssueDetail2.getHigh_prizes().length; i++) {
								HightPrize hightPrize = gameIssueDetail2.getHigh_prizes()[i];
								if (hightPrize.getLocations() != null) {
									for (int j = 0; j < hightPrize.getLocations().length; j++) {
										Location location = hightPrize.getLocations()[j];
										if (location.getAgency_code() != null) {
											location.setPrize_level(hightPrize.getPrize_level());
											location.setPrize_name(hightPrize.getPrize_name());
											hightPrizeList.add(location);
										}
									}
								}
							}
						}
					}
				}
			}

			model.addAttribute("gameIssue", gameIssue);
			model.addAttribute("hightPrizeList", hightPrizeList);
			model.addAttribute("issuePrizelist", issuePrizelist);

		} catch (Exception e) {
			e.printStackTrace();

		}
		return LocaleUtil.getUserLocalePath("oms/monitor/gameIssueDetails", request);
	}

}
