package cls.pilottery.pos.system.service;

import cls.pilottery.pos.common.model.BaseResponse;

public interface BasicDataService {
	
	public BaseResponse getPlanList(Object reqParam) throws Exception;
	
	public BaseResponse getOutletsInfoList(Object reqParam) throws Exception;
	
	public BaseResponse getWareHouseInfo(Object reqParam) throws Exception;
	
	public BaseResponse getBatchByPlan(Object reqParam) throws Exception;

}
