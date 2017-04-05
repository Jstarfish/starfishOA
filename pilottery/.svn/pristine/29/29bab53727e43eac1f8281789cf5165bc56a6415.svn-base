package cls.pilottery.oms.business.controller;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.HttpClientUtils;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.common.utils.PropertiesUtil;
import cls.pilottery.oms.business.form.tmversionform.SoftwarePackageForm;
import cls.pilottery.oms.business.model.TerminalType;
import cls.pilottery.oms.business.model.tmversionmodel.PackageContext;
import cls.pilottery.oms.business.model.tmversionmodel.SimpleSoftPack;
import cls.pilottery.oms.business.model.tmversionmodel.SoftwarePackage;
import cls.pilottery.oms.business.service.SoftwarePackageService;
import cls.pilottery.oms.common.entity.BaseMessageReq;
import cls.pilottery.oms.common.entity.BaseMessageRes;
import cls.pilottery.oms.common.entity.MessageLog;
import cls.pilottery.oms.common.msg.SoftwarePackageIsValidReq10005;
import cls.pilottery.oms.common.msg.SoftwarePackageReq10001;
import cls.pilottery.oms.common.service.LogService;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.system.model.UserLanguage;

@Controller
@RequestMapping("/tmversionPackage")
public class SoftwarePackageController {
	Logger log = Logger.getLogger(NotifyController.class);
	@Autowired
	private SoftwarePackageService packService;
	
	@Autowired
	private LogService logService;
	
	@ModelAttribute("terminalTypes")
	public List<TerminalType> getTerminalType(){
		List<TerminalType> terminalTypes = new ArrayList<TerminalType>();
		terminalTypes.add(new TerminalType(1));
		return terminalTypes;
	}

	@RequestMapping(params = "method=listSoftPackage")
	public String getPackages(HttpServletRequest request, ModelMap model, SoftwarePackage softwarePackage) {
		List<SoftwarePackage> list = new ArrayList<SoftwarePackage>();
		int count = packService.getCount();//查询总数
		int pageIndex = PageUtil.getPageIndex(request);
		if (count > 0) {
			softwarePackage.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			softwarePackage.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			list = packService.getSoftwarePackages(softwarePackage);//查询
		}
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
        model.addAttribute("pageDataList", list);
		return LocaleUtil.getUserLocalePath("oms/tmversion/softPackagetList", request);
	}
	
