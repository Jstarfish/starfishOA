package cls.pilottery.web.capital.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.pilottery.common.constants.OperateLogType;
import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.HttpClientUtils;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.oms.monitor.model.OperateLog;
import cls.pilottery.oms.monitor.service.OperateLogService;
import cls.pilottery.pos.system.dao.BankTransDao;
import cls.pilottery.pos.system.model.bank.AgencyDigitalTranInfo;
import cls.pilottery.pos.system.model.bank.PayCenterQueryRequest;
import cls.pilottery.pos.system.model.bank.PayCenterQueryRespone;
import cls.pilottery.pos.system.service.impl.BankServiceImpl;
import cls.pilottery.web.capital.form.OutletBankQueryForm;
import cls.pilottery.web.capital.model.OutletBankAccount;
import cls.pilottery.web.capital.model.OutletBankTranFlow;
import cls.pilottery.web.capital.service.OutletBankService;
import cls.pilottery.web.system.model.User;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

/**
 * 站点银行充值提现管理Controller
 * @author dzg
 */

@Controller
@RequestMapping("/outletBank")
public class OutletBankController {
	static Logger logger = Logger.getLogger(OutletBankController.class);

	@Autowired
	private OutletBankService outletBankService;
	
	@Autowired
	private BankTransDao bankDao;
	
	@Autowired
	private OperateLogService operateLogService;


	/**
	 * 站点账户管理列表和查询
	 */
	@RequestMapping(params = "method=listOutletAcc")
	public String listOutletAcc(HttpServletRequest request,
			ModelMap model, OutletBankQueryForm outletAcctForm) {
		
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		
		outletAcctForm.setCurrAdmin(currentUser.getId().intValue());
		outletAcctForm.setCurrOrg(currentUser.getInstitutionCode());
		
		Integer count = outletBankService.getOutletListCount(outletAcctForm);
		int pageIndex = PageUtil.getPageIndex(request);
		List<OutletBankAccount> list = new ArrayList<OutletBankAccount>();
		if (count != null && count.intValue() != 0) {
			outletAcctForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			outletAcctForm.setEndNum((pageIndex - 1) * PageUtil.pageSize
					+ PageUtil.pageSize);
			list = outletBankService.getOutletList(outletAcctForm);
		}
		
		model.addAttribute("outletStatus", LocaleUtil.getUserLocaleEnum("outletStatus", request));
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", list);
		model.addAttribute("outletAcctForm", outletAcctForm);

		return LocaleUtil.getUserLocalePath("capital/bankTranManage/listOutletBankAcc", request);
	}

	/**
	 * 初始化站点账户修改页面
	 */
	
	@RequestMapping(params = "method=editOutletAccount")
	public String editOutletAccounts(HttpServletRequest request, ModelMap model) {
		String agencyCode = request.getParameter("bankAccSeq");
		OutletBankAccount OutletAcc = outletBankService.getAccInfoById(agencyCode);
		model.addAttribute("OutletAcc", OutletAcc);	
		return LocaleUtil.getUserLocalePath("capital/bankTranManage/editOutletBankAcc", request);
	}

