package cls.pilottery.oms.business.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.oms.business.form.tmversionform.TerminalSoftWareForm;
import cls.pilottery.oms.business.model.TerminalType;
import cls.pilottery.oms.business.model.tmversionmodel.TerminalSoftWare;
import cls.pilottery.oms.business.service.TerminalSoftwareService;

@Controller
@RequestMapping("/terminalSoftWare")
public class TerminalSoftwareController {

	@Autowired
	private TerminalSoftwareService terminalSoftwareService;
	
	@ModelAttribute("terminalTypes")
	public List<TerminalType> getTerminalType(){
		List<TerminalType> terminalTypes = new ArrayList<TerminalType>();
		terminalTypes.add(new TerminalType(1));
		return terminalTypes;
	}

	@RequestMapping(params = "method=terminalSoftWareList")
	public String listTermSoft(HttpServletRequest request,
			HttpServletResponse response, ModelMap model, TerminalSoftWareForm terminalSoftWareForm) {

		TerminalSoftWare terminalSoftWare = terminalSoftWareForm.getTerminalSoftWare();
		
		List<TerminalSoftWare> list = new ArrayList<TerminalSoftWare>();
		Integer count = terminalSoftwareService.countTerminalSoftware(terminalSoftWareForm);
		
		int pageIndex = PageUtil.getPageIndex(request);
		
		if (count != null && count.intValue() != 0) {
			terminalSoftWare.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			terminalSoftWare.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			list = terminalSoftwareService.getTerminalSoftWareQuery(terminalSoftWareForm);
		}
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
        model.addAttribute("pageDataList", list);
        return LocaleUtil.getUserLocalePath("oms/tmversion/terminalSoftWareList", request);
	}
}