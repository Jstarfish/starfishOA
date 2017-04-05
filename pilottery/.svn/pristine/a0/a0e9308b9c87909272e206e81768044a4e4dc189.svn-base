package cls.taishan.web.service.Impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSON;

import cls.taishan.common.constants.SysConstants;
import cls.taishan.web.jtdao.WingCommonDAO;
import cls.taishan.web.jtdao.WingLoginDAO;
import cls.taishan.web.jtdao.WingWithdrawDAO;
import cls.taishan.web.model.control.WingWithdrawInputParam;
import cls.taishan.web.model.control.WingWithdrawOutputParam;
import cls.taishan.web.model.db.WingLoginDBParm;
import cls.taishan.web.model.db.WingReceiveWDDataDBParm;
import cls.taishan.web.model.db.WingWithdrawDBParam;
import cls.taishan.web.model.rest.WingLoginReq;
import cls.taishan.web.model.rest.WingLoginRes;
import cls.taishan.web.model.rest.WingWithdrawReq;
import cls.taishan.web.model.rest.WingWithdrawRes;
import cls.taishan.web.service.WingWithdrawService;

@Service
public class WingWithdrawServiceImpl implements WingWithdrawService {
	
	@Autowired
	public WingCommonDAO wingCommonDao;
	
	@Autowired
	public WingLoginDAO wingLoginDao;

	@Autowired
	public WingWithdrawDAO wingWithdrawDao;

	@Override
	public WingWithdrawOutputParam doWithdraw(WingWithdrawInputParam in) {
		WingWithdrawOutputParam out = new WingWithdrawOutputParam();
		String token = "";
		String eTradeFlow = "";
		String currency = "";
		int rtv = 0;
		String tempErrorMessage = "";
		
		// 获取企业用户的登录信息
		WingLoginReq userInfo = new WingLoginReq();
		rtv = wingCommonDao.getEUserLoginInfo(in.getAccount(), userInfo);
		if (rtv != 0){
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + rtv);
			out.setErrorMessage(wingCommonDao.getErrorMessage());
			return out;
		}
		
