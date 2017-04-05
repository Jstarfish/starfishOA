package cls.pilottery.webncp.system.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.webncp.common.annotation.WebncpMethod;
import cls.pilottery.webncp.common.annotation.WebncpService;
import cls.pilottery.webncp.common.model.BaseResponse;
import cls.pilottery.webncp.system.dao.FbsProcessDao;
import cls.pilottery.webncp.system.model.Response6001Model;
import cls.pilottery.webncp.system.model.Response6001Record;
import cls.pilottery.webncp.system.model.Response6002Model;
import cls.pilottery.webncp.system.model.Response6002Record;
import cls.pilottery.webncp.system.service.FbsProcessService;

@WebncpService
public class FbsProcessServiceImpl implements FbsProcessService {
	
	@Autowired
	private FbsProcessDao fbsProcessDao;

	/**
	 * 获取所有联赛信息
	 */
	@Override
	@WebncpMethod(code = "6001")
	public BaseResponse getCompetitionList(String reqJson) throws Exception {
		Response6001Model res = new Response6001Model();
		List<Response6001Record> recordList = fbsProcessDao.getCompetitionList();
		res.setRecordList(recordList);
		return res;
	}

	/**
	 * 获取所有球队信息
	 */
	@Override
	@WebncpMethod(code = "6002")
	public BaseResponse getTeamList(String reqJson) throws Exception {
		int competitionCode = 0;
		Response6002Model res = new Response6002Model();
		List<Response6002Record> recordList = fbsProcessDao.getTeamList(competitionCode);
		res.setRecordList(recordList);
		return res;
	}

}
