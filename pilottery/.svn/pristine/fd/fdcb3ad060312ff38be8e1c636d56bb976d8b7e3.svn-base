package cls.pilottery.oms.issue.controller;

/**
 * 期次管理Controller
 * @author Woo
 */
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringReader;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.ConfigUtil;
import cls.pilottery.common.utils.DateUtil;
import cls.pilottery.common.utils.HttpClientUtils;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.common.utils.PropertiesUtil;
import cls.pilottery.common.utils.RegexUtil;
import cls.pilottery.common.utils.SpringContextUtil;
import cls.pilottery.oms.common.entity.BaseMessageReq;
import cls.pilottery.oms.common.entity.BaseMessageRes;
import cls.pilottery.oms.common.entity.MessageLog;
import cls.pilottery.oms.common.msg.DeleteGameIssue3001Req;
import cls.pilottery.oms.common.service.LogService;
import cls.pilottery.oms.game.form.GameManagementForm;
import cls.pilottery.oms.game.model.GameParameterHistory;
import cls.pilottery.oms.game.model.GameParameterNormalView;
import cls.pilottery.oms.game.model.GamePolicyParam;
import cls.pilottery.oms.game.model.GamePool;
import cls.pilottery.oms.game.model.GamePrizeRule;
import cls.pilottery.oms.game.model.GameRule;
import cls.pilottery.oms.game.model.GameWinRule;
import cls.pilottery.oms.game.service.GameManagementService;
import cls.pilottery.oms.issue.form.IssueManagementForm;
import cls.pilottery.oms.issue.model.DrawNoticeXml;
import cls.pilottery.oms.issue.model.GameDrawInfo;
import cls.pilottery.oms.issue.model.GameInfo;
import cls.pilottery.oms.issue.model.GameIssue;
import cls.pilottery.oms.issue.model.GameIssuePrizeDetail;
import cls.pilottery.oms.issue.model.GameIssuePrizeRule;
import cls.pilottery.oms.issue.model.GameParameterControlView;
import cls.pilottery.oms.issue.model.RiskControlVo;
import cls.pilottery.oms.issue.model.DrawNoticeXml.AreaLotteryDetail;
import cls.pilottery.oms.issue.model.DrawNoticeXml.AreaPrize;
import cls.pilottery.oms.issue.model.DrawNoticeXml.LotteryDetail;
import cls.pilottery.oms.issue.service.GameDrawService;
import cls.pilottery.oms.issue.service.IssueManagementService;
import cls.pilottery.web.system.model.User;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

@Controller
@RequestMapping("issueManagement")
public class IssueManagementController {
	static Logger log = Logger.getLogger(IssueManagementController.class);

	@Autowired
	private IssueManagementService issueManagementService;
	@Autowired
	private GameDrawService gameDrawService;
	@Autowired
	private GameManagementService gameManagementService;
	@Autowired
	private LogService logService;

	@RequestMapping(params = "method=issueManagementTabs")
	public String issueManagementTabs(HttpServletRequest request, ModelMap model, IssueManagementForm issueManagementForm) {
		Map<Integer, String> issueStatusMap = LocaleUtil.getUserLocaleEnum("issueStatusRefItems", request);
		Map<Integer, String> issueStatusRefMap = LocaleUtil.getUserLocaleEnum("issueStatusShowItems", request);
		List<GameInfo> games = issueManagementService.getGameInfo();

		if (issueManagementForm == null || issueManagementForm.getGameCode() == 0) {
			issueManagementForm.setGameCode(games.get(0).getGameCode());
			issueManagementForm.setIssueStatus(0);
		}

		Integer count = issueManagementService.getGameIssueListCountSingle(issueManagementForm);
		int pageIndex = PageUtil.getPageIndex(request);
		List<GameIssue> list = null;
		if (count != null && count.intValue() != 0) {
			issueManagementForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			issueManagementForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			list = issueManagementService.getGameIssueListSingle(issueManagementForm);
		}

		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", list);
		model.addAttribute("issueStatusMap", issueStatusMap);
		model.addAttribute("issueStatusRefMap", issueStatusRefMap);
		model.addAttribute("games", games);
		return LocaleUtil.getUserLocalePath("oms/issue/issueManagementTabs", request);
	}

	// 详情
	@RequestMapping(params = "method=detail")
	public String detail(HttpServletRequest request, ModelMap model, Short gameCode, Long issueNumber) {
		try {
			GameIssue gameIssue = issueManagementService.getgameIssueByPK(gameCode, issueNumber);
			GameDrawInfo gameDrawInfo = new GameDrawInfo();
			gameDrawInfo.setGameCode(gameCode);
			gameDrawInfo.setIssueNumber(issueNumber);
			gameDrawInfo = gameDrawService.getCurrentGameIssue(gameDrawInfo);

			DrawNoticeXml drawNotice = getDrawNotice(gameDrawInfo.getWinnerBrodcast());

			List<GameIssuePrizeDetail> drawInfo = issueManagementService.getGameIssuePrizeDetail(gameCode, issueNumber);

			model.addAttribute("gameIssue", gameIssue);
			model.addAttribute("drawNotice", drawNotice);
			model.addAttribute("drawNoticeSize", drawNotice.lotteryDetails.size());
			model.addAttribute("drawInfo", drawInfo);
			model.addAttribute("drawInfoSize", drawInfo.size());
		} catch (Exception e) {
			e.printStackTrace();
		}

		return LocaleUtil.getUserLocalePath("oms/issue/issueDetail", request);
	}

