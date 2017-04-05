package cls.pilottery.oms.business.controller;

import java.lang.reflect.Method;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.oms.business.form.tmversionform.SoftwarePackageForm;
import cls.pilottery.oms.business.model.TerminalType;
import cls.pilottery.oms.business.model.tmversionmodel.PackageContext;
import cls.pilottery.oms.business.model.tmversionmodel.SimpleSoftPack;
import cls.pilottery.oms.business.model.tmversionmodel.SoftwarePackage;
import cls.pilottery.oms.business.service.SoftwarePackageService;

import com.alibaba.fastjson.JSONArray;

@Controller
@RequestMapping("/tmversionPackage")
public class SoftwarePackageController {
	Logger log = Logger.getLogger(NotifyController.class);
	@Autowired
	private SoftwarePackageService packService;

	@ModelAttribute("terminalTypes")
	public List<TerminalType> getTerminalType() {
		List<TerminalType> terminalTypes = new ArrayList<TerminalType>();
		terminalTypes.add(new TerminalType(1));
		terminalTypes.add(new TerminalType(2));
		return terminalTypes;
	}

	@RequestMapping(params = "method=listSoftPackage")
	public String getPackages(HttpServletRequest request, ModelMap model, SoftwarePackage softwarePackage) {
		List<SoftwarePackage> list = new ArrayList<SoftwarePackage>();
		int count = packService.getCount();// 查询总数
		int pageIndex = PageUtil.getPageIndex(request);
		if (count > 0) {
			softwarePackage.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			softwarePackage.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			list = packService.getSoftwarePackages(softwarePackage);// 查询
		}
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", list);
		return LocaleUtil.getUserLocalePath("oms/tmversion/softPackagetList", request);
	}

	// add
	@RequestMapping(params = "method=addSoftVerPackage", method = RequestMethod.GET)
	public String addSoftPackSetup(HttpServletRequest request, ModelMap model) throws Exception {

		SoftwarePackage sp = new SoftwarePackage();
		SoftwarePackageForm spf = new SoftwarePackageForm();
		model.addAttribute("softPackage", sp);
		model.addAttribute("softPackageForm", spf);
		return LocaleUtil.getUserLocalePath("oms/tmversion/addSoftPackage", request);
	}

