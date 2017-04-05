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

import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.web.logistics.form.PayoutForm;
import cls.pilottery.web.logistics.model.LogisticsList;
import cls.pilottery.web.logistics.model.LogisticsResult;
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

	public LogisticsController() {

	}

	// 查询页面
	@RequestMapping(params = "method=initLogistics")
	public String listArea(HttpServletRequest request , ModelMap model) throws Exception {

		String logisticsCode = request.getParameter("logisticsCode");
		if (logisticsCode == null || logisticsCode == "") {
			return LocaleUtil.getUserLocalePath("inventory/logisticsInfo/logistInfo", request);
		}
		LogisticsList logistics = service.getLogistics(logisticsCode);
		List<LogisticsResult> result = logistics.getResult();
		if (result == null) {
			return LocaleUtil.getUserLocalePath("inventory/logisticsInfo/logistInfo", request);
		}
		PayoutForm form = null;
		Date rewardTime = logistics.getRewardTime();
		if (rewardTime != null) {
			form = service.getPayout(logisticsCode);
		}
		Map<Integer, String> localE = LocaleUtil.getUserLocaleEnum("outOrInputStatus", request);
		for (LogisticsResult re : result) {
			re.setType(localE.get(re.getObjType()));
			re.setWareHouseType(service.getWarehousename(re.getWarehouseNo()));
			if (re.getOperator() != null && re.getOperator() != "")
				re.setOperatorName(service.getUserName(re.getOperator()));
		}
		model.addAttribute("form", form);
		model.addAttribute("logistics", result);
		return LocaleUtil.getUserLocalePath("inventory/logisticsInfo/logistInfo", request);
	}
}