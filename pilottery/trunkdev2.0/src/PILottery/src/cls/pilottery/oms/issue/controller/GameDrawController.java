package cls.pilottery.oms.issue.controller;

import java.io.File;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.HttpClientUtils;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PropertiesUtil;
import cls.pilottery.oms.common.entity.BaseMessageReq;
import cls.pilottery.oms.common.entity.BaseMessageRes;
import cls.pilottery.oms.common.entity.MessageLog;
import cls.pilottery.oms.common.msg.DrawConfirm3013Req;
import cls.pilottery.oms.common.msg.DrawNumber3005Req;
import cls.pilottery.oms.common.msg.RestartDraw3015Req;
import cls.pilottery.oms.common.msg.SendPrize3009Req;
import cls.pilottery.oms.common.service.LogService;
import cls.pilottery.oms.issue.form.GameDrawForm;
import cls.pilottery.oms.issue.model.AreaSaleDetail;
import cls.pilottery.oms.issue.model.AreaSaleXml;
import cls.pilottery.oms.issue.model.DrawNoticeXml;
import cls.pilottery.oms.issue.model.GameDrawInfo;
import cls.pilottery.oms.issue.model.GameDrawXml;
import cls.pilottery.oms.issue.model.Prize;
import cls.pilottery.oms.issue.model.PrizeLevel;
import cls.pilottery.oms.issue.model.AreaSaleXml.AreaSale;
import cls.pilottery.oms.issue.model.DrawNoticeXml.AreaLotteryDetail;
import cls.pilottery.oms.issue.model.DrawNoticeXml.AreaPrize;
import cls.pilottery.oms.issue.model.DrawNoticeXml.LotteryDetail;
import cls.pilottery.oms.issue.service.GameDrawService;
import cls.pilottery.web.system.model.User;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

/**
 * 游戏开奖Controller
 * 
 * @author
 * 
 */
@Controller
@RequestMapping("/gameDraw")
public class GameDrawController {
	Logger log = Logger.getLogger(GameDrawController.class);

	@Autowired
	private GameDrawService gameDrawService;
	
	@Autowired
	private LogService logService;