	/**
	 * 修改站点账户信息
	 */
	@RequestMapping(params = "method=saveOutletAcct")
	public String saveOutletAcct(HttpServletRequest request,
			ModelMap model, OutletBankAccount outlet) {
		try {
			if (outlet == null)
				throw new Exception("Invalid Paramter.");
			
			//新增插入日志
			HttpSession session = request.getSession();
			User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			String agencyCode = outlet.getAgencyCode();

			outletBankService.updateBankAcc(outlet);
			
			String operContents = JSON.toJSONString(outlet);
			OperateLog operateLog = new OperateLog();
			operateLog.setOperPrivilege(1407);
			operateLog.setOperStatus(1);
			operateLog.setOperAdmin(currentUser.getId().intValue());
			operateLog.setOperModeId(OperateLogType.OUTLET_BANK_ACCOUNT_EDIT.getTypeCode()); // 操作类型设置为该功能的菜单编号
			operateLog.setOperContents(operContents);
			operateLog.setAgencyCode(agencyCode);
			try
			{
				operateLogService.insertOperateLog(operateLog);
			}catch (Exception e) {
				logger.error("Update outlet bank account,insert log error:"+e.getMessage());
			}
						
		} catch (Exception e) {
			request.setAttribute("system_message", e.getMessage());
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("common/successTip", request);
	}

	
	/**
	 * 初始化站点账户修改页面
	 */
	
	@RequestMapping(params = "method=addInitOutletAccount")
	public String addInitOutletAccount(HttpServletRequest request, ModelMap model) {
		return LocaleUtil.getUserLocalePath("capital/bankTranManage/addOutletBankAcc", request);
	}
	
	/**
	 * 修改站点账户信息
	 */
	@RequestMapping(params = "method=addOutletAcct")
	public String addOutletAcct(HttpServletRequest request,
			ModelMap model, OutletBankAccount outlet) {
		try {
			if (outlet == null)
				throw new Exception("Invalid Paramter.");
			
			//新增插入日志
			HttpSession session = request.getSession();
			User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			String agencyCode = outlet.getAgencyCode();

			outletBankService.insertBankAcc(outlet);
			if(outlet.getC_errcode() != 0)
			{
				throw new Exception(outlet.getC_errmsg());
			}
			
			String operContents = JSON.toJSONString(outlet);
			OperateLog operateLog = new OperateLog();
			operateLog.setOperPrivilege(1407);
			operateLog.setOperStatus(1);
			operateLog.setOperAdmin(currentUser.getId().intValue());
			operateLog.setOperModeId(OperateLogType.OUTLET_BANK_ACCOUNT_EDIT.getTypeCode()); // 操作类型设置为该功能的菜单编号
			operateLog.setOperContents(operContents);
			operateLog.setAgencyCode(agencyCode);
			try
			{
				operateLogService.insertOperateLog(operateLog);
			}catch (Exception e) {
				logger.error("insert outlet bank account,insert log error:"+e.getMessage());
			}
						
		} catch (Exception e) {
			request.setAttribute("system_message", e.getMessage());
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("common/successTip", request);
	}
	
	/*
	 * 获取账户信息，用于异步请求
	 */
	@ResponseBody
	@RequestMapping(params = "method=getOutletInfo")
	public String getOutletInfo(HttpServletRequest request) {
		Map<String, String> map = new HashMap<String, String>();
		String outletCode = request.getParameter("outletCode");		
		try {		
			OutletBankAccount acc = outletBankService.getOutletInfo(outletCode);		
			map.put("reservedSuccessMsg", "");
			map.put("agencyName", acc.getAgencyName());
			map.put("orgName", acc.getOrgName());
			map.put("adminName", acc.getAdminName());
			
		} catch (Exception e) {
			logger.error("errmsgs" + e.getMessage());
			map.put("reservedSuccessMsg", "Delete failed");
		}
		return JSONArray.toJSONString(map);
	}
	
	/*
	 * 更新账户状态
	 */
	@ResponseBody
	@RequestMapping(params = "method=updateOutletStatus")
	public String updateOutletStatus(HttpServletRequest request) {
		Map<String, String> map = new HashMap<String, String>();
		String bankAccSeq = request.getParameter("bankAccSeq");
		Short status =Short.parseShort(request.getParameter("status"));
		
		try {
			
			OutletBankAccount acc = new OutletBankAccount();
			acc.setBankAccSeq(bankAccSeq);
			acc.setStatus(status);
			outletBankService.updateBankAccStatus(acc);			
			map.put("reservedSuccessMsg", "");
			
		} catch (Exception e) {
			logger.error("errmsgs" + e.getMessage());
			map.put("reservedSuccessMsg", "Delete failed");
		}
		return JSONArray.toJSONString(map);
	}
	
	
	/**
	 * 站点充值记录查询
	 */
	@RequestMapping(params = "method=listTopupRecords")
	public String listTopupRecords(HttpServletRequest request,
			ModelMap model, OutletBankQueryForm outletAcctForm) {
		
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		
		outletAcctForm.setCurrAdmin(currentUser.getId().intValue());
		outletAcctForm.setCurrOrg(currentUser.getInstitutionCode());
		
		Integer count = outletBankService.getTopupFlowCount(outletAcctForm);
		int pageIndex = PageUtil.getPageIndex(request);
		List<OutletBankTranFlow> list = new ArrayList<OutletBankTranFlow>();
		if (count != null && count.intValue() != 0) {
			outletAcctForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			outletAcctForm.setEndNum((pageIndex - 1) * PageUtil.pageSize
					+ PageUtil.pageSize);
			list = outletBankService.getTopupFlow(outletAcctForm);
		}
		
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", list);
		model.addAttribute("tranStatus", LocaleUtil.getUserLocaleEnum("payTransStatus", request));
		model.addAttribute("outletAcctForm", outletAcctForm);

		return LocaleUtil.getUserLocalePath("capital/bankTranManage/listOutletTopupFlow", request);
	}

	
	/**
	 * 站点提现记录查询
	 */
	@RequestMapping(params = "method=listWithdrawRecords")
	public String listWithdrawRecords(HttpServletRequest request,
			ModelMap model, OutletBankQueryForm outletAcctForm) {
		
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		
		outletAcctForm.setCurrAdmin(currentUser.getId().intValue());
		outletAcctForm.setCurrOrg(currentUser.getInstitutionCode());
		
		Integer count = outletBankService.getWithdrawFlowCount(outletAcctForm);
		int pageIndex = PageUtil.getPageIndex(request);
		List<OutletBankTranFlow> list = new ArrayList<OutletBankTranFlow>();
		if (count != null && count.intValue() != 0) {
			outletAcctForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			outletAcctForm.setEndNum((pageIndex - 1) * PageUtil.pageSize
					+ PageUtil.pageSize);
			list = outletBankService.getWithdrawFlow(outletAcctForm);
		}
		
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", list);
		model.addAttribute("tranStatus", LocaleUtil.getUserLocaleEnum("payTransStatus", request));
		model.addAttribute("outletAcctForm", outletAcctForm);

		return LocaleUtil.getUserLocalePath("capital/bankTranManage/listOutletWithdrawFlow", request);
	}
	
	
	/*
	 * 更新账户状态
	 */
	@ResponseBody
	@RequestMapping(params = "method=handlerTrans")
	public String handlerTrans(HttpServletRequest request) {
		Map<String, String> map = new HashMap<String, String>();
		String tranFlow = request.getParameter("tranFlow");
		int type =Integer.parseInt(request.getParameter("type"));
		
		try {
			
			AgencyDigitalTranInfo di = new AgencyDigitalTranInfo();
			di.setTranFlow(tranFlow);
			di.setTranType(type);
			//type=1 topup; type=2 withdraw	
			
			PayCenterQueryRequest qreq = new PayCenterQueryRequest();
        	qreq.setEuser(BankServiceImpl.CompanyWingCode);
        	qreq.setAccount(BankServiceImpl.CompanyWingAccount);
        	qreq.setReqFlow(tranFlow);
        	qreq.setTransType(type);
        	

        	String hjson = JSONObject.toJSONString(qreq);
            logger.debug("向支付中心发送查询请求:" + BankServiceImpl.TBForQuery + "，请求内容："+hjson);

            String resJson = HttpClientUtils.postStringForBank(BankServiceImpl.TBForQuery, hjson);
            logger.debug("接收支付中心的查询响应，消息内容：" + resJson);
            
            //如果超时不处理，不超时则解析返回信息
            if(resJson.contains("timeout"))
            {
            	throw new Exception("Time out");
            }else if(resJson.contains("neterror"))
            {
            	throw new Exception("network state is not normal.");
            }
            else 
            {
            	PayCenterQueryRespone resp = JSON.parseObject(resJson, PayCenterQueryRespone.class);
            	if(resp.getErrorCode()==0 && resp.getIsSucc()==1)//成功
            	{

            		di.setBankFlow(resp.getWingFlow());
    				di.setFee(resp.getFee());
    				di.setExchangeRate(resp.getExchange());
    				di.setStatus(2);
    				di.setRepJsonData(resJson);
    				//处理成功
    				if(type==1)
    				{
    					//做充值成功处理
    					bankDao.updataTranLog(di);   					
    					
    				}else if(type==2)
    				{
    					//更新交易状态
    					bankDao.topupConfirm(di);   					
    				}
    				
            	}
            	//实际情况是wing没有查询结果，无法确认交易是否真的失败，需要手动处理，这种情况不存在
    		    else if(resp.getErrorCode()==0 && resp.getIsSucc()==1)//失败
            	{
            		di.setStatus(3);
            		di.setFailureReason(resp.getFailReason());
            		di.setRepJsonData(resJson);
            		//处理失败
    				if(type==1)
    				{
    					//更新状态
    					bankDao.updataTranLog(di);
    					
    				}else if(type==2)
    				{
    					//退款
    					bankDao.withdrawCancel(di);
    				}
    				
            	}
            	else{
            		throw new Exception(resp.getErrorMessage());
            	}
            }
			map.put("reservedSuccessMsg", "");
			
		} catch (Exception e) {
			logger.error("errmsgs" + e.getMessage());
			map.put("reservedSuccessMsg", "Handle failure for:"+e.getMessage());
		}
		return JSONArray.toJSONString(map);
	}
	
}
