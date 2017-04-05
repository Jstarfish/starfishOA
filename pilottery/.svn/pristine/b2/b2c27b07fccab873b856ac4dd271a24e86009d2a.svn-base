package cls.pilottery.web.capital.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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

}
