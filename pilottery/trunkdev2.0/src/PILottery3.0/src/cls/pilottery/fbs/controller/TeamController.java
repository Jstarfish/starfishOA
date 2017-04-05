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
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONArray;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.fbs.model.Country;
import cls.pilottery.fbs.model.Match;
import cls.pilottery.fbs.model.Team;
import cls.pilottery.fbs.service.TeamService;
import cls.pilottery.web.capital.model.ResulstMessage;
import cls.pilottery.web.plans.model.Plan;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.system.model.UserLanguage;
/**
 * @Description:球队信息
 * @author:star
 * @time:2016年6月1日 上午10:08:14
 */

@Controller
@RequestMapping("/team")
public class TeamController {
	
	static Logger logger = Logger.getLogger(TeamController.class);
	
	@Autowired
	private TeamService teamService;
	
	@RequestMapping(params="method=listTeams")
	public String listTeam(HttpServletRequest request,ModelMap model,Team team){
		
		Integer count = teamService.getTeamCount(team);
		int pageIndex = PageUtil.getPageIndex(request);
		List<Team> teamList = new ArrayList<Team>();
		if(count != null && count.intValue() != 0){
			team.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			team.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			teamList = teamService.getTeamList(team);
		}
		
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("teamList", teamList);
		
		return LocaleUtil.getUserLocalePath("oms/fbs/team/listTeam", request);
	}
	
	@RequestMapping(params="method=initAddTeam")
	public String initAddTeam(HttpServletRequest request,ModelMap model){
		List<Country> countryList = this.teamService.getCountry();
		model.addAttribute("countryList", countryList);
		return LocaleUtil.getUserLocalePath("oms/fbs/team/addTeam", request);
	}
	
	@RequestMapping(params="method=addTeam")
	public String addTeam(HttpServletRequest request,ModelMap model,Team team) throws Exception{
		try {
			teamService.addTeam(team);
			return LocaleUtil.getUserLocalePath("common/successTip", request);
		} catch (Exception e) {
			User user = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			UserLanguage lg = user.getUserLang();
			if (lg == UserLanguage.ZH) {
				model.addAttribute("system_message", "新增球队错误");
			} else if (lg == UserLanguage.EN) {
				model.addAttribute("system_message", "Error Add Team");
			}
			logger.error("新增球队异常" + e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
	}
	}
	
	/**
	 * 修改球队信息
	 */
	@RequestMapping(params="method=modifyTeamInit")
	public String modifyTeamInit(HttpServletRequest request,ModelMap model) throws Exception{
		
		String teamCode = request.getParameter("teamCode");
		Team team = new Team();
		team = teamService.getTeamByCode(teamCode);
		List<Country> countryList = this.teamService.getCountry();
		model.addAttribute("countryList", countryList);
		model.addAttribute("team", team);
		return LocaleUtil.getUserLocalePath("oms/fbs/team/modifyTeam", request);
		
	}
	@RequestMapping(params = "method=modifyTeam")
	public String modifyPlan(HttpServletRequest request , ModelMap model , Team team) throws Exception {
		try{
			teamService.modifyTeam(team);
		}catch(Exception e){
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			logger.error("修改球队信息发生异常",e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("common/successTip", request);
	}
	
	/**
	 * 删除球队
	 */
	@ResponseBody
	@RequestMapping(params = "method=deleteTeam")
	public ResulstMessage deleteOutlets(HttpServletRequest request) {
		ResulstMessage message = new ResulstMessage();
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		UserLanguage lg = user.getUserLang();
		
		String teamCode = request.getParameter("teamCode");
		try {
			Integer haveBatch = teamService.haveMatch(teamCode);
			if (haveBatch != 0) {
				if(lg == UserLanguage.ZH){
					message.setMessage("该球队有比赛,不允许被删除!");
				}else if(lg == UserLanguage.EN) {
					message.setMessage("This Team have Match,do not allowed delete!");
				}else{
					Team team = new Team();
					team.setTeamCode(teamCode);
					this.teamService.deleteTeam(team);
				}
			}
		} catch (Exception e) {
			message.setMessage(e.getMessage());
			logger.error("删除球队出现异常,异常信息:" + e.getMessage(), e);
		}
		return message;
	}
	
	//查看比赛详情
	@RequestMapping(params = "method=getMatchDetail")
	public String getMatchDetail(HttpServletRequest request,ModelMap model,String teamCode){
		try {
			//比赛信息汇总
			Match matchNumber = teamService.getMatchNumber(teamCode); //比赛总、胜、平的场次
			//比赛记录列表信息
			List<Match> matchList = new ArrayList<Match>();
			matchList = teamService.getMatchList(teamCode);
			
			model.addAttribute("matchNumber", matchNumber);
			model.addAttribute("matchList", matchList);
			
		} catch (Exception e) {
		}
		return LocaleUtil.getUserLocalePath("oms/fbs/team/matchDetail", request);
		
	}
}
