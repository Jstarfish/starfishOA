package cls.taishan.app.handler;


import java.text.SimpleDateFormat;
import java.util.Date;

import javax.inject.Inject;
import javax.inject.Singleton;

import com.alibaba.fastjson.JSON;

import cls.taishan.app.model.generic.Res9001Msg;
import cls.taishan.app.service.GenericService;
import cls.taishan.common.annotations.RouteHandler;
import cls.taishan.common.annotations.RouteMapping;
import cls.taishan.common.exception.VertxInvokeException;
import cls.taishan.common.handler.AbstractInvokeHandler;
import cls.taishan.common.model.BaseMessage;
import cls.taishan.common.model.BaseResponse;
import cls.taishan.common.utils.DateUtils;
import io.vertx.core.http.HttpMethod;
import io.vertx.ext.web.RoutingContext;
import lombok.extern.log4j.Log4j;

/**
 * 通用业务类消息处理Handler
 * 
 * @author huangchy
 *
 * @2016年12月12日
 * 
 * 包含的消息如下：
 * 9001: 会话建立及认证消息
 * 9002: 图片上传消息
 * 9101: 系统业务列表消息
 * 9102: APP首页
 * 9201：  系统消息列表
 * 9202： 申请验证码
 * 9203： 获取保密问题列表
 * 9204： 获取地区列表
 * 9205： 获取组织机构列表
 * 9301： 获取广告列表
 */
@Log4j
@Singleton
@RouteHandler("/generic")
public class GenericHandler {
	
	@Inject
	private GenericService genericService;
	
	@RouteMapping(value="9001",method=HttpMethod.POST)
    public AbstractInvokeHandler createSession() {
    	return new AbstractInvokeHandler() {
    		@SuppressWarnings(value = { "rawtypes" })
			@Override
    		public BaseMessage<BaseResponse> invoke(RoutingContext event,String jsonBody) throws VertxInvokeException {
				log.debug("Message 9001 processing……");
    			BaseMessage req = JSON.parseObject(jsonBody,BaseMessage.class);
				BaseMessage<BaseResponse> res = new BaseMessage<BaseResponse>();
				
    			Res9001Msg result = new Res9001Msg();
    			String sysTime = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
    			result.setMsnPrefix(sysTime);
				
    			res.setBody(result);
    			res.setTransType(9001);
    			res.setMessengerId(req.getMessengerId());
    			res.setToken(req.getToken());
    			res.setTimestamp(Long.parseLong(DateUtils.getStringDateByLongDate(System.currentTimeMillis(),"yyyyMMddHHmmss")));
    			return res;
    		}
    	};
    }
	
	
	@RouteMapping(value="9002",method=HttpMethod.POST)
    public AbstractInvokeHandler uploadPicture() {
    	return new AbstractInvokeHandler() {
    		@SuppressWarnings(value = { "rawtypes" })
			@Override
    		public BaseMessage<BaseResponse> invoke(RoutingContext event,String jsonBody) throws VertxInvokeException {
				log.debug("Message 9002 processing……");
    			BaseMessage req = JSON.parseObject(jsonBody,BaseMessage.class);
				BaseMessage<BaseResponse> res = new BaseMessage<BaseResponse>();
				
    			Res9001Msg result = new Res9001Msg();
    			String sysTime = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
    			result.setMsnPrefix(sysTime);
				
    			res.setBody(result);
    			res.setTransType(9001);
    			res.setMessengerId(req.getMessengerId());
    			res.setToken(req.getToken());
    			res.setTimestamp(Long.parseLong(DateUtils.getStringDateByLongDate(System.currentTimeMillis(),"yyyyMMddHHmmss")));
    			return res;
    		}
    	};
    }
	
