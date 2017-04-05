package cls.pilottery.fbs.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.DateUtil;
import cls.pilottery.common.utils.HttpClientUtils;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.common.utils.PropertiesUtil;
import cls.pilottery.fbs.service.FbsRefundService;
import cls.pilottery.oms.common.entity.BaseMessageReq;
import cls.pilottery.oms.common.entity.MessageLog;
import cls.pilottery.oms.common.msg.RefundReq4005;
import cls.pilottery.oms.common.msg.RefundRes4005;
import cls.pilottery.oms.common.service.LogService;
import cls.pilottery.oms.common.utils.ResustConstant;
import cls.pilottery.oms.lottery.form.RefundForm;
import cls.pilottery.oms.lottery.form.SaleCancelInfoForm;
import cls.pilottery.oms.lottery.service.RefundqueryService;
import cls.pilottery.oms.lottery.vo.SaleCancelInfoVo;
import cls.pilottery.web.system.model.User;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;

@Controller
@RequestMapping("/fbsRefund")
public class FbsRefundController {
	public static Logger logger = Logger.getLogger(FbsRefundController.class);
	
	@Autowired
	private FbsRefundService fbsRefundService;
	@Autowired
	RefundqueryService refundqueryService;
	@Autowired
	private LogService logService;
	
	@RequestMapping(params = "method=initTicketCancel")
	public String initTicketCancel(HttpServletRequest request){
		return LocaleUtil.getUserLocalePath("oms/fbs/refund/refundFirst", request);
	}

	@RequestMapping(params = "method=refund")
	public String refund(HttpServletRequest request, ModelMap model, RefundForm refundForm) {

		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		String currdate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date());
		String currdatetime = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());

		String prId = this.refundqueryService.getRefundflow(new Long(user.getInstitutionCode()));

		String realname = user.getRealName();
		BaseMessageReq breq = new BaseMessageReq(12005, 2);
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
			refundForm.setCancelCommision(res.getResult().getCommissionAmount());
			refundForm.setGameName(this.refundqueryService.getGameName(new Long(res.getResult().getGameCode())));
			this.refundqueryService.saveRefund(refundForm);
		} else {
			String message = LocaleUtil.getUserLocaleEnum("awardingState", request).get(status);

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
	 * 列表查询 数据分页处理
	 */
	@RequestMapping(params = "method=listCancelRecord")
	public String listCancelRecord(HttpServletRequest request, ModelMap model, SaleCancelInfoForm saleCancelInfoForm) {
		User user = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		saleCancelInfoForm.setAreaCode(user.getInstitutionCode());
		Integer count = fbsRefundService.getSaleCancelCount(saleCancelInfoForm);

		List<SaleCancelInfoVo> salecancelist = new ArrayList<SaleCancelInfoVo>();
		int pageIndex = PageUtil.getPageIndex(request);
		if (count != null && count.intValue() != 0) {
			saleCancelInfoForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			saleCancelInfoForm.setEndNum(((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize));
			salecancelist = fbsRefundService.getSaleCancelList(saleCancelInfoForm);
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
	
}