	/**
	 * 新增软件包
	 * 
	 * @param request
	 * @param model
	 * @param softPackage
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params = "method=addSoftVerPackage", method = RequestMethod.POST)
	public String addSoftPack(HttpServletRequest request, ModelMap model, @ModelAttribute SoftwarePackage softPackage) throws Exception {
		try {
			packService.insertPackage(softPackage); // 普通sql
			model.addAttribute("reservedHrefURL", "tmversionPackage.do?method=listSoftPackage");
			return LocaleUtil.getUserLocalePath("common/successTip", request);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
	}

	/**
	 * 修改软件包有效性
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(params = "method=editValid", method = RequestMethod.GET)
	public String editValidSetup(HttpServletRequest request, ModelMap model) {

		String packVer = request.getParameter("packVer");
		String termTypeStr = request.getParameter("termType");
		String validStr = request.getParameter("valid");

		SoftwarePackage sp = new SoftwarePackage();
		sp.setPackageVersion(packVer);
		sp.setTerminalType(Integer.parseInt(termTypeStr));
		sp.setIsValid(Integer.parseInt(validStr));

		model.addAttribute("softPackage", sp);

		model.addAttribute("valid", sp.getIsValid());
		if (sp.getIsValid() == 1) {// 有效
			sp.setIsValid(2);
			model.addAttribute("validDesc", "有效");
			model.addAttribute("validStr", "禁用");
		} else {
			sp.setIsValid(1);
			model.addAttribute("validDesc", "无效");
			model.addAttribute("validStr", "启用");
		}
		return LocaleUtil.getUserLocalePath("oms/tmversion/editSoftPackageValid", request);
	}

	@RequestMapping(params = "method=editValid", method = RequestMethod.POST)
	public String editValid(HttpServletRequest request, ModelMap model, @ModelAttribute("softPackage") SoftwarePackage softPackage) {
		try {
			packService.updatePackageValid(softPackage);

			model.addAttribute("reservedHrefURL", "tmversionPackage.do?method=listSoftPackage");
			return LocaleUtil.getUserLocalePath("common/successTip", request);

		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}

	}

	@ResponseBody
	@RequestMapping(params = "method=editValidByCode")
	public String editValidByCode(HttpServletRequest request) throws Exception {

		Map<String, String> map = new HashMap<String, String>();
		try {
			SoftwarePackage softPackage = new SoftwarePackage();
			softPackage.setIsValid(Integer.valueOf(request.getParameter("valid")));
			softPackage.setPackageVersion(String.valueOf(request.getParameter("packVer")));
			softPackage.setTerminalType(Integer.valueOf(request.getParameter("termType")));

			packService.updatePackageValid(softPackage);

			map.put("reservedSuccessMsg", "");
			return JSONArray.toJSONString(map);
		} catch (Exception e) {
			e.printStackTrace();

			if (LocaleUtil.isChinese(request)) {
				String message = "修改软件有效性失败!";
				map.put("reservedSuccessMsg", URLEncoder.encode(message, "utf-8"));
			} else {
				String message = "Failed";
				map.put("reservedSuccessMsg", URLEncoder.encode(message, "utf-8"));
			}

			return JSONArray.toJSONString(map);
		}
	}

	// editSoftVersions
	@RequestMapping(params = "method=editSoftVersions", method = RequestMethod.GET)
	public String editSoftVersionsSetup(HttpServletRequest request, ModelMap model) throws Exception {

		String packVer = request.getParameter("packVer");
		String termTypeStr = request.getParameter("termType");

		SoftwarePackage sp = new SoftwarePackage();
		sp.setPackageVersion(packVer);
		sp.setTerminalType(Integer.parseInt(termTypeStr));

		model.addAttribute("softPackage", sp);

		SoftwarePackageForm spf = new SoftwarePackageForm();
		model.addAttribute("softPackageForm", spf);

		return LocaleUtil.getUserLocalePath("oms/tmversion/editSoftPackageVersions", request);

	}

	@RequestMapping(params = "method=editSoftVersions", method = RequestMethod.POST)
	public String editSoftVersions(HttpServletRequest request, ModelMap model, @ModelAttribute("softPackage") SoftwarePackage softPackage, @ModelAttribute("softPackageForm") SoftwarePackageForm packForm) throws Exception {
		try {
			softPackage.setSoftwareVersionList(getVersionList(softPackage, packForm));
			packService.updatePackageVersions(softPackage);

			model.addAttribute("reservedHrefURL", "tmversion.do?method=listSoft");

			return LocaleUtil.getUserLocalePath("common/successTip", request);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}

	}

	private List<PackageContext> getVersionList(SoftwarePackage softPack, SoftwarePackageForm packForm) {

		List<PackageContext> lst = new ArrayList<PackageContext>();
		Class<SoftwarePackageForm> clz = SoftwarePackageForm.class;
		try {
			for (int i = 1; i <= 7; i++) {
				Method m = clz.getMethod("getVersion" + i);
				String version = (String) m.invoke(packForm);
				PackageContext pc = new PackageContext();

				pc.setPackageVersion(softPack.getPackageVersion());
				pc.setSoftId(i);
				pc.setSoftVersion(version);
				pc.setTerminalType(softPack.getTerminalType());
				lst.add(pc);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} 
		return lst;
	}

	// Ajax pack version list
	@RequestMapping(params = "method=getpackvers", method = RequestMethod.GET)
	public String getPackVerList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		String curtype = request.getParameter("termtype");
		Integer termType = Integer.parseInt(curtype);

		List<SimpleSoftPack> plist = null;
		plist = packService.getPackVersForTermType(termType);

		String jsonStr = listToJsonStr(plist, "datalist");
		response.setContentType("application/json;charset=UTF-8");
		response.getWriter().print(jsonStr);
		response.getWriter().flush();
		response.getWriter().close();
		return null;

	}

	private String listToJsonStr(List<SimpleSoftPack> list, String listName) {
		if (list == null)
			return "";
		StringBuffer sb = new StringBuffer(512);

		sb.append("{\"");
		sb.append(listName);
		sb.append("\":[");
		for (int i = 0; i < list.size(); i++) {

			sb.append(" {\"label\":\" ");

			sb.append(list.get(i).getPackageVersion());

			sb.append(" \" ,\"value\":\"  ");

			sb.append(list.get(i).getPackageVersion());

			sb.append(" \"}");
			if (i != (list.size() - 1))
				sb.append(",");
		}
		sb.append("]}");
		return sb.toString();
	}

	@ResponseBody
	@RequestMapping(params = "method=ifExist")
	public String ifExistSoftWarePackageNo(HttpServletRequest request) {
		String flag = "0";// 不重复，1为重复
		String terminalType = request.getParameter("terminalType").trim();
		String packageVersion = request.getParameter("packageVersion");
		Map<String, String> map = new HashMap<String, String>();
		map.put("terminalType", terminalType);
		map.put("packageVersion", packageVersion);
		if (terminalType != null && !terminalType.isEmpty() && packageVersion != null && !packageVersion.isEmpty()) {
			Integer count = packService.ifExistSoftWarePackageNo(map);
			if (count.intValue() > 0)
				flag = "1";
		}
		return flag;
	}

	@ResponseBody
	@RequestMapping(params = "method=ifBiggerThanOther")
	public Object ifBiggerThanOther(HttpServletRequest request) {
		String flag = "0";// 传进来的packageVersion最大
		String terminalType = request.getParameter("terminalType").trim();
		String packageVersion = request.getParameter("packageVersion");
		Map<String, String> map = new HashMap<String, String>();
		map.put("terminalType", terminalType);
		map.put("packageVersion", packageVersion);
		String maxPackVersion = "";
		if (terminalType != null && !terminalType.isEmpty() && packageVersion != null && !packageVersion.isEmpty()) {
			Integer count = packService.ifBiggerThanOther(map);
			if (count.intValue() > 0) {
				flag = "1";
				maxPackVersion = packService.maxSoftwarePackNo(map);
			}
		}
		map.put("flag", flag);
		map.put("maxPackVersion", maxPackVersion);
		return JSONArray.toJSONString(map);
	}

	@ResponseBody
	@RequestMapping(params = "method=isFullNum")
	public String isFullNum(HttpServletRequest request) {
		String flag = "0";
		String terminalType = request.getParameter("terminalType").trim();
		if (terminalType != null && !terminalType.isEmpty()) {
			Integer count = packService.isFullNum(terminalType);
			if (count.intValue() >= 10) {
				flag = "1";
			}
		}
		return flag;
	}
}