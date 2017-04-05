package cls.pilottery.web.area.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.web.area.form.AreaForm;
import cls.pilottery.web.area.service.AreaService;

/**
 * 
 * @describe:区域的展示和搜索功能
 * 
 */
@Controller
@RequestMapping("/areas")
public class AreaController {

	static Logger logger = Logger.getLogger(AreaController.class);

	@Autowired
	private AreaService areaService;

	public AreaService getAreaService() {

		return areaService;
	}

	public void setAreaService(AreaService areaService) {

		this.areaService = areaService;
	}

	public AreaController() {

	}

	// 区域列表
	@RequestMapping(params = "method=listAreas")
	public String listArea(HttpServletRequest request , ModelMap model , @ModelAttribute("form")
	AreaForm form) throws Exception {

		Integer count = areaService.getAreaCount(form);
		int pageIndex = PageUtil.getPageIndex(request);
		List<AreaForm> areaList = new ArrayList<AreaForm>();
		if (count != null && count.intValue() != 0) {
			form.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			form.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			areaList = areaService.getAreaList(form);
			Map<Integer, String> areaStatus = LocaleUtil.getUserLocaleEnum("areaStatus", request);
			Map<Integer, String> areaType = LocaleUtil.getUserLocaleEnum("areaType", request);
			for (AreaForm area : areaList) {
				area.setStatusShow(areaType.get((int) area.getType()));
				area.setTypeShow(areaStatus.get((int) area.getStatus()));
			}
		}
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageAreaList", areaList);
		model.addAttribute("areaForm", form);
		return LocaleUtil.getUserLocalePath("data/areas/listAreas", request);
	}
	// 跳转到新增区域
	@RequestMapping(params = "method=addArea", method = RequestMethod.GET)
	public String addAreaSetup(HttpServletRequest request, ModelMap model)
			throws Exception {
		AreaForm af = new AreaForm();
		af.setStatus((short) 1);
		
		model.addAttribute("areaForm", af);
		return LocaleUtil.getUserLocalePath("data/areas/addArea", request);
	}
}