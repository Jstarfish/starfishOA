package cls.pilottery.pos.system.service.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.common.constants.RedisConstants;
import cls.pilottery.common.model.UserLoginInfo;
import cls.pilottery.common.service.RedisService;
import cls.pilottery.common.utils.MD5Util;
import cls.pilottery.pos.common.annotation.PosMethod;
import cls.pilottery.pos.common.annotation.PosService;
import cls.pilottery.pos.common.constants.PosConstant;
import cls.pilottery.pos.common.model.BaseRequest;
import cls.pilottery.pos.common.model.BaseResponse;
import cls.pilottery.pos.common.model.UserToken;
import cls.pilottery.pos.system.dao.SystemManageDao;
import cls.pilottery.pos.system.model.ConnectTestResponse;
import cls.pilottery.pos.system.model.LoginRequest;
import cls.pilottery.pos.system.model.ModifyPwdRequest;
import cls.pilottery.pos.system.model.OutletLoginModel;
import cls.pilottery.pos.system.service.SystemService;
import cls.pilottery.web.capital.model.MarketManager;
import cls.pilottery.web.system.dao.MarketPwdDao;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.system.service.UserService;

import com.alibaba.fastjson.JSONObject;

@PosService
public class SystemServiceImpl implements SystemService {
	private static Logger log = Logger.getLogger(SystemServiceImpl.class);
	
	@Autowired
	private RedisService redisService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private SystemManageDao systemManageDao;
	
	@Autowired
	private MarketPwdDao marketPwdDao;

