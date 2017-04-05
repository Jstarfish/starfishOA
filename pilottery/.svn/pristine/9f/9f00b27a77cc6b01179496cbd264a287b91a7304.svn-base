package cls.pilottery.oms.business.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.HttpClientUtils;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.common.utils.PropertiesUtil;
import cls.pilottery.oms.business.form.notifyform.TerminalNoticeForm;
import cls.pilottery.oms.business.model.notifymodel.ListJsonResponse;
import cls.pilottery.oms.business.model.notifymodel.TerminalNotice;
import cls.pilottery.oms.business.model.notifymodel.TreeNode;
import cls.pilottery.oms.business.service.NotifyService;
import cls.pilottery.oms.common.entity.BaseMessageReq;
import cls.pilottery.oms.common.entity.BaseMessageRes;
import cls.pilottery.oms.common.entity.MessageLog;
import cls.pilottery.oms.common.msg.NotifyReq11001;
import cls.pilottery.oms.common.msg.TicketMessageReq11003;
import cls.pilottery.oms.common.service.LogService;
import cls.pilottery.oms.common.utils.AjaxCharsetUtil;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.system.model.UserLanguage;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

@Controller
@RequestMapping("tmnotice")
public class NotifyController {

	Logger log = Logger.getLogger(NotifyController.class);
	
	@Autowired
	private NotifyService notifyService;
	
	@Autowired
	private LogService logService;

	/**
	 * @Description:查询销售站公告
	 */
	@RequestMapping(params = "method=notifyList")
	public String notifyList(HttpServletRequest request, ModelMap model, TerminalNoticeForm terminalNoticeForm){
		TerminalNotice terminalNotice = terminalNoticeForm.getTerminalNotice();
		Integer count = notifyService.countNotifyList(terminalNoticeForm);
		
		List<TerminalNotice> list = new ArrayList<TerminalNotice>();
		int pageIndex = PageUtil.getPageIndex(request);
		
		if (count != null && count.intValue() != 0) {
			terminalNotice.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			terminalNotice.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			list = notifyService.queryNotifyList(terminalNoticeForm);
		}
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
        model.addAttribute("pageDataList", list);
		
        return LocaleUtil.getUserLocalePath("oms/notify/notifyList", request);
	}
	
	
	@RequestMapping(params = "method=noticeDetail")
	public String getNoticeById(HttpServletRequest request, ModelMap model){
		String noticeId = request.getParameter("noticeId");
		Map<String, String> noticeMap = new HashMap<String, String>();
		if (noticeId!=null && !noticeId.isEmpty())
			noticeMap = notifyService.getNoticeById(noticeId);
		model.addAttribute("noticeMap", noticeMap);
		return LocaleUtil.getUserLocalePath("oms/notify/noticeDetail", request);
	}
	

