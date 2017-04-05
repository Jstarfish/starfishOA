package cls.pilottery.pos.system.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.common.EnumConfigEN;
import cls.pilottery.common.utils.HttpClientUtils;
import cls.pilottery.common.utils.MD5Util;
import cls.pilottery.common.utils.PropertiesUtil;
import cls.pilottery.pos.common.annotation.PosMethod;
import cls.pilottery.pos.common.annotation.PosService;
import cls.pilottery.pos.common.model.BaseRequest;
import cls.pilottery.pos.common.model.BaseResponse;
import cls.pilottery.pos.system.dao.BankTransDao;
import cls.pilottery.pos.system.model.bank.AgencyDigitalTranInfo;
import cls.pilottery.pos.system.model.bank.BankTopupRequest;
import cls.pilottery.pos.system.model.bank.BankTopupResponse;
import cls.pilottery.pos.system.model.bank.BankTypeResponse;
import cls.pilottery.pos.system.model.bank.BankWithdrawRequest;
import cls.pilottery.pos.system.model.bank.BankWithdrawResponse;
import cls.pilottery.pos.system.model.bank.OutletAccoutInfo;
import cls.pilottery.pos.system.model.bank.PayCenterQueryRequest;
import cls.pilottery.pos.system.model.bank.PayCenterQueryRespone;
import cls.pilottery.pos.system.model.bank.PayCenterTopupRequest;
import cls.pilottery.pos.system.model.bank.PayCenterTopupResponse;
import cls.pilottery.pos.system.model.bank.PayCenterWithdrawRequest;
import cls.pilottery.pos.system.model.bank.PayCenterWithdrawResponse;
import cls.pilottery.pos.system.service.BankService;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;

@PosService
public class BankServiceImpl implements BankService {

	public static Logger logger = Logger.getLogger(BankServiceImpl.class);

	// 交易中心url
	public static String TBForTopup = PropertiesUtil
			.readValue("banktran_for_topup_url");
	public static String TBForWithdraw = PropertiesUtil
			.readValue("banktran_for_withdraw_url");
	public static String TBForQuery = PropertiesUtil
			.readValue("banktran_for_query_url");
	public static String CompanyWingCode = PropertiesUtil
			.readValue("url_kpw_code");
	public static String CompanyWingAccount = PropertiesUtil
			.readValue("url_kpw_account");

	@Autowired
	private BankTransDao bankDao;

	@Override
	@PosMethod(code = "030001")
	public BaseResponse getTopupType(Object reqParam) throws Exception {

		BaseResponse result = new BaseResponse();
		List<BankTypeResponse> list = new ArrayList<BankTypeResponse>();

		// 目前没有选择语言，所以没有判断session，只从默认取英文
		if (EnumConfigEN.payTransTypes.size() > 0) {
			for (int key : EnumConfigEN.payTransTypes.keySet()) {
				BankTypeResponse bt1 = new BankTypeResponse();
				bt1.setTypeCode(key);
				bt1.setTypeName(EnumConfigEN.payTransTypes.get(key));
				list.add(bt1);
			}
		}
		result.setResult(list);
		return result;
	}

	@Override
	@PosMethod(code = "030002")
	public BaseResponse getOutletBankAccInfo(Object reqParam) throws Exception {
		BaseRequest request = (BaseRequest) reqParam;
		BaseResponse result = new BaseResponse();
		@SuppressWarnings("rawtypes")
		Map req = JSONObject.parseObject(request.getParam().toString(),
				Map.class);
		String outletCode = (String) req.get("outletCode");
		int accType = (Integer) req.get("typeCode");
		List<OutletAccoutInfo> infos = bankDao.getOutletPayType(outletCode,
				accType);
		result.setResult(infos);
		return result;
	}

