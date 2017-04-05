package cls.pilottery.oms.monitor.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.oms.monitor.dao.CheckDao;
import cls.pilottery.oms.monitor.form.TerminalCheckForm;
import cls.pilottery.oms.monitor.model.TerminalCheck;

@Service
public class CheckServiceImpl implements cls.pilottery.oms.monitor.service.CheckService {

	@Autowired
	private CheckDao checkDao;

	@Override
	public Integer getCheckCount(TerminalCheckForm form) {
		return checkDao.getCheckCount(form);
	}

	@Override
	public List<TerminalCheck> getCheckList(TerminalCheckForm form) {
		return checkDao.getCheckList(form);
	}

}
