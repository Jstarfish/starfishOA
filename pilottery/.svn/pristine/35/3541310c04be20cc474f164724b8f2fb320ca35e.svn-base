package cls.pilottery.oms.game.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.HttpClientUtils;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.common.utils.PropertiesUtil;
import cls.pilottery.oms.common.entity.BaseMessageReq;
import cls.pilottery.oms.common.entity.BaseMessageRes;
import cls.pilottery.oms.common.entity.MessageLog;
import cls.pilottery.oms.common.msg.UpdateGameAutoDraw2017Req;
import cls.pilottery.oms.common.msg.UpdateGameCancelControl2015Req;
import cls.pilottery.oms.common.msg.UpdateGameControlParameter2005Req;
import cls.pilottery.oms.common.msg.UpdateGameLimit2021Req;
import cls.pilottery.oms.common.msg.UpdateGameParameter2003Req;
import cls.pilottery.oms.common.msg.UpdateGamePayControl2013Req;
import cls.pilottery.oms.common.msg.UpdateGameSaleControl2011Req;
import cls.pilottery.oms.common.msg.UpdateGameServiceTime2019Req;
import cls.pilottery.oms.common.msg.UpdateRiskParam2009Req;
import cls.pilottery.oms.common.service.LogService;
import cls.pilottery.oms.game.form.GameManagementForm;
import cls.pilottery.oms.game.model.GameInfo;
import cls.pilottery.oms.game.model.GameIssue;
import cls.pilottery.oms.game.model.GameParameterControlView;
import cls.pilottery.oms.game.model.GameParameterDynamic;
import cls.pilottery.oms.game.model.GameParameterHistory;
import cls.pilottery.oms.game.model.GameParameterNormalView;
import cls.pilottery.oms.game.model.GamePolicyParam;
import cls.pilottery.oms.game.model.GamePool;
import cls.pilottery.oms.game.model.GamePoolAdj;
import cls.pilottery.oms.game.model.GamePoolHis;
import cls.pilottery.oms.game.model.GamePrizeRule;
import cls.pilottery.oms.game.model.GameRule;
import cls.pilottery.oms.game.model.GameWinRule;
import cls.pilottery.oms.game.model.RiskControlVo11X5;
import cls.pilottery.oms.game.model.RiskControlVoFBS;
import cls.pilottery.oms.game.model.RiskControlVoK3;
import cls.pilottery.oms.game.model.RiskControlVoSSC;
import cls.pilottery.oms.game.model.RiskControlVoTTY;
import cls.pilottery.oms.game.model.SystemParameter;
import cls.pilottery.oms.game.service.GameManagementService;
import cls.pilottery.web.system.model.User;

@Controller
@RequestMapping("gameManagement")
public class GameManagementController {

	static Logger logger = Logger.getLogger(GameManagementController.class);
	
	@Autowired
	private GameManagementService gameManagementService;
	
	@Autowired
	private LogService logService;
	
	//发送消息给主机的helper function
	private void sendMessageToHost(int func, Object params) {
		BaseMessageReq req = new BaseMessageReq(func, 2);
		req.setParams(params);
		long seq = logService.getNextSeq();
		req.setMsn(seq);
		String reqJson = JSONObject.toJSONString(req);
		logger.debug("向主机发送请求，请求内容："+reqJson);
		MessageLog msglog = new MessageLog(seq, reqJson);
		logService.insertLog(msglog);
		String resJson = HttpClientUtils.postString(PropertiesUtil.readValue("url_host"), reqJson);
		logger.debug("接收到主机的响应，消息内容："+resJson);
		if (resJson != null) {
			BaseMessageRes res = JSONObject.parseObject(resJson,BaseMessageRes.class);
			if (res.getRc() != 0) {
				logService.updateLog(msglog);
			}
		}
	}
	
	//ajax查询是否存在当前期
	@RequestMapping(params="method=checkIssueExist")
	public void checkIssueExist(HttpServletRequest request, HttpServletResponse response, Short gameCode) throws IOException {
		response.setContentType("text/txt; charset=UTF-8");
		PrintWriter out = null;
		out = response.getWriter();
		out.print(gameManagementService.checkIssueExist(gameCode));
		out.flush();
		out.close();
	}
	
	//ajax查询奖池余额
	@RequestMapping(params = "method=showYue")
	public void showYue(HttpServletRequest request, HttpServletResponse response, Short gameCode) throws IOException {
		response.setContentType("text/txt; charset=UTF-8");
		PrintWriter out = null;
		GamePool gamePool = gameManagementService.getGamePool(gameCode);
		Long yue = gamePool == null ? new Long(0) : gamePool.getPoolAmountAfter();
		out = response.getWriter();
		out.print(yue);
		out.flush();
		out.close();
	}
	
	//数据准备: 游戏MAP
	@ModelAttribute("gameInfoMap")
	public Map<Short,String> refGameInfoMap() {
		return gameManagementService.getGameInfoMap();
	}
	