	@RequestMapping(params = "method=issueParam")
	public String issueParam(HttpServletRequest request, ModelMap model, Short gameCode, Long issueNumber) {
		GameManagementForm gameManagementForm = new GameManagementForm();

		cls.pilottery.oms.game.model.GameInfo gameInfo = gameManagementService.getGameInfoByCode(gameCode);

		// 政策参数
		GamePolicyParam gamePolicyParam = gameManagementService.getPolicyParamByCode(gameInfo.getGameCode());

		// 普通规则参数
		GameParameterNormalView normalRuleParameter = gameManagementService.getNormalRuleView(gameInfo.getGameCode());

		// 游戏控制参数
		cls.pilottery.oms.game.model.GameParameterControlView controlParameter = gameManagementService.getControlView(gameInfo.getGameCode());

		// 中奖规则
		List<GameWinRule> gameWinRuleList = gameManagementService.getGameWinRuleByCode(gameInfo.getGameCode());

		// 玩法规则
		List<GameRule> gameRuleList = gameManagementService.getGameRuleByCode(gameInfo.getGameCode());

		// 奖级规则
		List<GamePrizeRule> gamePrizeRuleList = gameManagementService.getGamePrizeRuleByCode(gameInfo.getGameCode());

		// 游戏风控参数
		GameParameterHistory riskControlParameter = gameManagementService.getGameParameterHistory(gameInfo.getGameCode());

		// 奖池信息
		GamePool gamePool = gameManagementService.getGamePool(gameInfo.getGameCode());

		// 动态参数
		// GameParameterDynamic gameParameterDynamic = gameManagementService.getGameParameterDynamicByCode(gameInfo.getGameCode());

		/********** 算奖参数 ********************/
		GameIssue gi = issueManagementService.getgameIssueByPK(gameCode, issueNumber);
		String awardParam = gi.getCalcWinningCode();
		if (gi.getGameCode() == SysConstants.KOCTTY) {
			if (awardParam != null && !awardParam.equals(""))
				gameManagementForm.setIsSpecial(awardParam.split(":")[1].trim());
		} else if (gi.getGameCode() == SysConstants.KOC7LX) {
			if (awardParam != null && !awardParam.equals("")) {
				String[] t_ap = awardParam.split("#");
				gameManagementForm.setFdbd(t_ap[0].split(":")[1].trim());
				gameManagementForm.setFdfd(t_ap[1].split(":")[1].trim());
				gameManagementForm.setFdmin(t_ap[2].split(":")[1].trim());
			}
		}
		/*************************************/

		String riskParam = riskControlParameter.getRiskParam();
		if (riskControlParameter.getGameCode() == SysConstants.KOCTTY && riskParam != null) { // 天天赢游戏风控参数显示转换
			String[] temp = riskParam.split("#");
			List<RiskControlVo> voList = new ArrayList<RiskControlVo>();
			RiskControlVo vo = null;
			for (int i = 0; i < temp.length; i++) {
				vo = new RiskControlVo();
				String[] ss = temp[i].split(":");
				vo.setTemp_ruleCode(ss[0]);
				vo.setTemp_riskThreshold(ss[1]);
				vo.setTemp_maxClaimsAmount(ss[2]);
				voList.add(vo);
			}
			model.addAttribute("riskControlList", voList);
			Map<String, String> ruleMap = new HashMap<String, String>();
			Iterator<GameRule> it = gameRuleList.iterator();
			while (it.hasNext()) {
				GameRule gr = it.next();
				ruleMap.put(gr.getRuleCode().toString(), gr.getRuleName());
			}
			model.addAttribute("ruleMap", ruleMap);
		} else if (gameInfo.getGameCode() == SysConstants.KOCK2 || gameInfo.getGameCode() == SysConstants.KOCKENO && riskParam != null) {
			String[] temp = riskParam.split("#");
			String[] res = temp[0].split(":");
			RiskControlVo vo = new RiskControlVo();
			vo.setTemp_riskThreshold(res[0]);
			vo.setTemp_maxClaimsAmount(res[1]);
			model.addAttribute("riskControl", vo);
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

		// model.addAttribute("games", games);
		model.addAttribute("gameManagementForm", gameManagementForm);
		model.addAttribute("issueNumber", issueNumber);
		return LocaleUtil.getUserLocalePath("oms/issue/issueParam", request);
	}

	/**
	 * 删除/撤销期次
	 * 
	 * @param request
	 * @param model
	 * @param gameCode
	 * @param issueNumber
	 * @param isPublish
	 * @return
	 */
	@RequestMapping(params = "method=deleteIssue")
	public String deleteIssue(HttpServletRequest request, ModelMap model, Short gameCode, Long issueNumber, Short isPublish) {
		User user = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);

		Long operUserId = user.getId();
		StringBuilder sb = new StringBuilder();

		GameIssue gi = new GameIssue();
		gi.setGameCode(gameCode);
		gi.setIssueNumber(issueNumber);
		gi.setIsPublish(isPublish);
		if (isPublish == 0) {// 删除
			try {
				sb.append("deleteIssue;");
				sb.append(JSONArray.toJSONString(gi));
				log.debug("删除期次;");
				log.debug("操作者[" + operUserId + ";" + JSONArray.toJSONString(gi));
				log.debug("执行存储过程p_om_issue_delete,参数:[gameCode:" + gi.getGameCode() + ";issueNumber:" + gi.getIssueNumber() + "]");
				issueManagementService.deleteIssue(gi);
				sb.append("db_opr_result:success;");
				log.debug("存储过程执行成功，errorCode:" + gi.getC_errcode() + ";errorMsg:" + gi.getC_errmsg());
				if (gi.getC_errcode() != 0) {
					sb.append("delete issues after " + gi.getIssueNumber() + " of game code : " + gameCode + " fail！");
					model.addAttribute("system_message", gi.getC_errmsg());
					return LocaleUtil.getUserLocalePath("common/errorTip", request);
				} else {
					sb.append("delete issues after " + gi.getIssueNumber() + " of game code : " + gameCode + " success！");
				}
			} catch (Exception e) {
				model.addAttribute("system_message", e.getMessage());
				sb.append("opr_exception: (" + e.getMessage() + ");");
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			} finally {
				log.info(sb.toString());
			}
		} else {// 撤销
			gi = issueManagementService.getgameIssueByPK(gameCode, issueNumber);
			if (gi.getIssueStatus() > 0) {
				model.addAttribute("system_message", "Issues that are not prearranged cannot be withdrawn");
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			} else {
				DeleteGameIssue3001Req paramReq = new DeleteGameIssue3001Req();
				paramReq.setGameCode(gi.getGameCode());
				paramReq.setIssueNumber(gi.getIssueNumber());

				BaseMessageReq req = new BaseMessageReq(3001, 2);
				req.setParams(paramReq);
				String reqJson = JSONObject.toJSONString(req);
				log.debug("向主机发送请求，请求内容：" + reqJson);
				long seq = logService.getNextSeq();
				MessageLog msglog = new MessageLog(seq, reqJson);
				logService.insertLog(msglog);
				String resJson = HttpClientUtils.postString(PropertiesUtil.readValue("url_host"), reqJson);
				log.debug("接收到主机的响应，消息内容：" + resJson);
				
				BaseMessageRes res = JSON.parseObject(resJson,BaseMessageRes.class);
				if(res!= null && res.getRc()==0){
					logService.updateLog(msglog);
				}else{
					model.addAttribute("system_message", "消息发送失败");
					return LocaleUtil.getUserLocalePath("common/errorTip", request);
				}
			}
		}
		return "redirect:issueManagement.do?method=issueManagementTabs&gameCode=" + gameCode;
	}

