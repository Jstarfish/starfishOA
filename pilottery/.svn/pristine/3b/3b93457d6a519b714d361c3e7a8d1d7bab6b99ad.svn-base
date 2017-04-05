package cls.pilottery.fbs.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
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
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.common.utils.PropertiesUtil;
import cls.pilottery.fbs.model.FbsCenterSelectResModel;
import cls.pilottery.fbs.msg.FbsCenterSelectReq12001;
import cls.pilottery.fbs.msg.FbsCenterSelectRes12001;
import cls.pilottery.oms.common.entity.BaseMessageReq;
import cls.pilottery.oms.common.entity.MessageLog;
import cls.pilottery.oms.common.msg.LotteryReq4003;
import cls.pilottery.oms.common.msg.LotteryRes4003;
import cls.pilottery.oms.common.service.LogService;
import cls.pilottery.oms.common.utils.ResustConstant;
import cls.pilottery.oms.lottery.form.ExpirydateForm;
import cls.pilottery.oms.lottery.form.SaleGamepayinfoForm;
import cls.pilottery.oms.lottery.model.Betinfo;
import cls.pilottery.oms.lottery.model.LotterPrize;
import cls.pilottery.oms.lottery.model.LotteryResModel;
import cls.pilottery.oms.lottery.model.SaleGamepayinfo;
import cls.pilottery.oms.lottery.service.ExpirydateService;
import cls.pilottery.oms.lottery.vo.SaleGamepayinfoVo;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.system.model.UserLanguage;
import jxl.common.Logger;

@Controller
@RequestMapping("/fbsPayout")
public class FbsPayoutController {
	