	/**
	 *	@Description:发送销售站公告页面
	 */
	@RequestMapping(params = "method=sendTMNotify")
	public String sendTMNotify(HttpServletRequest request, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		if(user == null)
			throw new Exception("Invalid User Info.");
		List<TreeNode> list = buildTree(user.getInstitutionCode());
		model.addAttribute("list", list);
		return LocaleUtil.getUserLocalePath("oms/notify/sendAgencyNotify", request);
	}
	
	
	/*
	 * 构造区域树
	 */
	private List<TreeNode> buildTree(String institutionCode) {
		List<TreeNode> nodes = null;
		if (notifyService != null)
			nodes = notifyService.getAreas(institutionCode);
		return nodes;
	}
	
	
	/**
	 * 发送即时消息页面
	 */
	@RequestMapping(params = "method=sendIMInfo")
	public String sendImmediateNotice(HttpServletRequest request, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		if(user == null)
			throw new Exception("Invalid User Info.");
		List<TreeNode> list = buildTree(user.getInstitutionCode());
		model.addAttribute("list", list);
		return LocaleUtil.getUserLocalePath("oms/notify/immediateNotice", request);
	}
	
	
	/**
	 * 发送即时消息
	 */
	@ResponseBody
	@RequestMapping(params = "method=sendIMInfoData", method=RequestMethod.POST)
	public String sendIMInfo(HttpServletRequest request, HttpServletResponse response, TerminalNotice notice){
		String strRet = "发送完成！";
		String flag = "1";
		
		String objs = notice.getObjIds();
		String objNames = notice.getObjNames();
		String levelId = notice.getLevelIds();
		String content = notice.getContent();
		int postionId = notice.getPositionId();
		
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		UserLanguage lg = user.getUserLang();
		
		notice.setAdminId(user.getId());//发送人
		notice.setTitle("");
		notice.setSendTime(new Date());//发送时间
		
		String erroMsg = "[";
		int erroCount = 0;
		
		try {
			notifyService.sendIMInfo(notice);//存数据
			log.debug("发送即时消息成功！");
				//发送消息数据
				Date date = new Date();
				String[] objArray = objs.split(",");
				String[] objNameArray = objNames.split(",");
				String[] levelIdArray = levelId.split(",");
				for (int i=0; i<objArray.length; i++) {
					NotifyReq11001 nq = new NotifyReq11001();
					nq.setCreateTime(date);
					nq.setSendTime(date);
					nq.setLength(content.length());
					nq.setMessage(content);
					nq.setWho(postionId);
					nq.setCtrlCode(objArray[i]);
					nq.setCtrlLevel(Integer.valueOf(levelIdArray[i]));

					BaseMessageReq req = new BaseMessageReq(11001,2);
					req.setParams(nq);
					long seq = logService.getNextSeq();
					req.setMsn(seq);
					String reqJson = JSONObject.toJSONString(req);
					log.debug("向主机发送请求，请求内容："+reqJson);
					
					MessageLog msglog = new MessageLog(seq,reqJson);
					logService.insertLog(msglog);
					String resJson = HttpClientUtils.postString(PropertiesUtil.readValue("url_host"), reqJson);
					log.debug("接收到主机的响应，消息内容："+resJson);
					
					if(resJson != null){
						BaseMessageRes res = JSONObject.parseObject(resJson,BaseMessageRes.class);
						if(res.getRc() != 0){
							logService.updateLog(msglog);
							erroMsg += objNameArray[i]+",";
							erroCount++;
						}
					}
					erroMsg += "消息返回异常]";
					if (erroCount>0) {
						flag = "0";
						strRet = "发送消息失败！";
						strRet += erroMsg;
					}
				}}
			 catch (Exception e) {
				e.printStackTrace();
				flag = "0";
				strRet = "发送消息失败！";
			}
			return flag;
	}
	
	
	/*
	/**
	 * 发布票面信息页面
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(params = "method=sendTicketInfo")
	public String publishTicketInfo(HttpServletRequest request, ModelMap model) {
		String ticketMsg = notifyService.getTicketMessage();
		model.addAttribute("ticketMsg",ticketMsg);
		return LocaleUtil.getUserLocalePath("oms/notify/ticketInfoPublish", request);
	}
	
	
	/**
	 * 发布票面信息
	 * @param request
	 * @param response
	 */

	@ResponseBody
	@RequestMapping(params = "method=sendTicketData", method=RequestMethod.POST)
	public String sendTicketData(HttpServletRequest request, HttpServletResponse response, TerminalNotice notice){
		String flag = "1";
		String ticketInfo = notice.getContent();
		if(StringUtils.isNotBlank(ticketInfo))
			ticketInfo = ticketInfo.trim();
//		if (StringUtils.isBlank(ticketInfo)) {
//			strRet = "参数异常！";
//		} else {
			
			StringBuilder sb = new StringBuilder();
			try {
				sb.append("发送票面信息；" + JSONArray.toJSONString(notice));
				Integer count = notifyService.getTicketInfoCount();
				if (count.intValue() > 0) {
					if (ticketInfo.isEmpty()) {
						notifyService.updateTicketMessage(" ");
					} else {
						notifyService.updateTicketMessage(ticketInfo);
					}
					
					//发送消息
					TicketMessageReq11003 tm = new TicketMessageReq11003();
					tm.setLength(ticketInfo.length());
					tm.setSlogan(ticketInfo);
					
					BaseMessageReq req = new BaseMessageReq(11003,2);
					req.setParams(tm);
					long seq = logService.getNextSeq();
					req.setMsn(seq);
					String reqJson = JSONObject.toJSONString(req);
					log.debug("向主机发送请求，请求内容："+reqJson);
					
					MessageLog msglog = new MessageLog(seq,reqJson);
					logService.insertLog(msglog);
					String resJson = HttpClientUtils.postString(PropertiesUtil.readValue("url_host"), reqJson);
					log.debug("接收到主机的响应，消息内容："+resJson);
					
					if(resJson != null){
						BaseMessageRes res = JSONObject.parseObject(resJson,BaseMessageRes.class);
                        if(res.getRc() == 0){
						logService.updateLog(msglog);
						sb.append("发送成功");
					}
					 else {
						sb.append("发送失败!");
						flag = "0";
					}
				} else {
					flag = "0";
				}
			}
			} catch (Exception e) {
				e.printStackTrace();
				sb.append("操作异常："+"(" + e.getMessage() +")");
				flag = "0";
			} finally {
			}
			return flag;
	}
	
	
	/**
	 * 发送销售站公告
	 * @param request
	 * @param response
	 */

