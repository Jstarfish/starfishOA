package cls.pilottery.oms.report.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import cls.pilottery.common.excel.utils.ExcelUtil;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.oms.report.form.MisReportForm;
import cls.pilottery.oms.report.model.GameInfo;
import cls.pilottery.oms.report.model.MisReport3132;
import cls.pilottery.oms.report.model.MisReport3133;
import cls.pilottery.oms.report.model.MisReport3134;
import cls.pilottery.oms.report.model.MisReport3135;
import cls.pilottery.oms.report.model.MisReport3136;
import cls.pilottery.oms.report.service.MisReportService;

@Controller
@RequestMapping("misReport")
public class MisReportController {
	static Logger log = Logger.getLogger(MisReportController.class);
	
	@Autowired
	private MisReportService misReportService;
	
	/**
	 * 体育彩票中奖统计表
	 */
	@RequestMapping(params = "method=misReport3132")
	public String misReport3132(HttpServletRequest request,HttpServletResponse response, ModelMap model, MisReportForm misReportForm){
		try{ 
			 List<GameInfo> games = misReportService.getReportGames();
			 model.addAttribute("games", games);
			 
			 List<MisReport3132> resultList = null;
			 MisReport3132 resultSum = null;
			 if(StringUtils.isNotBlank(request.getParameter("init"))){
				 resultList = misReportService.getMisReport3132List(misReportForm);
				 resultSum = misReportService.getMisReport3132Sum(misReportForm);
				 model.addAttribute("resultList",resultList);
				 model.addAttribute("resultSum",resultSum);
			 }
			 model.addAttribute("misReportForm",misReportForm);
			 
			 return LocaleUtil.getUserLocalePath("oms/misReport/misReport3132", request);
		 }catch (Exception e) {
			 model.addAttribute("system_message", e.getMessage());
			 e.printStackTrace();
			 log.error("3132报表查询出错", e);
			 return LocaleUtil.getUserLocalePath("common/errorTip", request);
		 }
	}
	
	/**
	 * 体育彩票兑奖统计表（按游戏期次）
	 */
	@RequestMapping(params = "method=misReport3133")
	public String misReport3133(HttpServletRequest request,HttpServletResponse response, ModelMap model, MisReportForm misReportForm){
		try{ 
			 List<GameInfo> games = misReportService.getReportGames();
			 model.addAttribute("games", games);
			 
			 List<MisReport3133> resultList = null;
			 MisReport3133 resultSum = null;
			 if(StringUtils.isNotBlank(request.getParameter("init"))){
				 resultList = misReportService.getMisReport3133List(misReportForm);
				 resultSum = misReportService.getMisReport3133Sum(misReportForm);
				 model.addAttribute("resultList",resultList);
				 model.addAttribute("resultSum",resultSum);
			 }
			 model.addAttribute("misReportForm",misReportForm);
			 return LocaleUtil.getUserLocalePath("oms/misReport/misReport3133", request);
		 }catch (Exception e) {
			 model.addAttribute("system_message", e.getMessage());
			 e.printStackTrace();
			 log.error("3133报表查询出错", e);
			 return LocaleUtil.getUserLocalePath("common/errorTip", request);
		 }
	}
	
	/**
	 * 体育彩票兑奖统计表（按游戏期次）
	 */
	@RequestMapping(params = "method=misReport3134")
	public String misReport3134(HttpServletRequest request,HttpServletResponse response, ModelMap model, MisReportForm misReportForm){
		try{ 
			 List<GameInfo> games = misReportService.getReportGames();
			 model.addAttribute("games", games);
			 
			 List<MisReport3134> resultList = null;
			 MisReport3134 resultSum = null;
			 if(StringUtils.isNotBlank(request.getParameter("init"))){
				 resultList = misReportService.getMisReport3134List(misReportForm);
				 resultSum = misReportService.getMisReport3134Sum(misReportForm);
				 model.addAttribute("resultList",resultList);
				 model.addAttribute("resultSum",resultSum);
			 }
			 model.addAttribute("misReportForm",misReportForm);
			 return LocaleUtil.getUserLocalePath("oms/misReport/misReport3134", request);
		 }catch (Exception e) {
			 model.addAttribute("system_message", e.getMessage());
			 e.printStackTrace();
			 log.error("3134报表查询出错", e);
			 return LocaleUtil.getUserLocalePath("common/errorTip", request);
		 }
	}
	
	/**
	 * 体育彩票兑奖统计表（按游戏期次）
	 */
	@RequestMapping(params = "method=misReport3135")
	public String misReport3135(HttpServletRequest request,HttpServletResponse response, ModelMap model, MisReportForm misReportForm){
		try{ 
			 List<GameInfo> games = misReportService.getReportGames();
			 model.addAttribute("games", games);
			 
			 List<MisReport3135> resultList = null;
			 MisReport3135 resultSum = null;
			 if(StringUtils.isNotBlank(request.getParameter("init"))){
				 resultList = misReportService.getMisReport3135List(misReportForm);
				 resultSum = misReportService.getMisReport3135Sum(misReportForm);
				 model.addAttribute("resultList",resultList);
				 model.addAttribute("resultSum",resultSum);
			 }
			 model.addAttribute("misReportForm",misReportForm);
			 return LocaleUtil.getUserLocalePath("oms/misReport/misReport3135", request);
		 }catch (Exception e) {
			 model.addAttribute("system_message", e.getMessage());
			 e.printStackTrace();
			 log.error("3135报表查询出错", e);
			 return LocaleUtil.getUserLocalePath("common/errorTip", request);
		 }
	}
	/**
	 * 体育彩票奖金动态表
	 */

	@RequestMapping(params = "method=misReport3136")
	public String misReport3136(HttpServletRequest request,HttpServletResponse response, ModelMap model, MisReportForm misReportForm){
		try{ 
			 List<GameInfo> games = misReportService.getReportGames();
			 model.addAttribute("games", games);
			 MisReport3136 resultSum = null;
		 
			 if(StringUtils.isNotBlank(request.getParameter("init"))){
				 model.addAttribute("gameName",misReportForm.getGameName());
			 }
			
			 if(misReportForm != null && StringUtils.isNotBlank(misReportForm.getBeginIssue())){
				resultSum = misReportService.getMisReport3136Sum(misReportForm); 
			 }
			 
			 model.addAttribute("resultSum",resultSum);
			 model.addAttribute("misReportForm",misReportForm);
			 return LocaleUtil.getUserLocalePath("oms/misReport/misReport3136", request);
		 }catch (Exception e) {
			 model.addAttribute("system_message", e.getMessage());
			 e.printStackTrace();
			 log.error("3136报表查询出错", e);
			 return LocaleUtil.getUserLocalePath("common/errorTip", request);
		 }
	}

	@RequestMapping(params = "method=exportCSV")
	public void exportCSV(HttpServletRequest request,HttpServletResponse response, ModelMap model, MisReportForm misReportForm) {
		 MisReport3136 resultSum = null;
		 if(misReportForm != null && StringUtils.isNotBlank(misReportForm.getBeginIssue()))
		 {
			 resultSum = misReportService.getMisReport3136Sum(misReportForm); 
		 }
		 String title = request.getParameter("reportTitle");	
		 try {
				Map<String, Object> report_map = new HashMap<String, Object>();
			 if(title!="" && title!=null){
			 String[] reportTitle = title.split("\\|");
			 report_map.put("reportTitle", reportTitle[0]);
			 report_map.put("queryInfo", reportTitle[1]);
			 }
			
			 ExcelUtil exceUtil=new ExcelUtil();
			
			exceUtil.createReport(request, response,report_map, resultSum);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
