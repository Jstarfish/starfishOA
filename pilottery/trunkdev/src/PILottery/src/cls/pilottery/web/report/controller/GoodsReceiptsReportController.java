package cls.pilottery.web.report.controller;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import cls.pilottery.web.report.form.GoodsReceiptsReportForm;
import cls.pilottery.web.report.model.GoodsReceiptsReportVo;
import cls.pilottery.web.report.model.InstitutionModel;
import cls.pilottery.web.report.service.GoodsReceiptsReportService;
import cls.pilottery.web.warehouses.model.WarehouseInfo;

@Controller
@RequestMapping("goodsReceiptsReport")
public class GoodsReceiptsReportController {
	@Autowired
	private GoodsReceiptsReportService goodsReceiptsReportService;
	@RequestMapping(params="method=initGoodsReceiptsReport")
	public String initGoodsReceiptsReport(HttpServletRequest request , ModelMap model , GoodsReceiptsReportForm form){
		 List<WarehouseInfo> listhouse=this.goodsReceiptsReportService.getheadWhouseList();
		 Calendar cld = Calendar.getInstance();
		 /*String defaultDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
		 form.setBegDate(defaultDate);
		 form.setEndDate(defaultDate);*/
			
		 List<GoodsReceiptsReportVo> receiptsList=this.goodsReceiptsReportService.getReceiptsReportList(form);
		 GoodsReceiptsReportVo goodsReceiptsReportSum=this.goodsReceiptsReportService.getheadWhouseListSum(form);
		 model.addAttribute("listhouse", listhouse);
		 model.addAttribute("receiptsList",receiptsList);
		 model.addAttribute("goodsReceiptsReportSum",goodsReceiptsReportSum);
		 model.addAttribute("form", form);
		 return "report/goodsReceiptsReport";
	}
	@RequestMapping(params="method=queryGoodsReceiptsReport",method = RequestMethod.POST)
	public String queryGoodsReceiptsReport(HttpServletRequest request , ModelMap model , GoodsReceiptsReportForm form){
		 List<WarehouseInfo> listhouse=this.goodsReceiptsReportService.getheadWhouseList();
		 List<GoodsReceiptsReportVo> receiptsList=this.goodsReceiptsReportService.getReceiptsReportList(form);
		 GoodsReceiptsReportVo goodsReceiptsReportSum=this.goodsReceiptsReportService.getheadWhouseListSum(form);
		 model.addAttribute("listhouse", listhouse);
		 model.addAttribute("receiptsList",receiptsList);
		 model.addAttribute("goodsReceiptsReportSum",goodsReceiptsReportSum);
		 model.addAttribute("form", form);
		 return "report/goodsReceiptsReport";
	}
	@RequestMapping(params="method=initGoodsOutReport")
	public String initGoodsOutReport(HttpServletRequest request , ModelMap model , GoodsReceiptsReportForm form){
		 if(form == null || StringUtils.isEmpty(form.getBegDate())){
			 Calendar cld = Calendar.getInstance();
			 String defaultDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
			 form.setBegDate(defaultDate);
			 form.setEndDate(defaultDate);
		 }
			 List<WarehouseInfo> listhouse=this.goodsReceiptsReportService.getheadWhouseList();
			 List<GoodsReceiptsReportVo> receiptsOutList=this.goodsReceiptsReportService.getOutReportList(form);
			 GoodsReceiptsReportVo goodsOutReportSum=this.goodsReceiptsReportService.getheadWhouseListOutSum(form);
			 model.addAttribute("listhouse", listhouse);
			 model.addAttribute("receiptsList",receiptsOutList);
			 model.addAttribute("goodsReceiptsReportSum",goodsOutReportSum);
		 
		 model.addAttribute("form", form);
		 return "report/goodsOutReport";
	}
}
