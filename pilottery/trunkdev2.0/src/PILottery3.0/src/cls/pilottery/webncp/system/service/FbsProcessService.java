package cls.pilottery.webncp.system.service;

import cls.pilottery.webncp.common.model.BaseResponse;

public interface FbsProcessService {
	
	public BaseResponse getCompetitionList(String reqJson) throws Exception;

	public BaseResponse getTeamList(String reqJson) throws Exception ;
}
