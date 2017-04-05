package cls.pilottery.web.payout.controller;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.packinfo.PackInfo;
import cls.pilottery.web.payout.model.PayoutRecord;
import cls.pilottery.web.payout.model.WinInfo;
import cls.pilottery.web.payout.service.PayoutService;
import cls.pilottery.web.sales.model.PlanModel;
import cls.pilottery.web.sales.service.OrderService;
import cls.pilottery.web.system.model.User;

@Controller
@RequestMapping("/payout")
public class PayoutController {

	Logger logger = Logger.getLogger(PayoutController.class);

	@Autowired
	private PayoutService service;

	@Autowired
	private OrderService orderService;

	public PayoutService getService() {

		return service;
	}

	public void setService(PayoutService service) {

		this.service = service;
	}

	@RequestMapping(params = "method=listPayout")
	public String listPayoutRecord(HttpServletRequest request , ModelMap model , @ModelAttribute("payout")
	PayoutRecord payout) throws ParseException {

		String insCode = ((User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION))
				.getInstitutionCode();
		payout.setInsCode(insCode);
		Integer count = service.getPayoutCount(payout);
		int pageIndex = PageUtil.getPageIndex(request);
		List<PayoutRecord> list = new ArrayList<PayoutRecord>();
		List<PlanModel> planList = orderService.getPlanListByOrg(insCode);
		model.addAttribute("planList", planList);
		if (count != null && count.intValue() != 0) {
			payout.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			payout.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			list = service.getPayoutList(payout);
			Map<Integer, String> local = LocaleUtil.getUserLocaleEnum("sex", request);
			for (PayoutRecord l : list) {
				l.setSexEn(local.get(Integer.valueOf(l.getSex())));
			}
		}
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("payoutList", list);
		model.addAttribute("form", payout);
		return "payout/listPayoutRecords";
	}

	@RequestMapping(params = "method=payoutDetail")
	public String payoutDetail(HttpServletRequest request , ModelMap model) throws ParseException {

		String recordNo = request.getParameter("recordNo");
		PayoutRecord record = service.getPayoutDetail(recordNo);
		Map<Integer, String> local = LocaleUtil.getUserLocaleEnum("sex", request);
		record.setSexEn(local.get((int) record.getSex()));
		model.addAttribute("record", record);
		return "payout/detailsPayout";
	}

	@RequestMapping(params = "method=initProcessPayout")
	public String intiProcessPayout() {

		return "payout/payoutFirst";
	}

	@ResponseBody
	@RequestMapping(params = "method=firstStep")
	public String FirstStep(HttpServletRequest request , ModelMap model) throws Exception {

		try {
			String inputCode = request.getParameter("safeCode");
			if (StringUtils.isEmpty(inputCode) || inputCode.length()<41){
				return "error";
			}
			//调用工厂方法获取包装类
			//PackInfo packInfo = PackHandleFactory.getPayPackInfo(inputCode);
			PackInfo packInfo = new PackInfo();
			packInfo.setPlanCode(inputCode.substring(0,5));
			packInfo.setBatchCode(inputCode.substring(5,10));
			packInfo.setFirstPkgCode(inputCode.substring(10, 17));
			packInfo.setSafetyCode(inputCode.substring(20, 36));
			packInfo.setPaySign(inputCode.substring(36, 41));
			
			String insCode = ((User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION))
					.getInstitutionCode();
			//兑奖级别（1=站点、2=分公司、3=总公司）
			int plevel = 2;
			if(insCode != null && insCode.trim().equals("00"))
				plevel = 3;
			packInfo.setPayLevel(plevel);
			//调用存储过程查看中奖信息
			logger.debug("执行存储过程:p_get_lottery_reward");
			logger.debug(packInfo);
			WinInfo win = service.isValided(packInfo);
			logger.debug("error code:"+win.getC_errcode());
			logger.debug("error msg:"+win.getC_errmsg());
			logger.debug(win.toString());
			
			//返回一个结果 : 0中奖 1大奖 2 未中奖 3 已兑奖 4 未销售或无效
			int valided = win.getWinResult();
			if (valided == 0) {
				request.getSession().setAttribute("theCode", inputCode);
				return "successful";
			}else if (valided == 1) {
				if( plevel == 2)
				return "out";
				else
				{
					request.getSession().setAttribute("theCode", inputCode);
					return "successful";
				}
			} 
			else if (valided == 2) {
				return "no";
			} else if (valided == 3) {
				return "already";
			} else if (valided == 4) {
				return "nosale";
			} else if (valided == 8) {
				return "terminated";
			} else
				return "error";
		} catch (Exception e) {
			System.out.println("errMess:" + e.getMessage());
			return "error";
		}
	}

