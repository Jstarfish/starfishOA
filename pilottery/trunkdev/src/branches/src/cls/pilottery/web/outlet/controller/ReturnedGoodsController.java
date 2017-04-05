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

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.web.outlet.form.ReturnedGoodsForm;
import cls.pilottery.web.outlet.model.SaleAgencyReturnVo;
import cls.pilottery.web.outlet.service.ReturnedGoodsService;
import cls.pilottery.web.system.model.User;

@Controller
@RequestMapping("/returnedGoods")
public class ReturnedGoodsController {
	static Logger logger = Logger.getLogger(ReturnedGoodsController.class);
	@Autowired
	private ReturnedGoodsService returnedGoodsService;
	/**
	 * 
	    * @Title: returnGoodsList
	    * @Description: 退货查询
	    * @param @param request
	    * @param @param model
	    * @param @param returnedGoodsForm
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
	@RequestMapping(params = "method=returnGoodsList")
	public String returnGoodsList(HttpServletRequest request, ModelMap model,
			@ModelAttribute("returnedGoodsForm") ReturnedGoodsForm returnedGoodsForm){
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		returnedGoodsForm.setOrgCode(currentUser.getInstitutionCode());
		Integer count =returnedGoodsService.geetSaleReturnCount(returnedGoodsForm);
		List<SaleAgencyReturnVo> listsal=new ArrayList<SaleAgencyReturnVo>();
		
		int pageIndex = PageUtil.getPageIndex(request);
		
		
		if (count != null && count.intValue() != 0) {
			returnedGoodsForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			returnedGoodsForm.setEndNum((pageIndex - 1) * PageUtil.pageSize
					+ PageUtil.pageSize);

			listsal =this.returnedGoodsService.geetSaleReturnList(returnedGoodsForm);
		}
		
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", listsal);
		return LocaleUtil.getUserLocalePath("data/outlets/returnGoodsList", request);
		
	}
}