	//add
		@RequestMapping(params = "method=addSoftVerPackage", method=RequestMethod.GET)
		public String addSoftPackSetup(HttpServletRequest request, ModelMap model)
				throws Exception {

			SoftwarePackage sp = new SoftwarePackage();
		    SoftwarePackageForm spf = new SoftwarePackageForm();
		    model.addAttribute("softPackage",sp);
		    model.addAttribute("softPackageForm",spf);
		    return LocaleUtil.getUserLocalePath("oms/tmversion/addSoftPackage", request);
		}

		
		/**
		 * 新增软件包
		 * @param request
		 * @param model
		 * @param softPackage
		 * @return
		 * @throws Exception
		 */
		@RequestMapping(params = "method=addSoftVerPackage", method=RequestMethod.POST)
		public String addSoftPack(HttpServletRequest request, ModelMap model, @ModelAttribute SoftwarePackage softPackage)
				throws Exception {
			HttpSession session = request.getSession();
			User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			UserLanguage lg = user.getUserLang();
			
			StringBuilder sb = new StringBuilder();
			StringBuilder sb2 = new StringBuilder();
			try {
				
				sb.append(" 新增软件包: " + JSONArray.toJSONString(softPackage));
				sb2.append("新增软件包! 操作者：" + user.getId() +", 操作时间：" + new Date()
						+"新增软件包：[" + JSONArray.toJSONString(softPackage) + "]");
				
				try {
					packService.insertPackage(softPackage);//普通sql
					
					sb.append(", 新增软件包成功!");
					sb2.append(", 新增软件包成功!");
					
				//	SoftwarePackageReq swq = new SoftwarePackageReq();
					SoftwarePackageReq10001 swq = new SoftwarePackageReq10001();
					swq.setMachineType(softPackage.getTerminalType());
					swq.setVersionNO(softPackage.getPackageVersion());
					swq.setStatus(1);
					//swq.doAction();
					
					sb.append(", 向主机发送信息：[" + JSONArray.toJSONString(swq)+"]");
					sb2.append(", 向主机发送信息：[" + JSONArray.toJSONString(swq)+"]");
					
					BaseMessageReq req = new BaseMessageReq(10001,2);
					req.setParams(swq);
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
						sb.append(", 发送信息成功！");
						sb2.append(", 发送信息成功！");
					} else {
						sb.append(", 发送信息失败！");
						sb2.append(", 发送信息失败！");
					}
					}
					model.addAttribute("reservedHrefURL","tmversionPackage.do?method=listSoftPackage");
					return LocaleUtil.getUserLocalePath("common/successTip", request);
				} catch (Exception e) {
					e.printStackTrace();
					sb.append(", 新增软件包失败" + e.getMessage());
					sb2.append(", 新增软件包失败" + e.getMessage());
					model.addAttribute("system_message", e.getMessage());
					return LocaleUtil.getUserLocalePath("common/errorTip", request);
				} finally {
					log.debug(sb2.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
				model.addAttribute("system_message", e.getMessage());
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			}
		}
		
		
		/**
		 * 修改软件包有效性
		 * @param request
		 * @param model
		 * @return
		 */
		@RequestMapping(params = "method=editValid", method=RequestMethod.GET)
		public String editValidSetup(HttpServletRequest request, ModelMap model) {

			String packVer = request.getParameter("packVer");
			String termTypeStr = request.getParameter("termType");
			String validStr = request.getParameter("valid");
			
			SoftwarePackage sp = new SoftwarePackage();
			sp.setPackageVersion(packVer);
		    sp.setTerminalType(Integer.parseInt(termTypeStr));
		    sp.setIsValid(Integer.parseInt(validStr));
		    
			model.addAttribute("softPackage",sp);
		    
			model.addAttribute("valid", sp.getIsValid());
			if(sp.getIsValid() == 1 ) {//有效
				sp.setIsValid(2);
				model.addAttribute("validDesc", "有效");
				model.addAttribute("validStr","禁用");
			} else {
				sp.setIsValid(1);
				model.addAttribute("validDesc", "无效");
				model.addAttribute("validStr","启用");
			}
			return LocaleUtil.getUserLocalePath("oms/tmversion/editSoftPackageValid", request);
		}
		
		
		@RequestMapping(params = "method=editValid", method=RequestMethod.POST)
		public String editValid(HttpServletRequest request, ModelMap model,
				@ModelAttribute("softPackage") SoftwarePackage softPackage) {
			
			HttpSession session = request.getSession();
			User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			UserLanguage lg = user.getUserLang();
			
			StringBuilder sb = new StringBuilder();
			StringBuilder sb2 = new StringBuilder();
			try {
				
				sb.append("修改软件有效性! 操作者：" + user.getId() +", 操作时间：" + new Date()
				+"修改软件有效性：[" + JSONArray.toJSONString(softPackage) + "]");
				sb2.append("修改软件有效性! 操作者：" + user.getId() +", 操作时间：" + new Date()
						+"修改软件有效性：[" + JSONArray.toJSONString(softPackage) + "]");
				
				packService.updatePackageValid(softPackage);
				
				String packVer = softPackage.getPackageVersion();
				int termTypeStr = softPackage.getTerminalType();
				int validStr = softPackage.getIsValid();
				if (validStr==2) {
					sb.append(", 版本为"+packVer+", 终端机机型为"+termTypeStr+"的软件包禁用操作成功！");
					sb2.append(", 版本为"+packVer+", 终端机机型为"+termTypeStr+"的软件包禁用操作成功！");
				} else {
					sb.append(", 版本为"+packVer+", 终端机机型为"+termTypeStr+"的软件包启用操作成功！");
					sb2.append(", 版本为"+packVer+", 终端机机型为"+termTypeStr+"的软件包启用操作成功！");
				}
				
				//SoftwarePackageIsValidReq swq = new SoftwarePackageIsValidReq();
				SoftwarePackageIsValidReq10005 swq = new SoftwarePackageIsValidReq10005();
				
				swq.setMachineType(softPackage.getTerminalType());
				swq.setVersionNO(softPackage.getPackageVersion());
				swq.setStatus(validStr);
				
				//sb.append(SpringContextUtil.getMessage("controller.code3", request) + JSONArray.toJSONString(swq)+"]");
				sb.append(", 向主机发送信息：[" + JSONArray.toJSONString(swq)+"]");
				sb2.append(", 向主机发送信息：[" + JSONArray.toJSONString(swq)+"]");
				
				BaseMessageReq req = new BaseMessageReq(10005,2);
				req.setParams(swq);
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
					sb.append(", 发送信息成功！");
					sb2.append(", 发送信息成功！");
				} else {
					sb.append(", 发送信息失败！");
					sb2.append(", 发送信息失败！");
				}
				}
				
