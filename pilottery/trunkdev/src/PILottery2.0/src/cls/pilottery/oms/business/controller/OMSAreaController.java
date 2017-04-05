package cls.pilottery.oms.business.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.alibaba.fastjson.JSONObject;

import cls.pilottery.common.utils.HttpClientUtils;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.common.utils.PropertiesUtil;
import cls.pilottery.oms.business.form.OMSAreaAuthForm;
import cls.pilottery.oms.business.form.OMSAreaQueryForm;
import cls.pilottery.oms.business.model.areamodel.OMSArea;
import cls.pilottery.oms.business.model.areamodel.OMSAreaAuth;
import cls.pilottery.oms.business.service.OMSAreaService;
import cls.pilottery.oms.common.entity.BaseMessageReq;
import cls.pilottery.oms.common.entity.BaseMessageRes;
import cls.pilottery.oms.common.entity.MessageLog;
import cls.pilottery.oms.common.msg.AreaGameCtrl;
import cls.pilottery.oms.common.msg.UpdateGameAuth5011Req;
import cls.pilottery.oms.common.service.LogService;

@Controller
@RequestMapping("/omsarea")
public class OMSAreaController {
	static Logger logger = Logger.getLogger(OMSAreaController.class);
	
	@Autowired
	private OMSAreaService omsAreaService;
	
	@Autowired
	private LogService logService;
	
	//区域列表
	@RequestMapping(params="method=listOMSArea")
	public String listOMSArea(HttpServletRequest request, ModelMap model, @ModelAttribute("omsAreaQueryForm") OMSAreaQueryForm omsAreaQueryForm) throws Exception {
		
		Integer count = omsAreaService.countAreaList(omsAreaQueryForm);
		int pageIndex = PageUtil.getPageIndex(request);
		List<OMSArea> list = new ArrayList<OMSArea>();
		
		if (count != null && count.intValue() != 0) {
			omsAreaQueryForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			omsAreaQueryForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			list = omsAreaService.queryAreaList(omsAreaQueryForm);
		}
		formatLimits(list);
		
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", list);
		model.addAttribute("omsAreaQueryForm", omsAreaQueryForm);
		
		return LocaleUtil.getUserLocalePath("oms/area/areaList", request);
	}
	
	private void formatLimits(List<OMSArea> list) {
		for (OMSArea area: list) {
			Integer agencyCount = omsAreaService.getAgencyCountInArea(area.getAreaCode());
			Integer terminalCount = omsAreaService.getTerminalCountInArea(area.getAreaCode());
			Integer tellerCount = omsAreaService.getTellerCountInArea(area.getAreaCode());
//			area.setAgencyNumberLimitString(agencyCount + "(" + area.getAgencyNumberLimit() + ")");
//			area.setTerminalNumberLimitString(terminalCount + "(" + area.getTerminalNumberLimit() + ")");
//			area.setTellerNumberLimitString(tellerCount + "(" + area.getTellerNumberLimit() + ")");
			area.setAgencyNumberLimitString(agencyCount.toString());
			area.setTerminalNumberLimitString(terminalCount.toString());
			area.setTellerNumberLimitString(tellerCount.toString());
		}
	}
	
	@RequestMapping(params = "method=gameAuthen", method = RequestMethod.GET)
	public String gameAuthSetup(HttpServletRequest request, ModelMap model) throws Exception {
		String areaCode = request.getParameter("areaCode");
		
		List<OMSAreaAuth> omsAreaAuthList = omsAreaService.selectGameFromAreaAuth(areaCode);
		model.addAttribute("games", omsAreaAuthList);
		model.addAttribute("areaCode", areaCode);
		
		return LocaleUtil.getUserLocalePath("oms/area/auth", request);
	}
	
	@RequestMapping(params = "method=gameAuthen", method = RequestMethod.POST)
	public String gameAuth(HttpServletRequest request, ModelMap model, @ModelAttribute("omsAreaAuthForm") OMSAreaAuthForm omsAreaAuthForm) throws Exception {
		
		try {
			omsAreaService.updateGameAuth(omsAreaAuthForm);
			if (omsAreaAuthForm.getC_errcode().intValue() == 0) {
				
				String areaCode = omsAreaAuthForm.getGameAuth().get(0).getAreaCode();
				Integer ctrlLevel = 1;
				UpdateGameAuth5011Req paramReq = new UpdateGameAuth5011Req();
				paramReq.setCtrlLevel(ctrlLevel);
				paramReq.setCtrlCode(areaCode);
				paramReq.setGameCount(omsAreaAuthForm.getGameAuth().size());
				copyValueForGameAuth(paramReq.getCtrls(), omsAreaAuthForm.getGameAuth());
				sendMessageToHost(5011, paramReq);
				
				return LocaleUtil.getUserLocalePath("common/successTip", request);
			} else {
				logger.error("errmsgs:" + omsAreaAuthForm.getC_errmsg());
				model.addAttribute("system_message", omsAreaAuthForm.getC_errmsg());
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			}
		} catch (Exception e) {
			logger.error("errmsgs: " + e.getMessage());
			model.addAttribute("system_message", e.getMessage());
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
	}
	
	private void copyValueForGameAuth(List<AreaGameCtrl> ctrls, List<OMSAreaAuth> gameAuth) {
		for (OMSAreaAuth auth: gameAuth) {
			AreaGameCtrl areaGameCtrl = new AreaGameCtrl();
			areaGameCtrl.setGameCode(auth.getGameCode());
			areaGameCtrl.setStatus((auth.getEnabled() == 1) ? 1 : 0);
			areaGameCtrl.setPayStatus(auth.getAllowPay());
			areaGameCtrl.setSellStatus(auth.getAllowSale());
			areaGameCtrl.setCancelStatus(auth.getAllowCancel());
			ctrls.add(areaGameCtrl);
		}
	}
	
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
}