	private Logger logger = Logger.getLogger(FbsPayoutController.class);
	@Autowired
	private LogService logService;
	@Autowired
	private ExpirydateService expirydateService;
	/**
	 * FBS中心查询
	 */
	@RequestMapping(params = "method=initTicketInquiry")
	public String initTicketInquiry(HttpServletRequest request,ModelMap model){
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		UserLanguage lg = user.getUserLang();
		String message = "";
		try {
			if(request.getSession().getAttribute("fbsCenterSelectReq") != null){
				request.getSession().removeAttribute("fbsCenterSelectReq");
			}
			String tsn = request.getParameter("tsnSend");
			BaseMessageReq breq = new BaseMessageReq(12001,2);
			FbsCenterSelectReq12001 req = new FbsCenterSelectReq12001();
			req.setRspfn_ticket(tsn);
			breq.setParams(req);
			long seq = this.logService.getNextSeq();
			breq.setMsn(seq);
			String json = JSONObject.toJSONString(breq);
			MessageLog msglog = new MessageLog(seq,json);
			if(!StringUtils.isBlank(tsn)){
				tsn = tsn.trim();
				String reg = "^[a-zA-Z0-9]{24}|[0-9]{16}$";
				if(!Pattern.matches(reg, tsn)){
					if(lg == UserLanguage.ZH){
						message = "请输入正确的tsn";
					}else if(lg == UserLanguage.EN){
						message = "Please enter the correct TSN";
					}
					model.addAttribute("reservedSuccessMsg", message);
					return LocaleUtil.getUserLocalePath("oms/fbs/fbslottery/fbsTicketInquiry", request);
				}
				model.addAttribute("tsn", tsn);
				this.logService.insertLog(msglog);
				logger.debug("向主机发送请求，请求内容:"+ json);
				String resJson = HttpClientUtils.postString(PropertiesUtil.readValue("url_host"), json);
				logger.debug("接收到主机的响应，消息内容："+ resJson);
				FbsCenterSelectRes12001 res = JSON.parseObject(resJson,FbsCenterSelectRes12001.class);
				
				int status = res.getRc();
				logger.info("select ticket return status=" + status + ",Is tsn err=" + status);
				if(status == ResustConstant.OMS_RESULT_TICKET_TSN_ERR || status == ResustConstant.OMS_RESULT_FAILURE || status == ResustConstant.OMS_RESULT_TICKET_NOT_FOUND_ERR || status == ResustConstant.OMS_RESULT_BUSY_ERR || status == ResustConstant.OMS_TICK_CURRENTERR) {
					
					String resMessage = this.getMessage(request,status);
					logger.debug("fbs中心查询返回消息" + resMessage);
					return LocaleUtil.getUserLocalePath("oms/fbs/fbslottery/fbsTicketInquiry", request);
				}else{
					FbsCenterSelectResModel resm = res.getResult();
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
				request.getSession().setAttribute("fbsCenterSe lectReq", resm);
				model.addAttribute("status", status);
				model.addAttribute("fbsCenterSelectReq", resm);
				
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return LocaleUtil.getUserLocalePath("oms/fbs/fbslottery/fbsTicketInquiry", request);
	}
	
	private String getMessage(HttpServletRequest request, int status) {
		Map<Integer, String> awardingState = EnumConfigEN.awardingState;
		if (request != null)
			awardingState = LocaleUtil.getUserLocaleEnum("awardingState", request);
		String message = awardingState.get(status);
		return message;
	}

	/**
	 * 初始化FBS中心兑奖
	 * @param request
	 * @param model
	 * @param expirydateForm
	 * @return
	 */
	@RequestMapping(params = "method=initTicketPayout")
	public String initTicketPayout(HttpServletRequest request, ModelMap model, ExpirydateForm expirydateForm) {
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		expirydateForm.setPayagencycode(user.getInstitutionCode());
		model.addAttribute("expirydateForm", expirydateForm);
		return LocaleUtil.getUserLocalePath("oms/fbs/fbslottery/cashPrizeInit", request);
	}
	
	/**
	 * @description:FBS中心兑奖第二步：填写中奖人信息
	 * @exception:
	 * @author: star
	 * @time:2016年7月27日 下午1:53:21
	 */
	@RequestMapping(params = "method=insertWinnerInfo")
	public String insertWinnerInfo(HttpServletRequest request,HttpSession session,ModelMap model,ExpirydateForm expirydateForm){
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		UserLanguage lg = user.getUserLang();
		String message = "";
			String tsnquery = request.getParameter("tsnquery");
			BaseMessageReq breq = new BaseMessageReq(12001,2);
			FbsCenterSelectReq12001 req = new FbsCenterSelectReq12001();
			req.setRspfn_ticket(tsnquery);
			breq.setParams(req);
			long seq = this.logService.getNextSeq();
			breq.setMsn(seq);
			String json = JSONObject.toJSONString(breq);
			MessageLog msglog = new MessageLog(seq,json);
			this.logService.insertLog(msglog);
			logger.debug("向主机发送请求，请求内容：" + json);
			String resJson = HttpClientUtils.postString(PropertiesUtil.readValue("url_host"), json);
			logger.debug("接收到主机的响应，消息内容："+ resJson);
			
			FbsCenterSelectRes12001 res = JSON.parseObject(resJson, FbsCenterSelectRes12001.class);
			int status = res.getRc();
			FbsCenterSelectResModel resm = new FbsCenterSelectResModel();
			if(res.getRc() == 0){
				resm = res.getResult();
			}else{
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			}
			model.addAttribute("status", status);
			model.addAttribute("isWin", resm.getIsWin());
			model.addAttribute("isPayed", resm.getIsPayed());
			if(status == 0 && resm.getIsWin() ==2 && resm.getIsPayed() == 0){
				return LocaleUtil.getUserLocalePath("oms/fbs/fbslottery/insertWinnerInfo", request);
			}else if (status == 0 && resm.getIsWin() == 0) {
				if(resm.getIsCancel() ==1){
					if(lg == UserLanguage.ZH){
						message = "已退票";
					}else if (lg == UserLanguage.EN) {
						message = "The ticket has been canceled.";}
					}else{
						if(lg == UserLanguage.ZH){
							message = "未开奖";
						}else if(lg == UserLanguage.EN){
							message = "Lottery drawing has not started.";
						}
					}
					model.addAttribute("reservedSuccessMsg", message);
					return LocaleUtil.getUserLocalePath("oms/fbs/fbslottery/insertWinnerInfo", request);
				}else if(status == 0 && resm.getIsWin() ==1){
					if(lg == UserLanguage.ZH){
						message = "彩票未中奖！";
					}else if(lg == UserLanguage.EN){
						message = "The ticket does not win!";
					}
					model.addAttribute("reservedSuccessMsg", message);
					return LocaleUtil.getUserLocalePath("oms/fbs/fbslottery/insertWinnerInfo", request);
				}else if(status == 0 && resm.getIsWin() == 2 && resm.getIsPayed() ==1){
					if(lg == UserLanguage.ZH){
						message ="彩票已兑奖！";
					}else if (lg == UserLanguage.EN) {
						message = "The ticket has already been paid!";
					}
					model.addAttribute("reservedSuccessMsg", message);
					return LocaleUtil.getUserLocalePath("oms/fbs/fbslottery/insertWinnerInfo", request);
				}else{
					message = this.getMessage(request, status);
					model.addAttribute("reservedSuccessMsg", message);
					return LocaleUtil.getUserLocalePath("oms/fbs/fbslottery/insertWinnerInfo", request);
				}
	}
	
	/**
	 * 
	 * @description:保存中奖信息
	 * @exception:
	 * @time:2016年7月27日 下午3:03:53
	 */
	@RequestMapping(params = "method=saveWinnerInfo")
	public String saveWinnerInfo(HttpServletRequest request, ModelMap model, ExpirydateForm expirydateForm) {
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);

		String message = "";
		Long operUserId = user.getId();
		String realname = user.getRealName();
		try {
			String resultHtml = "";
			String jsonPrize = "";
			String htmlText = "";
			BaseMessageReq breq = new BaseMessageReq(12003, 2);
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
	
	
	
	
	
	
	
	/**
	 * @description:FBS兑奖记录查询
	 * @author: star
	 * @time:2016年7月27日 下午3:28:38
	 */
	@RequestMapping(params = "method=listPayoutRecord")
	public String payoutRecordlist(HttpServletRequest request, ModelMap model, SaleGamepayinfoForm salegamepayinfoForm) {
		User user = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		salegamepayinfoForm.setAreaCode(user.getInstitutionCode());

		Integer count = this.expirydateService.getSaleGamepaycount(salegamepayinfoForm);
		List<SaleGamepayinfoVo> salegamepayinfolist = new ArrayList<SaleGamepayinfoVo>();
		int pageIndex = PageUtil.getPageIndex(request);
		if (count != null && count.intValue() != 0) {
			salegamepayinfoForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			salegamepayinfoForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			salegamepayinfolist = this.expirydateService.getSaleGameList(salegamepayinfoForm);
		}
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", salegamepayinfolist);
		model.addAttribute("salegamepayinfoForm", salegamepayinfoForm);
		if (salegamepayinfoForm.getStartpayTime() != null) {
			model.addAttribute("startpayTime", salegamepayinfoForm.getStartpayTime().substring(0, 10));
		}
		if (salegamepayinfoForm.getEndpayTime() != null) {
			model.addAttribute("endpayTime", salegamepayinfoForm.getEndpayTime().substring(0, 10));
		}
		return LocaleUtil.getUserLocalePath("oms/fbs/fbslottery/payoutRecordlist", request);
	}

}