package cls.pilottery.oms.monitor.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.fastjson.JSONArray;

import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.oms.monitor.model.AreaTerminal;
import cls.pilottery.oms.monitor.service.AreaTerminalService;

@Controller
@RequestMapping("/areaTerminal")
@Scope("session")
public class AreaTerminalController {
	
	static Logger log =Logger.getLogger(AreaTerminalController.class);

    @Autowired
    AreaTerminalService areaTerminalService;
	
	
    @RequestMapping(params="method=areaTerminalCulumn")
    public String areaTerminal(HttpServletRequest request) {
    	return LocaleUtil.getUserLocalePath("oms/monitor/areaTerminalCulumn", request);
    }
    
    @RequestMapping(params="method=areaTerminalPie")
    public String sectorGraphAreaTerminal(HttpServletRequest request) {
    	return LocaleUtil.getUserLocalePath("oms/monitor/areaTerminalPie", request);
    }
    
    @RequestMapping(params="method=areaTerminalLine")
    public String areaTerminalLine(HttpServletRequest request) {
    	return LocaleUtil.getUserLocalePath("oms/monitor/areaTerminalLine", request);
    }
    
    /**
     * 饼状图页面
     * @param request
     * @param response
     */
    @RequestMapping(params="method=ajax")
    public void ajax(HttpServletRequest request, HttpServletResponse response) {
        try {
            List<AreaTerminal> areaTerminalList = areaTerminalService.listAllAreaTerminal();
            response.getWriter().write(JSONArray.toJSON(areaTerminalList).toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    /**
     * 折线图页面
     * @param request
     * @param response
     */
    @RequestMapping(params="method=ajaxLine")
    public void ajaxLine(HttpServletRequest request, HttpServletResponse response) {
    	try {
    		AreaTerminal areaTerminal = new AreaTerminal();
    		areaTerminal.setCalcTime(getYearDate(new Date()));
    		List<AreaTerminal> areasList =areaTerminalService.listAllAreas(areaTerminal);
    		response.getWriter().write(JSONArray.toJSON(areasList).toString());
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    	
    }
    
    public static String getYearDate(Date date){
		return new SimpleDateFormat("yyyy-MM-dd").format(date);
	}
    /**
     * 柱状图页面
     * @param request
     * @param response
     */
    @RequestMapping(params="method=ajaxCulu")
    public void ajaxCulu(HttpServletRequest request, HttpServletResponse response) {
    	
    	try {
    		List<AreaTerminal> areaTerminalList = areaTerminalService.listAllAreaTerminal();
            response.getWriter().write(JSONArray.toJSONString(areaTerminalList));
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    }
    
}