	//游戏参数菜单
	@RequestMapping(params="method=param")
	public String toTabs(HttpServletRequest request, ModelMap model, Short gameCode) {
		GameManagementForm gameManagementForm = new GameManagementForm();
		
		//左侧彩种显示
		List<GameInfo> games = gameManagementService.getGameInfo();
		GameInfo gameInfo = new GameInfo();
		if (gameCode == null || gameCode.equals("")) {
			gameInfo = games.get(0);
		} else {
			gameInfo = gameManagementService.getGameInfoByCode(gameCode);
		}
		
		//政策参数
		GamePolicyParam gamePolicyParam = gameManagementService.getPolicyParamByCode(gameInfo.getGameCode());
		
		//普通规则参数
		GameParameterNormalView normalRuleParameter = gameManagementService.getNormalRuleView(gameInfo.getGameCode());
		
		//游戏控制参数
		GameParameterControlView controlParameter = gameManagementService.getControlView(gameInfo.getGameCode());
		
		//中奖规则
		List<GameWinRule> gameWinRuleList = gameManagementService.getGameWinRuleByCode(gameInfo.getGameCode());
		
		//玩法规则
		List<GameRule> gameRuleList = gameManagementService.getGameRuleByCode(gameInfo.getGameCode());
		
		//奖级规则
		List<GamePrizeRule> gamePrizeRuleList = gameManagementService.getGamePrizeRuleByCode(gameInfo.getGameCode());
		
		//游戏风控参数
		GameParameterHistory riskControlParameter = gameManagementService.getGameParameterHistory(gameInfo.getGameCode());
		
		//奖池信息
		GamePool gamePool = gameManagementService.getGamePool(gameInfo.getGameCode());
		
		//动态参数
		GameParameterDynamic dy = gameManagementService.getGameParameterDynamicByCode(gameInfo.getGameCode());
		if (dy != null) {
			try {
				String awardParam = dy.getCalcWinningCode();
				if (dy.getGameCode() == SysConstants.KOCTTY && awardParam != null && !awardParam.equals("")) {
					gameManagementForm.setIsSpecial(awardParam.split(":")[1].trim());
				} else if (dy.getGameCode() == SysConstants.KOC7LX && awardParam != null && !awardParam.equals("")) {
					String[] t_ap = awardParam.split("#");
					gameManagementForm.setFdbd(t_ap[0].split(":")[1].trim());
					gameManagementForm.setFdfd(t_ap[1].split(":")[1].trim());
					gameManagementForm.setFdmin(t_ap[2].split(":")[1].trim());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		//风控参数处理
		String riskParam;
		if (gameInfo.getGameCode() == SysConstants.KOC11X5 && riskControlParameter != null) { //11选5
			try {
				riskParam = riskControlParameter.getRiskParam();
				if (riskParam != null && !riskParam.equals("")) {
					String[] temp = riskParam.split(":");
					RiskControlVo11X5 vo = new RiskControlVo11X5();
					if(temp != null && temp.length>1){
						vo.setParamA(temp[0]);
						vo.setParamB(temp[1]);
					}
					model.addAttribute("riskControl11X5", vo);
				}
			} catch (Exception e) {
				e.printStackTrace();
				riskParam = "";
			}
		} else if (gameInfo.getGameCode() == SysConstants.KOCK3 && riskControlParameter != null) { //快3
			try {
				riskParam = riskControlParameter.getRiskParam();
				if (riskParam != null && !riskParam.equals("")) {
					String[] temp = riskParam.split(":");
					RiskControlVoK3 vo = new RiskControlVoK3();
					if(temp != null && temp.length>1){
						vo.setParamA(temp[0]);
						vo.setParamB(temp[1]);
					}
					model.addAttribute("riskControlK3", vo);
				}
			} catch (Exception e) {
				e.printStackTrace();
				riskParam = "";
			}
		} else if (gameInfo.getGameCode() == SysConstants.KOCTTY && riskControlParameter != null) { //天天赢
			try {
				riskParam = riskControlParameter.getRiskParam();
				if (riskParam != null && !riskParam.equals("")) {
					String[] temp = riskParam.split("#");
					List<RiskControlVoTTY> voList = new ArrayList<RiskControlVoTTY>();
					for (int i = 0; i < temp.length; i++) {
						RiskControlVoTTY vo = new RiskControlVoTTY();
						String[] ss = temp[i].split(":");
						vo.setTemp_ruleCode(ss[0]);
						vo.setTemp_riskThreshold(ss[1]);
						vo.setTemp_maxClaimsAmount(ss[2]);
						voList.add(vo);
					}
					model.addAttribute("riskControlListTTY", voList);
				}
				Map<String,String> ruleMap = new HashMap<String,String>();
				Iterator<GameRule> it = gameRuleList.iterator();
				while(it.hasNext()){
					GameRule gr = it.next();
					ruleMap.put(gr.getRuleCode().toString(), gr.getRuleName());
				}
				model.addAttribute("ruleMap", ruleMap);
			} catch (Exception e) {
				e.printStackTrace();
				riskParam = "";
			}
		}else if(gameInfo.getGameCode() == SysConstants.FBS && riskControlParameter != null){
			 //足彩14
			try {
				riskParam = riskControlParameter.getRiskParam();
				if (riskParam != null && !riskParam.equals("")) {
					String[] temp = riskParam.split("#");
					List<RiskControlVoFBS> voList = new ArrayList<RiskControlVoFBS>();
					for (int i = 0; i < temp.length; i++) {
						RiskControlVoFBS vo = new RiskControlVoFBS();
						String[] ss = temp[i].split(":");
						vo.setTemp_ruleCode(ss[0]);
						vo.setTemp_riskThreshold(ss[1]);
						vo.setTemp_maxClaimsAmount(ss[2]);
						voList.add(vo);
					}
					model.addAttribute("riskControlListFBS", voList);
				}
				Map<String,String> ruleMap = new HashMap<String,String>();
				Iterator<GameRule> it = gameRuleList.iterator();
				while(it.hasNext()){
					GameRule gr = it.next();
					ruleMap.put(gr.getRuleCode().toString(), gr.getRuleName());
				}
				model.addAttribute("ruleMap", ruleMap);
			} catch (Exception e) {
				e.printStackTrace();
				riskParam = "";
			}
		
		}else if (gameInfo.getGameCode() == SysConstants.KOCSSC && riskControlParameter != null) { //时时彩
			try {
				riskParam = riskControlParameter.getRiskParam();
				if (riskParam != null && !riskParam.equals("")) {
					String[] tempA = riskParam.split(";");
					if(riskParam != null && tempA.length>1){
						model.addAttribute("paybackRatio", tempA[0]);
					
						String[] tempB = tempA[1].split(",");
						List<RiskControlVoSSC> voList = new ArrayList<RiskControlVoSSC>();
						for (int i = 0; i < tempB.length; i++) {
							RiskControlVoSSC vo = new RiskControlVoSSC();
							String[] ss = tempB[i].split(":");
							vo.setSubType(ss[0]);
							vo.setThreshold(ss[1]);
							voList.add(vo);
						}
						model.addAttribute("riskControlListSSC", voList);
					}
				}
				Map<String,String> ruleMap = new HashMap<String,String>();
				Iterator<GameRule> it = gameRuleList.iterator();
				while(it.hasNext()){
					GameRule gr = it.next();
					ruleMap.put(gr.getRuleCode().toString(), gr.getRuleName());
				}
				model.addAttribute("ruleMap", ruleMap);
			} catch (Exception e) {
				e.printStackTrace();
				riskParam = "";
			}
		}
		
		gameManagementForm.setStyleId(gameInfo.getGameCode());
		gameManagementForm.setGameInfo(gameInfo);
		gameManagementForm.setGamePolicyParam(gamePolicyParam);
		gameManagementForm.setControlParameter(controlParameter);
		gameManagementForm.setNormalRuleParameter(normalRuleParameter);
		gameManagementForm.setGameParameterHistory(riskControlParameter);
		gameManagementForm.setGameRuleList(gameRuleList);
		gameManagementForm.setGamePrizeRuleList(gamePrizeRuleList);
		gameManagementForm.setGameWinRuleList(gameWinRuleList);
		gameManagementForm.setGamePool(gamePool);
		
		model.addAttribute("games", games);
		model.addAttribute("gameManagementForm", gameManagementForm);
		
		return LocaleUtil.getUserLocalePath("oms/game/param/gameManagementTabs", request);
	}
	
	//异步编辑游戏普通规则参数（三）
	@RequestMapping(params = "method=editGameParameter")
	public String editGameParameter(HttpServletRequest request, HttpServletResponse response, ModelMap model,
			GameManagementForm gameManagementForm, Short gameCode) throws Exception {
		GameParameterNormalView normalRuleParameter = gameManagementService.getNormalRuleView(gameCode);
		gameManagementForm.setNormalRuleParameter(normalRuleParameter);
		model.addAttribute("gameManagementForm", gameManagementForm);

		return LocaleUtil.getUserLocalePath("oms/game/param/editGameParameter", request);
	}
	
	//更新游戏普通规则参数（三）
	@RequestMapping(params = "method=updateGameParameter")
	public String updateGameParameter(HttpServletRequest request, HttpServletResponse response, ModelMap model,
			GameManagementForm gameManagementForm, Short gameCode_) throws Exception {

		if (gameCode_ != null) {  //取消编辑的情况，form提交时带个gameCode参数
			GameParameterNormalView normalRuleParameter = gameManagementService.getNormalRuleView(gameCode_);
			gameManagementForm.setNormalRuleParameter(normalRuleParameter);
		} else {
			GameParameterNormalView param = gameManagementForm.getNormalRuleParameter();
			try {
				gameManagementService.updateGameParameterNormalView(param);
				UpdateGameParameter2003Req paramReq = new UpdateGameParameter2003Req();
				paramReq.setGameCode(param.getGameCode());
				paramReq.setMaxTimesPerBetLine(param.getSingleLineMaxAmount());
				paramReq.setMaxBetLinePerTicket(param.getSingleTicketMaxLine());
				paramReq.setMaxAmountPerTicket(param.getSingleTicketMaxAmount());
				sendMessageToHost(2003, paramReq);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		model.addAttribute("gameManagementForm", gameManagementForm);
		return LocaleUtil.getUserLocalePath("oms/game/param/saveGameParameter", request);
	}
	
	//修改游戏控制参数（四）
	@RequestMapping(params="method=editGameControlParameter")
	public String editGameControlParameter(HttpServletRequest request, HttpServletResponse response, ModelMap model,
			GameManagementForm gameManagementForm, Short gameCode)throws Exception {

		GameParameterControlView controlParameter = gameManagementService.getControlView(gameCode);
		gameManagementForm.setControlParameter(controlParameter);
		model.addAttribute("gameManagementForm", gameManagementForm);
		return LocaleUtil.getUserLocalePath("oms/game/param/editGameControlParameter", request);
	}
	
	//更新游戏控制参数（四）
	@RequestMapping(params="method=updateGameControlParameter")
	public String updateGameControlParameter(HttpServletRequest request, HttpServletResponse response, ModelMap model,
			GameManagementForm gameManagementForm, Short gameCode_) throws Exception {
		
		if (gameCode_ != null){	//取消编辑的情况，form提交时带个gameCode参数
			//GameParameterNormalView normalRuleParameter = gameManagementService.getNormalRuleView(gameCode_);
			//gameManagementForm.setNormalRuleParameter(normalRuleParameter);
			GameParameterControlView controlParameter = gameManagementService.getControlView(gameCode_);
			gameManagementForm.setControlParameter(controlParameter);
		} else {
			GameParameterControlView param = gameManagementForm.getControlParameter();
			try {
				gameManagementService.updateControlParameter(param);
				UpdateGameControlParameter2005Req paramReq = new UpdateGameControlParameter2005Req();
				paramReq.setGameCode(param.getGameCode());
				paramReq.setCancelTime(param.getCancelSec());
				paramReq.setCountDownTimes(param.getIssueCloseAlertTime());
				paramReq.setBranchCenterPayLimited(param.getLimitPayment2());
				paramReq.setBranchCenterCancelLimited(param.getLimitCancel2());
				paramReq.setCommonTellerPayLimited(param.getSalerPayLimit());
				paramReq.setCommonTellerCancelLimited(param.getSalerCancelLimit());
				sendMessageToHost(2005, paramReq);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		model.addAttribute("gameManagementForm", gameManagementForm);
		return LocaleUtil.getUserLocalePath("oms/game/param/saveGameControlParameter", request);
	}
	
	//异步编辑游戏风控参数（七）
	@RequestMapping(params="method=editRiskControl")
	public String editRiskControl(HttpServletRequest request, HttpServletResponse response, ModelMap model,
			GameManagementForm gameManagementForm, Short gameCode) throws Exception {
		
		GameParameterHistory gameParameter = gameManagementService.getGameParameterHistory(gameCode);
		String riskParam = gameParameter.getRiskParam();
		
		if (gameParameter.getGameCode() == SysConstants.KOC11X5 && riskParam != null) { //11选5
			String[] temp = riskParam.split(":");
			RiskControlVo11X5 vo = new RiskControlVo11X5();
			vo.setParamA(temp[0]);
			vo.setParamB(temp[1]);
			model.addAttribute("riskControl11X5", vo);
		} else if (gameParameter.getGameCode() == SysConstants.KOCK3 && riskParam != null) { //快3
			String[] temp = riskParam.split(":");
			RiskControlVoK3 vo = new RiskControlVoK3();
			vo.setParamA(temp[0]);
			vo.setParamB(temp[1]);
			model.addAttribute("riskControlK3", vo);
		} else if (gameParameter.getGameCode() == SysConstants.KOCSSC && riskParam != null) { //时时彩
			
			String[] tempA = riskParam.split(";");
			if(riskParam != null && tempA.length>1){
				model.addAttribute("paybackRatio", tempA[0]);
			
				String[] tempB = tempA[1].split(",");
				List<RiskControlVoSSC> voList = new ArrayList<RiskControlVoSSC>();
				for (int i = 0; i < tempB.length; i++) {
					RiskControlVoSSC vo = new RiskControlVoSSC();
					String[] ss = tempB[i].split(":");
					vo.setSubType(ss[0]);
					vo.setThreshold(ss[1]);
					voList.add(vo);
				}
				model.addAttribute("riskControlSSC", voList);
				
				List<GameRule> gameRuleList = gameManagementService.getGameRuleByCode(gameCode);
				Map<String,String> ruleMap = new HashMap<String,String>();
				Iterator<GameRule> it = gameRuleList.iterator();
				while(it.hasNext()){
					GameRule gr = it.next();
					ruleMap.put(gr.getRuleCode().toString(), gr.getRuleName());
				}
				model.addAttribute("ruleMap", ruleMap);
				model.addAttribute("listSize", voList.size());
			}
		}else if (gameParameter.getGameCode() == SysConstants.KOCTTY && riskParam != null) { //天天赢
			String[] temp = riskParam.split("#");
			List<RiskControlVoTTY> voList = new ArrayList<RiskControlVoTTY>();
			for (int i = 0; i < temp.length; i++) {
				RiskControlVoTTY vo = new RiskControlVoTTY();
				String[] ss = temp[i].split(":");
				vo.setTemp_ruleCode(ss[0]);
				vo.setTemp_riskThreshold(ss[1]);
				vo.setTemp_maxClaimsAmount(ss[2]);
				voList.add(vo);
			}
			List<GameRule> gameRuleList = gameManagementService.getGameRuleByCode(gameCode);
			Map<String, String> ruleMap = new HashMap<String,String>();
			Iterator<GameRule> it = gameRuleList.iterator();
			while (it.hasNext()) {
				GameRule gr = it.next();
				ruleMap.put(gr.getRuleCode().toString(), gr.getRuleName());
			}
			model.addAttribute("ruleMap", ruleMap);
			model.addAttribute("riskControlListTTY", voList);
			model.addAttribute("listSize", voList.size()); //input[type=hidden]
		}else if (gameParameter.getGameCode() == SysConstants.FBS && riskParam != null) { //FBS
			String[] temp = riskParam.split("#");
			List<RiskControlVoFBS> voList = new ArrayList<RiskControlVoFBS>();
			for (int i = 0; i < temp.length; i++) {
				RiskControlVoFBS vo = new RiskControlVoFBS();
				String[] ss = temp[i].split(":");
				vo.setTemp_ruleCode(ss[0]);
				vo.setTemp_riskThreshold(ss[1]);
				vo.setTemp_maxClaimsAmount(ss[2]);
				voList.add(vo);
			}
			List<GameRule> gameRuleList = gameManagementService.getGameRuleByCode(gameCode);
			Map<String, String> ruleMap = new HashMap<String,String>();
			Iterator<GameRule> it = gameRuleList.iterator();
			while (it.hasNext()) {
				GameRule gr = it.next();
				ruleMap.put(gr.getRuleCode().toString(), gr.getRuleName());
			}
			model.addAttribute("ruleMap", ruleMap);
			model.addAttribute("riskControlListFBS", voList);
			model.addAttribute("listSize", voList.size()); //input[type=hidden]
		}
		
		model.addAttribute("gameParameter",gameParameter);
		model.addAttribute("gameManagementForm", gameManagementForm);
		return LocaleUtil.getUserLocalePath("oms/game/param/editRiskControl", request);
	}
	
	//更新游戏风控参数（七）
	@RequestMapping(params = "method=updateRiskControl")
	public String updateRiskControl(HttpServletRequest request, HttpServletResponse response, ModelMap model,
			GameManagementForm gameManagementForm, Short gameCode_)throws Exception {
		
		List<GameRule> gameRuleList = new ArrayList<GameRule>();
		
		if (gameCode_ != null) {	//取消编辑的情况，form提交时带个gameCode参数
			GameParameterHistory gameParameter = gameManagementService.getGameParameterHistory(gameCode_);
			gameRuleList = gameManagementService.getGameRuleByCode(gameCode_);
			String riskParam = gameParameter.getRiskParam();
			if (gameParameter.getGameCode() == SysConstants.KOC11X5 && riskParam != null && !riskParam.equals("")) {
				String[] temp = riskParam.split(":");
				RiskControlVo11X5 vo = new RiskControlVo11X5();
				vo.setParamA(temp[0]);
				vo.setParamB(temp[1]);
				model.addAttribute("riskControl11X5", vo);
			} else if (gameParameter.getGameCode() == SysConstants.KOCK3 && riskParam != null && !riskParam.equals("")) {
				String[] temp = riskParam.split(":");
				RiskControlVoK3 vo = new RiskControlVoK3();
				vo.setParamA(temp[0]);
				vo.setParamB(temp[1]);
				model.addAttribute("riskControlK3", vo);
			} else if (gameParameter.getGameCode() == SysConstants.KOCTTY && riskParam != null && !riskParam.equals("")) {
				String[] temp = riskParam.split("#");
				List<RiskControlVoTTY> voList = new ArrayList<RiskControlVoTTY>();
				for (int i = 0; i < temp.length; i++) {
					RiskControlVoTTY vo = new RiskControlVoTTY();
					String[] ss = temp[i].split(":");
					vo.setTemp_ruleCode(ss[0]);
					vo.setTemp_riskThreshold(ss[1]);
					vo.setTemp_maxClaimsAmount(ss[2]);
					voList.add(vo);
				}
				model.addAttribute("riskControlListTTY", voList);
			}else if (gameParameter.getGameCode() == SysConstants.FBS && riskParam != null && !riskParam.equals("")) {
				String[] temp = riskParam.split("#");
				List<RiskControlVoFBS> voList = new ArrayList<RiskControlVoFBS>();
				for (int i = 0; i < temp.length; i++) {
					RiskControlVoFBS vo = new RiskControlVoFBS();
					String[] ss = temp[i].split(":");
					vo.setTemp_ruleCode(ss[0]);
					vo.setTemp_riskThreshold(ss[1]);
					vo.setTemp_maxClaimsAmount(ss[2]);
					voList.add(vo);
				}
				model.addAttribute("riskControlListTTY", voList);
			}
			gameManagementForm.setGameParameterHistory(gameParameter);
			model.addAttribute("gameParameter",gameParameter);
		} else {
			GameParameterHistory gph = gameManagementForm.getGameParameterHistory();
			try {
				GameParameterHistory p = new GameParameterHistory();
				p.setHisHisCode(gph.getHisHisCode()+1);
				p.setGameCode(gph.getGameCode());
				p.setIsOpenRisk(gph.getIsOpenRisk());
				p.setHisModifyDate(new Date());
				String riskParamStr = "";
				if (gph.getGameCode() == SysConstants.KOC11X5) {
					RiskControlVo11X5 vo = new RiskControlVo11X5();
					String paramA = request.getParameter("gameParam.paramA");
					String paramB = request.getParameter("gameParam.paramB");
					riskParamStr = paramA + ":" + paramB;
					vo.setParamA(paramA);
					vo.setParamB(paramB);
					model.addAttribute("riskControl11X5", vo);
				} else if (gph.getGameCode() == SysConstants.KOCK3) {
					RiskControlVoK3 vo = new RiskControlVoK3();
					String paramA = request.getParameter("gameParam.paramA");
					String paramB = request.getParameter("gameParam.paramB");
					riskParamStr = paramA + ":" + paramB;
					vo.setParamA(paramA);
					vo.setParamB(paramB);
					model.addAttribute("riskControlK3", vo);
				} else if (gph.getGameCode() == SysConstants.KOCTTY) {
					gameRuleList = gameManagementService.getGameRuleByCode(gph.getGameCode());
					List<RiskControlVoTTY> voList = new ArrayList<RiskControlVoTTY>();
					int size = new Integer(request.getParameter("listSize"));
					for (int i = 0; i < size; i++) {
						String tr = request.getParameter("gameParam"+i+".temp_ruleCode");
						String rt = request.getParameter("gameParam"+i+".temp_riskThreshold");
						String ca = request.getParameter("gameParam"+i+".temp_maxClaimsAmount");
						riskParamStr += tr+":"+rt+":"+ca+"#";
						RiskControlVoTTY vo = new RiskControlVoTTY();
						vo.setTemp_ruleCode(tr);
						vo.setTemp_riskThreshold(rt);
						vo.setTemp_maxClaimsAmount(ca);
						voList.add(vo);
					}
					model.addAttribute("riskControlListTTY", voList);
				}else if (gph.getGameCode() == SysConstants.KOCSSC) {
					gameRuleList = gameManagementService.getGameRuleByCode(gph.getGameCode());
					List<RiskControlVoSSC> voList = new ArrayList<RiskControlVoSSC>();
					int size = new Integer(request.getParameter("listSize"));
					String pa = request.getParameter("paybackRatio");
					riskParamStr += pa + ";";
					for (int i = 0; i < size; i++) {
						String tr = request.getParameter("gameParam"+i+".subType");
						String rt = request.getParameter("gameParam"+i+".threshold");
						riskParamStr += tr+":"+rt +",";
						RiskControlVoSSC vo = new RiskControlVoSSC();
						vo.setSubType(tr);
						vo.setThreshold(rt);
						voList.add(vo);
					}
					model.addAttribute("riskControlListSSC ", voList);
				}
				else if (gph.getGameCode() == SysConstants.FBS) {
					gameRuleList = gameManagementService.getGameRuleByCode(gph.getGameCode());
					List<RiskControlVoFBS> voList = new ArrayList<RiskControlVoFBS>();
					int size = new Integer(request.getParameter("listSize"));
					for (int i = 0; i < size; i++) {
						String tr = request.getParameter("gameParam"+i+".temp_ruleCode");
						String rt = request.getParameter("gameParam"+i+".temp_riskThreshold");
						String ca = request.getParameter("gameParam"+i+".temp_maxClaimsAmount");
						riskParamStr += tr+":"+rt+":"+ca+"#";
						RiskControlVoFBS vo = new RiskControlVoFBS();
						vo.setTemp_ruleCode(tr);
						vo.setTemp_riskThreshold(rt);
						vo.setTemp_maxClaimsAmount(ca);
						voList.add(vo);
					}
					model.addAttribute("riskControlListTTY", voList);
				}
				p.setRiskParam(riskParamStr);
				gameManagementService.updateRiskParam(p);
				UpdateRiskParam2009Req paramReq = new UpdateRiskParam2009Req();
				paramReq.setGameCode(p.getGameCode());
				paramReq.setRiskCtrl(p.getIsOpenRisk());
				paramReq.setRiskCtrlStr(p.getRiskParam());
				sendMessageToHost(2009, paramReq);
				
				gameManagementForm.setGameParameterHistory(p);
				model.addAttribute("gameParameter", p);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		Map<String,String> ruleMap = new HashMap<String,String>();
		Iterator<GameRule> it = gameRuleList.iterator();
		while (it.hasNext()) {
			GameRule gr = it.next();
			ruleMap.put(gr.getRuleCode().toString(), gr.getRuleName());
		}
		model.addAttribute("ruleMap", ruleMap);
		
		model.addAttribute("gameManagementForm", gameManagementForm);
		return LocaleUtil.getUserLocalePath("oms/game/param/saveRiskControl", request);
	}
	
	//启用禁用风控
	@RequestMapping(params="method=closeRisk")
	public void closeRisk(HttpServletRequest request, HttpServletResponse response, Short gameCode, Long isOpenRisk) {
		
		GameParameterHistory gph = gameManagementService.getGameParameterHistory(gameCode);
		try {
			GameParameterHistory p = new GameParameterHistory();
			p.setHisHisCode(gph.getHisHisCode() + 1);
			p.setGameCode(gph.getGameCode());
			p.setIsOpenRisk(isOpenRisk);
			p.setRiskParam(gph.getRiskParam());
			p.setHisModifyDate(new Date());
			gameManagementService.updateRiskParam(p);
			UpdateRiskParam2009Req paramReq = new UpdateRiskParam2009Req();
			paramReq.setGameCode(p.getGameCode());
			paramReq.setRiskCtrl(p.getIsOpenRisk());
			paramReq.setRiskCtrlStr(p.getRiskParam());
			sendMessageToHost(2009, paramReq);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	//游戏控制菜单
	@RequestMapping(params="method=control")
	public String control(HttpServletRequest request, ModelMap model, Short gameCode) {
		GameManagementForm gameManagementForm = new GameManagementForm();
		
		//左侧彩种显示
		List<GameInfo> games = gameManagementService.getGameInfo();
		GameInfo gameInfo = new GameInfo();
		if (gameCode == null || gameCode.equals("")) {
			gameInfo = games.get(0);
		} else {
			gameInfo = gameManagementService.getGameInfoByCode(gameCode);
		}
		
		//显示奖池余额
		GamePool gamePool = gameManagementService.getGamePool(gameInfo.getGameCode());
		gameManagementForm.setGamePool(gamePool);
		GameParameterDynamic gameParameter = gameManagementService.getGameParameterDynamicByCode(gameInfo.getGameCode());
		gameManagementForm.setGameParameterDynamic(gameParameter);
		gameManagementForm.setGameInfo(gameInfo);
		gameManagementForm.setStyleId(gameInfo.getGameCode());
		
		//获取当前期，期次状态为2
		GameIssue gameIssue = new GameIssue();
		try {
			gameIssue.setGameCode(gameInfo.getGameCode());
			if(gameInfo.getGameCode() == SysConstants.FBS){
				gameIssue.setIssueStatus(1);
				gameIssue = gameManagementService.getFbsCurrentIssue(gameIssue);
			}else{
				gameIssue.setIssueStatus(2);
				gameIssue = gameManagementService.getCurrentIssue(gameIssue);
			}
		} catch (Exception e) {
			model.addAttribute("system_message", e.getMessage());
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		gameManagementForm.setGameIssue(gameIssue);
		
		if(gameIssue != null){
			String issueStatusValue = LocaleUtil.getUserLocaleEnum("issueStatusShowItems", request).get(gameIssue.getIssueStatus());
			model.addAttribute("issueStatusValue",issueStatusValue);
		}
		model.addAttribute("games", games);
		model.addAttribute("gameManagementForm", gameManagementForm);
		return LocaleUtil.getUserLocalePath("oms/game/param/gameControl", request);
	}
	
	//编辑游戏控制参数（2-告警阈值，3-服务时段）
	@RequestMapping(params = "method=editControlParameter")
	public String editControlParameter(HttpServletRequest request, HttpServletResponse response, ModelMap model,
			GameManagementForm gameManagementForm, Short gameCode, Short d) throws Exception {
		
		GameParameterDynamic gameParameter = gameManagementService.getGameParameterDynamicByCode(gameCode);
		model.addAttribute("gameParameter", gameParameter);
		
		if (d == 2)
			return LocaleUtil.getUserLocalePath("oms/game/param/editControlParameter", request);
		else if (d == 3)
			return LocaleUtil.getUserLocalePath("oms/game/param/editControlParameter2", request);
		else
			return "";
	}
	
	//更新游戏控制参数（2-告警阈值，3-服务时段）
	@RequestMapping(params = "method=updateControlParameter")
	public String updateControlParameter(HttpServletRequest request, HttpServletResponse response, ModelMap model,
			GameManagementForm gameManagementForm, Short gameCode_,Short d) throws Exception {
		
		if (gameCode_ != null) {	//取消编辑的情况，form提交时带个gameCode参数
			GameParameterDynamic gameParameter = gameManagementService.getGameParameterDynamicByCode(gameCode_);
			gameManagementForm.setGameParameterDynamic(gameParameter);
		} else {
			if (d == 2) {
				GameParameterDynamic param = gameManagementForm.getGameParameterDynamic();
				try {
					gameManagementService.updateControlParameter1(param);
					UpdateGameLimit2021Req paramReq = new UpdateGameLimit2021Req();
					paramReq.setGameCode(param.getGameCode());
					paramReq.setSaleLimit(param.getAuditSingleTicketSale());
					paramReq.setPayLimit(param.getAuditSingleTicketPay());
					paramReq.setCancelLimit(param.getAuditSingleTicketCancel());
					sendMessageToHost(2021, paramReq);
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (d == 3) {
				GameParameterDynamic param = gameManagementForm.getGameParameterDynamic();
				try {
					gameManagementService.updateControlParameter2(param);
					UpdateGameServiceTime2019Req paramReq = new UpdateGameServiceTime2019Req();
					paramReq.setGameCode(param.getGameCode());
					if (param.getServiceTime1() != null && !param.getServiceTime1().equals("") && param.getServiceTime1().split("-").length>1) {
						String[] st1 = param.getServiceTime1().split("-");
						paramReq.service_time_1_b = Long.parseLong(st1[0].replace(":", ""));
						paramReq.service_time_1_e = Long.parseLong(st1[1].replace(":", ""));
					} else {
						paramReq.service_time_1_b = new Long(0);
						paramReq.service_time_1_e = new Long(0);
					}
					if (param.getServiceTime2() != null && !param.getServiceTime2().equals("") && param.getServiceTime2().split("-").length>1) {
						String[] st2 = param.getServiceTime2().split("-");
						paramReq.service_time_2_b = Long.parseLong(st2[0].replace(":", ""));
						paramReq.service_time_2_e = Long.parseLong(st2[1].replace(":", ""));
					} else {
						paramReq.service_time_2_b = new Long(0);
						paramReq.service_time_2_e = new Long(0);
					}
					sendMessageToHost(2019, paramReq);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		
		model.addAttribute("gameManagementForm", gameManagementForm);
		
		if (d == 2)
			return LocaleUtil.getUserLocalePath("oms/game/param/saveControlParameter", request);
		else if (d == 3)
			return LocaleUtil.getUserLocalePath("oms/game/param/saveControlParameter2", request);
		else
			return "";
	}
	
	//Toggle游戏控制开关
	@RequestMapping(params="method=changeStatus")
	public void changeStatus(HttpServletRequest request, HttpServletResponse response,
			Short gameCode, Short isSale, Short isPay, Short isCancel, Short isAutoDraw) throws Exception {
		
		response.setContentType("text/txt; charset=UTF-8");
		
		GameParameterDynamic gp = new GameParameterDynamic();
		gp.setGameCode(gameCode);
		
		if (isSale != null) {
			gp.setIsSale(isSale);
			gameManagementService.changeParamStatus(gp);
			try {
				UpdateGameSaleControl2011Req paramReq = new UpdateGameSaleControl2011Req();
				paramReq.setGameCode(gameCode);
				paramReq.setCanSale(isSale);
				sendMessageToHost(2011, paramReq);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if (isPay != null) {
			gp.setIsPay(isPay);
			gameManagementService.changeParamStatus(gp);
			try {
				UpdateGamePayControl2013Req paramReq = new UpdateGamePayControl2013Req();
				paramReq.setGameCode(gameCode);
				paramReq.setCanPay(isPay);
				sendMessageToHost(2013, paramReq);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if (isCancel != null) {
			gp.setIsCancel(isCancel);
			gameManagementService.changeParamStatus(gp);
			try {
				UpdateGameCancelControl2015Req paramReq = new UpdateGameCancelControl2015Req();
				paramReq.setGameCode(gameCode);
				paramReq.setCanCancel(isCancel);
				sendMessageToHost(2015, paramReq);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if (isAutoDraw != null) {
			gp.setIsAutoDraw(isAutoDraw);
			gameManagementService.changeParamStatus(gp);
			try {
				UpdateGameAutoDraw2017Req paramReq = new UpdateGameAutoDraw2017Req();
				paramReq.setGameCode(gameCode);
				paramReq.setCanAuto(isAutoDraw);
				sendMessageToHost(2017, paramReq);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	//奖池流水列表
	@RequestMapping(params="method=poolAdj")
	public String poolAdj(HttpServletRequest request, ModelMap model, GameManagementForm gameManagementForm) {
		
		Map<Integer, String> poolChangeType = LocaleUtil.getUserLocaleEnum("poolChangeTypeItems", request);
		
		List<GameInfo> games = gameManagementService.getGameInfo();
		GamePoolHis gamePoolHis = gameManagementForm.getGamePoolHis();
		if(gamePoolHis.getGameCode() == null)
			gamePoolHis.setGameCode(games.get(0).getGameCode());
		
		//显示奖池余额
		GamePool gamePool = gameManagementService.getGamePool(gamePoolHis.getGameCode());
		
		Integer count = gameManagementService.getPoolAdjListCount(gameManagementForm);
		int pageIndex = PageUtil.getPageIndex(request);
		List<GamePoolHis> list = new ArrayList<GamePoolHis>();
		if (count != null && count.intValue() != 0) {
			gamePoolHis.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			gamePoolHis.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);

			list = gameManagementService.getPoolAdjList(gameManagementForm);
		}
		model.addAttribute("games", games);
        model.addAttribute("pageDataList", list);
        model.addAttribute("gamePool", gamePool);
        model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
        model.addAttribute("poolChangeType", poolChangeType);
        
        return LocaleUtil.getUserLocalePath("oms/game/pool/poolAdjList", request);
	}
	
	//期次奖池
	@RequestMapping(params="method=poolManagement")
	public String poolManagement(HttpServletRequest request, ModelMap model, GameManagementForm gameManagementForm) {
		String gc = request.getParameter("gc");
		if(StringUtils.isNotEmpty(gc)){
			gameManagementForm.getGameIssue().setGameCode(Short.parseShort(gc));
		}
		List<GameInfo> games = gameManagementService.getGameInfo();
		GameIssue gameIssue = gameManagementForm.getGameIssue();
		if(gameIssue.getGameCode() == null){
			gameIssue.setGameCode(games.get(0).getGameCode());
			gameIssue.setIsPublish((short) 1);
		}
		gameIssue.setIssueStatus(7);
		Integer count = gameManagementService.getGameIssueListCount(gameManagementForm);
		int pageIndex = PageUtil.getPageIndex(request);
		List<GameIssue> list = new ArrayList<GameIssue>();
		if (count != null && count.intValue() != 0) {
			gameIssue.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			gameIssue.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);

			list = gameManagementService.getGameIssueList(gameManagementForm);
		}
		model.addAttribute("games", games);
        model.addAttribute("pageDataList", list);
        model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
        return LocaleUtil.getUserLocalePath("oms/game/pool/poolManagementList", request);
	}
	
	//创建奖池流水记录
	@RequestMapping(params = "method=createPoolAdj")
	public String createPoolAdj(HttpServletRequest request, ModelMap model) throws Exception {
		List<GameInfo> games = gameManagementService.getGameInfo();
		GameManagementForm createForm = new GameManagementForm();
		GamePool gamePool = gameManagementService.getGamePool(games.get(0).getGameCode());
		model.addAttribute("games", games);
		model.addAttribute("gamePool", gamePool);
		model.addAttribute("createForm", createForm);
		return LocaleUtil.getUserLocalePath("oms/game/pool/createPoolAdj", request);
	}
	
	//保存奖池流水记录
	@RequestMapping(params="method=savePoolAdj")
	public String savePoolAdj(HttpServletRequest request, ModelMap model,
			GameManagementForm createForm) {
		
		User currentUser = (User)request.getSession().getAttribute("current_user");
		
		try {
			GamePoolAdj gpa = createForm.getGamePoolAdj();
			gpa.setAdjAdmin(currentUser.getId());
			gameManagementService.insertPoolAdj(gpa);
			if (gpa.getC_errcode() == 0) {
				logger.debug("保存奖池流水记录;");
				logger.debug("操作者["+currentUser.getId() +";"+JSONArray.toJSONString(gpa));
				//return LocaleUtil.getUserLocalePath("common/successTip", request);
				return "redirect:gameManagement.do?method=poolManagement&gc="+gpa.getGameCode() ;
			} else {
				logger.error("errmsgs:" + gpa.getC_errmsg());
				model.addAttribute("system_message", gpa.getC_errmsg());
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			}
		} catch (Exception e) {
			logger.error("errmsgs: " + e.getMessage());
			model.addAttribute("system_message", e.getMessage());
    		return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
	}
	
	//系统参数
	@RequestMapping(params="method=systemParam")
	public String systemParam(HttpServletRequest request, ModelMap model, GameManagementForm gameManagementForm) {

		List<SystemParameter> sysList = gameManagementService.getSystemParameterList();
		gameManagementForm = loopSysParam(gameManagementForm,sysList);
		
		model.addAttribute("gameManagementForm", gameManagementForm);
		
		return LocaleUtil.getUserLocalePath("oms/game/param/systemParam", request);
	}
	
	//异步编辑系统参数
	@RequestMapping(params="method=editSystemParam")
	public String editSystemParam(HttpServletRequest request, HttpServletResponse response, ModelMap model,
			GameManagementForm gameManagementForm, String area) throws Exception {
		
		List<SystemParameter> sysList = gameManagementService.getSystemParameterList();
		gameManagementForm = loopSysParam(gameManagementForm,sysList);
		model.addAttribute("gameManagementForm", gameManagementForm);
		
		if (area.equals("sale")) {
			return LocaleUtil.getUserLocalePath("oms/game/param/editSystemParameter1", request);
		} else if (area.equals("agency")) {
			return LocaleUtil.getUserLocalePath("oms/game/param/editSystemParameter2", request);
		} else {
			return "";
		}
	}
	
	/**
	 * 异步存储系统参数
	 * @param request
	 * @param response
	 * @param gameManagementForm
	 * @param area
	 * @param fl	取消编辑标记，不为空时为取消编辑
	 * @throws Exception
	 */
	@RequestMapping(params = "method=updateSystemParam")
	public String updateSystemParam(HttpServletRequest request, HttpServletResponse response, ModelMap model,
			GameManagementForm gameManagementForm, String area, String fl) throws Exception {
		
		User currentUser = (User)request.getSession().getAttribute("current_user");
		
		if (fl != null) {
			List<SystemParameter> sysList = gameManagementService.getSystemParameterList();
			gameManagementForm = loopSysParam(gameManagementForm,sysList);
		} else {
			String strP = "";
			if (area.equals("sale")) {
				if (gameManagementForm.getStr_sysParamValue0() != null)
					strP = "1-"+gameManagementForm.getStr_sysParamValue0();
				if (gameManagementForm.getStr_sysParamValue1() != null)
					strP += "#2-"+gameManagementForm.getStr_sysParamValue1();
				if (gameManagementForm.getStr_sysParamValue2() != null)
					strP += "#3-"+gameManagementForm.getStr_sysParamValue2();
				if (gameManagementForm.getStr_sysParamValue3() != null)
					strP += "#4-"+gameManagementForm.getStr_sysParamValue3();
			} else if (area.equals("agency")) {
				if (gameManagementForm.getStr_sysParamValue4() != null)
					strP = "5-"+gameManagementForm.getStr_sysParamValue4();
				if (gameManagementForm.getStr_sysParamValue5() != null)
					strP += "#6-"+gameManagementForm.getStr_sysParamValue5();
				if (gameManagementForm.getStr_sysParamValue6() != null)
					strP += "#7-"+gameManagementForm.getStr_sysParamValue6();
				if (gameManagementForm.getStr_sysParamValue7() != null)
					strP += "#8-"+gameManagementForm.getStr_sysParamValue7();
			}
			gameManagementForm.setStrP(strP);
			try {
				gameManagementService.updateSystemParameter(gameManagementForm);
				if (gameManagementForm.getSysParam().getC_errcode() != 0) {
					logger.error("errmsgs:" + gameManagementForm.getSysParam().getC_errmsg());
				} 
			} catch (Exception e) {
				logger.error("errmsgs:" + e.getMessage());
				e.printStackTrace();
			}
		}
		model.addAttribute("gameManagementForm", gameManagementForm);
		
		if (area.equals("sale"))
			return LocaleUtil.getUserLocalePath("oms/game/param/saveSystemParameter1", request);
		else if (area.equals("agency"))
			return LocaleUtil.getUserLocalePath("oms/game/param/saveSystemParameter2", request);
		else return "";
	}
	
	//helper更新form中的系统参数
	private GameManagementForm loopSysParam(GameManagementForm gameManagementForm, List<SystemParameter> sysList){
		for(Iterator<SystemParameter> it = sysList.iterator();it.hasNext();){
			SystemParameter temp = it.next();
			if(temp.getSysDefaultSeq() == 1)
				gameManagementForm.setStr_sysParamValue0(temp.getSysDefaultValue());
			else if(temp.getSysDefaultSeq() == 2)
				gameManagementForm.setStr_sysParamValue1(temp.getSysDefaultValue());
			else if(temp.getSysDefaultSeq() == 3)
				gameManagementForm.setStr_sysParamValue2(temp.getSysDefaultValue());
			else if(temp.getSysDefaultSeq() == 4)
				gameManagementForm.setStr_sysParamValue3(temp.getSysDefaultValue());
			else if(temp.getSysDefaultSeq() == 5)
				gameManagementForm.setStr_sysParamValue4(temp.getSysDefaultValue());
			else if(temp.getSysDefaultSeq() == 6)
				gameManagementForm.setStr_sysParamValue5(temp.getSysDefaultValue());
			else if(temp.getSysDefaultSeq() == 7)
				gameManagementForm.setStr_sysParamValue6(temp.getSysDefaultValue());
			else if(temp.getSysDefaultSeq() == 8)
				gameManagementForm.setStr_sysParamValue7(temp.getSysDefaultValue());
		}
		return gameManagementForm;
	}
}
