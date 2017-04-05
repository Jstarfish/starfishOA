package cls.pilottery.oms.monitor.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.oms.monitor.dao.MLogDao;
import cls.pilottery.oms.monitor.form.LogForm;
import cls.pilottery.oms.monitor.model.TaishanLog;
import cls.pilottery.oms.monitor.service.MLogService;

@Service
public class MLogServiceImpl implements MLogService{

	@Autowired
	MLogDao  logDao;

	@Override
	public List<TaishanLog> getLogList(LogForm form) {
		return logDao.getLogList(form);
	}

	@Override
	public int getLogCount(LogForm form) {
		return logDao.getLogCount(form);
	}

	
}
