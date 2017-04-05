package cls.taishan.web.controller;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;

import cls.taishan.common.constants.SysConstants;
import cls.taishan.web.model.control.WingChargeInputParam;
import cls.taishan.web.model.control.WingChargeOutputParam;
import cls.taishan.web.model.control.WingSearchInputParam;
import cls.taishan.web.model.control.WingSearchOutputParam;
import cls.taishan.web.model.control.WingWithdrawInputParam;
import cls.taishan.web.model.control.WingWithdrawOutputParam;
import cls.taishan.web.service.WingChargeService;
import cls.taishan.web.service.WingSearchService;
import cls.taishan.web.service.WingWithdrawService;
import lombok.extern.log4j.Log4j;

@Log4j
@Controller
@RequestMapping("/API")
public class WingController {

	@Autowired
	public WingSearchService searchService;
	
	@Autowired
	public WingWithdrawService wingWithdrawService;
	
	@Autowired
	public WingChargeService wingChargeService;

	@RequestMapping(value = "/wing_check", method = RequestMethod.POST)
	@ResponseBody
	public WingSearchOutputParam doSearch(@RequestBody String reqBody) {
		log.debug("请求参数：" + reqBody);
		WingSearchInputParam in = null;
		WingSearchOutputParam out = new WingSearchOutputParam();
		if (StringUtils.isNotEmpty(reqBody)) {
			try {
				in = JSON.parseObject(reqBody, WingSearchInputParam.class);
			} catch (Exception e) {
				log.error(e);
				out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + SysConstants.ERR_PARAMETER_NOT_VALID);
				out.setErrorMessage("Request parameter is error.");
				return out;
			}
		} else {
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + SysConstants.ERR_PARAMETER_HAS_NULL);
			out.setErrorMessage("Request parameter is null.");
			return out;
		}

		if (in.getEuser() == null || in.getEuser().isEmpty()) {
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + SysConstants.ERR_PARAMETER_HAS_NULL);
			out.setErrorMessage("EUser is empty in the input parameter.");
			return out;
		}

		if (in.getAccount() == null || in.getAccount().isEmpty()) {
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + SysConstants.ERR_PARAMETER_HAS_NULL);
			out.setErrorMessage("Account is empty in the input parameter.");
			return out;
		}

		if (in.getReqFlow() == null || in.getReqFlow().isEmpty()) {
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + SysConstants.ERR_PARAMETER_HAS_NULL);
			out.setErrorMessage("ReqFlow is empty in the input parameter.");
			return out;
		}

		if (in.getTransType() == 0) {
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + SysConstants.ERR_PARAMETER_HAS_NULL);
			out.setErrorMessage("TransType is 0 in the input parameter.");
			return out;
		}

		searchService.doSearch(in, out);
		log.debug("返回结果：" + out);
		return out;
	}

	@RequestMapping(value = "/wing_withdraw", method = RequestMethod.POST)
	@ResponseBody
	public WingWithdrawOutputParam doWithdraw(@RequestBody String reqBody) {
		log.debug("请求参数：" + reqBody);
		WingWithdrawInputParam in = null;
		WingWithdrawOutputParam out = new WingWithdrawOutputParam();
		if (StringUtils.isNotEmpty(reqBody)) {
			try {
				in = JSON.parseObject(reqBody, WingWithdrawInputParam.class);
			} catch (Exception e) {
				log.error(e);
				out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + SysConstants.ERR_PARAMETER_NOT_VALID);
				out.setErrorMessage("Request parameter is error." + out.getErrorMessage());
				return out;
			}
		} else {
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + SysConstants.ERR_PARAMETER_HAS_NULL);
			out.setErrorMessage("Request parameter is null.");
			return out;
		}

		if (in.getEuser() == null || in.getEuser().isEmpty()) {
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + SysConstants.ERR_PARAMETER_HAS_NULL);
			out.setErrorMessage("EUser is empty in the input parameter.");
			return out;
		}

		if (in.getAccount() == null || in.getAccount().isEmpty()) {
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + SysConstants.ERR_PARAMETER_HAS_NULL);
			out.setErrorMessage("Account is empty in the input parameter.");
			return out;
		}

		if (in.getAmount() == 0) {
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + SysConstants.ERR_PARAMETER_HAS_NULL);
			out.setErrorMessage("Amount is 0 in the input parameter.");
			return out;
		}

		if (in.getUserAcc() == null || in.getUserAcc().isEmpty()) {
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + SysConstants.ERR_PARAMETER_HAS_NULL);
			out.setErrorMessage("userAcc is empty in the input parameter.");
			return out;
		}

		if (in.getReqFlow() == null || in.getReqFlow().isEmpty()) {
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + SysConstants.ERR_PARAMETER_HAS_NULL);
			out.setErrorMessage("ReqFlow is empty in the input parameter.");
			return out;
		}

		out = wingWithdrawService.doWithdraw(in);
		log.debug("返回结果：" + out);
		return out;
	}

	@RequestMapping(value = "/wing_charge", method = RequestMethod.POST)
	@ResponseBody
	public WingChargeOutputParam doCharge(@RequestBody String reqBody) {
		log.debug("请求参数：" + reqBody);
		WingChargeInputParam in = null;
		// 初始化返回值
		WingChargeOutputParam out = new WingChargeOutputParam();
		if (StringUtils.isNotEmpty(reqBody)) {
			try {
				in = JSON.parseObject(reqBody, WingChargeInputParam.class);
			} catch (Exception e) {
				log.error(e);
				out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + SysConstants.ERR_PARAMETER_NOT_VALID);
				out.setErrorMessage("Request parameter is error.");
				return out;
			}
		} else {
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + SysConstants.ERR_PARAMETER_HAS_NULL);
			out.setErrorMessage("Request parameter is null.");
			return out;
		}

		if (in.getEuser() == null || in.getEuser().isEmpty()) {
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + SysConstants.ERR_PARAMETER_HAS_NULL);
			out.setErrorMessage("EUser is empty in the input parameter.");
			return out;
		}

		if (in.getAccount() == null || in.getAccount().isEmpty()) {
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + SysConstants.ERR_PARAMETER_HAS_NULL);
			out.setErrorMessage("Account is empty in the input parameter.");
			return out;
		}

		if (in.getAmount() == 0) {
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + SysConstants.ERR_PARAMETER_HAS_NULL);
			out.setErrorMessage("Amount is 0 in the input parameter.");
			return out;
		}

		if (in.getUserAcc() == null || in.getUserAcc().isEmpty()) {
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + SysConstants.ERR_PARAMETER_HAS_NULL);
			out.setErrorMessage("userAcc is empty in the input parameter.");
			return out;
		}

		if (in.getOtp() == null || in.getOtp().isEmpty()) {
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + SysConstants.ERR_PARAMETER_HAS_NULL);
			out.setErrorMessage("otp is empty in the input parameter.");
			return out;
		}

		if (in.getReqFlow() == null || in.getReqFlow().isEmpty()) {
			out.setErrorCode(SysConstants.ERR_PRECODE_BANK_BEFORE_WING + SysConstants.ERR_PARAMETER_HAS_NULL);
			out.setErrorMessage("ReqFlow is empty in the input parameter.");
			return out;
		}

		out = wingChargeService.doCharge(in);
		log.debug("返回结果：" + out);
		return out;
	}

	@RequestMapping(value = "/test_login", method = RequestMethod.POST)
	@ResponseBody
	public String testCharge(@RequestBody String reqBody) {
		return "{\"access_token\":\"5f2fae66-6726-458b-bf98-1ff238754d8f\",\"token_type\":\"bearer\",\"expires_in\":299,\"scope\":\"trust\"}";
	}

	@RequestMapping(value = "/test_wd", method = RequestMethod.POST)
	@ResponseBody
	public String testWD(@RequestBody String reqBody) {
		return "{\"currency\":\"USD\",\"amount\":\"USD 300.00\",\"fee\":\"USD 0.50\",\"total\":\"USD 300.50\",\"balance\":\"USD 11,480.86\",\"exchange_rate\":\"\",\"transaction_id\":\"EAB760147\",\"account_name\":\"Sar Socheata\"}";
	}

	@RequestMapping(value = "/test_validate", method = RequestMethod.POST)
	@ResponseBody
	public String testValidate(@RequestBody String reqBody) {
		return "{\"amount\":\"KHR 4,000\",\"fee\":\"0\",\"total\":\"USD 0.98\",\"exchange_rate\":\"KHR 4,052=USD 1.00\",\"consumer_id\":\"123456789012345678901234\",\"biller_name\":\"KPW\"}";
	}

	@RequestMapping(value = "/test_commit", method = RequestMethod.POST)
	@ResponseBody
	public String testCommit(@RequestBody String reqBody) {
		return "{\"amount\":\"KHR 4,000=USD 0.98\",\"total\":\"KHR 4,000=USD 0.98\",\"balance\":\"USD 1,455.14\",\"exchange_rate\":\"KHR 4,052=USD 1.00\",\"transaction_id\":\"UAB909461\",\"consumer_id\":\"123456789012345678901234\",\"biller_name\":\"KPW\",\"biller_code\":\"6688\"}";
	}

}
