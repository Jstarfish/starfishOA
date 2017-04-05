package cls.pilottery.oms.lottery.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import cls.pilottery.common.EnumConfigEN;
import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.DateUtil;
import cls.pilottery.common.utils.HttpClientUtils;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.common.utils.PropertiesUtil;
import cls.pilottery.oms.common.entity.BaseMessageReq;
import cls.pilottery.oms.common.entity.MessageLog;
import cls.pilottery.oms.common.msg.RefundReq4005;
import cls.pilottery.oms.common.msg.RefundRes4005;
import cls.pilottery.oms.common.msg.RefundRes4005Result;
import cls.pilottery.oms.common.service.LogService;
import cls.pilottery.oms.common.utils.ResustConstant;
import cls.pilottery.oms.lottery.form.RefundForm;
import cls.pilottery.oms.lottery.form.SaleCancelInfoForm;
import cls.pilottery.oms.lottery.service.RefundqueryService;
import cls.pilottery.oms.lottery.vo.SaleCancelInfoVo;
import cls.pilottery.web.system.model.User;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

@Controller
@RequestMapping("refundquery")
public class RefundqueryController {
	static Logger logger = Logger.getLogger(RefundqueryController.class);
	@Autowired
	RefundqueryService refundqueryService;
	@Autowired
	private LogService logService;

	/**
	 * 列表查询 数据分页处理
	 */
	@RequestMapping(params = "method=list")
	public String refundQurylist(HttpServletRequest request, ModelMap model, SaleCancelInfoForm saleCancelInfoForm) {
		// User user = UserSession.getUser(request);
		User user = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		// saleCancelInfoForm.setAreaCode(new Long(user.getAreaCode()));
		saleCancelInfoForm.setAreaCode(user.getInstitutionCode());
		Integer count = this.refundqueryService.getSaleCancelcount(saleCancelInfoForm);

		List<SaleCancelInfoVo> salecancelist = new ArrayList<SaleCancelInfoVo>();
		int pageIndex = PageUtil.getPageIndex(request);
		if (count != null && count.intValue() != 0) {
			saleCancelInfoForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			saleCancelInfoForm.setEndNum(((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize));
			salecancelist = this.refundqueryService.getSaleCancelList(saleCancelInfoForm);
		}
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", salecancelist);
		model.addAttribute("saleCancelInfoForm", saleCancelInfoForm);
		if (saleCancelInfoForm.getSatrtcancelTime() != null)
			model.addAttribute("satrtcancelTime", saleCancelInfoForm.getSatrtcancelTime());
		if (saleCancelInfoForm.getEndcancelTime() != null) {
			model.addAttribute("endcancelTime", saleCancelInfoForm.getEndcancelTime());
		}

		return LocaleUtil.getUserLocalePath("oms/expirydate/refundquerylist", request);
	}

	/**
	 * 初始化中心退票
	 * 
	 * @param request
	 * @param model
	 * @param refundForm
	 * @return
	 */
	@RequestMapping(params = "method=refundInit")
	public String refundInit(HttpServletRequest request, ModelMap model, RefundForm refundForm) {

		model.addAttribute("refundForm", refundForm);
		return LocaleUtil.getUserLocalePath("oms/expirydate/refundqueryInint", request);

	}

	/**
	 * 保存 退票信息
	 * 
	 * @param request
	 * @param model
	 * @param refundForm
	 * @return
	 */

	@RequestMapping(params = "method=refund")
	public String refund(HttpServletRequest request, ModelMap model, RefundForm refundForm) {

		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		String currdate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date());
		String currdatetime = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());

		String prId = this.refundqueryService.getRefundflow(new Long(user.getInstitutionCode()));

		Long operUserId = user.getId();
		String realname = user.getRealName();
		BaseMessageReq breq = new BaseMessageReq(4005, 2);
		RefundReq4005 req = new RefundReq4005();
		refundForm.setReqfnticketcancel(prId);
		req.setRspfn_ticket(refundForm.getReqtsn());
		req.setReqfn_ticket_cancel(prId);
		req.setAreaCode_cancel(user.getInstitutionCode());
		breq.setParams(req);
		long seq = this.logService.getNextSeq();
		breq.setMsn(seq);
		String json = JSONObject.toJSONString(breq);
		MessageLog msglog = new MessageLog(seq, json);
		this.logService.insertLog(msglog);

		logger.debug("向主机发送请求，请求内容：" + json);
		String resJson = HttpClientUtils.postString(PropertiesUtil.readValue("url_host"), json);
		logger.debug("接收到主机的响应，消息内容：" + resJson);

