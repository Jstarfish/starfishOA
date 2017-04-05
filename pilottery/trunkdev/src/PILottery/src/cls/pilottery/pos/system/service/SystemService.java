package cls.pilottery.pos.system.service;

import cls.pilottery.pos.common.model.BaseResponse;

public interface SystemService {
	
	/*
	 * 登录（010001）
	 */
	public BaseResponse login(Object reqParam) throws Exception;
	
	/*
	 * 修改登陆密码（010002）
	 */
	public BaseResponse modifyLoginPwd(Object reqParam) throws Exception;
	
	/*
	 * 修改交易密码（010003）
	 */
	public BaseResponse modifyTransPwd(Object reqParam) throws Exception;
	
	/*
	 * 签退（010004）
	 */
	public BaseResponse logout(Object reqParam) throws Exception;
	
	/*
	 * 通信测试消息（010009)
	 */
	public BaseResponse connectTest(Object reqParam) throws Exception;
}