	@ResponseBody
	@RequestMapping(params = "method=sendNotice2", method=RequestMethod.POST)
	public String sendNotice2(HttpServletRequest request, HttpServletResponse response, ModelMap model, TerminalNotice notice){
		String strRet = "0";
			//User user = UserSession.getUser(request);
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			
			notice.setAdminId(user.getId());//发送人
			notice.setSendTime(new Date());
			
			try {
				notifyService.sendNotice(notice);
				
				if (notice.getC_errcode()==0) {
					strRet = "1";
					log.debug("发送销售站公告成功！");
					model.addAttribute("system_message","发送销售站公告成功！");
				} else {
					log.debug("发送销售站公告失败！");
					model.addAttribute("system_message","发送销售站公告失败！");
				}
				return strRet;
			} catch (Exception e) {
				e.printStackTrace();
				
				log.debug("发送销售站公告失败！");
				model.addAttribute("system_message","发送销售站公告失败！");
				
			}
			return strRet;
	}


	
	@RequestMapping(params = "method=asysGetAgencysByIDS")
	public void asysGetAgencysByIDS(HttpServletRequest request,
			HttpServletResponse response) {

		String ids = AjaxCharsetUtil.getDecodeString(request, "ids", true);
			
	    if(!ids.matches("^\\d{6,12}[([;|；]\\d(6,12))]*$"))
	    {
	    	AjaxCharsetUtil.outJsonChineseStr(response, "Invalid agency code ！");
	    	return;
	    }
		
		
		if (StringUtils.isNotBlank(ids)) {
			String[] ida = ids.split(";");
			if (ida != null && ida.length > 0) {
				String nids = "";
				for (String s : ida) {
					if (StringUtils.isBlank(s))
						continue;
					if (StringUtils.isBlank(nids))
						nids = ("'"+s.trim()+"'");
					else
						nids += (",'" + s.trim()+"'");
				}
				if(StringUtils.isNotBlank(nids))
					nids = ("("+ nids+")");
				
				List<TreeNode> list = notifyService.getAgencys(nids);
				ListJsonResponse resp = new ListJsonResponse();
				resp.setList(list);
				AjaxCharsetUtil.outJsonChineseStr(response, resp);
			}
		}
	}
	
	@RequestMapping(params = "method=asysGetTerminalsByIDS")
	public void asysGetTerminalsByIDS(HttpServletRequest request,
			HttpServletResponse response) {

		String ids = AjaxCharsetUtil.getDecodeString(request, "ids", true);
			
	    if(!ids.matches("^\\d{6,12}[([;|；]\\d(6,12))]*$"))
	    {
	    	AjaxCharsetUtil.outJsonChineseStr(response, "Invalid object code！");
	    	return;
	    }
		
		
		if (StringUtils.isNotBlank(ids)) {
			String[] ida = ids.split(";");
			if (ida != null && ida.length > 0) {
				String nids = "";
				for (String s : ida) {
					if (StringUtils.isBlank(s))
						continue;
					if (StringUtils.isBlank(nids))
						nids = ("'"+s.trim()+"'");
					else
						nids += (",'" + s.trim()+"'");
				}
				if(StringUtils.isNotBlank(nids))
					nids = ("("+ nids+")");
				
				List<TreeNode> list = notifyService.getTerminals(nids);
				ListJsonResponse resp = new ListJsonResponse();
				resp.setList(list);
				AjaxCharsetUtil.outJsonChineseStr(response, resp);
			}
		}
	}
}