		// 记录提现请求
		WingReceiveWDDataDBParm dbParm = new WingReceiveWDDataDBParm();
		dbParm.setEUser(in.getEuser());
		dbParm.setAccount(in.getAccount());
		dbParm.setAmount(in.getAmount());
		dbParm.setUserAcc(in.getUserAcc());
		dbParm.setReqFlow(in.getReqFlow());
		wingWithdrawDao.recordWithdrawJsonData(dbParm);
		if (dbParm.getErrorCode() != 0){
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + dbParm.getErrorCode());
			out.setErrorMessage(dbParm.getErrorMesg());
			return out;
		}
		eTradeFlow = dbParm.getETradeFlow();
		currency = dbParm.getCurrency();
		
		// 记录登录请求
		WingLoginDBParm loginDBParm = new WingLoginDBParm();
		loginDBParm = wingLoginDao.recordLoginBeforeDB(userInfo, eTradeFlow);
		if (loginDBParm.getErrorCode() != 0){
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + loginDBParm.getErrorCode());
			out.setErrorMessage(loginDBParm.getErrorMessage());
			return out;
		}
		
		// 发起Wing登录
		WingLoginRes loginRes = new WingLoginRes();
		loginRes = wingLoginDao.restWingLogin(userInfo);
		if (loginRes.getErrorCode() != 0){
			switch (loginRes.getErrorCode()){
			//超时
				case SysConstants.WING_REST_TIMEOUT:
					loginDBParm.setRestStatus(SysConstants.DB_WING_REST_STATUS_TIMEOUT);
					break; 
	
				case SysConstants.WING_REST_CONNECTION:
					loginDBParm.setRestStatus(SysConstants.DB_WING_REST_STATUS_FAIL);
					break; 
	
				case SysConstants.WING_REST_RETURN_ERROR:
					loginDBParm.setRestStatus(SysConstants.DB_WING_REST_STATUS_FAIL);
					loginDBParm.setHttpStatus(loginRes.getHttpStatus());
				
			}
			
			// 保留错误信息，留着保存完以后，再返回客户端
			tempErrorMessage = loginRes.getErrorMessage();
			
			loginDBParm.setEInPostId(loginDBParm.getEOutPostId());
			loginDBParm.setJsonData(tempErrorMessage);
			
		} else {
			token = loginRes.getAccess_token();
			loginDBParm.setRestStatus(SysConstants.DB_WING_REST_STATUS_SUCC);
			loginDBParm.setEInPostId(loginDBParm.getEOutPostId());
			loginDBParm.setHttpStatus(200);
			loginDBParm.setJsonData(JSON.toJSONString(loginRes));
		}
		
		// 更新登录请求，记录到数据库里面
		loginDBParm = wingLoginDao.recordLoginPostDB(loginDBParm);
		if (loginDBParm.getErrorCode() != 0){
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + loginDBParm.getErrorCode());
			out.setErrorMessage(loginDBParm.getErrorMessage());
			return out;
		}
		if (loginDBParm.getRestStatus() != SysConstants.DB_WING_REST_STATUS_SUCC){
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + loginDBParm.getRestStatus());
			out.setErrorMessage(tempErrorMessage);
			return out;
		}
		
		// 记录提现请求
		WingWithdrawReq req = new WingWithdrawReq(in.getAmount(), currency, in.getUserAcc());
		WingWithdrawDBParam wdDBParm = wingWithdrawDao.recordWithdrawBeforeDB(req, eTradeFlow);
		if (wdDBParm.getErrorCode() != 0){
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + wdDBParm.getErrorCode());
			out.setErrorMessage(wdDBParm.getErrorMessage());
			return out;
		}

		// 发起Wing提现
		WingWithdrawRes wdRes = new WingWithdrawRes();
		wdRes = wingWithdrawDao.restWingWithdraw(req, token);
		if (wdRes.getErrorCode() != 0){
			switch (wdRes.getErrorCode()){
				//超时
				case SysConstants.WING_REST_TIMEOUT:
					wdDBParm.setRestStatus(SysConstants.DB_WING_REST_STATUS_TIMEOUT);
					break; 

				case SysConstants.WING_REST_CONNECTION:
					wdDBParm.setRestStatus(SysConstants.DB_WING_REST_STATUS_FAIL);
					break; 

				case SysConstants.WING_REST_RETURN_ERROR:
					wdDBParm.setRestStatus(SysConstants.DB_WING_REST_STATUS_FAIL);
					wdDBParm.setHttpStatus(wdRes.getHttpStatus());
					
			}
			tempErrorMessage = wdRes.getErrorMessage();
			
			wdDBParm.setEInPostId(wdDBParm.getEOutPostId());
			wdDBParm.setJsonData(tempErrorMessage);
			
		}else{
			wdDBParm.setRestStatus(SysConstants.DB_WING_REST_STATUS_SUCC);
			wdDBParm.setEInPostId(wdDBParm.getEOutPostId());
			wdDBParm.setJsonData(JSON.toJSONString(wdRes));
			wdDBParm.setHttpStatus(200);
		}
		
		// 更新充值请求
		wdDBParm = wingWithdrawDao.recordWithdrawPostDB(wdDBParm);
		if (wdDBParm.getErrorCode() != 0){
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_AFTER_WING + wdDBParm.getErrorCode());
			out.setErrorMessage(wdDBParm.getErrorMessage());
			return out;
		}
		
		if (wdDBParm.getRestStatus() != SysConstants.DB_WING_REST_STATUS_SUCC){
			if (wdDBParm.getRestStatus() == SysConstants.DB_WING_REST_STATUS_FAIL){
				out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + wdDBParm.getRestStatus());
				out.setErrorMessage(tempErrorMessage);
				return out;
			}
			if (wdDBParm.getRestStatus() == SysConstants.DB_WING_REST_STATUS_TIMEOUT){
				out.setErrorCode(SysConstants.ERR_PRECODE_BANK_AFTER_WING + wdDBParm.getRestStatus());
				out.setErrorMessage(tempErrorMessage);
				return out;
			}
			
		}
		
		// 生成返回参数
		out = wingWithdrawDao.genOutParam(eTradeFlow);
		if (out.getErrorCode() != 0){
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_AFTER_WING + out.getErrorCode());
			out.setErrorMessage(out.getErrorMessage());
			return out;
		}
		
		return out;
	}

}
