package cls.pilottery.web.capital.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.web.capital.form.ReturnRecoderForm;
import cls.pilottery.web.capital.model.returnmodel.ReturnRecoder;
import cls.pilottery.web.capital.service.ReturnRecoderService;
import cls.pilottery.web.system.model.User;

/**
 * 还货管理
 * 
 * @author jhx
 */
@Controller
@RequestMapping("/return")
public class ReturnRecordController {
	static Logger logger = Logger.getLogger(ReturnRecordController.class);

	@Autowired
	private ReturnRecoderService returnRecoderService;

	/**
	 * 还货管理列表和查询
	 */
	@RequestMapping(params = "method=listReturnDeliveries")
	public String listReturnRecoder(HttpServletRequest request, ModelMap model,
			ReturnRecoderForm returnRecoderForm) {
		
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		returnRecoderForm.setAdminOrg(currentUser.getInstitutionCode());
		List<ReturnRecoder> list = null;
		int count = 0;
		try {
			count = returnRecoderService.getReturnCount(returnRecoderForm);
			int pageIndex = PageUtil.getPageIndex(request);

			list = new ArrayList<ReturnRecoder>();
			if (count > 0) {
				returnRecoderForm.setBeginNum((pageIndex - 1)
						* PageUtil.pageSize);
				returnRecoderForm.setEndNum((pageIndex - 1) * PageUtil.pageSize
						+ PageUtil.pageSize);

				list = returnRecoderService.getReturnList(returnRecoderForm);
			}
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			logger.error("查询还货单列表功能发生异常！", e);
			return "_common/errorTip";
		}
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", list);
		model.addAttribute("returnRecoderForm", returnRecoderForm);
		return LocaleUtil.getUserLocalePath("capital/returnDeliveries/listReturnRecoder", request);
	}

	/* 初始化还货审批 */
	@RequestMapping(params = "method=initApproveReturn")
	public String initApproveReturn(HttpServletRequest request, ModelMap model) {
		String returnNo = request.getParameter("returnNo");
		ReturnRecoder returnRecordInfo = returnRecoderService
				.getReturnInfoById(returnNo);
		model.addAttribute("returnRecordInfo", returnRecordInfo);
		return LocaleUtil.getUserLocalePath("capital/returnDeliveries/approval", request);
	}

	/* 还货审批 */
	@RequestMapping(params = "method=approveReturn", method = RequestMethod.POST)
	public String approveReturn(HttpServletRequest request,
			HttpSession session, ModelMap model, ReturnRecoder returnRecorder) {
		try {
			User currentUser = (User) session
					.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			returnRecorder.setFinanceAdmin(currentUser.getId().intValue());
			String approveStatus = request.getParameter("approveStatus");
			if ("1".equals(approveStatus)) {
				returnRecorder.setStatus(7);
			} else {
				returnRecorder.setStatus(8);
			}
			returnRecoderService.updateReturnApproval(returnRecorder);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			logger.error("还货审批功能发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("common/successTip", request);
	}
}
