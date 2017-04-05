package cls.pilottery.web.capital.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.web.capital.dao.CapitalRecordDao;
import cls.pilottery.web.capital.form.CapitalRecordForm;
import cls.pilottery.web.capital.model.CapitalRecord;
import cls.pilottery.web.capital.model.InstitutionCommDetailVO;
import cls.pilottery.web.capital.service.CapitalRecordService;

@Service
public class CapitalRecordServiceImpl implements CapitalRecordService {
	
	@Autowired
	private CapitalRecordDao capitalRecordDao;

	@Override
	public Integer getCapitalRecordCount(CapitalRecordForm form) {
		return capitalRecordDao.getCapitalRecordCount(form);
	}

	@Override
	public List<CapitalRecord> getCapitalRecordList(CapitalRecordForm form) {
		return capitalRecordDao.getCapitalRecordList(form);
	}

	@Override
	public List<InstitutionCommDetailVO> getCapitalRecordDetail(String flowNo) {
		return capitalRecordDao.getCapitalRecordDetail(flowNo);
	}

	@Override
	public InstitutionCommDetailVO getCapitalRecordDetailSum(String flowNo) {
		return capitalRecordDao.getCapitalRecordDetailSum(flowNo);
	}

	@Override
	public Map<Integer, String> getTransFlowList(String institutionCode, HttpServletRequest request) {
		List<Integer> list = capitalRecordDao.getTransFlowList(institutionCode);
		Map<Integer, String> map = new HashMap<Integer,String>();
		Map<Integer, String> transMap = LocaleUtil.getUserLocaleEnum("transFlowType", request);
		for(Integer i :list){
			map.put(i, transMap.get(i));
		}
		
		return map;
	}

}
