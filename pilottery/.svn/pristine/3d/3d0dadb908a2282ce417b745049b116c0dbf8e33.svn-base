package cls.pilottery.web.logistics.controller;

import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.packinfo.PackHandleFactory;
import cls.pilottery.packinfo.PackInfo;
import cls.pilottery.web.goodsreceipts.model.GameBatchImport;
import cls.pilottery.web.goodsreceipts.model.GamePlans;
import cls.pilottery.web.goodsreceipts.service.GoodsReceiptsService;
import cls.pilottery.web.inventory.service.CheckPointService;
import cls.pilottery.web.logistics.form.LogisticsForm;
import cls.pilottery.web.logistics.model.LogisticsList;
import cls.pilottery.web.logistics.model.LogisticsResult;
import cls.pilottery.web.logistics.model.PayoutModel;
import cls.pilottery.web.logistics.service.LogisticsService;

/**
 * 
 * @describe:区域的展示和搜索功能
 * 
 */
@Controller
@RequestMapping("/logistics")
 public class LogisticsController {

	static Logger logger = Logger.getLogger(LogisticsController.class);

	@Autowired
	LogisticsService service;
	@Autowired
	private GoodsReceiptsService goodsReceiptsService;
	@Autowired
	private CheckPointService checkPointService;

	public LogisticsController() {

	}

	// 查询页面
	@RequestMapping(params = "method=initLogistics")
	public String listArea(HttpServletRequest request , ModelMap model,LogisticsForm form) throws Exception {
		try {
			List<GamePlans> planList = goodsReceiptsService.getAllGamePlan();
			model.addAttribute("planList",planList);
			
			if(form == null || form.getQueryType() == null){
				return "inventory/logisticsInfo/logistInfo";
			}
			if(form.getQueryType().equals("1")){
				String logisticsCode = form.getLogisticsCode();
				PackInfo pi = PackHandleFactory.getPackInfo(logisticsCode);
				if(pi==null){
					model.addAttribute("system_message", "Invalid Barcode");
					return "common/errorTip";
				}
				switch(pi.getPackUnit()){
				case Trunck :
					form.setSpecification("1");
					break;
				case Box :
					form.setSpecification("2");
					break;
				case pkg:
					form.setSpecification("3");
					break;
				default : 
					form.setSpecification("4");
				}
				form.setPlanCode(pi.getPlanCode());
				form.setBatchCode(pi.getBatchCode());
				form.setTagCode(pi.getPackUnitCode());
				form.setTicketNo(pi.getTicketNum()+"");
				
			}else if(form.getQueryType().equals("2")){
				if(form.getSpecification().equals("4")){	//如果是票
					String[] tagCodes = form.getPackUnitCode().split("-");
					if(tagCodes !=null && tagCodes.length>2){
						form.setTagCode(tagCodes[0]);
						form.setTicketNo(tagCodes[1]);
					}
				}else{
					form.setTagCode(form.getPackUnitCode());
				}
			}
			
			LogisticsList logistics = service.getLogistics(form);
			
			if(logistics==null){
				model.addAttribute("system_message", "Invalid Barcode");
				return "common/errorTip";
			}
			List<LogisticsResult> result = logistics.getResult();
			if (logistics != null && result != null) {
				PayoutModel payout = null;
				Date rewardTime = logistics.getRewardTime();
				if (rewardTime != null) {
					payout = service.getPayout(form);
				}
				Map<Integer, String> localE = LocaleUtil.getUserLocaleEnum("outOrInputStatus", request);
				for (LogisticsResult re : result) {
					re.setType(localE.get(re.getObjType()));
					re.setWareHouseType(re.getWarehouseNo());
					if (re.getOperator() != null && re.getOperator() != "")
						re.setOperatorName(re.getOperator());
				}
				model.addAttribute("payout", payout);
			}
			model.addAttribute("form", form);
			model.addAttribute("logistics", result);
			return "inventory/logisticsInfo/logistInfo";
		} catch (Exception e) {
			logger.error("物流查询失败：" + e.getMessage());
			model.addAttribute("system_message", e.getMessage());
			return "common/errorTip";
		}
	}
	
	@ResponseBody
	@RequestMapping(params = "method=getBatchList")
	public List<GameBatchImport> getBatchList(HttpServletRequest request) {
		String planCode = "";
		planCode = request.getParameter("planCode");
		GameBatchImport gameBatchImport = new GameBatchImport();
		gameBatchImport.setPlanCode(planCode);
		List<GameBatchImport> listvo = checkPointService.getGameBatchListBCode(gameBatchImport);
		return listvo;
	}
}