	@RouteMapping(value="9101",method=HttpMethod.POST)
    public AbstractInvokeHandler getModuleList() {
    	return new AbstractInvokeHandler() {
    		@SuppressWarnings(value = { "rawtypes" })
			@Override
    		public BaseMessage<BaseResponse> invoke(RoutingContext event,String jsonBody) throws VertxInvokeException {
				log.debug("Message 9101 processing……");
    			BaseMessage req = JSON.parseObject(jsonBody,BaseMessage.class);
				BaseMessage<BaseResponse> res = new BaseMessage<BaseResponse>();
				
    			Res9001Msg result = new Res9001Msg();
    			String sysTime = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
    			result.setMsnPrefix(sysTime);
				
    			res.setBody(result);
    			res.setTransType(9001);
    			res.setMessengerId(req.getMessengerId());
    			res.setToken(req.getToken());
    			res.setTimestamp(Long.parseLong(DateUtils.getStringDateByLongDate(System.currentTimeMillis(),"yyyyMMddHHmmss")));
    			return res;
    		}
    	};
    }
	
	
	@RouteMapping(value="9102",method=HttpMethod.POST)
    public AbstractInvokeHandler getAppMainPage() {
    	return new AbstractInvokeHandler() {
    		@SuppressWarnings(value = { "rawtypes" })
			@Override
    		public BaseMessage<BaseResponse> invoke(RoutingContext event,String jsonBody) throws VertxInvokeException {
				log.debug("Message 9102 processing……");
    			BaseMessage req = JSON.parseObject(jsonBody,BaseMessage.class);
				BaseMessage<BaseResponse> res = new BaseMessage<BaseResponse>();
				
    			Res9001Msg result = new Res9001Msg();
    			String sysTime = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
    			result.setMsnPrefix(sysTime);
				
    			res.setBody(result);
    			res.setTransType(9001);
    			res.setMessengerId(req.getMessengerId());
    			res.setToken(req.getToken());
    			res.setTimestamp(Long.parseLong(DateUtils.getStringDateByLongDate(System.currentTimeMillis(),"yyyyMMddHHmmss")));
    			return res;
    		}
    	};
    }
	
	
	@RouteMapping(value="9201",method=HttpMethod.POST)
    public AbstractInvokeHandler getNoticeList() {
    	return new AbstractInvokeHandler() {
    		@SuppressWarnings(value = { "rawtypes" })
			@Override
    		public BaseMessage<BaseResponse> invoke(RoutingContext event,String jsonBody) throws VertxInvokeException {
				log.debug("Message 9201 processing……");
    			BaseMessage req = JSON.parseObject(jsonBody,BaseMessage.class);
				BaseMessage<BaseResponse> res = new BaseMessage<BaseResponse>();
				
    			Res9001Msg result = new Res9001Msg();
    			String sysTime = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
    			result.setMsnPrefix(sysTime);
				
    			res.setBody(result);
    			res.setTransType(9001);
    			res.setMessengerId(req.getMessengerId());
    			res.setToken(req.getToken());
    			res.setTimestamp(Long.parseLong(DateUtils.getStringDateByLongDate(System.currentTimeMillis(),"yyyyMMddHHmmss")));
    			return res;
    		}
    	};
    }
	
	@RouteMapping(value="9202",method=HttpMethod.POST)
    public AbstractInvokeHandler applyValidCode() {
    	return new AbstractInvokeHandler() {
    		@SuppressWarnings(value = { "rawtypes" })
			@Override
    		public BaseMessage<BaseResponse> invoke(RoutingContext event,String jsonBody) throws VertxInvokeException {
				log.debug("Message 9202 processing……");
    			BaseMessage req = JSON.parseObject(jsonBody,BaseMessage.class);
				BaseMessage<BaseResponse> res = new BaseMessage<BaseResponse>();
				
    			Res9001Msg result = new Res9001Msg();
    			String sysTime = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
    			result.setMsnPrefix(sysTime);
				
    			res.setBody(result);
    			res.setTransType(9001);
    			res.setMessengerId(req.getMessengerId());
    			res.setToken(req.getToken());
    			res.setTimestamp(Long.parseLong(DateUtils.getStringDateByLongDate(System.currentTimeMillis(),"yyyyMMddHHmmss")));
    			return res;
    		}
    	};
    }
	
