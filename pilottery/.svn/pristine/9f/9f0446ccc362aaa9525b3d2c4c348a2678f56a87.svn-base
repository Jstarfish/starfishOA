package cls.taishan.demo.handler;

import javax.inject.Inject;
import javax.inject.Singleton;

import cls.taishan.common.annotations.RouteHandler;
import cls.taishan.common.annotations.RouteMapping;
import cls.taishan.common.exception.VertxInvokeException;
import cls.taishan.common.handler.AbstractInvokeHandler;
import cls.taishan.common.model.BaseMessage;
import cls.taishan.common.model.BaseResponse;
import cls.taishan.demo.entity.User;
import cls.taishan.demo.model.DemoResponse;
import cls.taishan.demo.service.DemoService;
import io.vertx.core.http.HttpMethod;
import io.vertx.ext.web.RoutingContext;
import lombok.extern.log4j.Log4j;
/**
 * 示例handler
 * 
 * @author huangchy
 *
 * @2016年8月24日
 *
 */
@Log4j
@Singleton
@RouteHandler("/demo")
public class DemoHandler{
	@Inject
	private DemoService demoService;
	
	@RouteMapping(method=HttpMethod.POST)
    public AbstractInvokeHandler testService() {
    	return new AbstractInvokeHandler() {
    		@Override
    		public BaseMessage<BaseResponse> invoke(RoutingContext event,String jsonBody) throws VertxInvokeException {
    			log.debug("DemoHandler processing……");
    			demoService.test();
    			return new BaseMessage<BaseResponse>();
    		}
    	};
    }
	
	@RouteMapping(value="123",method=HttpMethod.POST)
    public AbstractInvokeHandler products() {
    	return new AbstractInvokeHandler() {
    		@Override
    		public BaseMessage<BaseResponse> invoke(RoutingContext event,String jsonBody) throws VertxInvokeException {
    			log.info(jsonBody);
    			log.debug("DemoHandler processing……");
    			return new BaseMessage<BaseResponse>();
    		}
    	};
    }
	
	@RouteMapping(value="getUserById",method=HttpMethod.POST)
    public AbstractInvokeHandler getUserById() {
    	return new AbstractInvokeHandler() {
    		@Override
    		public BaseMessage<BaseResponse> invoke(RoutingContext event,String jsonBody) throws VertxInvokeException {
    			int userId = 12;
    			User user = demoService.getUserById(userId);
    			DemoResponse res = new DemoResponse();
    			res.setUser(user);
    			BaseMessage<BaseResponse> msg = new BaseMessage<BaseResponse>();
    			msg.setBody(res);
    			return msg;
    		}
    	};
    }
	
	@RouteMapping(value="getUserByAnnotation",method=HttpMethod.POST)
    public AbstractInvokeHandler getUserByAnnotation() {
    	return new AbstractInvokeHandler() {
    		@Override
    		public BaseMessage<BaseResponse> invoke(RoutingContext event,String jsonBody) throws VertxInvokeException {
    			int userId = 12;
    			User user = demoService.getUserByAnnotation(userId);
    			DemoResponse res = new DemoResponse();
    			res.setUser(user);
    			BaseMessage<BaseResponse> msg = new BaseMessage<BaseResponse>();
    			msg.setBody(res);
    			return msg;
    		}
    	};
    }

	/*@RouteMapping(value="/getUserList",method=HttpMethod.POST)
    public AbstractInvokeHandler getUserList() {
    	return new AbstractInvokeHandler() {
    		@Override
    		public BaseResponse invoke(RoutingContext event,String jsonBody) throws VertxInvokeException {
    			int userId = 12;
    			List<User> list = demoService.getUserList();
    			return ViewModelHelper.OKViewModelResult(list);
    		}
    	};
    }*/
}
