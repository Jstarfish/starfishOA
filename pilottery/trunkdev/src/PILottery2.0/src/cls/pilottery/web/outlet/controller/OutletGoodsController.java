package cls.pilottery.web.outlet.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.web.outlet.form.OutletGoodsForm;
import cls.pilottery.web.outlet.model.SaleAgencyReceiptVo;
import cls.pilottery.web.outlet.service.OutletGoodsService;
import cls.pilottery.web.system.model.User;

@Controller
@RequestMapping("/outletGoods")
public class OutletGoodsController {
	static Logger logger = Logger.getLogger(OutletGoodsController.class);
	@Autowired
   private OutletGoodsService outletGoodsService;
   /**
    * 
       * @Title: outlsetGoodsList
       * @Description: 站点入库查询
       * @param @param request
       * @param @param model
       * @param @param outletGoodsForm
       * @param @return    参数
       * @return String    返回类型
       * @throws
    */
   @RequestMapping(params = "method=outletGoodsList")
   public String outletGoodsList(HttpServletRequest request, ModelMap model,
			@ModelAttribute("outletGoodsForm") OutletGoodsForm outletGoodsForm){
	   HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		outletGoodsForm.setOrgCode(currentUser.getInstitutionCode());
	   Integer count =outletGoodsService.getOutletGoodsCount(outletGoodsForm);
		List<SaleAgencyReceiptVo> listsal=new ArrayList<SaleAgencyReceiptVo>();
		
		int pageIndex = PageUtil.getPageIndex(request);
		
		
		if (count != null && count.intValue() != 0) {
			outletGoodsForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			outletGoodsForm.setEndNum((pageIndex - 1) * PageUtil.pageSize
					+ PageUtil.pageSize);

			listsal =this.outletGoodsService.getOutletGoodsCountList(outletGoodsForm);
		}
		
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", listsal);
		return LocaleUtil.getUserLocalePath("data/outlets/outlsetGoodsList", request);
//		return "data/outlets/outlsetGoodsList";
   }
}