	@Override
	@PosMethod(code="010001")
	public BaseResponse login(Object obj) throws Exception{
		BaseRequest bq = (BaseRequest) obj;
		
		String token = "";
		BaseResponse response = new BaseResponse();
		
		LoginRequest request = JSONObject.parseObject(bq.getParam().toString(), LoginRequest.class);
		
		UserLoginInfo ul = (UserLoginInfo)redisService.getObject(RedisConstants.USER_LOGIN_ERROE_TIMES_KEY+request.getUsername());
        if(ul == null){
        	ul = new UserLoginInfo();
        	ul.setLoginName(request.getUsername());
        }else{
        	//if(ul.getIsLogin() == 1 && ul.getLoginDevice().equals("2")){
        	if(ul.getToken() != null){
        		redisService.del(ul.getToken());
        	}
    		redisService.del(RedisConstants.USER_LOGIN_ERROE_TIMES_KEY+ul.getLoginName());
    		log.info("用户已登录，将其删除重新登陆！user:"+request.getUsername());
        }
        
        //市场管理员登陆
        if("1".equals(request.getType())){
        	User user = userService.getUserByLogin(request.getUsername());
    		if(user != null && user.getStatus() == 1 && user.getIsCollector() == 1){
    			if(MD5Util.MD5Encode(request.getPassword()).equals(user.getPassword())){
    				token = this.getToken(user.getId());
    				UserToken ut = new UserToken();
    				ut.setUserType("1");
    				ut.setDeviceType(request.getDeviceType());
    				ut.setDeviceSign(request.getDeviceSign());
    				
    				BeanUtils.copyProperties(ut, user);
    				redisService.setObject(token, ut);
    				redisService.expire(token, PosConstant.SESSION_TIMEOUT);
    				
    				ul.setIsLogin(1);
    		        ul.setLoginDevice("2");
    		        ul.setLastLoginTime(System.currentTimeMillis());
    		        ul.setPwdErrorTimes(0);
    		        ul.setToken(token);
    		        redisService.setObject(RedisConstants.USER_LOGIN_ERROE_TIMES_KEY+request.getUsername(), ul);
    		        redisService.expire(RedisConstants.USER_LOGIN_ERROE_TIMES_KEY+request.getUsername(), PosConstant.SESSION_TIMEOUT);
    		        
    				log.info("用户登录成功,登录用户:"+request.toString());
    			}else{
    				int times = ul.getPwdErrorTimes();
    	        	if(times == RedisConstants.USER_LOGIN_ERROR_TIMES - 1){
    	        		times++;
    	        		log.info("连续登录五次失败，账户锁定:"+request.getUsername());
    	        		user.setStatus(3);
    	        		userService.changeUserActive(user);
    	        		ul.setPwdErrorTimes(0);
    	        	}else{
    	        		ul.setPwdErrorTimes(times++);
    	        	}
    	        	redisService.setObject(RedisConstants.USER_LOGIN_ERROE_TIMES_KEY+request.getUsername(), ul);
    				
    				response.setErrcode(10002);
    				log.info("用户名或密码校验错误,用户名为："+request.getUsername());
    			}
    		}else{
    			response.setErrcode(10001);
    			log.info("认证失败："+request.getUsername());
    		}
    		
        } else if("2".equals(request.getType())){	//站点登陆
        	
        	OutletLoginModel user = systemManageDao.getOutletInfoByLogin(request.getUsername());
    		if(user != null && user.getStatus() == 1 ){
    			if(MD5Util.MD5Encode(request.getPassword()).equals(user.getLoginPwd())){
    				token = this.getToken(request.getUsername());
    				UserToken ut = new UserToken();
    				//BeanUtils.copyProperties(ut, user);
    				ut.setLoginId(user.getAgencyCode());
    				ut.setRealName(user.getAgencyName());
    				ut.setInstitutionCode(user.getOrgCode());
    				ut.setUserType("2");
    				ut.setDeviceType(request.getDeviceType());
    				ut.setDeviceSign(request.getDeviceSign());
    				ut.setMarketManageId(user.getMarketManageId());
    				
    				redisService.setObject(token, ut);
    				redisService.expire(token, PosConstant.SESSION_TIMEOUT);
    				
    				ul.setIsLogin(1);
    		        ul.setLoginDevice("2");
    		        ul.setLastLoginTime(System.currentTimeMillis());
    		        ul.setPwdErrorTimes(0);
    		        ul.setToken(token);
    		        redisService.setObject(RedisConstants.USER_LOGIN_ERROE_TIMES_KEY+request.getUsername(), ul);
    		        redisService.expire(RedisConstants.USER_LOGIN_ERROE_TIMES_KEY+request.getUsername(), PosConstant.SESSION_TIMEOUT);
    		        
    				log.info("用户登录成功,登录用户:"+request.toString());
    			}else{
    				response.setErrcode(10002);
    				log.info("用户名或密码校验错误,用户名为："+request.getUsername());
    			}
    		}else{
    			response.setErrcode(10001);
    			log.info("认证失败："+request.getUsername());
    		}
        } else{
        	response.setErrcode(10001);
			log.info("认证失败："+request.getUsername());
        }
        
        //校验版本
        String version = systemManageDao.getParamValueById(3);
        String url = null;
        String username = null;
        String password = null;
        if(version != null && !version.equals(request.getVersion())){
        	log.info("非最新版本，old:"+request.getVersion()+" , new:"+version);
        	url = systemManageDao.getParamValueById(4);
        	username = systemManageDao.getParamValueById(8);
        	password = systemManageDao.getParamValueById(9);
        	token = "";
        	log.info("返回下载地址url:"+url);
        	response.setErrcode(10022);
        }
        
		Map<String,String> map = new HashMap<String,String>();
		map.put("token", token);
		map.put("url", url);
		map.put("username", username);
		map.put("password", password);
		response.setResult(map);
		return response;
	}
	
	private String getToken(Long userId){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		String token = StringUtils.leftPad(userId+"", 4, "0")+sdf.format(new Date()) 
					+ UUID.randomUUID().toString().substring(0,14) ;
		return token;
	}
	
	private String getToken(String outletCode){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		String token = outletCode+sdf.format(new Date()) 
					+ UUID.randomUUID().toString().substring(0,10) ;
		return token;
	}

