package cls.pilottery.web.institutions.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ThreadPoolExecutor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;

import cls.pilottery.common.EnumConfigEN;
import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.HttpClientUtils;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.common.utils.PropertiesUtil;
import cls.pilottery.oms.business.service.AgencyService;
import cls.pilottery.oms.common.entity.BaseMessageReq;
import cls.pilottery.oms.common.entity.BaseMessageRes;
import cls.pilottery.oms.common.entity.MessageLog;
import cls.pilottery.oms.common.service.LogService;
import cls.pilottery.web.area.model.City;
import cls.pilottery.web.area.model.GameAuth;
import cls.pilottery.web.capital.model.ResulstMessage;
import cls.pilottery.web.institutions.form.InstitutionsForm;
import cls.pilottery.web.institutions.model.InfOrgArea;
import cls.pilottery.web.institutions.model.InfOrgs;
import cls.pilottery.web.institutions.msg.AddAreaReq5001;
import cls.pilottery.web.institutions.msg.DelAreaReq5006;
import cls.pilottery.web.institutions.service.InstitutionsService;
import cls.pilottery.web.system.model.User;
/**
 * 
    * @ClassName: InstitutionsController
    * @Description: 部门管理的Controller
    * @author yuyuanhua
    * @date 2015年9月8日
    *
 */

