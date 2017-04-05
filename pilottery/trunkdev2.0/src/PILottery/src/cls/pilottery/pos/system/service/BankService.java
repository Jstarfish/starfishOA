package cls.pilottery.pos.system.service;

import cls.pilottery.pos.common.model.BaseResponse;

public interface BankService {

	public BaseResponse getTopupType(Object reqParam) throws Exception;
	public BaseResponse getOutletBankAccInfo(Object reqParam) throws Exception;
	public BaseResponse bankTopUp(Object reqParam) throws Exception;
	public BaseResponse bankWithdraw(Object reqParam) throws Exception;
}
