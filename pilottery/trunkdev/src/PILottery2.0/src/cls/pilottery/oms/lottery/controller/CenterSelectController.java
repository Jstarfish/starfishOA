package cls.pilottery.oms.lottery.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

import cls.pilottery.common.EnumConfigEN;
import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.HttpClientUtils;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PropertiesUtil;
import cls.pilottery.oms.common.entity.BaseMessageReq;
import cls.pilottery.oms.common.entity.MessageLog;
import cls.pilottery.oms.common.msg.CenterSelectReq4001;
import cls.pilottery.oms.common.msg.CenterSelectRes4001;
import cls.pilottery.oms.common.msg.LotteryReq4003;
import cls.pilottery.oms.common.msg.LotteryRes4003;
import cls.pilottery.oms.common.service.LogService;
import cls.pilottery.oms.common.utils.ResustConstant;
import cls.pilottery.oms.lottery.form.ExpirydateForm;
import cls.pilottery.oms.lottery.model.Betinfo;
import cls.pilottery.oms.lottery.model.CenterSelectResModel;
import cls.pilottery.oms.lottery.model.GamePrize;
import cls.pilottery.oms.lottery.model.LotterPrize;
import cls.pilottery.oms.lottery.model.LotteryResModel;
import cls.pilottery.oms.lottery.model.SaleGamepayinfo;
import cls.pilottery.oms.lottery.service.ExpirydateService;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.system.model.UserLanguage;

@Controller
@RequestMapping("/centerSelect")
public class CenterSelectController {
	private Logger logger = Logger.getLogger(CenterSelectController.class);
	@Autowired
	private LogService logService;
	@Autowired
	private ExpirydateService expirydateService;