	/** 手工开奖 */
	@RequestMapping(params = "method=manualDraw")
	public String gameDraw(HttpServletRequest request, ModelMap model) {
		try {
			List<GameDrawInfo> manualDrawList = gameDrawService.getManualDrawGameList();
			model.addAttribute("manualDrawList", manualDrawList);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return LocaleUtil.getUserLocalePath("oms/game-draw/chooseGame", request);
	}
	
	/** 因为输入错误号码重新开奖 *//*
	@RequestMapping(params = "method=reManualDraw")
	public String reManualDraw(HttpServletRequest request, ModelMap model) {
		try {
			short gameCode = toShort(request.getParameter("gameCode"));
			long issueNumber = toLong(request.getParameter("issueNumber"));
			
			GameDrawInfo manualDraw = new GameDrawInfo();
			manualDraw.setGameCode(gameCode);
			manualDraw.setIssueNumber(issueNumber);
			gameDrawService.redrawGameIssue(manualDraw);
			
			List<GameDrawInfo> manualDrawList = gameDrawService.getManualDrawGameList();
			model.addAttribute("manualDrawList", manualDrawList);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return LocaleUtil.getUserLocalePath("oms/game-draw/chooseGame", request);
	}*/

	/** 重新开奖 */
	@RequestMapping(params = "method=restart")
	public String restart(HttpServletRequest request, ModelMap model) {
		try {
			RestartDraw3015Req restartDrawReq = new RestartDraw3015Req();
			restartDrawReq.setGameCode(toShort(request.getParameter("gameCode")));
			restartDrawReq.setIssueNumber(toLong(request.getParameter("issueNumber")));
			restartDrawReq.setDrawTimes((short)1);
			BaseMessageReq req = new BaseMessageReq(3015, 2);
			long seq = logService.getNextSeq();
			req.setMsn(seq);
			req.setParams(restartDrawReq);
			String reqJson = JSONObject.toJSONString(req);
			log.debug("向主机发送请求，请求内容："+reqJson);
			
			MessageLog msglog = new MessageLog(seq,reqJson);
			logService.insertLog(msglog);
			String resJson = HttpClientUtils.postString(PropertiesUtil.readValue("url_host"), reqJson);
			log.debug("接收到主机的响应，消息内容："+resJson);
			BaseMessageRes res = JSON.parseObject(resJson,BaseMessageRes.class);
			
			if(res!= null && res.getRc()==0){
				logService.updateLog(msglog);
			}else{
				log.error("消息发送失败");
				return LocaleUtil.getUserLocalePath("oms/game-draw/_error", request);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}

		return "redirect:gameDraw.do?method=manualDraw";
	}

	// 1.选择游戏期次
	/**
	 * DB中 期次开奖状态：
	 * 
	 * 0=不能开奖状态；1=开奖准备状态；2=数据整理状态； 3=备份状态；4=备份完成；5=第一次输入完成； 6=第二次输入完成； 7=开奖号码审批通过；8=开奖号码审批失败；9=开奖号码已发送；10=派奖检索完成； 11=派奖输入已发送；12=中奖统计完成；13=数据稽核已发送 ； 14=数据稽核完成；15=期结确认已发送；16=开奖完成
	 */
	@RequestMapping(params = "method=chooseGame")
	public String chooseGame(HttpServletRequest request, ModelMap model) {

		String goToUrl = LocaleUtil.getUserLocalePath("oms/game-draw/_error", request);
		try {

			GameDrawInfo queryInfo = new GameDrawInfo();
			queryInfo.setGameCode(toShort(request.getParameter("gameCode")));
			queryInfo.setIssueNumber(toLong(request.getParameter("issueNumber")));

			GameDrawInfo gameDrawInfo = gameDrawService.getCurrentGameIssue(queryInfo);
			model.addAttribute("gameDrawInfo", gameDrawInfo);

			User user = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);

			if (gameDrawInfo != null) {
				// 如果是第一次录入，或者是开奖负责人1
				if (gameDrawInfo.getFirstDrawUserId() == 0 || user.getId() == gameDrawInfo.getFirstDrawUserId()) {

					switch (gameDrawInfo.getDrawStatus()) {
					case 1:
						goToUrl = LocaleUtil.getUserLocalePath("oms/game-draw/dataDisposal", request);
						break;
					case 4:
						goToUrl = "forward:gameDraw.do?method=dataBackup";
						break;
					case 5:
						goToUrl = LocaleUtil.getUserLocalePath("oms/game-draw/waitDrawApprove", request);
						break;
					case 6:
						goToUrl = LocaleUtil.getUserLocalePath("oms/game-draw/waitDrawApprove", request);
						model.addAttribute("status", 6);
						break;
					case 7:
						goToUrl = LocaleUtil.getUserLocalePath("oms/game-draw/waitDrawApprove", request);
						model.addAttribute("status", 7);
						break;
					case 9:
						goToUrl = LocaleUtil.getUserLocalePath("oms/game-draw/waitGamePrize", request);
						break;
					case 10:
						goToUrl = "forward:gameDraw.do?method=sendPrizeAmount";
						break;
					case 12:
						goToUrl = "forward:gameDraw.do?method=prizeStatistic";
						break;
					case 13:
						// goToUrl = "forward:gameDraw.do?method=drawPrizeConfirm";
						goToUrl = LocaleUtil.getUserLocalePath("oms/game-draw/dataCheck", request);
						break;
					}

				} else {// 如果是开奖负责人2
					if (gameDrawInfo.getDrawStatus() == 5) {
						// goToUrl = "forward:gameDraw.do?method=dataBackup";
						goToUrl = "forward:gameDraw.do?method=dataBackup";
					} else {
						goToUrl = LocaleUtil.getUserLocalePath("oms/game-draw/waitDrawApprove", request);
						model.addAttribute("status", -1);
					}
				}

			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		// goToUrl = "forward:gameDraw.do?method=dataBackup";
		// return "redirect:gameDraw.do?method=manualDraw";
		return goToUrl;
	}

	// 2.开奖数据整理，并数据备份
	@RequestMapping(params = "method=dataDisposal")
	public String dataDisposal(HttpServletRequest request, ModelMap model) {

		try {
			GameDrawInfo queryInfo = new GameDrawInfo();
			queryInfo.setGameCode(toShort(request.getParameter("gameCode")));
			queryInfo.setIssueNumber(toLong(request.getParameter("issueNumber")));

			GameDrawInfo gameDrawInfo = gameDrawService.getCurrentGameIssue(queryInfo);
			model.addAttribute("gameDrawInfo", gameDrawInfo);

			String gameMark = "";
			if (gameDrawInfo.getGameCode() == 6) {
				gameMark = "KOCTTY";
			} else if (gameDrawInfo.getGameCode() == 7) {
				gameMark = "KOC7LX";
			} else if (gameDrawInfo.getGameCode() == 13) {
				gameMark = "TEMA";
			}

			String fileName = "game_" + gameMark + "_issue_" + gameDrawInfo.getIssueNumber() + "_seal.dat";
			File datFile = new File("/ts_webapp/draw_files/" + fileName);

			if (datFile.exists()) {
				request.setAttribute("flg", "exists");
				request.setAttribute("fileName", fileName);
				request.setAttribute("fileSize", datFile.length());
			}else{
				log.info("备份文件不存在:"+"/ts_webapp/draw_files/" + fileName);
			}

			return LocaleUtil.getUserLocalePath("oms/game-draw/dataBackup", request);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return  LocaleUtil.getUserLocalePath("oms/game-draw/_error", request);
	}

	// 3.从数据备份页面，跳转到录入开奖号码页面
	@RequestMapping(params = "method=dataBackup")
	public String dataBackup(HttpServletRequest request, ModelMap model) {

		try {
			GameDrawInfo queryInfo = new GameDrawInfo();
			queryInfo.setGameCode(toShort(request.getParameter("gameCode")));
			queryInfo.setIssueNumber(toLong(request.getParameter("issueNumber")));

			GameDrawInfo gameDrawInfo = gameDrawService.getCurrentGameIssue(queryInfo);
			model.addAttribute("gameDrawInfo", gameDrawInfo);

			return LocaleUtil.getUserLocalePath("oms/game-draw/inputDrawNumber", request);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return LocaleUtil.getUserLocalePath("oms/game-draw/_error", request);
	}

	// 4.开奖号码录入
	@RequestMapping(params = "method=inputDrawNumber")
	public String inputDrawNumber(HttpServletRequest request, ModelMap model) {
		short gameCode = toShort(request.getParameter("gameCode"));
		long issueNumber = toLong(request.getParameter("issueNumber"));
		
		try {
			String drawNumber = request.getParameter("drawNumber");
			GameDrawInfo queryInfo = new GameDrawInfo();
			queryInfo.setGameCode(gameCode);
			queryInfo.setIssueNumber(issueNumber);

			GameDrawInfo gameDrawInfo = gameDrawService.getCurrentGameIssue(queryInfo);
			model.addAttribute("gameDrawInfo", gameDrawInfo);

			GameDrawInfo manualDraw = new GameDrawInfo();
			manualDraw.setGameCode(gameDrawInfo.getGameCode());
			manualDraw.setIssueNumber(gameDrawInfo.getIssueNumber());

			User user = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);

			// 如果是第一次录入
			if (gameDrawInfo.getDrawStatus() == 1) {
				manualDraw.setDrawStatus(5);
				manualDraw.setFirstDrawUserId(user.getId().intValue());
				manualDraw.setFirstDrawNumher(drawNumber);

				gameDrawService.updateGameIssue(manualDraw);

				return LocaleUtil.getUserLocalePath("oms/game-draw/waitDrawApprove", request);
				// 如果是第二次录入
			} else if (gameDrawInfo.getDrawStatus() == 5) {

				if (user.getId() == gameDrawInfo.getFirstDrawUserId()) {
					return LocaleUtil.getUserLocalePath("oms/game-draw/waitDrawApprove", request);
				} else if (user.getId() == gameDrawInfo.getSecondDrawUserId()) {
					model.addAttribute("status", -1);
					return LocaleUtil.getUserLocalePath("oms/game-draw/waitDrawApprove", request);
				} else {

					manualDraw.setDrawStatus(6);
					manualDraw.setSecondDrawUserId(user.getId().intValue());
					manualDraw.setSecondDrawNumher(drawNumber);

					if (gameDrawInfo.getFirstDrawNumher().equals(drawNumber)) {
						gameDrawService.updateGameIssue(manualDraw);
						
						DrawNumber3005Req dnreq = new DrawNumber3005Req();
						dnreq.setGameCode(gameCode);
						dnreq.setIssueNumber(issueNumber);
						dnreq.setDrawNumber(drawNumber);
						dnreq.setNumberCount(getNumberCount(drawNumber));
						//dnreq.setGameDisplay(drawNumber);
						dnreq.setDrawTimes((short)1);
						
						BaseMessageReq req = new BaseMessageReq(3005, 2);
						long seq = logService.getNextSeq();
						req.setMsn(seq);
						req.setParams(dnreq);
						String reqJson = JSONObject.toJSONString(req);
						log.debug("向主机发送请求，请求内容："+reqJson);
						MessageLog msglog = new MessageLog(seq,reqJson);
						logService.insertLog(msglog);
						String resJson = HttpClientUtils.postString(PropertiesUtil.readValue("url_host"), reqJson);
						log.debug("接收到主机的响应，消息内容："+resJson);
						BaseMessageRes res = JSON.parseObject(resJson,BaseMessageRes.class);
						
						if(resJson != null && res.getRc()==0){
							logService.updateLog(msglog);
						}else{
							log.error("消息发送失败");
							return LocaleUtil.getUserLocalePath("oms/game-draw/_error", request);
						}

						model.addAttribute("status", -1);
						return LocaleUtil.getUserLocalePath("oms/game-draw/waitDrawApprove", request);
					} else {
						if(LocaleUtil.isChinese(request)){
							model.addAttribute("msg","开奖号码输入不一致！");
						}else{
							model.addAttribute("msg", "* The two sets of draw numbers are not identical");
						}
						return "forward:gameDraw.do?method=dataBackup";
					}
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		//model.addAttribute("gameCode", gameCode);
		//model.addAttribute("issueNumber", issueNumber);
		return LocaleUtil.getUserLocalePath("oms/game-draw/_error", request);
	}

	// ajax请求
	@RequestMapping(params = "method=asyncData")
	@ResponseBody
	public Object asyncData(HttpServletRequest request, ModelMap model) {
		GameDrawInfo gameDrawInfo = new GameDrawInfo();
		try {
			GameDrawInfo queryInfo = new GameDrawInfo();
			queryInfo.setGameCode(toShort(request.getParameter("gameCode")));
			queryInfo.setIssueNumber(toLong(request.getParameter("issueNumber")));

			gameDrawInfo = gameDrawService.getCurrentGameIssue(queryInfo);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return JSONArray.toJSON(gameDrawInfo).toString();
	}

	// 5.跳转到等待中奖数据检索页面
	@RequestMapping(params = "method=waitGamePrize")
	public String waitGamePrize(HttpServletRequest request, ModelMap model) {
		try {
			GameDrawInfo queryInfo = new GameDrawInfo();
			queryInfo.setGameCode(toShort(request.getParameter("gameCode")));
			queryInfo.setIssueNumber(toLong(request.getParameter("issueNumber")));

			GameDrawInfo gameDrawInfo = gameDrawService.getCurrentGameIssue(queryInfo);
			model.addAttribute("gameDrawInfo", gameDrawInfo);

			return LocaleUtil.getUserLocalePath("oms/game-draw/waitGamePrize", request);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return LocaleUtil.getUserLocalePath("oms/game-draw/_error", request);
	}

	// 5.中奖数据检索
	@RequestMapping(params = "method=dataRetrieval")
	public String gamePrizeData(HttpServletRequest request, ModelMap model) {
		try {
			short gameCode = toShort(request.getParameter("gameCode"));
			long issueNumber = toLong(request.getParameter("issueNumber"));

			GameDrawInfo queryInfo = new GameDrawInfo();
			queryInfo.setGameCode(gameCode);
			queryInfo.setIssueNumber(issueNumber);

			GameDrawInfo gameDrawInfo = gameDrawService.getCurrentGameIssue(queryInfo);
			model.addAttribute("gameDrawInfo", gameDrawInfo);

			GameDrawXml gameDrawXml = new GameDrawXml();
			readXml(gameDrawInfo.getWinnerLocalInfo(), gameDrawXml);
			List<PrizeLevel> levelList = gameDrawService.getPrizeLevels(gameCode);
			dealPrizeOrderAndName(levelList, gameDrawXml);
			model.addAttribute("gamePrizeInfo", gameDrawXml);

			return LocaleUtil.getUserLocalePath("oms/game-draw/dataRetrieval", request);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return LocaleUtil.getUserLocalePath("oms/game-draw/_error", request);
	}

	// 6.跳转到派奖页面
	@RequestMapping(params = "method=sendPrizeAmount")
	public String sendPrizeAmount(HttpServletRequest request, ModelMap model) {
		try {
			short gameCode = toShort(request.getParameter("gameCode"));
			long issueNumber = toLong(request.getParameter("issueNumber"));

			GameDrawInfo queryInfo = new GameDrawInfo();
			queryInfo.setGameCode(gameCode);
			queryInfo.setIssueNumber(issueNumber);

			GameDrawInfo gameDrawInfo = gameDrawService.getCurrentGameIssue(queryInfo);
			model.addAttribute("gameDrawInfo", gameDrawInfo);

			GameDrawXml gameDrawXml = new GameDrawXml();
			log.debug("从数据库获取的xml数据："+gameDrawInfo.getWinnerLocalInfo());
			readXml(gameDrawInfo.getWinnerLocalInfo(), gameDrawXml);
			log.debug("解析xml后的数据："+gameDrawXml);
			// modify by dzg 修改新的排序和奖级显示
			List<PrizeLevel> levelList = gameDrawService.getPrizeLevels(gameCode);
			dealPrizeOrderAndName(levelList, gameDrawXml);
			log.debug("排序后的数据："+gameDrawXml);
			model.addAttribute("gamePrizeInfo", gameDrawXml);

			return LocaleUtil.getUserLocalePath("oms/game-draw/sendPrizeAmount", request);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return LocaleUtil.getUserLocalePath("oms/game-draw/_error", request);
	}

	// 6.发送派奖消息，并跳转到等待生成中奖统计表页面
	@RequestMapping(params = "method=waitStatistic")
	public String waitStatistic(HttpServletRequest request, ModelMap model) {
		try {
			short gameCode = toShort(request.getParameter("gameCode"));
			long issueNumber = toLong(request.getParameter("issueNumber"));
			String[] prize_levels = request.getParameterValues("prize_levels");
			String[] prize_amounts = request.getParameterValues("prize_amounts");
			log.debug("获得浏览器的奖级参数Prize_level:"+Arrays.toString(prize_levels));
			log.debug("获得浏览器的奖级参数Prize_Amount:"+Arrays.toString(prize_amounts));

			GameDrawInfo queryInfo = new GameDrawInfo();
			queryInfo.setGameCode(gameCode);
			queryInfo.setIssueNumber(issueNumber);

			GameDrawInfo gameDrawInfo = gameDrawService.getCurrentGameIssue(queryInfo);
			model.addAttribute("gameDrawInfo", gameDrawInfo);

			GameDrawXml gameDrawXml = new GameDrawXml();
			readXml(gameDrawInfo.getWinnerConfirmInfo(), gameDrawXml);
			model.addAttribute("gamePrizeInfo", gameDrawXml);

			if (gameDrawInfo.getDrawStatus() == 10) {
				/**** 发送派奖消息 ****/
				SendPrize3009Req sendPrize = new SendPrize3009Req();

				if (prize_levels != null && prize_amounts != null) {
					sendPrize.gameCode = gameDrawInfo.getGameCode();
					sendPrize.issueNumber = gameDrawInfo.getIssueNumber();
					sendPrize.prizeCount = (short) prize_amounts.length;

					for (int i = 0; i < prize_levels.length; i++) {

						SendPrize3009Req.PrizeInfo prize = sendPrize.new PrizeInfo();
						prize.setPrizeCode(Short.parseShort(prize_levels[i]));
						prize.setPrizeAmount(Long.parseLong(prize_amounts[i]));

						sendPrize.prizes.add(prize);
					}
					sendPrize.drawTimes = 1;

					BaseMessageReq req = new BaseMessageReq(3009, 2);
					long seq = logService.getNextSeq();
					req.setMsn(seq);
					req.setParams(sendPrize);
					String reqJson = JSONObject.toJSONString(req);
					log.debug("向主机发送请求，请求内容："+reqJson);
					MessageLog msglog = new MessageLog(seq,reqJson);
					logService.insertLog(msglog);
					String resJson = HttpClientUtils.postString(PropertiesUtil.readValue("url_host"), reqJson);
					log.debug("接收到主机的响应，消息内容："+resJson);
					BaseMessageRes res = JSON.parseObject(resJson,BaseMessageRes.class);
					
					if(res!= null && res.getRc()==0){
						logService.updateLog(msglog);
					}else{
						log.error("消息发送失败");
						return LocaleUtil.getUserLocalePath("oms/game-draw/_error", request);
					}
				}

				return LocaleUtil.getUserLocalePath("oms/game-draw/waitStatistic", request);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return LocaleUtil.getUserLocalePath("oms/game-draw/_error", request);
	}

	// 7.生成中奖统计表
	@RequestMapping(params = "method=prizeStatistic")
	public String prizeStatistic(HttpServletRequest request, ModelMap model) {
		try {
			short gameCode = toShort(request.getParameter("gameCode"));
			long issueNumber = toLong(request.getParameter("issueNumber"));

			GameDrawInfo queryInfo = new GameDrawInfo();
			queryInfo.setGameCode(gameCode);
			queryInfo.setIssueNumber(issueNumber);

			GameDrawInfo gameDrawInfo = gameDrawService.getCurrentGameIssue(queryInfo);
			model.addAttribute("gameDrawInfo", gameDrawInfo);

			GameDrawXml gameDrawXml = new GameDrawXml();
			readXml(gameDrawInfo.getWinnerConfirmInfo(), gameDrawXml);
			List<PrizeLevel> levelList = gameDrawService.getPrizeLevels(gameCode);
			dealPrizeOrderAndName(levelList, gameDrawXml);
			model.addAttribute("gamePrizeInfo", gameDrawXml);

			return LocaleUtil.getUserLocalePath("oms/game-draw/prizeStatistic", request);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return LocaleUtil.getUserLocalePath("oms/game-draw/_error", request);
	}

	// 8.数据稽核
	@RequestMapping(params = "method=dataCheck")
	public String dataCheck(HttpServletRequest request, ModelMap model) {
		try {
			GameDrawInfo queryInfo = new GameDrawInfo();
			queryInfo.setGameCode(toShort(request.getParameter("gameCode")));
			queryInfo.setIssueNumber(toLong(request.getParameter("issueNumber")));

			GameDrawInfo gameDrawInfo = gameDrawService.getCurrentGameIssue(queryInfo);
			model.addAttribute("gameDrawInfo", gameDrawInfo);
			if (gameDrawInfo.getDrawStatus() == 12) {
				GameDrawInfo manualDraw = new GameDrawInfo();
				manualDraw.setGameCode(gameDrawInfo.getGameCode());
				manualDraw.setIssueNumber(gameDrawInfo.getIssueNumber());
				manualDraw.setDrawStatus(13);

				gameDrawService.updateGameIssue(manualDraw);

				return LocaleUtil.getUserLocalePath("oms/game-draw/dataCheck", request);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return LocaleUtil.getUserLocalePath("oms/game-draw/_error", request);
	}

	// 9.确认开奖页面
	@RequestMapping(params = "method=drawPrizeConfirm")
	public String prizeConfirm(HttpServletRequest request, ModelMap model) {
		try {
			GameDrawInfo queryInfo = new GameDrawInfo();
			queryInfo.setGameCode(toShort(request.getParameter("gameCode")));
			queryInfo.setIssueNumber(toLong(request.getParameter("issueNumber")));

			GameDrawInfo gameDrawInfo = gameDrawService.getCurrentGameIssue(queryInfo);
			model.addAttribute("gameDrawInfo", gameDrawInfo);

			if (gameDrawInfo.getDrawStatus() == 13) {
				DrawConfirm3013Req dreq = new DrawConfirm3013Req();
				dreq.setGameCode(gameDrawInfo.getGameCode());
				dreq.setIssueNumber(gameDrawInfo.getIssueNumber());
				dreq.setDrawTimes((short)1);
				
				BaseMessageReq req = new BaseMessageReq(3013, 2);
				long seq = logService.getNextSeq();
				req.setMsn(seq);
				req.setParams(dreq);
				String reqJson = JSONObject.toJSONString(req);
				log.debug("向主机发送请求，请求内容："+reqJson);
				MessageLog msglog = new MessageLog(seq,reqJson);
				logService.insertLog(msglog);
				String resJson = HttpClientUtils.postString(PropertiesUtil.readValue("url_host"), reqJson);
				log.debug("接收到主机的响应，消息内容："+resJson);
				BaseMessageRes res = JSON.parseObject(resJson,BaseMessageRes.class);
				
				if(resJson != null && res.getRc()==0){
					logService.updateLog(msglog);
				}else{
					log.error("消息发送失败");
					return LocaleUtil.getUserLocalePath("oms/game-draw/_error", request);
				}

				return LocaleUtil.getUserLocalePath("oms/game-draw/drawPrizeConfirm", request);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return LocaleUtil.getUserLocalePath("oms/game-draw/_error", request);
	}

	@RequestMapping(params = "method=printDrawNotice")
	public String printDrawNotice(HttpServletRequest request, ModelMap model) {
		try {

			User user = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);

			model.addAttribute("operator", user.getRealName());

			GameDrawInfo queryInfo = new GameDrawInfo();
			queryInfo.setGameCode(toShort(request.getParameter("gameCode")));
			queryInfo.setIssueNumber(toLong(request.getParameter("issueNumber")));

			GameDrawInfo gameDrawInfo = gameDrawService.getCurrentGameIssue(queryInfo);
			model.addAttribute("gameDrawInfo", gameDrawInfo);

			DrawNoticeXml drawNotice = getDrawNotice(gameDrawInfo.getWinnerBrodcast());
			model.addAttribute("drawNotice", drawNotice);

			String drawNumberStr = drawNotice.getCodeResult();
			if (queryInfo.getGameCode() == 7) {
				String drawNumber1 = drawNumberStr.substring(0, drawNumberStr.lastIndexOf(","));
				String drawNumber2 = drawNumberStr.substring(drawNumberStr.lastIndexOf(",") + 1);
				request.setAttribute("drawNumber1", drawNumber1);
				request.setAttribute("drawNumber2", drawNumber2);

				return LocaleUtil.getUserLocalePath("oms/game-draw/step9_print2", request);
			} else {
				return LocaleUtil.getUserLocalePath("oms/game-draw/step9_print1", request);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return LocaleUtil.getUserLocalePath("common/errorTip", request);
	}

	@RequestMapping(params = "method=step3_print")
	public String step3_print(HttpServletRequest request, ModelMap model) {
		try {
			GameDrawInfo queryInfo = new GameDrawInfo();
			queryInfo.setGameCode(toShort(request.getParameter("gameCode")));
			queryInfo.setIssueNumber(toLong(request.getParameter("issueNumber")));

			GameDrawInfo gameDrawInfo = gameDrawService.getCurrentGameIssue(queryInfo);
			model.addAttribute("gameDrawInfo", gameDrawInfo);

			String gameMark = "";
			if (gameDrawInfo.getGameCode() == 6) {
				gameMark = "KOCTTY";
			} else if (gameDrawInfo.getGameCode() == 7) {
				gameMark = "KOC7LX";
			} else if (gameDrawInfo.getGameCode() == 12) {
				gameMark = "KOC11X5";
			} else if (gameDrawInfo.getGameCode() == 5) {
				gameMark = "KOCSSC";
			} else if (gameDrawInfo.getGameCode() == 11) {
				gameMark = "KOCK3";
			} else if (gameDrawInfo.getGameCode() == 13) {
				gameMark = "TEMA";
			}

			String fileName = "game_" + gameMark + "_issue_" + gameDrawInfo.getIssueNumber() + "_seal.dat.xml";
			File xmlFile = new File("/ts_webapp/draw_files/" + fileName);
			// File xmlFile = new File("e://b.xml");
			if (xmlFile.exists()) {
				AreaSaleXml areaSaleXml = getAreaSale(xmlFile);
				request.setAttribute("areaSaleXml", areaSaleXml);

				List<AreaSaleDetail> areaSaleList = gameDrawService.getLevelAreas();

				if (areaSaleList != null && areaSaleXml != null) {
					for (AreaSale areaSale : areaSaleXml.getArea_all()) {

						for (AreaSaleDetail areaSaleDetail : areaSaleList) {
							//if (areaSaleDetail.getAreaCode().equals(areaSale.getCode())) {
							if(Integer.parseInt(areaSaleDetail.getAreaCode()) == Integer.parseInt(areaSale.getCode())){
							areaSaleDetail.setS_amount(areaSale.getS_amount());
							areaSaleDetail.setS_amount_r(areaSale.getS_amount_r());
							}
						}
					}
				}
				request.setAttribute("areaSaleList", areaSaleList);

			}

			if ("1".equals(request.getParameter("type"))) {
				return LocaleUtil.getUserLocalePath("oms/game-draw/step3_print1", request);
			} else if ("2".equals(request.getParameter("type"))) {
				return LocaleUtil.getUserLocalePath("oms/game-draw/step3_print2", request);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return LocaleUtil.getUserLocalePath("common/errorTip", request);
	}

	@RequestMapping(params = "method=test")
	public String test(HttpServletRequest request, ModelMap model, GameDrawForm gameDrawForm) {
		try {
			System.out.println(gameDrawForm.getIssueNumber());

		} catch (Exception e) {
			e.printStackTrace();
		}

		return LocaleUtil.getUserLocalePath("oms/game-draw/test", request);
	}

	// 获取开奖号码个数
	private long getNumberCount(String str) {
		long count = 0;
		if (str == null) {
			return count;
		}
		count = str.contains("|") ? str.split(",").length + 1 : str.split(",").length;
		return count;
	}

	/*public static void main(String[] args) {
		String xml = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\" ?><game_draw><game_code>7</game_code><issue_number>2016002</issue_number><draw_result>01,02,03,04,05,06,07</draw_result><sale_total_amount>400000</sale_total_amount><prize_total_amount>108064000</prize_total_amount><pool_amount>1080</pool_amount><pool_left_amount>-107846920</pool_left_amount><prizes><prize><prize_level>1</prize_level><is_high_prize>1</is_high_prize><prize_num>1</prize_num><prize_amount>48000000</prize_amount><prize_after_tax_amount>48000000</prize_after_tax_amount><prize_tax_amount>0</prize_tax_amount></prize><prize><prize_level>2</prize_level><is_high_prize>1</is_high_prize><prize_num>2</prize_num><prize_amount>24000000</prize_amount><prize_after_tax_amount>24000000</prize_after_tax_amount><prize_tax_amount>0</prize_tax_amount></prize><prize><prize_level>3</prize_level><is_high_prize>0</is_high_prize><prize_num>3</prize_num><prize_amount>2400000</prize_amount><prize_after_tax_amount>2400000</prize_after_tax_amount><prize_tax_amount>0</prize_tax_amount></prize><prize><prize_level>4</prize_level><is_high_prize>0</is_high_prize><prize_num>10</prize_num><prize_amount>400000</prize_amount><prize_after_tax_amount>400000</prize_after_tax_amount><prize_tax_amount>0</prize_tax_amount></prize><prize><prize_level>5</prize_level><is_high_prize>0</is_high_prize><prize_num>8</prize_num><prize_amount>80000</prize_amount><prize_after_tax_amount>80000</prize_after_tax_amount><prize_tax_amount>0</prize_tax_amount></prize><prize><prize_level>6</prize_level><is_high_prize>0</is_high_prize><prize_num>12</prize_num><prize_amount>16000</prize_amount><prize_after_tax_amount>16000</prize_after_tax_amount><prize_tax_amount>0</prize_tax_amount></prize><prize><prize_level>7</prize_level><is_high_prize>0</is_high_prize><prize_num>4</prize_num><prize_amount>8000</prize_amount><prize_after_tax_amount>8000</prize_after_tax_amount><prize_tax_amount>0</prize_tax_amount></prize><prize><prize_level>8</prize_level><is_high_prize>1</is_high_prize><prize_num>0</prize_num><prize_amount>24000000</prize_amount><prize_after_tax_amount>24000000</prize_after_tax_amount><prize_tax_amount>0</prize_tax_amount></prize><prize><prize_level>9</prize_level><is_high_prize>1</is_high_prize><prize_num>0</prize_num><prize_amount>12000000</prize_amount><prize_after_tax_amount>12000000</prize_after_tax_amount><prize_tax_amount>0</prize_tax_amount></prize><prize><prize_level>10</prize_level><is_high_prize>0</is_high_prize><prize_num>0</prize_num><prize_amount>1200000</prize_amount><prize_after_tax_amount>1200000</prize_after_tax_amount><prize_tax_amount>0</prize_tax_amount></prize><prize><prize_level>11</prize_level><is_high_prize>0</is_high_prize><prize_num>0</prize_num><prize_amount>200000</prize_amount><prize_after_tax_amount>200000</prize_after_tax_amount><prize_tax_amount>0</prize_tax_amount></prize><prize><prize_level>12</prize_level><is_high_prize>0</is_high_prize><prize_num>0</prize_num><prize_amount>40000</prize_amount><prize_after_tax_amount>40000</prize_after_tax_amount><prize_tax_amount>0</prize_tax_amount></prize><prize><prize_level>13</prize_level><is_high_prize>0</is_high_prize><prize_num>0</prize_num><prize_amount>8000</prize_amount><prize_after_tax_amount>8000</prize_after_tax_amount><prize_tax_amount>0</prize_tax_amount></prize><prize><prize_level>14</prize_level><is_high_prize>0</is_high_prize><prize_num>0</prize_num><prize_amount>4000</prize_amount><prize_after_tax_amount>4000</prize_after_tax_amount><prize_tax_amount>0</prize_tax_amount></prize></prizes><high_prizes><high_prize><prize_level>1</prize_level><locations><location><agency_code>1010001</agency_code><count>1</count></location></locations></high_prize><high_prize><prize_level>2</prize_level><locations><location><agency_code>1010001</agency_code><count>2</count></location></locations></high_prize></high_prizes></game_draw>";
		
		GameDrawXml gameDrawXml = new GameDrawXml();
		readXml(xml, gameDrawXml);
		System.out.println(gameDrawXml);
	}*/
	
	
	// 读取中奖信息的xml
	public void readXml(String text, GameDrawXml gameDrawXml) {
		try {
			if (text == null || gameDrawXml == null) {
				return;
			}

			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder db = factory.newDocumentBuilder();
			Document doc = db.parse(new InputSource(new StringReader(text)));
			Element elmtInfo = doc.getDocumentElement();
			NodeList nodes = elmtInfo.getChildNodes();

			for (int i = 0; i < nodes.getLength(); i++) {

				Node subNode_1 = nodes.item(i);
				if ("draw_result".equals(subNode_1.getNodeName())) {
					gameDrawXml.setDraw_result(subNode_1.getTextContent());
				} else if ("sale_total_amount".equals(subNode_1.getNodeName())) {
					gameDrawXml.setSale_total_amount(subNode_1.getTextContent());
				} else if ("pool_left_amount".equals(subNode_1.getNodeName())) {
					gameDrawXml.setPool_left_amount(subNode_1.getTextContent());
				} else if ("prizes".equals(subNode_1.getNodeName())) {

					List<Prize> prizes = new ArrayList<Prize>();
					for (int j = 0; j < subNode_1.getChildNodes().getLength(); j++) {
						Node subNode_2 = subNode_1.getChildNodes().item(j);

						if ("prize".equals(subNode_2.getNodeName())) {
							Prize prize = new Prize();

							for (int n = 0; n < subNode_2.getChildNodes().getLength(); n++) {
								Node subNode_3 = subNode_2.getChildNodes().item(n);
								if ("prize_level".equals(subNode_3.getNodeName())) {
									prize.setPrize_level(subNode_3.getTextContent());
								} else if ("prize_num".equals(subNode_3.getNodeName())) {
									prize.setPrize_num(subNode_3.getTextContent());
								} else if ("prize_amount".equals(subNode_3.getNodeName())) {
									prize.setPrize_amount(subNode_3.getTextContent());
								} else if ("prize_after_tax_amount".equals(subNode_3.getNodeName())) {
									prize.setPrize_after_tax_amount(subNode_3.getTextContent());
								} else if ("prize_tax_amount".equals(subNode_3.getNodeName())) {
									prize.setPrize_tax_amount(subNode_3.getTextContent());
								}
							}

							prizes.add(prize);
						}
					}

					gameDrawXml.setPrizes(prizes);
				}

			}

		} catch (Exception e) {
			e.printStackTrace();
		}

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
				drawNotice.setOverDual(elmtInfo.getAttribute("overDual"));

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

	public static AreaSaleXml getAreaSale(File xmlFile) {

		try {
			if (xmlFile != null) {

				AreaSaleXml areaSaleXml = new AreaSaleXml();

				DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
				DocumentBuilder db = factory.newDocumentBuilder();
				Document doc = db.parse(xmlFile);
				Element elmtInfo = doc.getDocumentElement();

				NodeList nodes = elmtInfo.getChildNodes();

				for (int i = 0; i < nodes.getLength(); i++) {

					Node node = nodes.item(i);
					if ("state".equals(node.getNodeName())) {

						NodeList subNodes = node.getChildNodes();
						for (int j = 0; j < subNodes.getLength(); j++) {
							Node subNode = subNodes.item(j);

							if ("s_amount_r".equals(subNode.getNodeName())) {
								areaSaleXml.setS_amount_r(subNode.getTextContent());
							} else if ("s_amount".equals(subNode.getNodeName())) {
								areaSaleXml.setS_amount(subNode.getTextContent());
							}
						}
					} else if ("area_all".equals(node.getNodeName())) {
						List<AreaSaleXml.AreaSale> areaAll = new ArrayList<AreaSaleXml.AreaSale>();

						NodeList subNodes = node.getChildNodes();
						for (int j = 0; j < subNodes.getLength(); j++) {
							Node subNode = subNodes.item(j);
							if ("area".equals(subNode.getNodeName())) {

								AreaSaleXml.AreaSale areaSale = areaSaleXml.new AreaSale();

								NodeList subNodes2 = subNode.getChildNodes();
								for (int n = 0; n < subNodes2.getLength(); n++) {
									if ("code".equals(subNodes2.item(n).getNodeName())) {
										areaSale.setCode(subNodes2.item(n).getTextContent());
									} else if ("s_amount_r".equals(subNodes2.item(n).getNodeName())) {
										areaSale.setS_amount_r(subNodes2.item(n).getTextContent());
									} else if ("s_amount".equals(subNodes2.item(n).getNodeName())) {
										areaSale.setS_amount(subNodes2.item(n).getTextContent());
									}
								}
								areaAll.add(areaSale);
							}
						}

						areaSaleXml.setArea_all(areaAll);
					}

				}
				return areaSaleXml;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	@RequestMapping(params = "method=printDrawNotice2")
	public String printDrawNotice2(HttpServletRequest request, ModelMap model, GameDrawForm gameDrawForm, Short gameCode, Long issueNumber) {
		try {
			GameDrawInfo gameDrawInfo = new GameDrawInfo();
			gameDrawInfo.setGameCode(gameCode);
			gameDrawInfo.setIssueNumber(issueNumber);
			gameDrawInfo = gameDrawService.getCurrentGameIssue(gameDrawInfo);

			DrawNoticeXml drawNotice = getDrawNotice(gameDrawInfo.getWinnerBrodcast());

			model.addAttribute("gameDrawInfo", gameDrawInfo);
			model.addAttribute("drawNotice", drawNotice);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return LocaleUtil.getUserLocalePath("oms/game-draw/printDrawNotice", request);
	}

	private long toLong(String str) {
		long result = 0;
		if (str == null) {
			result = 0;
		} else {
			result = Long.parseLong(str);
		}
		return result;
	}

	private short toShort(String str) {
		Short result = 0;
		if (str == null) {
			result = 0;
		} else {
			result = Short.parseShort(str);
		}
		return result;
	}

	// 处理奖级排序和名称显示
	private void dealPrizeOrderAndName(List<PrizeLevel> plist, GameDrawXml gdxml) {
		if (plist == null || plist.isEmpty() || gdxml == null || gdxml.getPrizes() == null || gdxml.getPrizes().isEmpty())
			return;

		List<Prize> newPrizes = new ArrayList<Prize>();

		for (PrizeLevel item : plist) {

			Prize p = new Prize();
			p.setPrize_level(item.getLevel());
			p.setPrize_name(item.getName());

			// 从已有奖级中获取相关信息
			Prize po = getPrizeByLevel(gdxml.getPrizes(), item.getLevel());
			if (po == null) {
				p.setPrize_after_tax_amount("0");
				p.setPrize_amount("0");
				p.setPrize_num("0");
				p.setPrize_tax_amount("0");

			} else {
				p.setPrize_after_tax_amount(po.getPrize_after_tax_amount());
				p.setPrize_amount(po.getPrize_amount());
				p.setPrize_num(po.getPrize_num());
				p.setPrize_tax_amount(po.getPrize_tax_amount());
			}

			newPrizes.add(p);
		}

		gdxml.setPrizes(null);
		gdxml.setPrizes(newPrizes);

	}

	// 根据级别获取奖级信息
	private Prize getPrizeByLevel(List<Prize> prizes, String level) {
		if (prizes == null || prizes.isEmpty())
			return null;

		Prize pretrun = null;
		for (Prize p : prizes) {
			if (p.getPrize_level().equals(level)) {
				pretrun = p;
				break;
			}
		}
		return pretrun;
	}
}