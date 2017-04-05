package cls.pilottery.web.goodsreceipts.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.web.goodsIssues.model.GoodsIssueDetailVo;
import cls.pilottery.web.goodsreceipts.model.GameBatchImportDetail;
import cls.pilottery.web.goodsreceipts.model.GamePlanVo;
import cls.pilottery.web.goodsreceipts.model.GamePlans;
import cls.pilottery.web.goodsreceipts.model.GoodReceiptParamt;
import cls.pilottery.web.goodsreceipts.model.GoodsStruct;
import cls.pilottery.web.goodsreceipts.service.GoodsReceiptsService;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.system.model.UserLanguage;

@Controller
@RequestMapping("/goodsReceiptsTmp")
public class GoodsReceiptsTempController {
	@Autowired
	private GoodsReceiptsService goodsReceiptsService;
	@RequestMapping(params = "method=receiptByInit", method = RequestMethod.GET)
	public String receiptByInit(HttpServletRequest request, ModelMap model){
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		if(currentUser.getWarehouseCode()!=null){
			String houseCode=currentUser.getWarehouseCode();
			List<GoodsIssueDetailVo> listvo=	this.goodsReceiptsService.getPlanListTemp(houseCode);
			
			Long sumTickets=new Long(0);
			if(!listvo.isEmpty()){
				for(GoodsIssueDetailVo vo:listvo){
					sumTickets+=vo.getTickets();
				}
				
			}
		
			model.addAttribute("listvo", listvo);
			model.addAttribute("sumTickets", sumTickets);
		}
		
		return LocaleUtil.getUserLocalePath("inventory/goodsReceipts/goodsReceiptsfirstTempStep", request);
		
	}
	@ResponseBody
	 @RequestMapping(params = "method=getGameBatchInfoTemp")
	 public List<GamePlanVo> getGameBatchInfoTemp(HttpServletRequest request){
		
		 List <GamePlanVo> listplan=this.goodsReceiptsService.getGameBatchInfoTemp();
		 return listplan;
	 }

	
	
	@RequestMapping(params = "method=goodsReceiptTempSecond", method = RequestMethod.POST)
	public String goodsReceiptTempSecond(HttpServletRequest request,ModelMap model,GoodReceiptParamt goodReceiptParamt){
		GoodsStruct gstruct=new GoodsStruct();
		
		try {
		
			HttpSession session = request.getSession();
			User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			goodReceiptParamt.setAdminId(currentUser.getId().intValue());
			if(currentUser.getWarehouseCode()!=null){
			goodReceiptParamt.setWarehouseCode(currentUser.getWarehouseCode());
			}else{
				User user = (User) request.getSession().getAttribute(
						SysConstants.CURR_LOGIN_USER_SESSION);
				if (user != null) {
					UserLanguage lg = user.getUserLang();
					if (lg == UserLanguage.ZH) {
						model.addAttribute("system_message","没有仓库!");

					} else if (lg == UserLanguage.EN) {
						model.addAttribute("system_message","Without this warehouse");
					}
				}
			
				// log.error("查询角色数据发生异常！", e);
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			}
			gstruct=this.goodsReceiptsService.addCallGoodTemps(goodReceiptParamt);
			//this.goodsReceiptsService.addGoodsBatch(goodReceiptParamt);
           
			if (gstruct.getC_errorcode() != 0) {
				throw new Exception(gstruct.getC_errormesg());
			}
			List<GoodsIssueDetailVo> listvo=this.goodsReceiptsService.getPlanListTempDiff(currentUser.getWarehouseCode());
			model.addAttribute("listvo", listvo);
			model.addAttribute("param", goodReceiptParamt);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			// log.error("查询角色数据发生异常！", e);
//			return "common/errorTip";
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}

	
		return LocaleUtil.getUserLocalePath("inventory/goodsReceipts/goodsReceiptsSencondTempStep", request);
		
//		return "inventory/goodsReceipts/goodsReceiptsSencondTempStep";
	}
	@RequestMapping(params = "method=goodsReceiptTempNext", method = RequestMethod.POST)
	public String goodsReceiptTempNext(HttpServletRequest request,ModelMap model,GoodReceiptParamt goodReceiptParamt){
	
		goodReceiptParamt.setOperType(2);
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		String houseCode=currentUser.getWarehouseCode();
		List<GoodsIssueDetailVo> listvo=	this.goodsReceiptsService.getPlanListTemp(houseCode);
		
		Long sumTickets=new Long(0);
		if(!listvo.isEmpty()){
			for(GoodsIssueDetailVo vo:listvo){
				sumTickets+=vo.getTickets();
			}
			
		}
	
		model.addAttribute("param", goodReceiptParamt);
		model.addAttribute("listvo", listvo);
	
		model.addAttribute("sumTickets", sumTickets);
		return LocaleUtil.getUserLocalePath("inventory/goodsReceipts/goodsReceiptsfirstTempStep", request);
//		return "inventory/goodsReceipts/goodsReceiptsfirstTempStep";
	}

}