@Controller
@RequestMapping("/institutions")
public class InstitutionsController {
	static Logger logger = Logger.getLogger(InstitutionsController.class);
	@Autowired
	private InstitutionsService institutionsService;
	@Autowired
	private LogService logService;
	@Autowired
	private AgencyService agencyService;
	private Map<Integer,String> maporgType = EnumConfigEN.orgType;
	/*
	 * 准备数据-枚举定义
	 */
	@ModelAttribute("maporgType")
	public Map<Integer,String> getmaporgType(HttpServletRequest request)
	{
		if(request != null)
			this.maporgType =LocaleUtil.getUserLocaleEnum("orgType", request);
		
		return maporgType;
	}
	/**
	 * 
	    * @Title: listInstitutions
	    * @Description: 部门列表
	    * @param @param request
	    * @param @param model
	    * @param @param institutionsForm
	    * @param @return
	    * @param @throws Exception    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=listInstitutions")
	public String listInstitutions(HttpServletRequest request, ModelMap model,
			@ModelAttribute("institutionsForm") InstitutionsForm institutionsForm)
			throws Exception {
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		String orgCode=currentUser.getInstitutionCode();
		int pageIndex = PageUtil.getPageIndex(request);
		Integer count=0;
		List<InfOrgs> infOrgsList=new ArrayList<InfOrgs>();
		if(currentUser.getInstitutionCode().equals("00")){
			
			 count =institutionsService.getInstitutionsCount(institutionsForm);
				
				if (count != null && count.intValue() != 0) {
					institutionsForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
					institutionsForm.setEndNum((pageIndex - 1) * PageUtil.pageSize
							+ PageUtil.pageSize);

					infOrgsList =institutionsService.getInstitutionsList(institutionsForm);
				}
		}
		else{
			
			institutionsForm.setOpertCode(currentUser.getInstitutionCode());
			 count =institutionsService.getInstitutionsCount1(institutionsForm);
				
				if (count != null && count.intValue() != 0) {
					institutionsForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
					institutionsForm.setEndNum((pageIndex - 1) * PageUtil.pageSize
							+ PageUtil.pageSize);

					infOrgsList =institutionsService.getInstitutionsList1(institutionsForm);
				}
		}
	
		
		
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", infOrgsList);
		model.addAttribute("orgCode", orgCode);
		
		model.addAttribute("institutionsForm", institutionsForm);

		return LocaleUtil.getUserLocalePath("data/institutions/listInstitutions", request);
	}
	/**
	 * 
	    * @Title: addInit
	    * @Description:初始化增加部门
	    * @param @param request
	    * @param @param model
	    * @param @return
	    * @param @throws Exception    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=addInit")
	public String addInit(HttpServletRequest request, ModelMap model)
			throws Exception {
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		InfOrgArea area=new InfOrgArea();
		area.setOrgCode(currentUser.getInstitutionCode().toString());
		//String pid=this.institutionsService.getArecode(area).trim();
		String pid="0000";
		 List<InfOrgs> orgsList=this.institutionsService.getInstitutionsInfo();
		 model.addAttribute("orgsList", orgsList);
		List<City> cityList = this.institutionsService.selectCityAreaCode(pid);
		String jsonStr=this.institutionsService.getTree(cityList);
		List<User> userList=this.institutionsService.getUser();
		model.addAttribute("userList", userList);
		model.addAttribute("jsonStr", jsonStr);

		return LocaleUtil.getUserLocalePath("data/institutions/addInstitutions", request);
	}
	/**
	 * 
	    * @Title: addInstitutions
	    * @Description: 添加部门
	    * @param @param request
	    * @param @param model
	    * @param @param inforgs
	    * @param @return
	    * @param @throws Exception    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=addInstitutions")
	public String addInstitutions(HttpServletRequest request, ModelMap model,InfOrgs inforgs)
			throws Exception {
		
		try{
			logger.info("orgCode"+":"+inforgs.getOrgCode()+","+"areaCode"+":"+inforgs.getAreaCode());
			this.institutionsService.addInforgs(inforgs);
			if(inforgs.getC_errcode().intValue()==0){
				BaseMessageReq  breq=new BaseMessageReq(5001, 2);
				AddAreaReq5001 req=new AddAreaReq5001();
				req.setAreaCode(inforgs.getOrgCode());
				req.setAreaName(inforgs.getOrgName());
				if(!inforgs.getOrgCode().equals("00")){
					req.setAreaType(1);
					
				}
				req.setStatus(1);
				req.setParentCode(inforgs.getSuperOrg());
				
				List<GameAuth> ctrls = agencyService.getGameFromArea(inforgs.getOrgCode());
				req.setGameCount(ctrls.size());
				req.setCtrls(ctrls);
				breq.setParams(req);
				long seq=this.logService.getNextSeq();
				breq.setMsn(seq);
				String json=JSONObject.toJSONString(breq);
				MessageLog msglog=new MessageLog(seq,json);
				this.logService.insertLog(msglog);
				// 向主机发送消息
				logger.debug("向主机发送请求，请求内容："+json);
				String resJson = HttpClientUtils.postString(PropertiesUtil.readValue("url_host"), json);
				logger.debug("接收到主机的响应，消息内容："+resJson);
				BaseMessageRes res = JSON.parseObject(resJson, BaseMessageRes.class);
				if(res.getRc()==0){
					return LocaleUtil.getUserLocalePath("common/successTip", request);
				}
				else{
					return LocaleUtil.getUserLocalePath("common/errorTip", request);
				}
				
			}
			logger.error("errmsgs"+LocaleUtil.getUserLocaleErrorMsg(inforgs.getC_errmsg(), request));
			model.addAttribute("system_message", LocaleUtil.getUserLocaleErrorMsg(inforgs.getC_errmsg(), request));
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}catch(Exception e){
			logger.error("errmsgs"+e.getMessage());
			model.addAttribute("system_message", e.getMessage());
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		
		
	}
	/**
	 * 
	    * @Title: modyInit
	    * @Description: 初始化修改页面
	    * @param @param request
	    * @param @param model
	    * @param @return
	    * @param @throws Exception    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=modyInit")
	public String modyInit(HttpServletRequest request, ModelMap model)throws Exception {
		//String pid="0000";
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		InfOrgArea area=new InfOrgArea();
		area.setOrgCode(currentUser.getInstitutionCode().toString());
		String orgCode=request.getParameter("orgCode");
		 List<InfOrgs> orgsList=this.institutionsService.getInstitutionsInfo();
		 InfOrgs infOrgs=this.institutionsService.getInfOrgByCode(orgCode);
		
	//	String pid=this.institutionsService.getArecode(area);
		List<User> userList=this.institutionsService.getUser();
		String pid="0000";
		String jsonStr=this.institutionsService.getModyTree(orgCode, pid);
		model.addAttribute("orgsList", orgsList);
		model.addAttribute("infOrgs", infOrgs);
		model.addAttribute("userList", userList);
		model.addAttribute("jsonStr", jsonStr);

		return LocaleUtil.getUserLocalePath("data/institutions/modyInstitutions", request);
	}
	/**
	 * 
	    * @Title: modyInstitutions
	    * @Description:修改部门
	    * @param @param request
	    * @param @param model
	    * @param @param inforgs
	    * @param @return
	    * @param @throws Exception    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=modyInstitutions")
	public String modyInstitutions(HttpServletRequest request, ModelMap model,InfOrgs inforgs)throws Exception{
		try{
			logger.info("orgCode"+":"+inforgs.getOrgCode()+","+"areaCode"+":"+inforgs.getAreaCode());
			this.institutionsService.updateInforgs(inforgs);
			if(inforgs.getC_errcode().intValue()==0){
				
				BaseMessageReq  breq=new BaseMessageReq(5001, 2);
				AddAreaReq5001 req=new AddAreaReq5001();
				req.setAreaCode(inforgs.getOrgCode());
				req.setAreaName(inforgs.getOrgName());
				if(!inforgs.getOrgCode().equals("00")){
					req.setAreaType(inforgs.getOrgType());
				}
				req.setStatus(1);
				//req.setStatus(inforgs.getOrgType());
				req.setParentCode(inforgs.getSuperOrg());
				
				List<GameAuth> ctrls = agencyService.getGameFromArea(inforgs.getOrgCode());
				req.setGameCount(ctrls.size());
				req.setCtrls(ctrls);
				breq.setParams(req);
				long seq=this.logService.getNextSeq();
				breq.setMsn(seq);
				String json=JSONObject.toJSONString(breq);
				String url=PropertiesUtil.readValue("url_host");
				MessageLog msglog=new MessageLog(seq,json);
				this.logService.insertLog(msglog);
				// 向主机发送消息
				String  resulst = HttpClientUtils.postString(url, json);
				BaseMessageRes res = JSON.parseObject(resulst, BaseMessageRes.class);
				if(res.getRc()==0){
					return LocaleUtil.getUserLocalePath("common/successTip", request);
				}
				else{
					return LocaleUtil.getUserLocalePath("common/errorTip", request);
				}
				
			}
			logger.error("errmsgs"+LocaleUtil.getUserLocaleErrorMsg(inforgs.getC_errmsg(), request));
			model.addAttribute("system_message", LocaleUtil.getUserLocaleErrorMsg(inforgs.getC_errmsg(), request));
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
			
		}catch(Exception e){
			logger.error("errmsgs"+e.getMessage());
			model.addAttribute("system_message", e.getMessage());
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		
	}
	/**
	 * 
	    * @Title: deleteInstitutions
	    * @Description: 逻辑删除部门管理
	    * @param @param request
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@ResponseBody
	@RequestMapping(params = "method=deleteInstitutions")
	public ResulstMessage deleteInstitutions(HttpServletRequest request){
		ResulstMessage message=new ResulstMessage();
		String orgCode=request.getParameter("orgCode");
		try{
			Integer cont=this.institutionsService.getDeleteCount(orgCode);
			if(cont>0){
				message.setMessage("Departments under the site can not be deleted");
			}
			else
			{	int staus=this.institutionsService.deleteupdeSatus(orgCode);
				if(staus!=0){
					message.setMessage("Delete failed");
				}
				else{
					BaseMessageReq  breq=new BaseMessageReq(5005, 2);
					DelAreaReq5006 req=new DelAreaReq5006();
					req.setAreaCode(orgCode);
					breq.setParams(req);
					long seq=this.logService.getNextSeq();
					breq.setMsn(seq);
					String json=JSONObject.toJSONString(breq);
					String url=PropertiesUtil.readValue("url_host");
					MessageLog msglog=new MessageLog(seq,json);
					this.logService.insertLog(msglog);
					// 向主机发送消息
					String  resulst = HttpClientUtils.postString(url, json);
					BaseMessageRes res = JSON.parseObject(resulst, BaseMessageRes.class);
					if(res.getRc()!=0){
						
						throw new RuntimeException();
					}
				}
				
			}
		}catch(Exception e){
			logger.error("errmsgs"+e.getMessage());
			message.setMessage("Delete failed");
			
		}
		return message;
	}
	/**
	 * 
	    * @Title: getInstitutionsCode
	    * @Description: 部门详情
	    * @param @param request
	    * @param @param model
	    * @param @return
	    * @param @throws Exception    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=getInstitutionsCode")
	public String getInstitutionsCode(HttpServletRequest request, ModelMap model)throws Exception{
		String orgCode=request.getParameter("orgCode");
		List<InfOrgArea> Listara=this.institutionsService.getAreaInfoByorgCode(orgCode);
		InfOrgs infOrgs=this.institutionsService.getInstitutionsCode(orgCode);
		model.addAttribute("Listara", Listara);
		model.addAttribute("infOrgs", infOrgs);

		return LocaleUtil.getUserLocalePath("data/institutions/institutionsDetail", request);
	}
	@ResponseBody
	@RequestMapping(params = "method=getAddOrgNameCount")
	public String getAddOrgNameCount(HttpServletRequest request){
	
		String orgName="";
		try {
			orgName = URLDecoder.decode(request.getParameter("orgName"),"UTF-8");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		};
		String flag="false";
		Integer count=this.institutionsService.getAddOrgNameCount(orgName);
		if(count!=0){
			flag="true";
		}
		return flag;
	}
}