	/*
	 * (non-Javadoc) 业务处理流程如下 1、首先判断http返回 超时
	 * 、错误，正常=2xx；超时按照超时继续查询，如果错误直接返回错误；正常继续下一步 2、如果正常返回，根据返回值处理：0 成功 1-200
	 * 失败；200+超时
	 */
	@Override
	@PosMethod(code = "030003")
	public BaseResponse bankTopUp(Object reqParam) throws Exception {
		BaseRequest bq = (BaseRequest) reqParam;
		BaseResponse response = new BaseResponse();

		if (bq == null) {
			response.setErrcode(10012);
			logger.info("请求参数不合法或为空!");
			return response;
		}

		BankTopupRequest rqparam = new BankTopupRequest();
		rqparam = JSONObject.parseObject(bq.getParam().toString(),
				BankTopupRequest.class);

		// 充值流程如下
		// 首先：充值数字表，调用wing接口，如果成功插入充值成功记录，如果失败更新数字表
		// 验证状态
		AgencyDigitalTranInfo dgInfo = bankDao.getOutletTranInfo(rqparam);
		if (dgInfo == null) {
			response.setErrcode(10020);
			logger.info("充值失败：站点、账户不存在或者状态异常！");
			return response;
		}

		dgInfo.setAmount(rqparam.getAmount());
		dgInfo.setTranType(1);// 充值
		dgInfo.setStatus(1);// 发起
		dgInfo.setReqJsonData(JSON.toJSONString(dgInfo));

		// 插入充值申请信息
		try {
			bankDao.insertTranLog(dgInfo);
		} catch (Exception e) {
			response.setErrcode(10500);
			logger.info("充值失败：插入申请信息异常，" + e.getMessage());
			return response;
		}

		// 调用接口
		int errCode = -1;
		PayCenterTopupRequest req = new PayCenterTopupRequest();
		req.setEuser(CompanyWingCode);
		req.setAccount(CompanyWingAccount);
		req.setAmount(rqparam.getAmount());
		req.setUserAcc(rqparam.getAccountID());
		req.setOtp(rqparam.getVerifyCode());
		req.setReqFlow(dgInfo.getTranFlow());

		String hostUrl = TBForTopup;
		String hjson = JSONObject.toJSONString(req);
		logger.debug("向支付中心发送充值请求:" + hostUrl + "，请求内容：" + hjson);

		String resJson = HttpClientUtils.postStringForBank(hostUrl, hjson);
		logger.debug("接收支付中心的充值响应，消息内容：" + resJson);

		if (resJson.contains("timeout")) {

			PayCenterQueryRequest qreq = new PayCenterQueryRequest();
			qreq.setEuser(CompanyWingCode);
			qreq.setAccount(CompanyWingAccount);
			qreq.setReqFlow(dgInfo.getTranFlow());
			qreq.setTransType(1);

			hjson = JSONObject.toJSONString(qreq);
			logger.debug("向支付中心发送查询请求:" + TBForQuery + "，请求内容：" + hjson);

			resJson = HttpClientUtils.postStringForBank(TBForQuery, hjson);
			logger.debug("接收支付中心的查询响应，消息内容：" + resJson);

			// 如果超时不处理，不超时则解析返回信息
			if ((!resJson.contains("timeout"))
					&& (!resJson.contains("neterror"))) {
				PayCenterQueryRespone resp = JSON.parseObject(resJson,
						PayCenterQueryRespone.class);
				if (resp.getErrorCode() == 0 && resp.getIsSucc() == 1)// 成功
				{
					errCode = 0;
					// 赋值
					dgInfo.setBankFlow(resp.getWingFlow());
					dgInfo.setFee(resp.getFee());
					dgInfo.setExchangeRate(resp.getExchange());
				} else if (resp.getErrorCode() == 0 && resp.getIsSucc() == 2)// 失败
				{
					errCode = 2;
					dgInfo.setFailureReason("query result for:"+resp.getFailReason());
					dgInfo.setRepJsonData(resJson);
					
				}else {
					errCode = 4;
					dgInfo.setFailureReason("time out.");
				}
			}

		} else if (resJson.contains("neterror")) {
			errCode = 2;
			dgInfo.setFailureReason("network state is not normal.");
		} else {
			PayCenterTopupResponse resp = JSON.parseObject(resJson,
					PayCenterTopupResponse.class);
			if (resp.getErrorCode() == 0)// 成功
			{
				errCode = 0;
				// 赋值
				dgInfo.setBankFlow(resp.getWingFlow());
				dgInfo.setFee(resp.getFee());
				dgInfo.setExchangeRate(resp.getExchange());

			} else if (resp.getErrorCode() > 0 && resp.getErrorCode() <= 200) {
				errCode = 2;
				dgInfo.setFailureReason("error,for:" + resp.getErrorMessage());
			} else {
				errCode = 4;
				dgInfo.setFailureReason("time out,for:"
						+ resp.getErrorMessage());

			}
		}

		try {
			dgInfo.setRepJsonData(resJson);
			switch (errCode) {
			case 0:// 成功
				bankDao.topupConfirm(dgInfo);
				logger.debug("p_outlet_topup_digital_succ执行完毕,errcode="
						+ dgInfo.getErrCode());
				if (dgInfo.getErrCode() != 0) {
					dgInfo.setStatus(4);
					throw new Exception(dgInfo.getErrMessage());
				}
				break;
			case 2:// 失败
				dgInfo.setStatus(3);
				throw new Exception("failure");
			default:// 其他默认超时
				dgInfo.setStatus(4);
				throw new Exception("Time out");
			}

		} catch (Exception e) {

			bankDao.updataTranLog(dgInfo);
			logger.info("充值失败：" + e.getMessage());
			response.setErrcode(10501);
			response.setErrmesg(e.getMessage());
			return response;

		}

		BankTopupResponse info = new BankTopupResponse();
		info.setBalance(dgInfo.getAfterAmout());
		info.setOutletCode(dgInfo.getAgencyCode());
		info.setOutletName("Outlet Name");
		info.setTopupAmount(dgInfo.getAmount());
		response.setResult(info);
		return response;
	}

