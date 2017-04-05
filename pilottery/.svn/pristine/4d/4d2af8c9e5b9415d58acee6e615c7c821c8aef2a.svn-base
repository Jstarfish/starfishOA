package cls.taishan.web.service.Impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSON;

import cls.taishan.common.constants.SysConstants;
import cls.taishan.web.jtdao.WingChargeDAO;
import cls.taishan.web.jtdao.WingCommonDAO;
import cls.taishan.web.jtdao.WingLoginDAO;
import cls.taishan.web.model.control.WingChargeInputParam;
import cls.taishan.web.model.control.WingChargeOutputParam;
import cls.taishan.web.model.db.WingCommitDBParam;
import cls.taishan.web.model.db.WingLoginDBParm;
import cls.taishan.web.model.db.WingReceiveChargeDataDBParm;
import cls.taishan.web.model.db.WingValidateDBParam;
import cls.taishan.web.model.rest.WingCommitRes;
import cls.taishan.web.model.rest.WingLoginReq;
import cls.taishan.web.model.rest.WingLoginRes;
import cls.taishan.web.model.rest.WingValidateReq;
import cls.taishan.web.model.rest.WingValidateRes;
import cls.taishan.web.service.WingChargeService;

@Service
public class WingChargeServiceImpl implements WingChargeService {

	@Autowired
	public WingCommonDAO wingCommonDao;

	@Autowired
	public WingLoginDAO wingLoginDao;

	@Autowired
	public WingChargeDAO wingChargeDao;

	@Override
	public WingChargeOutputParam doCharge(WingChargeInputParam in) {
		int rtv = 0;
		String token = "";
		String eTradeFlow = "";
		String tempErrorMessage = "";

		WingChargeOutputParam out = new WingChargeOutputParam();

		// 获取企业用户的登录信息
		WingLoginReq userInfo = new WingLoginReq();
		rtv = wingCommonDao.getEUserLoginInfo(in.getAccount(), userInfo);
		if (rtv != 0){
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + rtv);
			out.setErrorMessage(wingCommonDao.getErrorMessage());
			return out;
		}