	@RequestMapping(params = "method=initSecStep")
	public String initSecStep(HttpServletRequest request , ModelMap model) throws Exception {

		try {
			String inputCode = request.getParameter("safeCode");
			//PackInfo packInfo = PackHandleFactory.getPayPackInfo(inputCode);
			if (StringUtils.isEmpty(inputCode) || inputCode.length()<41){
				throw new Exception("Invalid barcode.");
			}
			PackInfo packInfo = new PackInfo();
			packInfo.setPlanCode(inputCode.substring(0,5));
			packInfo.setBatchCode(inputCode.substring(5,10));
			packInfo.setFirstPkgCode(inputCode.substring(10, 17));
			packInfo.setPackUnitCode(inputCode.substring(17, 20));
			packInfo.setSafetyCode(inputCode.substring(20, 36));
			packInfo.setPaySign(inputCode.substring(36, 41));
			
			
			String insCode = ((User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION))
					.getInstitutionCode();
			//兑奖级别（1=站点、2=分公司、3=总公司）
			int plevel = 2;
			if(insCode != null && insCode.trim().equals("00"))
				plevel = 3;
			packInfo.setPayLevel(plevel);
			
			//调用存储过程查看中奖信息
			WinInfo win = service.isValided(packInfo);
			logger.debug("执行存储过程p_get_lottery_reward");
			logger.debug(win.toString());
			logger.debug("error code:"+win.getC_errcode());
			logger.debug("error message:"+win.getC_errmsg());
			
			//返回一个结果 : 0中奖 1大奖 2 未中奖 3 已兑奖 4 未销售或无效
			int valided = win.getWinResult();
			if (valided == 2) {
				throw new Exception("This ticket is not a winning ticket.");
			} else if (valided == 3) {
				throw new Exception("This ticket has already been paid.");
			} else if (valided == 4) {
				throw new Exception("This ticket has not been sold or is invalid .");
			} else if (valided == 1 &&  plevel == 2) {
				throw new Exception("Out of the pay limit .");
			} else if (valided == 8) {
				throw new Exception("This batch is terminated .");
			}
			String planCode = packInfo.getPlanCode();
			String batchCode = packInfo.getBatchCode();
			
			Map<String,String> map = new HashMap<String,String>();
			map.put("planCode", planCode);
			map.put("batchCode", batchCode);
			String planName=service.getPlanName(map);
			packInfo.setPlanName(planName);
			request.getSession().setAttribute("ticketNum", inputCode.substring(17, 20));
			request.getSession().setAttribute("safeCode", inputCode.substring(20, 41));
			request.getSession().setAttribute("packInfo", packInfo);
			String trunkBox = service.getNum(inputCode);
			PayoutRecord form = new PayoutRecord();
			form.setSafeCode(packInfo.getPaySign());
			form.setPlanCode(packInfo.getPlanCode());
			form.setBatchCode(packInfo.getBatchCode());
			//String amount = service.getAmount(form);
			model.addAttribute("amount", win.getAmount());
			model.addAttribute("packInfo", packInfo);
			model.addAttribute("trunkBox", trunkBox);
			return "payout/payoutSecStep";
		} catch (Exception e) {
			model.addAttribute("system_message", e.getMessage());
			logger.error("兑奖异常" + e);
			e.printStackTrace();
			return "common/errorTip";
		}
	}

