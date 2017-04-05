package cls.pilottery.oms.monitor.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.oms.monitor.dao.OperateLogDao;
import cls.pilottery.oms.monitor.form.OperateLogForm;
import cls.pilottery.oms.monitor.form.OperateTypeForm;
import cls.pilottery.oms.monitor.model.OperateLog;
import cls.pilottery.oms.monitor.model.OperateType;
import cls.pilottery.oms.monitor.service.OperateLogService;

@Service
public class OperateLogServiceImpl implements OperateLogService {

	@Autowired
	private OperateLogDao operateLogDao;

	@Override
	public Integer getOperateLogCount(OperateLogForm form) {
		return operateLogDao.getOperateLogCount(form);
	}

	@Override
	public List<OperateLog> getOperateLogList(OperateLogForm form) {
		return operateLogDao.getOperateLogList(form);
	}

	@Override
	public Integer getOperateTypeCount(OperateTypeForm form) {
		return operateLogDao.getOperateTypeCount(form);
	}

	@Override
	public List<OperateType> getOperateTypeList(OperateTypeForm form) {
		return operateLogDao.getOperateTypeList(form);
	}

	@Override
	public OperateType getOperateTypeInfo(String operModeId) {
		return operateLogDao.getOperateTypeInfo(operModeId);
	}

	@Override
	public void updateOperateType(OperateType operateType) {
		operateLogDao.updateOperateType(operateType);
	}

	@Override
	public List<OperateType> getAllOperateType() {
		return operateLogDao.getAllOperateType();
	}

	@Override
	public void insertOperateLog(OperateLog operateLog) {
		operateLogDao.insertOperateLog(operateLog);
	}

	@Override
	public String getOperateContent(String operNo) {
		return operateLogDao.getOperateContent(operNo);
	}

	@Override
	public String getThreshold(int typeCode) {
		return operateLogDao.getThreshold(typeCode);
	}

}