	// 读取中奖信息的xml
	public static DrawNoticeXml getDrawNotice(String xml) {
		DrawNoticeXml drawNotice = new DrawNoticeXml();
		try {
			if (xml != null) {
				DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
				DocumentBuilder db = factory.newDocumentBuilder();
				Document doc = db.parse(new InputSource(new StringReader(xml)));
				Element elmtInfo = doc.getDocumentElement();

				drawNotice.setGameCode(elmtInfo.getAttribute("gameCode"));
				drawNotice.setGameName(elmtInfo.getAttribute("gameName"));
				drawNotice.setPeriodIssue(elmtInfo.getAttribute("periodIssue"));
				drawNotice.setCodeResult(elmtInfo.getAttribute("codeResult"));
				drawNotice.setSaleAmount(elmtInfo.getAttribute("saleAmount"));
				drawNotice.setPoolScroll(elmtInfo.getAttribute("poolScroll"));

				NodeList nodes = elmtInfo.getChildNodes();
				for (int i = 0; i < nodes.getLength(); i++) {

					if ("lotteryDetail".equals(nodes.item(i).getNodeName())) {
						NodeList subNodes = nodes.item(i).getChildNodes();
						LotteryDetail lotteryDetail = drawNotice.new LotteryDetail();
						for (int n = 0; n < subNodes.getLength(); n++) {

							if ("prizeLevel".equals(subNodes.item(n).getNodeName())) {
								lotteryDetail.setPrizeLevel(subNodes.item(n).getTextContent());
							} else if ("betCount".equals(subNodes.item(n).getNodeName())) {
								lotteryDetail.setBetCount(subNodes.item(n).getTextContent());
							} else if ("awardAmount".equals(subNodes.item(n).getNodeName())) {
								lotteryDetail.setAwardAmount(subNodes.item(n).getTextContent());
							} else if ("amountAfterTax".equals(subNodes.item(n).getNodeName())) {
								lotteryDetail.setAmountAfterTax(subNodes.item(n).getTextContent());
							} else if ("amountTotal".equals(subNodes.item(n).getNodeName())) {
								lotteryDetail.setAmountTotal(subNodes.item(n).getTextContent());
							}
						}
						drawNotice.lotteryDetails.add(lotteryDetail);

					} else if ("highPrizeAreas".equals(nodes.item(i).getNodeName())) {

						NodeList subNodes = nodes.item(i).getChildNodes();
						for (int n = 0; n < subNodes.getLength(); n++) {
							if ("Area".equals(subNodes.item(n).getNodeName())) {
								NodeList subNodes2 = subNodes.item(n).getChildNodes();
								AreaPrize areaPrize = drawNotice.new AreaPrize();
								for (int j = 0; j < subNodes2.getLength(); j++) {

									if ("areaCode".equals(subNodes2.item(j).getNodeName())) {
										areaPrize.setAreaCode(subNodes2.item(j).getTextContent());
									} else if ("areaName".equals(subNodes2.item(j).getNodeName())) {
										areaPrize.setAreaName(subNodes2.item(j).getTextContent());
									} else if ("areaLotteryDetail".equals(subNodes2.item(j).getNodeName())) {
										NodeList subNodes3 = subNodes2.item(j).getChildNodes();
										AreaLotteryDetail areaLotteryDetail = drawNotice.new AreaLotteryDetail();
										for (int k = 0; k < subNodes3.getLength(); k++) {
											if ("prizeLevel".equals(subNodes3.item(k).getNodeName())) {
												areaLotteryDetail.setPrizeLevel(subNodes3.item(k).getTextContent());
											} else if ("betCount".equals(subNodes3.item(k).getNodeName())) {
												areaLotteryDetail.setBetCount(subNodes3.item(k).getTextContent());
											}
										}
										areaPrize.areaLotteryDetails.add(areaLotteryDetail);
									}
								}
								drawNotice.highPrizeAreas.add(areaPrize);
							}
						}

					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return drawNotice;
	}

	// 編輯獎金
	@RequestMapping(params = "method=editPrize")
	public String editPrize(HttpServletRequest request, ModelMap model, Short gameCode, Long issueNumber) throws Exception {
		GameIssue gameIssue = issueManagementService.getgameIssueByPK(gameCode, issueNumber);
		List<GameIssuePrizeRule> gameIssuePrizeRuleList = issueManagementService.getGameIssuePrizeRule(gameCode, issueNumber);
		GameManagementForm gameManagementForm = new GameManagementForm();
		model.addAttribute("gameManagementForm", gameManagementForm);
		model.addAttribute("list", gameIssuePrizeRuleList);
		model.addAttribute("listSize", gameIssuePrizeRuleList.size());
		model.addAttribute("gameIssue", gameIssue);
		return LocaleUtil.getUserLocalePath("oms/issue/editPrize", request);
	}

	// 保存奖金
	@RequestMapping(params = "method=savePrize")
	public String savePrize(HttpServletRequest request, ModelMap model) {
		User user = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		Long operUserId = user.getId();
		try {
			int size = new Integer(request.getParameter("listSize"));
			GameIssuePrizeRule rule = null;
			List<GameIssuePrizeRule> list = new ArrayList<GameIssuePrizeRule>(size);
			for (int i = 0; i < size; i++) {
				String gc = request.getParameter("gameIssuePrizeRule" + i + ".gameCode");
				String in = request.getParameter("gameIssuePrizeRule" + i + ".issueNumber");
				String pl = request.getParameter("gameIssuePrizeRule" + i + ".prizeLevel");
				String pn = request.getParameter("gameIssuePrizeRule" + i + ".prizeName");
				String lp = request.getParameter("gameIssuePrizeRule" + i + ".levelPrize");
				rule = new GameIssuePrizeRule();
				rule.setGameCode(new Short(gc));
				rule.setIssueNumber(new Long(in));
				rule.setPrizeName(pn);
				rule.setLevelPrize(new Long(lp));
				rule.setPrizeLevel(new Short(pl));
				list.add(rule);
			}
			issueManagementService.updateGameIssuePrizeRule(list);
			log.debug("修改期次奖金;");
			log.debug("操作者[" + operUserId + ";" + JSONArray.toJSONString(list));
		} catch (Exception e) {
			model.addAttribute("system_message", e.getMessage());
			e.printStackTrace();
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		} finally {

		}
		return LocaleUtil.getUserLocalePath("common/successTip", request);
	}

	// 編輯算奖参数
	@RequestMapping(params = "method=editCalcWinningParam")
	public String editCalcWinningParam(HttpServletRequest request, ModelMap model, Short gameCode, Long issueNumber) throws Exception {
		GameManagementForm gameManagementForm = new GameManagementForm();
		GameIssue gameIssue = issueManagementService.getgameIssueByPK(gameCode, issueNumber);
		String awardParam = "";
		if (gameIssue != null)
			awardParam = gameIssue.getCalcWinningCode();
		if (gameIssue.getGameCode() == SysConstants.KOCTTY) {
			if (awardParam != null && !awardParam.equals(""))
				gameManagementForm.setIsSpecial(awardParam.split(":")[1].trim());
		} else if (gameIssue.getGameCode() == SysConstants.KOC7LX) {
			if (awardParam != null && !awardParam.equals("")) {
				String[] t_ap = awardParam.split("#");
				gameManagementForm.setFdbd(t_ap[0].split(":")[1].trim());
				gameManagementForm.setFdfd(t_ap[1].split(":")[1].trim());
				gameManagementForm.setFdmin(t_ap[2].split(":")[1].trim());
			}
		}
		model.addAttribute("gameIssue", gameIssue);
		model.addAttribute("gameManagementForm", gameManagementForm);
		return LocaleUtil.getUserLocalePath("oms/issue/editCalcWinningParam", request);

	}

	// 保存算奖参数
	@RequestMapping(params = "method=saveCalcWinningParam")
	public String saveCalcWinningParam(HttpServletRequest request, ModelMap model, GameManagementForm gameManagementForm) {
		User user = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		Long operUserId = user.getId();
		try {
			cls.pilottery.oms.game.model.GameIssue gameIssue = gameManagementForm.getGameIssue();
			if (gameIssue.getGameCode() == SysConstants.KOCTTY)
				gameIssue.setCalcWinningCode("TBZJ:" + gameManagementForm.getIsSpecial());
			else if (gameIssue.getGameCode() == SysConstants.KOC7LX)
				gameIssue.setCalcWinningCode("FDBD:" + gameManagementForm.getFdbd() + "#FDFD:" + gameManagementForm.getFdfd() + "#FDMIN:" + gameManagementForm.getFdmin());
			issueManagementService.updateCalcWinningCode(gameIssue);
			log.debug("修改算奖参数;");
			log.debug("操作者[" + operUserId + ";" + JSONArray.toJSONString(gameIssue));
		} catch (Exception e) {
			model.addAttribute("system_message", e.getMessage());
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		} finally {
		}
		return LocaleUtil.getUserLocalePath("common/successTip", request);
	}

	/**
	 * 查询未发布期次
	 */
	@RequestMapping(params = "method=getUnPublishCount")
	public void getUnPublishCount(HttpServletRequest request, HttpServletResponse response, Short gameCode) throws IOException {
		response.setContentType("text/txt; charset=UTF-8");
		PrintWriter out = null;
		out = response.getWriter();
		out.print(issueManagementService.getUnPublishCount(gameCode));
		out.flush();
		out.close();
	}

	// 期次发布
	@RequestMapping(params = "method=issuePublish")
	public String issuePublish(HttpServletRequest request, ModelMap model) {
		List<GameInfo> games = issueManagementService.getGameInfo();
		IssueManagementForm form = new IssueManagementForm();
		form.setGameCode(games.get(0).getGameCode());
		int publishNumber = issueManagementService.getUnPublishCount(games.get(0).getGameCode());
		form.setPublishNumber(publishNumber);
		model.addAttribute("games", games);
		model.addAttribute("issuePublishForm", form);
		return LocaleUtil.getUserLocalePath("oms/issue/issuePublish", request);
	}

	// 保存
	@RequestMapping(params = "method=submitPublish")
	public String submitPublish(HttpServletRequest request, ModelMap model, IssueManagementForm form) {
		if (form.getPublishNumber() == 0) {
			model.addAttribute("system_message", "Number of issues to publish cannot be 0");
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		User user = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		Long operUserId = user.getId();

		// Long minIss = issueManagementService.getMinPublishIssueNumber(form);
		// Long maxIss = issueManagementService.getMaxPublishIssueNumber(form);
		try {
			Map map = new HashMap();
			map.put("gameCode", form.getGameCode());
			BaseMessageReq req = new BaseMessageReq(3017, 2);
			long seq = logService.getNextSeq();
			req.setMsn(seq);
			req.setParams(map);
			String reqJson = JSONObject.toJSONString(req);
			log.debug("向主机发送请求，请求内容：" + reqJson);
			MessageLog msglog = new MessageLog(seq, reqJson);
			logService.insertLog(msglog);
			String resJson = HttpClientUtils.postString(PropertiesUtil.readValue("url_host"), reqJson);
			log.debug("接收到主机的响应，消息内容：" + resJson);
			BaseMessageRes res = JSON.parseObject(resJson, BaseMessageRes.class);

			if (resJson != null && res.getRc() == 0) {
				issueManagementService.updateIssuePublish(form);
				log.debug("发布排期;");
				log.debug("操作者[" + operUserId + ";" + JSONArray.toJSONString(form));

				logService.updateLog(msglog);
				log.info("send_host_msg: success;");
				model.addAttribute("reservedHrefURL", "issueManagement.do?method=issueManagementTabs");
				return LocaleUtil.getUserLocalePath("common/successTip", request);
			} else {
				model.addAttribute("system_message", "");
				log.info("send_host_msg: failure(" + res.getRc() + ");");
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error("opr_exception: (" + e.getMessage() + ");");
			model.addAttribute("system_message", e.getMessage());
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		} finally {
		}
	}

	// 手工排期
	@RequestMapping(params = "method=preArrangementTabs")
	public String toPreArrangementTabs(HttpServletRequest request, ModelMap model, Short gameCode) {
		List<GameInfo> games = issueManagementService.getGameInfo();
		IssueManagementForm form = new IssueManagementForm();
		if (gameCode != null)
			form.setGameCode(gameCode);
		else {
			gameCode = games.get(0).getGameCode();
			form.setGameCode(gameCode);
		}
		
		model.addAttribute("gameManagementForm", form);
		model.addAttribute("games", games);
		return LocaleUtil.getUserLocalePath("oms/issue/preArrangementTabs", request);
	}

	// 七龙星，天天赢默认参数 -------------------------------------------
	@RequestMapping(params = "method=pre_qlx_tty")
	public String pre_qlx_tty(HttpServletRequest request, ModelMap model, Short gameCode) {
		List<GameInfo> games = issueManagementService.getGameInfo();
		IssueManagementForm form = new IssueManagementForm();
		if (gameCode != null)
			form.setGameCode(gameCode);
		else {
			gameCode = games.get(0).getGameCode();
			form.setGameCode(gameCode);
		}
		Long maxIssueNumber = issueManagementService.getMaxIssueNumber(form.getGameCode());
		if (gameCode == SysConstants.KOC7LX || gameCode == SysConstants.KOCTTY || gameCode == SysConstants.C30S6) {
			if (maxIssueNumber == null) {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
				String year = sdf.format(new Date());
				maxIssueNumber = new Long(year + "000");
			}
			form.setBeginIssue(maxIssueNumber + 1);
		}
		model.addAttribute("games", games);
		model.addAttribute("gameManagementForm", form);
		return LocaleUtil.getUserLocalePath("oms/issue/pre_qlx_tty", request);
	}

	/*
	 * 游戏排期预览
	 */
	@RequestMapping(params = "method=preview_qlx_tty")
	public String preview_qlx_tty(HttpServletRequest request, HttpServletResponse response, ModelMap model, IssueManagementForm form) throws Exception {
		String contentHTML = "";// 渲染内容

		int gameCode = form.getGameCode();

		if (gameCode == SysConstants.KOC11X5 || gameCode == SysConstants.KOCK3 || gameCode == SysConstants.KOCSSC) {
			contentHTML = this.previewIssue(request, model, form);
			return contentHTML;
		}

		List<GameIssue> issueList = new ArrayList<GameIssue>();
		// 期次序号
		Long maxIssueSeq = issueManagementService.getMaxIssueSeq(gameCode);
		if (maxIssueSeq == null)
			maxIssueSeq = (long) 1;

		/**************** 非快开游戏 *********************/
		// 开始期号
		Long beginIssue = form.getBeginIssue();
		// 排期第一期的开始时间
		String beginHour = form.getPlanStartHour();
		// 排期期数
		Long issueNos = form.getIssueNos();
		// 开始时间
		String planStartHour = "";
		// 关闭时间
		String planCloseHour = "";

		int[] drawDays = null;
		Hashtable<String, String> param = ConfigUtil.loadIssueParam();
		if (gameCode == SysConstants.KOC7LX) {
			planStartHour = param.get("planStartHour_qlx");
			planCloseHour = param.get("planCloseHour_qlx");
			drawDays = RegexUtil.getString2intArr(param.get("drawDays_qlx"));
		} else if (gameCode == SysConstants.KOCTTY) {
			planStartHour = param.get("planStartHour_tty1");
			planCloseHour = param.get("planCloseHour_tty1");
			drawDays = RegexUtil.getString2intArr(param.get("drawDays_tty"));
		}

		long issueNo = 0;
		Long tINo = issueManagementService.getMaxIssueNumber(gameCode);
		if (tINo == null) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
			String year = sdf.format(new Date());
			tINo = new Long(year + "000");
		}
		GameIssue lastIssue = issueManagementService.getgameIssueByPK(gameCode, tINo);

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date beginTime = sdf.parse(beginHour);
		// 实际开始时间
		Date realbeginTime = DateUtil.getIssueTime(beginTime, planStartHour);
		if (beginTime.getTime() > realbeginTime.getTime())
			DateUtil.nextDate(realbeginTime);

		if (lastIssue.getPlanCloseTime().getTime() > realbeginTime.getTime()) {
			model.addAttribute("reservedSuccessMsg", "The begin At must be later than the end time of the last issue");
			contentHTML = LocaleUtil.getUserLocalePath("oms/issue/error", request);
			return contentHTML;
		}

		Calendar cal = Calendar.getInstance();
		Calendar calendar = Calendar.getInstance();
		cal.setTime(realbeginTime);
		calendar.setTime(realbeginTime);
		if (gameCode == SysConstants.KOCTTY) {
			Date lastStartDate = null;
			int drawTimesEachDay = Integer.parseInt(ConfigUtil.getIssusPltPara("drawTimesEachDay_tty"));
			String beginTimeStrPre = "planStartHour_tty";// 匹配开始时间前缀
			String endTimeStrPre = "planCloseHour_tty";// 匹配结束时间的前缀
			SimpleDateFormat yysdf = new SimpleDateFormat("yyyy");
			String year_lastStartTime = null;
			String year_currentStartTime = null;
			if (lastIssue != null)
				lastStartDate = lastIssue.getPlanStartTime();
			while (issueNo < issueNos) {

				for (int i = 1; i <= drawTimesEachDay; i++) {
					// 获取配置开始结束时间
					planStartHour = ConfigUtil.getIssusPltPara(beginTimeStrPre + i);
					planCloseHour = ConfigUtil.getIssusPltPara(endTimeStrPre + i);

					// 计算开始时间
					Date planStartTime = cal.getTime();

					if (issueNo == 0) {
						planStartTime = realbeginTime;
						// 和第一期的结束时间比较,确认是比当日第一期结束时间晚则cal.add(1d);
						Date firstIssEndTimeDate = DateUtil.getIssueTime(cal, planCloseHour);
						if (firstIssEndTimeDate.getTime() <= realbeginTime.getTime())
							cal.add(Calendar.DATE, 1);

						// 第一期要判断是否从新年开始
						if (lastStartDate != null) {
							year_lastStartTime = yysdf.format(lastStartDate);
							year_currentStartTime = yysdf.format(planStartTime);
							if (!year_lastStartTime.equals(year_currentStartTime))
								beginIssue = new Long(year_currentStartTime + "001");
						}

					} else {

						planStartTime = DateUtil.getIssueTime(cal, planStartHour);

						Date endTime = DateUtil.getIssueTime(cal, planCloseHour);
						if (planStartTime.getTime() > endTime.getTime())
							cal.add(Calendar.DATE, 1);

					}

					// 计算结束时间和开奖时间
					Date planCloseTime = DateUtil.getIssueTime(cal, planCloseHour);
					Date planRewardTime = planCloseTime;

					// 判断期次跨年
					year_lastStartTime = yysdf.format(planStartTime);
					year_currentStartTime = yysdf.format(planCloseTime);
					if (!year_lastStartTime.equals(year_currentStartTime))
						beginIssue = new Long(year_currentStartTime + "001");

					// 加入列表
					GameIssue gi = new GameIssue();
					gi.setGameCode((short) gameCode);
					gi.setIssueNumber(beginIssue++);
					gi.setIssueSeq(maxIssueSeq++);
					gi.setIssueStatus(0);
					gi.setIsPublish((short) 0);
					gi.setPlanStartTime(planStartTime);
					gi.setPlanCloseTime(planCloseTime);
					gi.setPlanRewardTime(planRewardTime);
					issueList.add(gi);
					issueNo++;

					lastStartDate = planStartTime;
				}

			}
		} else {// 七龙星
			Date lastStartDate = null;
			if (lastIssue != null)
				lastStartDate = lastIssue.getPlanStartTime();
			while (issueNo < issueNos) {
				while (issueManagementService.isDrawDay(calendar, drawDays)) {
					sdf = new SimpleDateFormat("yyyy-MM-dd");
					String dateCloseStr = sdf.format(calendar.getTime());
					sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					Date planStartTime = cal.getTime();
					Date planCloseTime = sdf.parse(dateCloseStr + " " + planCloseHour);
					Date planRewardTime = planCloseTime;
					if (planCloseTime.getTime() <= planStartTime.getTime()) {
						break;
					}
					if (lastStartDate != null) {
						SimpleDateFormat yysdf = new SimpleDateFormat("yyyy");
						String year_lastStartTime = yysdf.format(lastStartDate);
						String year_currentStartTime = yysdf.format(planStartTime);
						if (!year_lastStartTime.equals(year_currentStartTime))
							beginIssue = new Long(year_currentStartTime + "001");
					}
					GameIssue gi = new GameIssue();
					gi.setGameCode((short) gameCode);
					gi.setIssueNumber(beginIssue++);
					gi.setIssueSeq(maxIssueSeq++);
					gi.setIssueStatus(0);
					gi.setIsPublish((short) 0);
					gi.setPlanStartTime(planStartTime);
					gi.setPlanCloseTime(planCloseTime);
					gi.setPlanRewardTime(planRewardTime);
					issueList.add(gi);
					issueNo++;
					lastStartDate = planStartTime;
					cal.setTime(sdf.parse(dateCloseStr + " " + planStartHour));
					if (planCloseHour.compareTo(planStartHour) > 0) // 模板文件中结束时间大于开始时间。例如8：00开始。18：00结束
						cal.add(Calendar.DATE, 1);
				}
				calendar.add(Calendar.DATE, 1);
			}
		}

		if (issueList.size() > 0)
			request.getSession().setAttribute("issueList", issueList);
		model.addAttribute("issueList", issueList);
		contentHTML = LocaleUtil.getUserLocalePath("oms/issue/preArrangement", request);
		return contentHTML;

	}

	private String previewIssue(HttpServletRequest request, ModelMap model, IssueManagementForm form) throws ParseException {
		int gameCode = form.getGameCode();
		Long issueNos = form.getIssueNos(); // 排期期数
		List<GameIssue> issueList = new ArrayList<GameIssue>();
		SimpleDateFormat sdf1 = new SimpleDateFormat("yyMMdd");
		SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat sdf3 = new SimpleDateFormat("yyyy-MM-dd");
		Date beginTime = null;
		// 期次序号
		long beginIssueNo = form.getBeginIssue();
		beginTime = sdf2.parse(form.getPlanStartHour());

		ConfigUtil.loadIssueParam();

		Long maxIssueNo = issueManagementService.getMaxIssueNumber(gameCode);
		if( maxIssueNo != null && maxIssueNo > 0){
			GameIssue lastIssue = issueManagementService.getgameIssueByPK(gameCode, maxIssueNo);
	
			if (lastIssue.getPlanCloseTime().getTime() >= beginTime.getTime()) {
				model.addAttribute("reservedSuccessMsg", "The begin At must be later than the end time of the last issue");
				return LocaleUtil.getUserLocalePath("oms/issue/error", request);
			}
		}

		String prefix = "";
		if(gameCode==SysConstants.KOC11X5){
			prefix="11x5";
		}else if(gameCode==SysConstants.KOCK3){
			prefix = "k3";
			
		}else if(gameCode==SysConstants.KOCSSC){
			prefix = "ssc";
		}
		int drawTimesEachDay = Integer.parseInt(ConfigUtil.getIssusPltPara(prefix+"_drawTimesEachDay"));
		String beginTimeStrPre = prefix+"_planStartTime_";// 匹配开始时间前缀
		String endTimeStrPre = prefix+"_planCloseTime_";// 匹配结束时间的前缀

		long issueNo = 0;
		String planStartHour = null;
		String planCloseHour = null;
		
		String issueDate = sdf1.format(beginTime);
		Calendar c = Calendar.getInstance();
		c.setTime(beginTime);
		for (int i = 1; i <= drawTimesEachDay; i++) {
			// 获取配置开始结束时间
			planStartHour = ConfigUtil.getIssusPltPara(beginTimeStrPre + i);
			planCloseHour = ConfigUtil.getIssusPltPara(endTimeStrPre + i);

			String issueStartTime = sdf3.format(sdf1.parse(issueDate))+" "+" " + planStartHour;
			Date issueStartDate = sdf2.parse(issueStartTime);
			if (issueStartDate.before(beginTime)) {
				continue;
			}
			long issueNumber = Integer.parseInt(issueDate) * 1000 + i;
			if(issueDate.equals(sdf1.format(beginTime))){
				issueNumber = Integer.parseInt(issueDate) * 1000+beginIssueNo++;
			}

			GameIssue gi = new GameIssue();
			gi.setGameCode((short) gameCode);
			gi.setIssueNumber(issueNumber);
			gi.setIssueSeq((long) i);
			gi.setIssueStatus(0);
			gi.setIsPublish((short) 0);
			gi.setPlanStartTime(issueStartDate);
			gi.setPlanCloseTime(sdf2.parse(sdf3.format(sdf1.parse(issueDate))+" " + planCloseHour));
			gi.setPlanRewardTime(sdf2.parse(sdf3.format(sdf1.parse(issueDate))+" " + planCloseHour));
			issueList.add(gi);
			issueNo++;

			if (issueNo == issueNos) {
				break;
			}
			if (i == drawTimesEachDay) {
				i = 0;
				c.add(Calendar.DATE, 1);
				issueDate = sdf1.format(c.getTime());
			}

		}
		if (issueList.size() > 0)
			request.getSession().setAttribute("issueList", issueList);
		model.addAttribute("issueList", issueList);
		return LocaleUtil.getUserLocalePath("oms/issue/preArrangement", request);
	}

	@RequestMapping(params = "method=checkSupplement")
	public String checkSupplement(HttpServletRequest request, HttpServletResponse response, ModelMap model, String gameCode) throws Exception {
		model.addAttribute("reservedSuccessMsg", "No add-on issues currently");
		model.addAttribute("reservedUrl", "issueManagement.do?method=preArrangementTabs&gameCode=" + gameCode);
		model.addAttribute("backFlg", "true");
		return LocaleUtil.getUserLocalePath("oms/issue/error", request);
	}

	// 生成预览
	@RequestMapping(params = "method=preview")
	public String preview(HttpServletRequest request, HttpServletResponse response, ModelMap model, IssueManagementForm form) throws Exception {
		boolean showPre = true;// 定义要渲染的内容
		String contentHTML = "";// 渲染内容

		Short gameCode = (short) form.getGameCode();
		List<GameIssue> issueList = new ArrayList<GameIssue>();
		long maxIssueSeq = 0;

		// 开始期号
		Long beginIssue = form.getBeginIssue();
		// 开始时间
		String planStartHour = form.getPlanStartHour();
		// 关闭时间
		String planCloseHour = form.getPlanCloseHour();

		GameIssue lastIssue = issueManagementService.getMaxIssueByGame(gameCode);
		if(lastIssue != null){
			if (beginIssue <= lastIssue.getIssueNumber()) {
				String reservedSuccessMsg = null;
				if(LocaleUtil.isChinese(request)){
					reservedSuccessMsg = "期次错误：开始期次必须大于 " + lastIssue.getIssueNumber();
				}else{
					reservedSuccessMsg = "Issue error: start issue must be greater than&nbsp;" + lastIssue.getIssueNumber();
				}
				model.addAttribute("reservedSuccessMsg", reservedSuccessMsg);
				contentHTML = LocaleUtil.getUserLocalePath("oms/issue/error", request);
				showPre = false;
			}
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date planStartTime = sdf.parse(planStartHour);
			if (lastIssue.getPlanCloseTime().getTime() > planStartTime.getTime()) {
				String reservedSuccessMsg = null;
				if(LocaleUtil.isChinese(request)){
					reservedSuccessMsg = "期次错误：期次开始时间必须大于最后一期的结束时间 " ;
				}else{
					reservedSuccessMsg = "The begin At must be later than the end time of the last issue";
				}
				model.addAttribute("reservedSuccessMsg", reservedSuccessMsg);
				contentHTML = LocaleUtil.getUserLocalePath("oms/issue/error", request);
				showPre = false;
			}
			
			maxIssueSeq = lastIssue.getIssueSeq();
		}
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date planStartTime = sdf.parse(planStartHour);
			Date planCloseTime = sdf.parse(planCloseHour);
			Date planRewardTime = planCloseTime;

			if (planCloseTime.getTime() <= planStartTime.getTime()) {
				String reservedSuccessMsg = null;
				if(LocaleUtil.isChinese(request)){
					reservedSuccessMsg = "期次错误：结束时间必须晚于开始时间 ！";
				}else{
					reservedSuccessMsg = "Issue error: end time must be later than begin At";
				}
				model.addAttribute("reservedSuccessMsg", reservedSuccessMsg);
				contentHTML = LocaleUtil.getUserLocalePath("oms/issue/error", request);
				showPre = false;
			}
			GameIssue gi = new GameIssue();
			gi.setGameCode(gameCode);
			gi.setIssueNumber(beginIssue);
			gi.setIssueSeq(maxIssueSeq++);
			gi.setIssueStatus(0);
			gi.setIsPublish((short) 0);
			gi.setPlanStartTime(planStartTime);
			gi.setPlanCloseTime(planCloseTime);
			gi.setPlanRewardTime(planRewardTime);
			issueList.add(gi);
		
		if (showPre) {
			if (issueList.size() > 0)
				request.getSession().setAttribute("issueList", issueList);
			model.addAttribute("issueList", issueList);
			contentHTML = LocaleUtil.getUserLocalePath("oms/issue/preArrangement", request);
		}
		return contentHTML;
	}

	// 保存预排数据
	@SuppressWarnings("unchecked")
	@RequestMapping(params = "method=savePreIssue")
	public String savePreIssue(HttpServletRequest request, ModelMap model) {
		Short gameCode = null;
		if (request.getSession().getAttribute("issueList") == null) {
			model.addAttribute("system_message", "No issue data available");
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		} else {
			List<GameIssue> issueList = (List<GameIssue>) request.getSession().getAttribute("issueList");
			gameCode = issueList.get(0).getGameCode();
			issueList.get(issueList.size() - 1).getIssueNumber();
			// 存储
			try {
				String str = issueManagementService.insertIssuesP(issueList);
				String[] s = str.split("#");
				if (new Integer(s[0]) != 0) {
					model.addAttribute("system_message", s[1]);
					return LocaleUtil.getUserLocalePath("common/errorTip", request);
				}
				log.info("add issues of game game Code:" + gameCode + " success！（" + issueList.get(0).getIssueNumber() + "-" + issueList.get(issueList.size() - 1).getIssueNumber() + "）");
			} catch (Exception e) {
				model.addAttribute("system_message", e.getMessage());
				log.error("opr_exception: (" + e.getMessage() + ");");
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			} finally {
			}

		}
		request.getSession().removeAttribute("issueList");
		return "redirect:issueManagement.do?method=issueManagementTabs&gameCode=" + gameCode;
	}

}