				model.addAttribute("reservedHrefURL","tmversionPackage.do?method=listSoftPackage");
				return LocaleUtil.getUserLocalePath("common/successTip", request);
				
			} catch (Exception e) {
				e.printStackTrace();
				sb.append(", 修改软件有效性失败" + e.getMessage());
				sb2.append(", 修改软件有效性失败" + e.getMessage());
				model.addAttribute("system_message", e.getMessage());
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			} finally {
				log.debug(sb2.toString());
			}
			
		}
		
		@ResponseBody
		@RequestMapping(params = "method=editValidByCode")
		public String editValidByCode(HttpServletRequest request) throws Exception {
			
			//Long operUserId = UserSession.getUser(request) == null ? null : UserSession.getUser(request).getId();
			HttpSession session = request.getSession();
			User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			UserLanguage lg = user.getUserLang();
			
			StringBuilder sb = new StringBuilder();
			StringBuilder sb2 = new StringBuilder();
			Map<String, String> map = new HashMap<String, String>();
			try {
				SoftwarePackage softPackage = new SoftwarePackage();
				softPackage.setIsValid(Integer.valueOf(request.getParameter("valid")));
				softPackage.setPackageVersion(String.valueOf(request.getParameter("packVer")));
				softPackage.setTerminalType(Integer.valueOf(request.getParameter("termType")));
				
				//sb.append(SpringContextUtil.getMessage("controller.code11", request) + JSONArray.toJSONString(softPackage));
				sb.append("修改软件有效性! 操作者：" + user.getId() +", 操作时间：" + new Date()
						+"修改软件有效性：[" + JSONArray.toJSONString(softPackage) + "]");
				sb2.append("修改软件有效性! 操作者：" + user.getId() +", 操作时间：" + new Date()
				+"修改软件有效性：[" + JSONArray.toJSONString(softPackage) + "]");
				
				packService.updatePackageValid(softPackage);
				
				String packVer = softPackage.getPackageVersion();
				int termTypeStr = softPackage.getTerminalType();
				int validStr = softPackage.getIsValid();
				if (validStr==2) {//禁用
					sb.append(", 版本为"+packVer+", 终端机机型为"+termTypeStr+"的软件包禁用操作成功！");
					sb2.append(", 版本为"+packVer+", 终端机机型为"+termTypeStr+"的软件包禁用操作成功！");
				} else if (validStr==1) {//启用
					sb.append(", 版本为"+packVer+", 终端机机型为"+termTypeStr+"的软件包启用操作成功！");
					sb2.append(", 版本为"+packVer+", 终端机机型为"+termTypeStr+"的软件包启用操作成功！");
				} else if (validStr==3) {//删除
					sb.append(", 版本为"+packVer+", 终端机机型为"+termTypeStr+"的软件包删除操作成功！");
					sb2.append(", 版本为"+packVer+", 终端机机型为"+termTypeStr+"的软件包删除操作成功！");
				}
				
				//SoftwarePackageIsValidReq swq = new SoftwarePackageIsValidReq();
				SoftwarePackageIsValidReq10005 swq = new SoftwarePackageIsValidReq10005();
				swq.setMachineType(softPackage.getTerminalType());
				swq.setVersionNO(softPackage.getPackageVersion());
				swq.setStatus(validStr);
				//swq.doAction();
				
				sb.append(", 向主机发送信息：[" + JSONArray.toJSONString(swq)+"]");
				sb2.append(", 向主机发送信息：[" + JSONArray.toJSONString(swq)+"]");
				
				BaseMessageReq req = new BaseMessageReq(10005,2);
				req.setParams(swq);
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
					sb.append(", 发送信息成功！");
					sb2.append(", 发送信息成功！");
				} else {
					sb.append(", 发送信息失败！");
					sb2.append(", 发送信息失败！");
				}
				}
				
				map.put("reservedSuccessMsg", "");
				return JSONArray.toJSONString(map);
				
			} catch (Exception e) {
				e.printStackTrace();
				sb.append(", 修改软件有效性失败" + e.getMessage());
				sb2.append(", 修改软件有效性失败" + e.getMessage());
				map.put("reservedSuccessMsg", URLEncoder.encode("修改软件有效性失败！","utf-8"));
				return JSONArray.toJSONString(map);
			} finally {
				log.debug(sb2.toString());
			}
		}
		
		//editSoftVersions
		@RequestMapping(params = "method=editSoftVersions", method=RequestMethod.GET)
		public String editSoftVersionsSetup(HttpServletRequest request, ModelMap model)
				throws Exception {
			
			String packVer = request.getParameter("packVer");
			String termTypeStr = request.getParameter("termType");
			
			SoftwarePackage sp = new SoftwarePackage();
			sp.setPackageVersion(packVer);
		    sp.setTerminalType(Integer.parseInt(termTypeStr));
		    
		    model.addAttribute("softPackage",sp);
		    
		    SoftwarePackageForm spf = new SoftwarePackageForm();	    
		    model.addAttribute("softPackageForm",spf);
		    
		    //select 各个软件的可用版本
		    ArrayList<String> list1 = new ArrayList<String>();
		    list1.add("1.1.1_111");
		    list1.add("1.1.1_112");
		    list1.add("1.1.1_113");
		    model.addAttribute("list1",list1);
		    return LocaleUtil.getUserLocalePath("oms/tmversion/editSoftPackageVersions", request);

		}
		@RequestMapping(params = "method=editSoftVersions", method=RequestMethod.POST)
		public String editSoftVersions(HttpServletRequest request, ModelMap model,@ModelAttribute("softPackage") SoftwarePackage softPackage,
				@ModelAttribute("softPackageForm") SoftwarePackageForm packForm)
				throws Exception {
			 
			try {

				softPackage.setSoftwareVersionList( getVersionList(softPackage,packForm) );
				packService.updatePackageVersions(softPackage);
				
				model.addAttribute("reservedHrefURL",
						"tmversion.do?method=listSoft");
				
				return LocaleUtil.getUserLocalePath("common/successTip", request);
			} catch (Exception e) {
				e.printStackTrace();
				model.addAttribute("system_message", e.getMessage());
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			}

		}
		
		private List<PackageContext> getVersionList(SoftwarePackage softPack,SoftwarePackageForm packForm)
		{
			
			List<PackageContext> lst = new ArrayList<PackageContext>();
			Class<SoftwarePackageForm> clz = SoftwarePackageForm.class;
			try{
				for(int i=1;i<=7;i++)
				{
					Method m = clz.getMethod("getVersion"+i);
					String version = (String)m.invoke(packForm);
					PackageContext pc = new PackageContext();
					
					pc.setPackageVersion(softPack.getPackageVersion());
					pc.setSoftId(i);
					pc.setSoftVersion(version);
					pc.setTerminalType(softPack.getTerminalType());
					lst.add(pc);
				}
			}catch(NoSuchMethodException ex)
			{
				ex.printStackTrace();
			} catch (IllegalArgumentException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return lst;
		}

		//Ajax pack version list
		@RequestMapping(params="method=getpackvers", method=RequestMethod.GET)
		public String getPackVerList(HttpServletRequest request, HttpServletResponse response,ModelMap model) throws Exception {
					
			
			String curtype = request.getParameter("termtype");
			Integer termType = Integer.parseInt(curtype);
			
			List<SimpleSoftPack> plist = null;
			plist = packService.getPackVersForTermType(termType);
			

			String jsonStr = listToJsonStr(plist,"datalist");
			response.setContentType("application/json;charset=UTF-8");
			response.getWriter().print(jsonStr);
			response.getWriter().flush();
			response.getWriter().close();
			return null;

		}
		
		private String listToJsonStr(List<SimpleSoftPack> list,String listName)
		{
			if(list == null)
				return "";
			StringBuffer sb = new StringBuffer(512);
			
			sb.append("{\"");
			sb.append(listName);
			sb.append("\":[");
			for(int i=0;i<list.size();i++)
			{
		
				sb.append(" {\"label\":\" ");
				
				sb.append(list.get(i).getPackageVersion());
				
				sb.append(" \" ,\"value\":\"  ");
				
				sb.append(list.get(i).getPackageVersion());
				
				sb.append(" \"}");
				if(i != (list.size() -1) )
					sb.append(",");
			}
			sb.append("]}");
			return sb.toString();
		}
		
		@ResponseBody
		@RequestMapping(params="method=ifExist")
		public String ifExistSoftWarePackageNo(HttpServletRequest request){
			String flag = "0";//不重复，1为重复
			String terminalType = request.getParameter("terminalType").trim();
			String packageVersion = request.getParameter("packageVersion");
			Map<String, String> map = new HashMap<String, String>();
			map.put("terminalType", terminalType);
			map.put("packageVersion", packageVersion);
			if (terminalType!=null && !terminalType.isEmpty() && packageVersion!=null && !packageVersion.isEmpty()) {
				Integer count = packService.ifExistSoftWarePackageNo(map);
				if (count.intValue()>0)
					flag = "1";
			}
			return flag;
		}
		
		
		@ResponseBody
		@RequestMapping(params="method=ifBiggerThanOther")
		public Object ifBiggerThanOther(HttpServletRequest request){
			String flag = "0";//传进来的packageVersion最大
			String terminalType = request.getParameter("terminalType").trim();
			String packageVersion = request.getParameter("packageVersion");
			Map<String, String> map = new HashMap<String, String>();
			map.put("terminalType", terminalType);
			map.put("packageVersion", packageVersion);
			String maxPackVersion = "";
			if (terminalType!=null && !terminalType.isEmpty() && packageVersion!=null && !packageVersion.isEmpty()) {
				Integer count = packService.ifBiggerThanOther(map);
				if (count.intValue()>0) {
					flag = "1";
					maxPackVersion = packService.maxSoftwarePackNo(map);
				}
			}
			map.put("flag", flag);
			map.put("maxPackVersion", maxPackVersion);
			return JSONArray.toJSONString(map);
		}
		
		@ResponseBody
		@RequestMapping(params="method=isFullNum")
		public String isFullNum(HttpServletRequest request){
			String flag = "0";
			String terminalType = request.getParameter("terminalType").trim();
			if (terminalType!=null && !terminalType.isEmpty()) {
				Integer count = packService.isFullNum(terminalType);
				if (count.intValue()>=10) {
					flag = "1";
				}
			}
			return flag;
		}
}