package cls.pilottery.webncp.common.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import cls.pilottery.common.utils.ReflectUtil;
import cls.pilottery.common.utils.SpringContextUtil;
import cls.pilottery.webncp.common.constants.WebncpConstant;
import cls.pilottery.webncp.common.model.BaseRequest;
import cls.pilottery.webncp.common.model.BaseResponse;
import cls.pilottery.webncp.common.model.MethodInfo;
import cls.pilottery.webncp.system.model.Response30d4Model;

import com.alibaba.fastjson.JSON;

@Controller
@RequestMapping("ncp")
public class WebncpController {
	private static Logger log = Logger.getLogger(WebncpController.class); 

	@RequestMapping(method = {RequestMethod.POST,RequestMethod.GET})
	public void doPost(HttpServletRequest request, HttpServletResponse response) {
		String reqJson = (String)request.getAttribute("req");
		BaseRequest req = JSON.parseObject(reqJson,BaseRequest.class);
		BaseResponse res = null;
		try {
			MethodInfo method = WebncpConstant.methodMap.get(Integer.toHexString(req.getCMD()));
			log.debug("执行业务方法，方法编号为:"+Integer.toHexString(req.getCMD())+"["+req.getCMD()+"]");
			Object obj = SpringContextUtil.getBean(method.getClassName());
			res = (BaseResponse)ReflectUtil.invokeMethodWebncp(obj, method.getMethodName(), reqJson);
			
			log.debug("业务方法执行成功。");
			//request.setAttribute("res", res);
			
		} catch (Exception e) {
			res = new BaseResponse(500102);
			e.printStackTrace();
			log.error("执行业务方法出现异常，方法编号："+req.getCMD(),e);
		} finally{
			if(res == null){
				res = new BaseResponse(500102);
			}
			res.setCMD(req.getCMD());
			request.setAttribute("res", res);
		}
	}
}