		RefundRes4005 res = JSON.parseObject(resJson, RefundRes4005.class);
		logger.debug("退票 --操作者[" + operUserId + " tsn:" + refundForm.getReqtsn() + "begin-refund parms:" + JSONArray.toJSONString(refundForm) + "]");
		int status = res.getRc();
		if (status == ResustConstant.OMS_RESULT_SUCCESS) {
			refundForm.setGamecode(res.getResult().getGameCode());
			if (res.getResult().getRspfn_ticket() != null)
				refundForm.setTsn(res.getResult().getRspfn_ticket());
			refundForm.setSaleagencycode(res.getResult().getSaleAgencyCode());

			refundForm.setCancelAgencyCodeFormat(res.getResult().getSaleAgencyCode());
			refundForm.setRescancelagencycode(res.getResult().getAreaCode_cancel());
			refundForm.setIssuenumber(res.getResult().getStartIssueNumber());
			refundForm.setCancelamount(res.getResult().getCancelAmount());
			refundForm.setSaletime(res.getResult().getSaleDate());
			if (res.getResult().getSaleDate() != null) {
				refundForm.setHtmltext(DateUtil.formatDate(res.getResult().getSaleDate()));
			}
			refundForm.setCanceler(realname);
			refundForm.setCancelerAdmin(user.getId());
			refundForm.setPid(prId);
			refundForm.setReqfnticket(res.getResult().getRspfn_ticket());
			refundForm.setCancelamount(res.getResult().getCancelAmount());
			refundForm.setDatetime(new Date());
			refundForm.setCancelCommision(res.getResult().getCommissionCommision());
			refundForm.setGameName(this.refundqueryService.getGameName(new Long(res.getResult().getGameCode())));
			logger.debug(refundForm);
			this.refundqueryService.saveRefund(refundForm);

			logger.debug("退票 --操作者[" + operUserId + " tsn:" + refundForm.getReqtsn() + "end-refund parms:" + JSONArray.toJSONString(refundForm) + "]");
			logger.debug("退票 --操作者[" + operUserId + " tsn:" + refundForm.getReqtsn() + "msg parms:" + JSONArray.toJSONString(res) + "]");
		} else {
			String message = this.getMessage(request, status);

			model.addAttribute("reservedSuccessMsg", message);
			return LocaleUtil.getUserLocalePath("oms/expirydate/refuninfo", request);
		}
		model.addAttribute("currdate", currdate);
		model.addAttribute("currdatetime", currdatetime);
		model.addAttribute("refundForm", refundForm);
		model.addAttribute("refundReq", req);
		model.addAttribute("status", status);

		return LocaleUtil.getUserLocalePath("oms/expirydate/refuninfo", request);
	}

	/**
	 * 打印退票凭证
	 * 
	 * @param request
	 * @param model
	 * @param refundForm
	 * @return
	 */

	@RequestMapping(params = "method=cancelInfoPrint")
	public String cancelInfoPrint(HttpServletRequest request, ModelMap model, RefundForm refundForm) {
		String id = request.getParameter("id");
		// User user = UserSession.getUser(request);
		User user = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		SaleCancelInfoVo vo = this.refundqueryService.getSaleCanelinfoByid(id);
		if (vo != null) {
			RefundRes4005Result res = new RefundRes4005Result();
			res.setSaleAgencyCode(vo.getSaleAgencyCode());
			res.setAreaCode_cancel(vo.getCancelAgencyCode());
			res.setCancelAmount(vo.getCancelAmount());
			res.setReqfn_ticket(vo.getId());
			res.setGameCode(vo.getGameCode().intValue());
			res.setStartIssueNumber(vo.getIssueNumer() != null ? vo.getIssueNumer() : new Long(0));

			res.setSaleDate(vo.getSaleTime());
			res.setCancelAmount(vo.getCancelAmount());
			res.setRspfn_ticket(vo.getSaleTsn());
			refundForm.setGameName(vo.getGameName());
			refundForm.setSaleAgencyCodeFormat(vo.getSaleAgencyCodeFormat());
			refundForm.setCancelAgencyCodeFormat(vo.getCancelAgencyCode());
			
			model.addAttribute("refundReq", res);
			model.addAttribute("currdatetime", new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(vo.getCancelTime()));
			model.addAttribute("refundForm", refundForm);
		}
		model.addAttribute("realname", user.getRealName());
		
		return LocaleUtil.getUserLocalePath("oms/expirydate/refund", request);
	}

	@RequestMapping(params = "method=refunInfoPrint")
	public String refunInfoPrint(HttpServletRequest request, ModelMap model, RefundForm refundForm) {
		String tsn = request.getParameter("reqtsn");
		User user = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		SaleCancelInfoVo vo = this.refundqueryService.getSaleCanelinfoByTsn(tsn);
		if (vo != null) {
			RefundRes4005Result res = new RefundRes4005Result();
			res.setSaleAgencyCode(vo.getSaleAgencyCode());
			res.setAreaCode_cancel(vo.getCancelAgencyCode());
			res.setCancelAmount(vo.getCancelAmount());
			res.setReqfn_ticket(vo.getId());
			res.setGameCode(vo.getGameCode().intValue());
			res.setStartIssueNumber(vo.getIssueNumer() != null ? vo.getIssueNumer() : new Long(0));

			res.setSaleDate(vo.getSaleTime());
			res.setCancelAmount(vo.getCancelAmount());
			res.setRspfn_ticket(vo.getSaleTsn());
			refundForm.setGameName(vo.getGameName());
			refundForm.setSaleAgencyCodeFormat(vo.getSaleAgencyCodeFormat());
			refundForm.setCancelAgencyCodeFormat(String.valueOf(vo.getCancelAgencyCode()));
			
			model.addAttribute("refundReq", res);
			
			model.addAttribute("currdatetime", new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(vo.getCancelTime()));
			model.addAttribute("refundForm", refundForm);
		}
		model.addAttribute("realname", user.getRealName());
		
		return LocaleUtil.getUserLocalePath("oms/expirydate/refund", request);
	}

	@RequestMapping(params = "method=refunInfoPrintInit")
	public String refunInfoPrintInit(HttpServletRequest request, ModelMap model, RefundForm refundForm) {
		String reqtsn = refundForm.getReqtsn();
		refundForm.setReqtsn(reqtsn);
		model.addAttribute("refundForm", refundForm);
		return LocaleUtil.getUserLocalePath("oms/expirydate/refundprintInit", request);
	}

	private String getMessage(HttpServletRequest request, int status) {

		Map<Integer, String> awardingState = EnumConfigEN.awardingState;
		if (request != null)
			awardingState = LocaleUtil.getUserLocaleEnum("awardingState", request);
		String message = awardingState.get(status);
		return message;
	}
}
