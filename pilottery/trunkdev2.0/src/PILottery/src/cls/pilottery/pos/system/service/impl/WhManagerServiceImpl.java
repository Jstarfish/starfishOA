package cls.pilottery.pos.system.service.impl;

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
import cls.pilottery.pos.system.dao.WhManagerDao;
import cls.pilottery.pos.system.model.wh.InstoreRecord070001Res;
import cls.pilottery.pos.system.service.WhManagerService;

@PosService
public class WhManagerServiceImpl implements WhManagerService {
	public static Logger log = Logger.getLogger(WhManagerServiceImpl.class);
	
	@Autowired
	private WhManagerDao whManagerDao;
	@Autowired
	private RedisService redisService;

	@Override
	@PosMethod(code="0700001")
	public BaseResponse getInstorRecordList(Object reqParam) throws Exception {
		BaseRequest bq = (BaseRequest)reqParam;
		BaseResponse result = new BaseResponse();
		UserToken ut = (UserToken)redisService.getObject(bq.getToken());
		
		List<InstoreRecord070001Res> recordList = whManagerDao.getInstorRecordList(ut.getInstitutionCode());
		Map<String,Object> res = new HashMap<String,Object>();
		res.put("recordList", recordList);
		result.setResult(res);
		
		return result;
	}

	@Override
	@PosMethod(code="0700002")
	public BaseResponse getBatchList(Object reqParam) throws Exception {
		
		
		return null;
	}

	@Override
	@PosMethod(code="0700003")
	public BaseResponse submitBatchInstore(Object reqParam) throws Exception {
		
		return null;
	}

	@Override
	@PosMethod(code="0700004")
	public BaseResponse getTransferList(Object reqParam) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	@PosMethod(code="0700005")
	public BaseResponse submitTransferInstore(Object reqParam) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	@PosMethod(code="0700006")
	public BaseResponse getReturnList(Object reqParam) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	@PosMethod(code="0700007")
	public BaseResponse submitReturnInstore(Object reqParam) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	@PosMethod(code="0700008")
	public BaseResponse getOutStoreList(Object reqParam) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	@PosMethod(code="0700009")
	public BaseResponse submitTransferOutStore(Object reqParam)
			throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	@PosMethod(code="0700010")
	public BaseResponse getDeliveryList(Object reqParam) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	@PosMethod(code="0700011")
	public BaseResponse submitDeliveryOutStore(Object reqParam)
			throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	@PosMethod(code="0700012")
	public BaseResponse getCheckRecordList(Object reqParam) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	@PosMethod(code="0700013")
	public BaseResponse submitCheckRecord(Object reqParam) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

}
