package cls.pilottery.pos.common.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import cls.pilottery.common.utils.ReflectUtil;
import cls.pilottery.common.utils.SpringContextUtil;
import cls.pilottery.pos.common.constants.PosConstant;
import cls.pilottery.pos.common.model.BaseRequest;
import cls.pilottery.pos.common.model.BaseResponse;
import cls.pilottery.pos.common.model.MethodInfo;

@Controller
@RequestMapping("pos")
public class PosController {
	
	private static Logger log = Logger.getLogger(PosController.class); 

	@RequestMapping(method = {RequestMethod.POST,RequestMethod.GET})
	public void doPost(HttpServletRequest request, HttpServletResponse response) {
		Object reqObj = request.getAttribute("req");
		BaseRequest req = null;
		if(reqObj instanceof BaseRequest){
			req = (BaseRequest)reqObj;
		}
		
		BaseResponse res = (BaseResponse)request.getAttribute("res");
		try {
			if(res != null && res.getErrcode() > 0){
				if(req != null){
					BeanUtils.copyProperties(res, req); 
				}
				request.setAttribute("res", res);
				log.debug("请求参数格式不正确或认证失败，直接返回结果");
				return;
			}
			
			MethodInfo method = PosConstant.methodMap.get(req.getMethod());
			log.debug("执行业务方法，方法编号为:"+req.getMethod());
			Object obj = SpringContextUtil.getBean(method.getClassName());
			res = (BaseResponse)ReflectUtil.invokeMethodPos(obj, method.getMethodName(), req);
			BeanUtils.copyProperties(res, req);
			
			log.debug("业务方法执行成功。");
			request.setAttribute("res", res);
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error("处理POS终端请求出现异常", e);
			res = new BaseResponse(10500);
			try {
				BeanUtils.copyProperties(res, req);
			}  catch (Exception e1) {
				log.error("复制Bean成员变量时出现异常", e);
				res = new BaseResponse(10500);
			} 
			request.setAttribute("res", res);
		}
	}
}