	@RouteMapping(value="9203",method=HttpMethod.POST)
    public AbstractInvokeHandler getQuestionList() {
    	return new AbstractInvokeHandler() {
    		@SuppressWarnings(value = { "rawtypes" })
			@Override
    		public BaseMessage<BaseResponse> invoke(RoutingContext event,String jsonBody) throws VertxInvokeException {
				log.debug("Message 9203 processing……");
    			BaseMessage req = JSON.parseObject(jsonBody,BaseMessage.class);
				BaseMessage<BaseResponse> res = new BaseMessage<BaseResponse>();
				
    			Res9001Msg result = new Res9001Msg();
    			String sysTime = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
    			result.setMsnPrefix(sysTime);
				
    			res.setBody(result);
    			res.setTransType(9001);
    			res.setMessengerId(req.getMessengerId());
    			res.setToken(req.getToken());
    			res.setTimestamp(Long.parseLong(DateUtils.getStringDateByLongDate(System.currentTimeMillis(),"yyyyMMddHHmmss")));
    			return res;
    		}
    	};
    }
	
	@RouteMapping(value="9204",method=HttpMethod.POST)
    public AbstractInvokeHandler getRegionList() {
    	return new AbstractInvokeHandler() {
    		@SuppressWarnings(value = { "rawtypes" })
			@Override
    		public BaseMessage<BaseResponse> invoke(RoutingContext event,String jsonBody) throws VertxInvokeException {
				log.debug("Message 9204 processing……");
    			BaseMessage req = JSON.parseObject(jsonBody,BaseMessage.class);
				BaseMessage<BaseResponse> res = new BaseMessage<BaseResponse>();
				
    			Res9001Msg result = new Res9001Msg();
    			String sysTime = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
    			result.setMsnPrefix(sysTime);
				
    			res.setBody(result);
    			res.setTransType(9001);
    			res.setMessengerId(req.getMessengerId());
    			res.setToken(req.getToken());
    			res.setTimestamp(Long.parseLong(DateUtils.getStringDateByLongDate(System.currentTimeMillis(),"yyyyMMddHHmmss")));
    			return res;
    		}
    	};
    }
	
	
	@RouteMapping(value="9205",method=HttpMethod.POST)
    public AbstractInvokeHandler getInstitutionList() {
    	return new AbstractInvokeHandler() {
    		@SuppressWarnings(value = { "rawtypes" })
			@Override
    		public BaseMessage<BaseResponse> invoke(RoutingContext event,String jsonBody) throws VertxInvokeException {
				log.debug("Message 9205 processing……");
    			BaseMessage req = JSON.parseObject(jsonBody,BaseMessage.class);
				BaseMessage<BaseResponse> res = new BaseMessage<BaseResponse>();
				
    			Res9001Msg result = new Res9001Msg();
    			String sysTime = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
    			result.setMsnPrefix(sysTime);
				
    			res.setBody(result);
    			res.setTransType(9001);
    			res.setMessengerId(req.getMessengerId());
    			res.setToken(req.getToken());
    			res.setTimestamp(Long.parseLong(DateUtils.getStringDateByLongDate(System.currentTimeMillis(),"yyyyMMddHHmmss")));
    			return res;
    		}
    	};
    }
	
	@RouteMapping(value="9301",method=HttpMethod.POST)
    public AbstractInvokeHandler getADList() {
    	return new AbstractInvokeHandler() {
    		@SuppressWarnings(value = { "rawtypes" })
			@Override
    		public BaseMessage<BaseResponse> invoke(RoutingContext event,String jsonBody) throws VertxInvokeException {
				log.debug("Message 9301 processing……");
    			BaseMessage req = JSON.parseObject(jsonBody,BaseMessage.class);
				BaseMessage<BaseResponse> res = new BaseMessage<BaseResponse>();
				
    			Res9001Msg result = new Res9001Msg();
    			String sysTime = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
    			result.setMsnPrefix(sysTime);
				
    			res.setBody(result);
    			res.setTransType(9001);
    			res.setMessengerId(req.getMessengerId());
    			res.setToken(req.getToken());
    			res.setTimestamp(Long.parseLong(DateUtils.getStringDateByLongDate(System.currentTimeMillis(),"yyyyMMddHHmmss")));
    			return res;
    		}
    	};
    }
}
