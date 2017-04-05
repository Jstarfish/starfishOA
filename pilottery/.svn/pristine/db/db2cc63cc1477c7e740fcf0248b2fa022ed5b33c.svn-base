package cls.pilottery.oms.game.controller;
/**
 * 基金、发行费管理Controller
 * @author Woo
 */
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.fastjson.JSONArray;

import cls.pilottery.common.EnumConfig;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.oms.game.form.FundManagementForm;
import cls.pilottery.oms.game.model.FundAdj;
import cls.pilottery.oms.game.model.FundAdjHistory;
import cls.pilottery.oms.game.model.FundAdjHistoryVo;
import cls.pilottery.oms.game.model.GameInfo;
import cls.pilottery.oms.game.model.GovernmentCommision;
import cls.pilottery.oms.game.service.FundManagementService;
import cls.pilottery.oms.game.service.GameManagementService;
import cls.pilottery.web.system.model.User;


@Controller
@RequestMapping("fundManagement")
public class FundManagementController {
	
	static Logger logger = Logger.getLogger(FundManagementController.class);

	@Autowired
	private FundManagementService fundManagementService;
	@Autowired
	private GameManagementService gameManagementService;
	
	/**
	 * 数据准备: 游戏MAP
	 */
	@ModelAttribute("gameInfoMap")
	public Map<Short,String> refGameInfoMap() {
		return gameManagementService.getGameInfoMap();
	}
	
	/**
	 * 数据准备: 调节基金变更类型
	 */
	@ModelAttribute("fundChangeType")
	public Map<Integer,String> refFundChangeTypeMap() {
		return EnumConfig.fundChangeTypeItems;
	}
	
	@RequestMapping(params = "method=fundList")
	public String fundList(HttpServletRequest request,HttpServletResponse response,
			FundManagementForm fundManagementForm,ModelMap model)throws Exception {
		
		List<GameInfo> games = gameManagementService.getGameInfo();
		FundAdj fundAdj = fundManagementForm.getFundAdj();
		if(fundAdj.getGameCode() == null)
			fundAdj.setGameCode(games.get(0).getGameCode());
		Integer count = fundManagementService.getFundAdjListCount(fundManagementForm);
		int pageIndex = PageUtil.getPageIndex(request);
		List<FundAdjHistory> list = new ArrayList<FundAdjHistory>();
		if (count != null && count.intValue() != 0) {
			fundAdj.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			fundAdj.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);

			list = fundManagementService.getFundAdjList(fundManagementForm);
		}
		
		model.addAttribute("games", games);
        model.addAttribute("pageDataList", list);
        model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
        
		return LocaleUtil.getUserLocalePath("oms/game/fund/fundList", request);
	}
	
	//创建调节基金流水记录
	@RequestMapping(params = "method=createFundAdj")
	public String createFundAdj(HttpServletRequest request, ModelMap model) throws Exception {
		List<GameInfo> games = gameManagementService.getGameInfo();
		FundManagementForm createForm = new FundManagementForm();
		model.addAttribute("games", games);
		model.addAttribute("createForm", createForm);
		return LocaleUtil.getUserLocalePath("oms/game/fund/createFundAdj", request);
	}
	
	//保存调节基金流水记录
	@RequestMapping(params = "method=saveFundAdj")
	public String saveFundAdj(HttpServletRequest request, ModelMap model, FundManagementForm createForm) {
		
		User currentUser = (User)request.getSession().getAttribute("current_user");
		
		try {
			FundAdj fa = createForm.getFundAdj();
			fa.setAdjAmount(fa.getAdjAmount());
			fa.setAdjTime(new Date());
			fa.setAdjAdmin(currentUser.getId());
			fundManagementService.insertFundAdj(fa);
			if(fa.getC_errcode()!=0){
				logger.error("errmsgs:" + fa.getC_errmsg());
				model.addAttribute("system_message", fa.getC_errmsg());
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			} else {
				logger.debug("保存调节基金流水记录;");
				logger.debug("操作者["+currentUser.getId() +";"+JSONArray.toJSONString(fa));
				return LocaleUtil.getUserLocalePath("common/successTip", request);
			}
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
	}
	
	// 期次调节基金信息
	@RequestMapping(params="method=issueFundInfo")
	public String issueFundInfo(HttpServletRequest request, ModelMap model,FundManagementForm fundManagementForm) {
		
		List<GameInfo> games = gameManagementService.getGameInfo();
		FundAdjHistoryVo vo = fundManagementForm.getFundAdjHistoryVo();
		if(vo.getGameCode() == null){
			vo.setGameCode(games.get(0).getGameCode());
		}
		Integer count = fundManagementService.getFundAdjHistoryListCount(fundManagementForm);
		int pageIndex = PageUtil.getPageIndex(request);
		List<FundAdjHistoryVo> list = new ArrayList<FundAdjHistoryVo>();
		if (count != null && count.intValue() != 0) {
			vo.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			vo.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);

			list = fundManagementService.getFundAdjHistoryList(fundManagementForm);
		}
		
		model.addAttribute("games", games);
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
        model.addAttribute("pageDataList", list);
        
		return LocaleUtil.getUserLocalePath("oms/game/fund/issueFundInfo", request);
	}
	
	//发行费管理
	@RequestMapping(params="method=govCommision")
	public String govCommision(HttpServletRequest request, ModelMap model,FundManagementForm fundManagementForm) {
		
		List<GameInfo> games = gameManagementService.getGameInfo();
		GovernmentCommision governmentCommision = fundManagementForm.getGovernmentCommision();
		if(governmentCommision.getGameCode() == null)
			governmentCommision.setGameCode(games.get(0).getGameCode());
		Integer count = fundManagementService.getGovernmentCommisionListCount(fundManagementForm);
		List<GovernmentCommision> list = new ArrayList<GovernmentCommision>();
		int pageIndex = PageUtil.getPageIndex(request);

		if (count != null && count.intValue() != 0) {
			governmentCommision.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			governmentCommision.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);

			list = fundManagementService.getGovernmentCommisionList(fundManagementForm);
		}
		
		model.addAttribute("games", games);
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
        model.addAttribute("pageDataList", list);
        
		return LocaleUtil.getUserLocalePath("oms/game/fund/govCommision", request);
	}
}
