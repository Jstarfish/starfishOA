package cls.pilottery.fbs.controller;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONArray;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.fbs.model.Country;
import cls.pilottery.fbs.model.League;
import cls.pilottery.fbs.model.Team;
import cls.pilottery.fbs.service.LeagueService;
import cls.pilottery.oms.business.model.Agency;
import cls.pilottery.oms.business.model.Terminal;
import cls.pilottery.web.capital.controller.AccountController;
import cls.pilottery.web.capital.model.ResulstMessage;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.system.model.UserLanguage;
import cls.pilottery.web.teller.model.Teller;

@Controller
@RequestMapping("/league")
public class LeagueController {
	
	static Logger logger = Logger.getLogger(LeagueController.class);
	
	@Autowired
	private LeagueService leagueService;
	
	@RequestMapping(params="method=listLeagues")
	public String leagueList(HttpServletRequest request,ModelMap model,League league){
		
		Integer count = leagueService.getLeagueCount(league);
		int pageIndex = PageUtil.getPageIndex(request);
		List<League> list = new ArrayList<League>();
		if(count != null && count.intValue() != 0){
			league.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			league.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			list = leagueService.getLeagueList(league);
		}
		model.addAttribute("pageDataList", list);
		return LocaleUtil.getUserLocalePath("oms/fbs/league/listLeagues", request);
	}
	
	@RequestMapping(params="method=addLeagueInit")
	public String addLeagueInit(HttpServletRequest request,ModelMap model){
		//List<Team> teamList = this.leagueService.getTeam();
		//model.addAttribute("teamList", teamList);
		return LocaleUtil.getUserLocalePath("oms/fbs/league/addLeague", request);
		
	}
	
	@RequestMapping(params="method=addLeague")
	public String addLeague(HttpServletRequest request,ModelMap model,League league) throws Exception{
		try {
			leagueService.addLeague(league);
			return LocaleUtil.getUserLocalePath("common/successTip", request);
		} catch (Exception e) {
			User user = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			UserLanguage lg = user.getUserLang();
			if (lg == UserLanguage.ZH) {
				model.addAttribute("system_message", "新增联赛错误");
			} else if (lg == UserLanguage.EN) {
				model.addAttribute("system_message", "Error Add League");
			}
			logger.error("新增联赛异常" + e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
	}
	}
	
	@RequestMapping(params="method=editLeagueInit")
	public String editLeagueInit(HttpServletRequest request,ModelMap model){
		League league = null;
		try {
			String competitionCode = request.getParameter("competitionCode");
			league = leagueService.getLeagueByCode(competitionCode);
			model.addAttribute("league", league);
			//获取所有球队信息
			List<Team> teamList = this.leagueService.getTeam();
			model.addAttribute("teamList", teamList);
			//获取该联赛下的球队
			//List<Team> leagueTeamList = leagueService.getTeamByLeagueCode(competitionCode);
			//model.addAttribute("leagueTeamList", leagueTeamList);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			logger.error("初始化修改联赛页面出现异常",e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("oms/fbs/league/editLeague", request);
	}
	
	@RequestMapping(params="method=editLeague")
	public String editLeague(HttpServletRequest request,ModelMap model,League league) throws Exception{
		try {
			leagueService.updateLeague(league);
			return LocaleUtil.getUserLocalePath("common/successTip", request);
		} catch (Exception e) {
			User user = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			UserLanguage lg = user.getUserLang();
			if (lg == UserLanguage.ZH) {
				model.addAttribute("system_message", "修改联赛错误");
			} else if (lg == UserLanguage.EN) {
				model.addAttribute("system_message", "Error Edit League");
			}
			logger.error("修改联赛异常" + e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
	}
	}
	
	/**
	 * 删除球队
	 */
	@ResponseBody
	@RequestMapping(params = "method=deleteLeague")
	public ResulstMessage deleteLeague(HttpServletRequest request) {
		ResulstMessage message = new ResulstMessage();
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		UserLanguage lg = user.getUserLang();
		
		String competitionCode = request.getParameter("competitionCode");
		try {
			//判断是否有比赛
			Integer haveBatch = leagueService.haveMatch(competitionCode);
			if (haveBatch != 0) {
				if(lg == UserLanguage.ZH){
					message.setMessage("该联赛下球队有比赛,不允许被删除!");
				}else if(lg == UserLanguage.EN){
					message.setMessage("The League have Match,do not allowed delete!");
				}else{
					League league = new League();
					league.setCompetitionCode(competitionCode);
					this.leagueService.deleteLeague(league);
					}
				}
		} catch (Exception e) {
			logger.error("errmsgs" + e.getMessage());
			message.setMessage(e.getMessage());
		}
		return message;
	}
	
		// 联赛详情
		@RequestMapping(params = "method=detailLeague", method = RequestMethod.GET)
		public String detailLeague(HttpServletRequest request, ModelMap model) throws Exception {
			String competitionCode = request.getParameter("competitionCode");
			League league = leagueService.getLeagueByCode(competitionCode);
			//获取该联赛下的足球队
			List<Team> leagueTeam = leagueService.getTeamByLeagueCode(competitionCode);
			model.addAttribute("league", league);
			model.addAttribute("leagueTeam", leagueTeam);
			return LocaleUtil.getUserLocalePath("oms/fbs/league/detailLeague", request);
		}
}