	@RequestMapping(params = "method=secStep")
	public String secStep() {

		return "payout/payoutThiStep";
	}

	@RequestMapping(params = "method=secStep1")
	public String secStep1() {

		return "payout/payoutThiStep1";
	}

	@RequestMapping(params = "method=thirdStep")
	public String thirdStep(HttpServletRequest request , ModelMap model) throws Exception {

		PayoutRecord record = new PayoutRecord();
		record.setAge(Integer.valueOf(request.getParameter("age")));
		record.setSex(Short.valueOf(request.getParameter("sex")));
		String winnername = request.getParameter("winnerName");
		//winnername=winnername.replace(" ", "+");
		record.setWinnerName(winnername);
		String contact = request.getParameter("contact");
		//contact=contact.replace(" ", "+");
		record.setContact(contact);
		String personnal=request.getParameter("personalId");
		//personnal=personnal.replace(" ", "+");
		record.setPersonalId(personnal);
		PackInfo info = (PackInfo) request.getSession().getAttribute("packInfo");
		String planCode = info.getPlanCode();
		String batchCode = info.getBatchCode();
		Map<String,String> map = new HashMap<String,String>();
		map.put("planCode", planCode);
		map.put("batchCode", batchCode);
		String planName=service.getPlanName(map);
		info.setPlanName(planName);
		long userid = ((User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION)).getId();
		String username = service.getUsername(userid);
		record.setOperaName(username);
		record.setOperator(userid);
		record.setTicketNo(Integer.parseInt(info.getPackUnitCode()));
		record.setPlanCode(info.getPlanCode());
		record.setPaidType(1);
		record.setBatchCode(info.getBatchCode());
		record.setSafeCode(info.getSafetyCode() + info.getPaySign());
		record.setPackageNo(info.getFirstPkgCode());
		record.setPayAgency("");
		try {
			service.payout(record);
			logger.error("执行存储过程P_LOTTERY_REWARD,执行结果:");
			logger.error("errorCode:" + record.getC_errcode());
			logger.error("errorMsg:" + record.getC_errmsg());
			if (record.getC_errcode() == 0) {
				String code = record.getSafeCode();
				String flow = service.getPayFlow1(code);
				Map<Integer, String> sex = LocaleUtil.getUserLocaleEnum("sex", request);
				record.setSexEn(sex.get((int) record.getSex()));
				model.addAttribute("flow", flow);
				model.addAttribute("orgs", service.getOrgByUser(userid));
				model.addAttribute("record", record);
				model.addAttribute("info", info);
				model.addAttribute("date", new Date());
				return "payout/certificate";
			}
			logger.error("errmsgs" + record.getC_errmsg());
			model.addAttribute("system_message", record.getC_errmsg());
			return "common/errorTip";
		} catch (Exception e) {
			model.addAttribute("system_message", e.getMessage());
			logger.error("兑奖异常" + e);
			return "common/errorTip";
		}
	}

	@RequestMapping(params = "method=print")
	public String print(HttpServletRequest request , ModelMap model) {

		String recordNo = request.getParameter("recordNo");
		//long userid = ((User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION)).getId();
		//String username = service.getUsername(userid);
		//InfOrgs user = service.getOrgByUser(userid);
		PayoutRecord record = service.getPrintRecord(recordNo);
		//record.setOperaName(username);
		record.setSexEn(LocaleUtil.getUserLocaleEnum("sex", request).get((int) record.getSex()));
		model.addAttribute("record", record);
		//model.addAttribute("user", user);
		model.addAttribute("recordNo", recordNo);
		model.addAttribute("date", new Date());
		return "payout/certificatePrint";
	}
}