		// 记录提现请求
		WingReceiveChargeDataDBParm dbParm = new WingReceiveChargeDataDBParm();
		dbParm.setEUser(in.getEuser());
		dbParm.setAccount(in.getAccount());
		dbParm.setAmount(in.getAmount());
		dbParm.setUserAcc(in.getUserAcc());
		dbParm.setOtp(in.getOtp());
		dbParm.setReqFlow(in.getReqFlow());
		wingChargeDao.recordChargeJsonData(dbParm);
		if (dbParm.getErrorCode() != 0){
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + dbParm.getErrorCode());
			out.setErrorMessage(dbParm.getErrorMesg());
			return out;
		}
		eTradeFlow = dbParm.getETradeFlow();
		
		// 向Wing发起Login交易之前，在数据库中保存请求数据
		WingLoginDBParm loginDBParm = new WingLoginDBParm();
		loginDBParm = wingLoginDao.recordLoginBeforeDB(userInfo, eTradeFlow);
		if (loginDBParm.getErrorCode() != 0){
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + loginDBParm.getErrorCode());
			out.setErrorMessage(loginDBParm.getErrorMessage());
			return out;
		}
		
		// 向Wing发起Login交易
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
		
		// 向Wing发起Login交易之后，更新数据库数据
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
		
		// 向Wing发起Validate交易之前，在数据库中保存请求数据
		WingValidateReq validateReq = new WingValidateReq();
		validateReq.setUserAcc(in.getUserAcc());
		validateReq.setOtp(in.getOtp());
		validateReq.setAmount(in.getAmount());
		validateReq.setBillCode(userInfo.getBillCode());
		validateReq.setReqFlow(in.getReqFlow());
		WingValidateDBParam validateDBParm = wingChargeDao.recordValidateBeforeDB(validateReq, eTradeFlow);
		if (validateDBParm.getErrorCode() != 0){
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + validateDBParm.getErrorCode());
			out.setErrorMessage(validateDBParm.getErrorMessage());
			return out;
		}
		
		// 向Wing发起Validate交易
		WingValidateRes validateRes = new WingValidateRes();
		validateRes = wingChargeDao.restWingValidate(validateReq, token);
		if (validateRes.getErrorCode() != 0){
			switch (validateRes.getErrorCode()){
				//超时
				case SysConstants.WING_REST_TIMEOUT:
					validateDBParm.setRestStatus(SysConstants.DB_WING_REST_STATUS_TIMEOUT);
					break; 

				case SysConstants.WING_REST_CONNECTION:
					validateDBParm.setRestStatus(SysConstants.DB_WING_REST_STATUS_FAIL);
					break; 

				case SysConstants.WING_REST_RETURN_ERROR:
					validateDBParm.setRestStatus(SysConstants.DB_WING_REST_STATUS_FAIL);
					validateDBParm.setHttpStatus(validateRes.getHttpStatus());
					
			}
			tempErrorMessage = validateRes.getErrorMessage();
			
			validateDBParm.setEInPostId(validateDBParm.getEOutPostId());
			validateDBParm.setJsonData(tempErrorMessage);
			
		}else{
			validateDBParm.setRestStatus(SysConstants.DB_WING_REST_STATUS_SUCC);
			validateDBParm.setEInPostId(validateDBParm.getEOutPostId());
			validateDBParm.setJsonData(JSON.toJSONString(validateRes));
			validateDBParm.setHttpStatus(200);
		}
		
		// 向Wing发起Validate交易之后，更新数据库数据
		wingChargeDao.recordValidatePostDB(validateDBParm);
		if (validateDBParm.getErrorCode() != 0){
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_AFTER_WING + validateDBParm.getErrorCode());
			out.setErrorMessage(validateDBParm.getErrorMessage());
			return out;
		}
		
		if (validateDBParm.getRestStatus() != SysConstants.DB_WING_REST_STATUS_SUCC){
			if (validateDBParm.getRestStatus() == SysConstants.DB_WING_REST_STATUS_FAIL){
				out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + validateDBParm.getRestStatus());
				out.setErrorMessage(tempErrorMessage);
				return out;
			}
			if (validateDBParm.getRestStatus() == SysConstants.DB_WING_REST_STATUS_TIMEOUT){
				out.setErrorCode(SysConstants.ERR_PRECODE_BANK_AFTER_WING + validateDBParm.getRestStatus());
				out.setErrorMessage(tempErrorMessage);
				return out;
			}
			
		}

		// 向Wing发起Commit交易之前，在数据库中保存请求数据
		WingCommitDBParam commitDBParm = wingChargeDao.recordCommitBeforeDB(eTradeFlow);
		if (commitDBParm.getErrorCode() != 0){
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + commitDBParm.getErrorCode());
			out.setErrorMessage(commitDBParm.getErrorMessage());
			return out;
		}
		
		// 向Wing发起Commit交易
		WingCommitRes commitRes = new WingCommitRes();
		commitRes = wingChargeDao.restWingCommit(token);
		if (commitRes.getErrorCode() != 0){
			switch (commitRes.getErrorCode()){
				//超时
				case SysConstants.WING_REST_TIMEOUT:
					commitDBParm.setRestStatus(SysConstants.DB_WING_REST_STATUS_TIMEOUT);
					break; 

				case SysConstants.WING_REST_CONNECTION:
					commitDBParm.setRestStatus(SysConstants.DB_WING_REST_STATUS_FAIL);
					break; 

				case SysConstants.WING_REST_RETURN_ERROR:
					commitDBParm.setRestStatus(SysConstants.DB_WING_REST_STATUS_FAIL);
					commitDBParm.setHttpStatus(commitRes.getHttpStatus());
					
			}
			tempErrorMessage = commitRes.getErrorMessage();
			
			commitDBParm.setEInPostId(commitDBParm.getEOutPostId());
			commitDBParm.setJsonData(tempErrorMessage);
			
		}else{
			commitDBParm.setRestStatus(SysConstants.DB_WING_REST_STATUS_SUCC);
			commitDBParm.setEInPostId(commitDBParm.getEOutPostId());
			commitDBParm.setJsonData(JSON.toJSONString(commitRes));
			commitDBParm.setHttpStatus(200);
		}
		
		// 向Wing发起Commit交易之后，更新数据库数据
		wingChargeDao.recordCommitPostDB(commitDBParm);
		if (commitDBParm.getErrorCode() != 0){
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_AFTER_WING + commitDBParm.getErrorCode());
			out.setErrorMessage(commitDBParm.getErrorMessage());
			return out;
		}
		
		if (commitDBParm.getRestStatus() != SysConstants.DB_WING_REST_STATUS_SUCC){
			if (commitDBParm.getRestStatus() == SysConstants.DB_WING_REST_STATUS_FAIL){
				out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + commitDBParm.getRestStatus());
				out.setErrorMessage(tempErrorMessage);
				return out;
			}
			if (commitDBParm.getRestStatus() == SysConstants.DB_WING_REST_STATUS_TIMEOUT){
				out.setErrorCode(SysConstants.ERR_PRECODE_BANK_AFTER_WING + commitDBParm.getRestStatus());
				out.setErrorMessage(tempErrorMessage);
				return out;
			}
			
		}
		
		// 从数据库中，生成返回数据
		out = wingChargeDao.genOutParam(eTradeFlow);
		if (out.getErrorCode() != 0){
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_AFTER_WING + out.getErrorCode());
			out.setErrorMessage(out.getErrorMessage());
			return out;
		}
		
		return out;
	}
}
