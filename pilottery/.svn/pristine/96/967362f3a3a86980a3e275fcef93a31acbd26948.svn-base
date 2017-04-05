package cls.pilottery.web.marketManager.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.web.marketManager.form.MMTransferRecordForm;
import cls.pilottery.web.marketManager.form.SalesDetailForm;
import cls.pilottery.web.marketManager.model.MMTransferRecordModel;
import cls.pilottery.web.marketManager.model.PayoutDetailModel;
import cls.pilottery.web.marketManager.model.ReturnDetailModel;
import cls.pilottery.web.marketManager.model.SalesDetailModel;
import cls.pilottery.web.marketManager.service.TransferRecordService;
import cls.pilottery.web.system.model.User;

@Controller
@RequestMapping("transferRecord")
public class TransferRecordController {
	Logger logger = Logger.getLogger(TransferRecordController.class);
	@Autowired
	private TransferRecordService transferRecordsService;
	
	@RequestMapping(params = "method=listMMTransferRecords")
	public String listMMTransferRecords(HttpServletRequest request, ModelMap model,MMTransferRecordForm form) {
		List<MMTransferRecordModel> list = null;
		int count = 0;
		try{
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			form.setCuserOrg(currentUser.getInstitutionCode());
			int pageIndex = PageUtil.getPageIndex(request);
			//form.setMarketManagerId(10);
			count = transferRecordsService.getTransferRecordCount(form);
			if (count > 0) {
				form.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
				form.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
				list = transferRecordsService.getTransferRecordList(form);
			}
		}catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			logger.error("市场管理员详情功能发生异常！", e);
			return "common/errorTip";
		}
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", list);
		model.addAttribute("form",form);
		return "marketManager/MMTransRecords/listMMTransferRecords";
	}
	
	/* 销售的详细交易记录 */
	@RequestMapping(params = "method=salesDetail")
	public String salesDetail(HttpServletRequest request , ModelMap model) {
		String contractNo = request.getParameter("contractNo");
		SalesDetailModel saleDetail_1 = transferRecordsService.getSaleDetailOne(contractNo);
		List<SalesDetailModel> saleDetail_2 =transferRecordsService.getSaleDetailTwo(contractNo);
		List<SalesDetailModel> saleDetail_3 =transferRecordsService.getSaleDetailThree(contractNo);
		model.addAttribute("saleDetail_1", saleDetail_1);
		model.addAttribute("saleDetail_2", saleDetail_2);
		model.addAttribute("saleDetail_3", saleDetail_3);
		return "marketManager/MMTransRecords/salesDetail";
	}

	/* 兑奖记录的详情 */
	@RequestMapping(params = "method=payoutRecordDetail")
	public String payoutRecordDetail(HttpServletRequest request , ModelMap model) {
		String contractNo = request.getParameter("contractNo");
		PayoutDetailModel payoutDetail_1 = transferRecordsService.getPayoutDetailOne(contractNo);
		List<PayoutDetailModel> payoutDetail_2 =transferRecordsService.getPayoutDetailTwo(contractNo);
		List<PayoutDetailModel> payoutDetail_3 =transferRecordsService.getPayoutDetailThree(contractNo);
		model.addAttribute("payoutDetail_1", payoutDetail_1);
		model.addAttribute("payoutDetail_2", payoutDetail_2);
		model.addAttribute("payoutDetail_3", payoutDetail_3);
		return "marketManager/MMTransRecords/payoutRecordDetail";
	}

	/* 退票记录的详情 */
	@RequestMapping(params = "method=returnRecordDetail")
	public String returnRecordDetail(HttpServletRequest request , ModelMap model) {
		String contractNo = request.getParameter("contractNo");
		ReturnDetailModel returnDetail_1 = transferRecordsService.getReturnDetailOne(contractNo);
		List<ReturnDetailModel> returnDetail_2 =transferRecordsService.getReturnDetailTwo(contractNo);
		List<ReturnDetailModel> returnDetail_3 =transferRecordsService.getReturnDetailThree(contractNo);
		model.addAttribute("returnDetail_1", returnDetail_1);
		model.addAttribute("returnDetail_2", returnDetail_2);
		model.addAttribute("returnDetail_3", returnDetail_3);
		return "marketManager/MMTransRecords/returnRecordDetail";
	}
}