	/*
	 * 修改登陆密码
	 */
	@Override
	@PosMethod(code="010002")
	public BaseResponse modifyLoginPwd(Object obj) throws Exception {
		BaseResponse response = new BaseResponse();
		BaseRequest request = (BaseRequest) obj;
		
		ModifyPwdRequest mpr = JSONObject.parseObject(request.getParam().toString(),ModifyPwdRequest.class);
		UserToken ut = (UserToken)redisService.getObject(request.getToken());
		
		String userType = ut.getUserType();
		if("1".equals(userType)){
			User user = userService.getUserByLogin(ut.getLoginId());
			if(MD5Util.MD5Encode(mpr.getOldPassword()).equals(user.getPassword())){
				User u = new User();
				u.setId(ut.getId());
				u.setPassword(MD5Util.MD5Encode(mpr.getNewPassword()));
				userService.updatePwd(u);
				
				redisService.del(request.getToken());
				redisService.del(RedisConstants.USER_LOGIN_ERROE_TIMES_KEY+ut.getLoginId());
				
				log.info("市场管理员修改密码成功。");
			}else{
				response.setErrcode(10004);
				log.info("原密码错误!");
			}
		} else if ("2".equals(userType)){
			OutletLoginModel outlet = systemManageDao.getOutletInfoByLogin(ut.getLoginId());
			if(MD5Util.MD5Encode(mpr.getOldPassword()).equals(outlet.getLoginPwd())){
				OutletLoginModel newOutlet = new OutletLoginModel();
				newOutlet.setAgencyCode(outlet.getAgencyCode());
				newOutlet.setLoginPwd(MD5Util.MD5Encode(mpr.getNewPassword()));
				systemManageDao.updateLoginPwd(newOutlet);
				
				redisService.del(request.getToken());
				redisService.del(RedisConstants.USER_LOGIN_ERROE_TIMES_KEY+ut.getLoginId());
				
				log.info("站点修改密码成功。");
			}else{
				response.setErrcode(10004);
				log.info("原密码错误!");
			}
		}
		
		return response;
	}

	/*
	 * 修改交易密码
	 */
	@Override
	@PosMethod(code="010003")
	public BaseResponse modifyTransPwd(Object obj) throws Exception {
		BaseRequest request = (BaseRequest) obj;
		
		BaseResponse response = new BaseResponse();
		//BeanUtils.copyProperties(mpr, request.getParam());
		ModifyPwdRequest mpr = JSONObject.parseObject(request.getParam().toString(),ModifyPwdRequest.class);
		UserToken ut = (UserToken)redisService.getObject(request.getToken());
		
		MarketManager manager =  marketPwdDao.getMarketById(ut.getId());
		if(MD5Util.MD5Encode(mpr.getOldPassword()).equals(manager.getTransPass())){
			MarketManager account = new MarketManager();
			account.setMarketAdmin(ut.getId());
			account.setTransPass(MD5Util.MD5Encode(mpr.getNewPassword()));
			marketPwdDao.updatePwd(account);
			
			log.info("用户修改密码成功。");
		}else{
			response.setErrcode(10004);
			log.info("原密码错误!");
		}
		
		return response;
	}
	
	/*
	 * 登出
	 */
	@Override
	@PosMethod(code="010004")
	public BaseResponse logout(Object obj) throws Exception {
		BaseRequest request = (BaseRequest) obj;
		UserToken ut = (UserToken)redisService.getObject(request.getToken());
		
		redisService.del(request.getToken());
		redisService.del(RedisConstants.USER_LOGIN_ERROE_TIMES_KEY+ut.getLoginId());
		
		log.info("用户:"+ut.getLoginId()+"签退成功!");
		return new BaseResponse();
	}

	/*
	 * 通信测试
	 */
	@Override
	@PosMethod(code="010009")
	public BaseResponse connectTest(Object obj) throws Exception {
		long rcvTime = System.currentTimeMillis();
		BaseRequest request = (BaseRequest) obj;
		Map map = JSONObject.parseObject(request.getParam().toString(),Map.class);
		long temTime = Long.parseLong(map.get("term1Time").toString());
		BaseResponse response = new BaseResponse();
		ConnectTestResponse result = new ConnectTestResponse();
		result.setTermTxTime(temTime);
		result.setServRxTime(rcvTime);
		result.setServTxTime(System.currentTimeMillis());
		
		response.setResult(result);
		return response;
	}

}