	@Override
	@PosMethod(code = "030004")
	public BaseResponse bankWithdraw(Object reqParam) throws Exception {
		BaseRequest request = (BaseRequest) reqParam;
		BaseResponse response = new BaseResponse();

		BankWithdrawRequest req = JSONObject.parseObject(request.getParam()
				.toString(), BankWithdrawRequest.class);
		if (req == null || StringUtils.isEmpty(req.getAccountID())
				|| StringUtils.isEmpty(req.getOutletCode())
				|| req.getAmount() < 1) {
			response.setErrcode(10012);
			return response;
		}

		// 提现流程如下
		// 首先：扣款，插入日志表、调用wing接口，如果成功插入充值成功记录，如果失败更新日志表，退款
		BankTopupRequest rqparam = new BankTopupRequest();
		rqparam.setOutletCode(req.getOutletCode());
		rqparam.setAccountID(req.getAccountID());
		AgencyDigitalTranInfo dgInfo = bankDao.getOutletTranInfoNoFlow(rqparam);
		if (dgInfo == null) {
			response.setErrcode(10020);
			logger.info("提现失败：站点、账户不存在或者状态异常！");
			return response;
		}

		dgInfo.setAmount(req.getAmount());
		dgInfo.setPassword(MD5Util.MD5Encode(req.getPassword()));
		dgInfo.setTranType(2);// 提现
		dgInfo.setStatus(1);// 发起
		dgInfo.setReqJsonData(JSON.toJSONString(dgInfo));

		// 本地扣款
		try {
			bankDao.applyForWithdraw(dgInfo);
			if (dgInfo.getErrCode() != 0)
				throw new Exception(dgInfo.getErrMessage());

			// 超出限额流程
			if (dgInfo.getIsOutLimit() == 1) {
				response.setErrcode(0);
				response.setErrmesg("Application has submitted,waiting for review.");
				logger.info("提现失败：超出限额，等待审批！");
				return response;
			}

		} catch (Exception e) {
			response.setErrcode(10500);
			response.setErrmesg(e.getMessage());
			logger.info("充值失败：插入申请信息异常，" + e.getMessage());
			return response;
		}

		// 发送wing请求
		// 调用接口
		int errCode = -1;
		PayCenterWithdrawRequest req0 = new PayCenterWithdrawRequest();
		req0.setEuser(CompanyWingCode);
		req0.setAccount(CompanyWingAccount);
		req0.setAmount(req.getAmount());
		req0.setUserAcc(req.getAccountID());
		req0.setReqFlow(dgInfo.getTranFlow());

		String hostUrl = TBForWithdraw;
		String hjson = JSONObject.toJSONString(req0);
		logger.debug("向支付中心发送提现请求:" + hostUrl + "，请求内容：" + hjson);

		String resJson = HttpClientUtils.postStringForBank(hostUrl, hjson);
		logger.debug("接收支付中心的提现响应，消息内容：" + resJson);

		if (resJson.contains("timeout")) {

			PayCenterQueryRequest qreq = new PayCenterQueryRequest();
			qreq.setEuser(CompanyWingCode);
			qreq.setAccount(CompanyWingAccount);
			qreq.setReqFlow(dgInfo.getTranFlow());
			qreq.setTransType(2);

			hjson = JSONObject.toJSONString(qreq);
			logger.debug("向支付中心发送查询请求:" + TBForQuery + "，请求内容：" + hjson);

			resJson = HttpClientUtils.postStringForBank(TBForQuery, hjson);
			logger.debug("接收支付中心的查询响应，消息内容：" + resJson);

			errCode = 4;		
			// 如果超时不处理，不超时则解析返回信息
			if ((!resJson.contains("timeout"))
					&& (!resJson.contains("neterror"))) {
				PayCenterQueryRespone resp = JSON.parseObject(resJson,
						PayCenterQueryRespone.class);
				if (resp.getErrorCode() == 0 && resp.getIsSucc() == 1)// 成功
				{
					errCode = 0;
					// 赋值
					dgInfo.setBankFlow(resp.getWingFlow());
					dgInfo.setFee(resp.getFee());
					dgInfo.setExchangeRate(resp.getExchange());
				} else if (resp.getErrorCode() == 0 && resp.getIsSucc() == 2)// 失败
				{
					errCode = 2;
					dgInfo.setFailureReason("query result for:"+resp.getFailReason());
					dgInfo.setRepJsonData(resJson);
					
				}else {
					errCode = 4;
					dgInfo.setFailureReason("time out.");
				}
			}

		} else if (resJson.contains("neterror")) {
			errCode = 2;
			dgInfo.setFailureReason("network state is not normal.");
		} else {
			PayCenterWithdrawResponse resp = JSON.parseObject(resJson,
					PayCenterWithdrawResponse.class);
			if (resp.getErrorCode() == 0)// 成功
			{
				errCode = 0;
				// 赋值
				dgInfo.setBankFlow(resp.getWingFlow());
				dgInfo.setFee(resp.getFee());
				dgInfo.setExchangeRate(resp.getExchange());

			} else if (resp.getErrorCode() > 0 && resp.getErrorCode() <= 200) {
				errCode = 2;
				dgInfo.setFailureReason("error,for:" + resp.getErrorMessage());
			} else {
				errCode = 4;
				dgInfo.setFailureReason("time out,for:"
						+ resp.getErrorMessage());

			}			
		}

		try {
			dgInfo.setRepJsonData(resJson);
			switch (errCode) {
			case 0:// 成功
				dgInfo.setStatus(2);
				bankDao.updataTranLog(dgInfo);
				break;
			case 2:// 失败
				dgInfo.setStatus(3);
				bankDao.withdrawCancel(dgInfo);
			default:// 其他默认超时
				dgInfo.setStatus(4);
				bankDao.updataTranLog(dgInfo);
			}
			if (errCode != 0)
				throw new Exception("交易失败");

		} catch (Exception e) {

			logger.info("提现失败：" + e.getMessage());
			response.setErrcode(10501);
			return response;
		}

		BankWithdrawResponse result = new BankWithdrawResponse();
		result.setWithdrawCode(dgInfo.getTranFlow());
		response.setResult(result);
		return response;
	}

}