	/** 中心查询 */
	@RequestMapping(params = "method=centerSelect")
	public String gameDraw(HttpServletRequest request, ModelMap model) {
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		UserLanguage lg = user.getUserLang();
		String message = "";
		try {
			if (request.getSession().getAttribute("centerSelectReq") != null) {
				request.getSession().removeAttribute("centerSelectReq");
			}
			String tsn = request.getParameter("tsnSend");
			BaseMessageReq breq = new BaseMessageReq(4001, 2);
			CenterSelectReq4001 req = new CenterSelectReq4001();
			req.setRspfn_ticket(tsn);
			breq.setParams(req);
			long seq = this.logService.getNextSeq();
			breq.setMsn(seq);
			String json = JSONObject.toJSONString(breq);
			MessageLog msglog = new MessageLog(seq, json);

			if (!StringUtils.isBlank(tsn)) {
				tsn = tsn.trim();
				String reg = "^[a-zA-Z0-9]{24}|[0-9]{16}$";
				if (!Pattern.matches(reg, tsn)) {
					if (lg == UserLanguage.ZH) {
						message = "请输入正确tsn";

					} else if (lg == UserLanguage.EN) {
						message = "Please enter the correct TSN";

					}
					model.addAttribute("reservedSuccessMsg", message);
					return LocaleUtil.getUserLocalePath("oms/ticket/chooseGame", request);

				}
				model.addAttribute("tsn", tsn);
				this.logService.insertLog(msglog);
				logger.debug("向主机发送请求，请求内容：" + json);
				String resJson = HttpClientUtils.postString(PropertiesUtil.readValue("url_host"), json);
				logger.debug("接收到主机的响应，消息内容：" + resJson);
				CenterSelectRes4001 res = JSON.parseObject(resJson, CenterSelectRes4001.class);

				int status = res.getRc();
				logger.info("select ticket return status=" + status + ",Is tsn err=" + status);
				if (status == ResustConstant.OMS_RESULT_TICKET_TSN_ERR || status == ResustConstant.OMS_RESULT_FAILURE || status == ResustConstant.OMS_RESULT_TICKET_NOT_FOUND_ERR || status == ResustConstant.OMS_RESULT_BUSY_ERR || status == ResustConstant.OMS_TICK_CURRENTERR) {

					String resMessage = this.getMessage(request, status);
					logger.debug("中心兑奖查询返回消息" + resMessage);

					model.addAttribute("reservedSuccessMsg", resMessage);
					return LocaleUtil.getUserLocalePath("oms/ticket/chooseGame", request);

				} else {
					CenterSelectResModel resm = res.getResult();
					SaleGamepayinfo info = null;
					if (tsn != null && !"".equals(tsn)) {
						info = this.expirydateService.getSalegameByTsn(tsn);
					}
					if (info != null) {
						String xvalue = String.valueOf(info.getCertType());
						resm.setCardType(Integer.parseInt(StringUtils.isNotEmpty(xvalue) ? xvalue : "0"));
						resm.setCardCode(info.getCertNo());
						resm.setCustomName(info.getWinnerName());
					}
					if (resm.getPrizes() != null) {
						for (GamePrize prize : resm.getPrizes()) {
							Map<String, Object> map = new HashMap<String, Object>();
							try {
								map.put("gameCode", resm.getGameCode());
								map.put("prizecode", prize.getPrizeCode());
								String name = this.expirydateService.getPrizeName(map);
								prize.setPrizeName(name);
							} catch (Exception e) {
								e.printStackTrace();
							}

						}
					}
					request.getSession().setAttribute("centerSelectReq", resm);
					model.addAttribute("status", status);
					model.addAttribute("centerSelectReq", resm);
				}

			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return LocaleUtil.getUserLocalePath("oms/ticket/chooseGame", request);
	}

	private String getMessage(HttpServletRequest request, int status) {

		Map<Integer, String> awardingState = EnumConfigEN.awardingState;
		if (request != null)
			awardingState = LocaleUtil.getUserLocaleEnum("awardingState", request);
		String message = awardingState.get(status);
		return message;
	}

	/**
	 * 初始化中奖查询
	 * 
	 * @param request
	 * @param model
	 * @param expirydateForm
	 * @return
	 */
	@RequestMapping(params = "method=expirydateint")
	public String expirydateint(HttpServletRequest request, ModelMap model, ExpirydateForm expirydateForm) {

		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		expirydateForm.setPayagencycode(user.getInstitutionCode());
		model.addAttribute("expirydateForm", expirydateForm);
		return LocaleUtil.getUserLocalePath("oms/ticket/expirydateint", request);

	}

	/**
	 * 填写中奖人信息
	 * 
	 * @param request
	 * @param model
	 * @param expirydateForm
	 * @return
	 */
	@RequestMapping(params = "method=insertexpiryInfo")
	public String insertexpiryInfo(HttpServletRequest request, ModelMap model, ExpirydateForm expirydateForm) {
		model.addAttribute("expirydateForm", expirydateForm);
		String tsnquery = request.getParameter("tsnquery");
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		UserLanguage lg = user.getUserLang();
		String message = "";

		BaseMessageReq breq = new BaseMessageReq(4001, 2);
		CenterSelectReq4001 req = new CenterSelectReq4001();
		req.setRspfn_ticket(tsnquery);
		breq.setParams(req);
		long seq = this.logService.getNextSeq();
		breq.setMsn(seq);
		String json = JSONObject.toJSONString(breq);
		MessageLog msglog = new MessageLog(seq, json);
		this.logService.insertLog(msglog);

		logger.debug("向主机发送请求，请求内容：" + json);
		String resJson = HttpClientUtils.postString(PropertiesUtil.readValue("url_host"), json);
		logger.debug("接收到主机的响应，消息内容：" + resJson);

		CenterSelectRes4001 res = JSON.parseObject(resJson, CenterSelectRes4001.class);
		int status = res.getRc();
		CenterSelectResModel resm = new CenterSelectResModel();
		if (res.getRc() == 0) {
			resm = res.getResult();
		}
		model.addAttribute("status", status);
		model.addAttribute("isWin", resm.getIsWin());
		model.addAttribute("isPayed", resm.getIsPayed());
		if (status == 0 && resm.getIsWin() == 2 && resm.getIsPayed() == 0) {
			return LocaleUtil.getUserLocalePath("oms/ticket/insertexpiryInfo", request);

		} else if (status == 0 && resm.getIsWin() == 0) {

			if (lg == UserLanguage.ZH) {
				message = "未开奖";

			} else if (lg == UserLanguage.EN) {
				message = "Lottery drawing has not started.";

			}

			model.addAttribute("reservedSuccessMsg", message);
			return LocaleUtil.getUserLocalePath("oms/ticket/insertexpiryInfo", request);
		} else if (status == 0 && resm.getIsWin() == 1) {
			if (lg == UserLanguage.ZH) {
				message = "彩票未中奖!";

			} else if (lg == UserLanguage.EN) {
				message = " The ticket does not win!";

			}

			model.addAttribute("reservedSuccessMsg", message);
			return LocaleUtil.getUserLocalePath("oms/ticket/insertexpiryInfo", request);
		} else if (status == 0 && resm.getIsWin() == 2 && resm.getIsPayed() == 1) {

			if (lg == UserLanguage.ZH) {
				message = "彩票已兑奖!";

			} else if (lg == UserLanguage.EN) {
				message = " The ticket has already been paid!";

			}
			model.addAttribute("reservedSuccessMsg", message);
			return LocaleUtil.getUserLocalePath("oms/ticket/insertexpiryInfo", request);
		} else {
			message = this.getMessage(request, status);
			model.addAttribute("reservedSuccessMsg", message);
			return LocaleUtil.getUserLocalePath("oms/ticket/insertexpiryInfo", request);
		}

	}

	/**
	 * 保存中奖查询信息
	 */
	@RequestMapping(params = "method=saveexpiryInfo")
	public String saveexpiryInfo(HttpServletRequest request, ModelMap model, ExpirydateForm expirydateForm) {
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);

		String message = "";
		Long operUserId = user.getId();
		String realname = user.getRealName();
		try {
			String resultHtml = "";
			String jsonPrize = "";
			String htmlText = "";
			BaseMessageReq breq = new BaseMessageReq(4003, 2);
			LotteryReq4003 req = new LotteryReq4003();
			/* LotteryReq req = new LotteryReq(); */
			int status;
			long winningamount;
			String guipayFlow = this.expirydateService.getTicketpay(Long.parseLong(expirydateForm.getPayagencycode()));
			String reqfnticketpay = guipayFlow;
			req.setRspfn_ticket(expirydateForm.getTsnquery());
			req.setReqfn_ticket_pay(reqfnticketpay);

			expirydateForm.setReqfnticketpay(reqfnticketpay);
			expirydateForm.setGuipayFlow(guipayFlow);
			req.setAreaCode_pay(user.getInstitutionCode());
			breq.setParams(req);
			long seq = this.logService.getNextSeq();
			breq.setMsn(seq);
			String json = JSONObject.toJSONString(breq);
			MessageLog msglog = new MessageLog(seq, json);
			this.logService.insertLog(msglog);
			logger.debug("向主机发送请求，请求内容：" + json);
			String resJson = HttpClientUtils.postString(PropertiesUtil.readValue("url_host"), json);
			logger.debug("接收到主机的响应，消息内容：" + resJson);
			LotteryRes4003 res = JSON.parseObject(resJson, LotteryRes4003.class);
			status = res.getRc();
			logger.debug("中心兑奖查询!");
			logger.debug("操作者[" + operUserId + " tsn:" + expirydateForm.getTsnquery() + "]");
			if (status == ResustConstant.OMS_RESULT_SUCCESS) {
				LotteryResModel resm = new LotteryResModel();
				resm = res.getResult();
				winningamount = resm.getWinningAmountWithTax();
				expirydateForm.setGameCode(new Long(resm.getGamecode()));
				expirydateForm.setIssuenumber(resm.getStartIssueNumber());
				expirydateForm.setPayAmount(resm.getWinningAmountWithTax());
				expirydateForm.setPayTax(resm.getTaxAmount());
				expirydateForm.setPayamountAftertax(resm.getWinningAmount());
				expirydateForm.setReqfnticket(resm.getReqfn_ticket());
				expirydateForm.setTsn(resm.getRspfn_ticket_pay());
				expirydateForm.setIssuenumbrend(resm.getEndIssueNumber());
				expirydateForm.setRealname(realname);
				expirydateForm.setPayerAdmin(user.getId());
				model.addAttribute("status", status);
				model.addAttribute("winningamount", winningamount);
				if (resm.getBetlist() != null) {
					for (int i = 0; i < resm.getBetlist().size(); i++) {
						Betinfo info = resm.getBetlist().get(i);
						resultHtml += info.getBettingnumber() + "@";
					}
					resultHtml = resultHtml.substring(0, resultHtml.length() - 1);
				}
				if (resm.getPrizeDetail() != null) {
					for (LotterPrize prize : resm.getPrizeDetail()) {
						Map<String, Object> map = new HashMap<String, Object>();
						try {
							map.put("gameCode", resm.getGamecode());
							map.put("prizecode", prize.getPrizeCode());
							String name = this.expirydateService.getPrizeName(map);
							prize.setName(name);
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
				}
				if (resm.getPrizeDetail() != null)
					jsonPrize = JSONArray.toJSON(resm.getPrizeDetail().toArray()).toString();
				if (resultHtml != "" && jsonPrize != "") {
					htmlText = resultHtml + "*" + jsonPrize;
				}
				expirydateForm.setHtmlText(htmlText);
				if (status == 0 && winningamount > 0) {
					this.expirydateService.insertSalegame(expirydateForm);

					JSONArray.toJSONString(expirydateForm);

					logger.debug("中心兑奖!");
					logger.debug("操作者[" + operUserId + " tsn:" + expirydateForm.getTsnquery() + "func:insertSalegame]");

					SaleGamepayinfo info = this.expirydateService.getSalegameByTsn(expirydateForm.getTsnquery());
					model.addAttribute("lotteryReq", resm);
					model.addAttribute("info", info);
					return LocaleUtil.getUserLocalePath("oms/ticket/expiryInfo", request);

				} else {
					return LocaleUtil.getUserLocalePath("oms/ticket/expiryInfo", request);
				}
			} else {
				message = this.getMessage(request, status);

				model.addAttribute("reservedSuccessMsg", message);
				return LocaleUtil.getUserLocalePath("oms/ticket/insertexpiryInfo", request);

			}
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("reservedSuccessMsg", "Error");
			return LocaleUtil.getUserLocalePath("oms/ticket/expirydateint", request);

		}
	}

	@RequestMapping(params = "method=inintPrint")
	public String inintPrint(HttpServletRequest request, ModelMap model) {
		CenterSelectResModel req = new CenterSelectResModel();

		req = (CenterSelectResModel) request.getSession().getAttribute("centerSelectReq");
		if (req != null) {
			String tsn = req.getRspfn_ticket();
			model.addAttribute("centerSelectReq", req);
			model.addAttribute("tsn", tsn);
		}

		return LocaleUtil.getUserLocalePath("oms/ticket/chooseGamePrint", request);

	}

	@RequestMapping(params = "method=printinit")
	public String printinit(HttpServletRequest request, ModelMap model, ExpirydateForm expirydateForm) {

		model.addAttribute("expirydateForm", expirydateForm);
		return LocaleUtil.getUserLocalePath("oms/ticket/expiryInfosucess", request);

	}

	@RequestMapping(params = "method=printInfo")
	public String printInfo(HttpServletRequest request, ModelMap model, ExpirydateForm expirydateForm) {
		String id = request.getParameter("carId");
		SaleGamepayinfo info = this.expirydateService.getSalegameById(id);
		if (info != null) {
			expirydateForm.setGameName(info.getPlayName());
			expirydateForm.setIssuenumber(info.getIssueNumber());
			expirydateForm.setPayAmount(info.getPayAmount());
			expirydateForm.setPayTax(info.getPayTax());
			expirydateForm.setPayamountAftertax(info.getPayamountAftertax());
			expirydateForm.setName(info.getWinnerName());
			expirydateForm.setCarId(info.getCertNo());
			expirydateForm.setTsnquery(info.getSaleTsn());
			expirydateForm.setPlayname(info.getPlayname());
			expirydateForm.setIssuenumbrend(info.getIssuenumbrend());
			LotteryResModel req = new LotteryResModel();

			req.setRespayagencycode(new Long(info.getAgencyCode()));
			expirydateForm.setAgencyCodeFormart(info.getAgencyCode());
			String htmlTxt = info.getHtmlText();
			if (htmlTxt != null) {
				String arr[] = htmlTxt.split("\\*");
				List<Betinfo> betList = new ArrayList<Betinfo>();
				if (arr.length > 0) {
					String pet[] = arr[0].split("@");
					if (pet.length > 0) {
						for (int i = 0; i < pet.length; i++) {
							Betinfo bet = new Betinfo();
							bet.setBettingnumber(pet[i]);
							betList.add(bet);
						}
					}
					req.setBetlist(betList);
					List<LotterPrize> prizes = JSON.parseArray(arr[1], LotterPrize.class);
					req.setPrizeDetail(prizes);
				}
				Long sum = 0L;
				if (req.getPrizeDetail() != null && req.getPrizeDetail().size() > 0) {
					for (int i = 0; i < req.getPrizeDetail().size(); i++) {
						sum += req.getPrizeDetail().get(i).getAmountAfterTax();
					}
				}
				model.addAttribute("sumprize", sum);
				model.addAttribute("lotteryReq", req);
			}
			model.addAttribute("currdate", new java.text.SimpleDateFormat("yyyy-MM-dd").format(info.getPayTime()));
			model.addAttribute("id", info.getId());

		}
		model.addAttribute("expirydateForm", expirydateForm);
		return LocaleUtil.getUserLocalePath("oms/ticket/gmInfoprint", request);

	}

	/**
	 * 打印兑奖单
	 * 
	 * @param request
	 * @param model
	 * @param expirydateForm
	 * @return
	 */
	@RequestMapping(params = "method=printExpir")
	public String printExpir(HttpServletRequest request, ModelMap model, ExpirydateForm expirydateForm) {
		String id = request.getParameter("id");
		SaleGamepayinfo info = this.expirydateService.getSalegameById(id);
		if (info != null) {
			expirydateForm.setGameName(info.getPlayName());
			expirydateForm.setIssuenumber(info.getIssueNumber());
			expirydateForm.setPayAmount(info.getPayAmount());
			expirydateForm.setPayTax(info.getPayTax());
			expirydateForm.setPayamountAftertax(info.getPayamountAftertax());
			expirydateForm.setName(info.getWinnerName());
			expirydateForm.setCarId(info.getCertNo());
			expirydateForm.setTsnquery(info.getSaleTsn());
			expirydateForm.setPlayname(info.getPlayname());
			expirydateForm.setIssuenumbrend(info.getIssuenumbrend());
			LotteryResModel req = new LotteryResModel();
			req.setRespayagencycode(new Long(info.getAgencyCode()));
			expirydateForm.setAgencyCodeFormart(info.getAgencyCode());
			String htmlTxt = info.getHtmlText();
			if (htmlTxt != null) {
				String arr[] = htmlTxt.split("\\*");
				List<Betinfo> betList = new ArrayList<Betinfo>();
				if (arr.length > 0) {
					String pet[] = arr[0].split("@");
					if (pet.length > 0) {
						for (int i = 0; i < pet.length; i++) {
							Betinfo bet = new Betinfo();
							bet.setBettingnumber(pet[i]);
							betList.add(bet);
						}
					}
					req.setBetlist(betList);
					List<LotterPrize> prizes = JSON.parseArray(arr[1], LotterPrize.class);
					req.setPrizeDetail(prizes);
				}
				Long sum = 0L;
				if (req.getPrizeDetail() != null && req.getPrizeDetail().size() > 0) {
					for (int i = 0; i < req.getPrizeDetail().size(); i++) {
						sum += req.getPrizeDetail().get(i).getAmountAfterTax();
					}
				}
				model.addAttribute("sumprize", sum);
				model.addAttribute("lotteryReq", req);
			}
			if (info.getPayTime() != null) {
				model.addAttribute("currdate", new java.text.SimpleDateFormat("yyyy-MM-dd").format(info.getPayTime()));
			}
			model.addAttribute("id", info.getId());

		}
		model.addAttribute("expirydateForm", expirydateForm);

		return LocaleUtil.getUserLocalePath("oms/ticket/gmInfoprint", request);
	}

}
