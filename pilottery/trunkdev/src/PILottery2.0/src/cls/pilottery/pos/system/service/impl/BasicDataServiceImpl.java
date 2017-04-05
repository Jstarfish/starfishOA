package cls.pilottery.pos.system.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.common.service.RedisService;
import cls.pilottery.pos.common.annotation.PosMethod;
import cls.pilottery.pos.common.annotation.PosService;
import cls.pilottery.pos.common.model.BaseRequest;
import cls.pilottery.pos.common.model.BaseResponse;
import cls.pilottery.pos.common.model.UserToken;
import cls.pilottery.pos.system.dao.BasicDataManageDao;
import cls.pilottery.pos.system.model.BatchInfo;
import cls.pilottery.pos.system.model.OutletInfoResponse;
import cls.pilottery.pos.system.model.PlanListResponse;
import cls.pilottery.pos.system.model.WareHouseInfo;
import cls.pilottery.pos.system.service.BasicDataService;
import cls.pilottery.web.plans.model.Plan;
import cls.pilottery.web.plans.service.PlanService;

import com.alibaba.fastjson.JSONObject;

@PosService
public class BasicDataServiceImpl implements BasicDataService {

	public static Logger logger = Logger.getLogger(BasicDataServiceImpl.class);

	@Autowired
	private PlanService planService;
	@Autowired
	private RedisService redisService;
	@Autowired
	private BasicDataManageDao basicDataManageDao;

	/*
	 * 获取方案列表（0x990001）
	 */
	@Override
	@PosMethod(code = "990001")
	public BaseResponse getPlanList(Object reqParam) throws Exception {
		BaseResponse result = new BaseResponse();
		List<PlanListResponse> list = new ArrayList<PlanListResponse>();
		List<Plan> plans = planService.getPlanListForPOS();
		if (plans != null && plans.size() > 0) {
			for (Plan p : plans) {
				PlanListResponse pi = new PlanListResponse();
				pi.setFaceValue(p.getFaceValue());
				pi.setPlanCode(p.getPlanCode());
				pi.setPlanName(p.getFullName());
				pi.setPrinterCode(p.getPrinterCode() + "");
				list.add(pi);
			}
		}
		result.setResult(list);
		return result;
	}
	
	/*
	 * 获取市场管理员所管辖的站点信息（0x990002）
	 */
	@Override
	@PosMethod(code = "990002")
	public BaseResponse getOutletsInfoList(Object reqParam) throws Exception {
		BaseRequest bq = (BaseRequest)reqParam;
		BaseResponse result = new BaseResponse();
		UserToken ut = (UserToken)redisService.getObject(bq.getToken());
		
		List<OutletInfoResponse> list = basicDataManageDao.getOutletsInfoList(ut.getId());
		
		if(list != null && list.size()>0){
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("outletList", list);
			result.setResult(map);
		}
		
		return result;
	}
	
	/*
	 * 仓库管理员获取其管辖仓库的信息（0x990003）
	 */
	@Override
	@PosMethod(code = "990003")
	public BaseResponse getWareHouseInfo(Object reqParam) throws Exception {
		BaseRequest request = (BaseRequest)reqParam;
		BaseResponse result = new BaseResponse();
		Map req = JSONObject.parseObject(request.getParam().toString(), Map.class);
		String whManager = (String)req.get("whManager");
		
		WareHouseInfo info = basicDataManageDao.getWareHouseInfo(whManager);
		result.setResult(info);
		
		return result;
	}

	@Override
	public BaseResponse getBatchByPlan(Object reqParam) throws Exception {
		BaseRequest request = (BaseRequest)reqParam;
		BaseResponse result = new BaseResponse();
		Map req = JSONObject.parseObject(request.getParam().toString(), Map.class);
		String planCode = (String)req.get("planCode");
		
		List<BatchInfo> batchList = basicDataManageDao.getBatchByPlan(planCode);
		Map<String,Object> res = new HashMap<String,Object>();
		res.put("batchList", batchList);
		result.setResult(res);
		
		return result;
	}
}
