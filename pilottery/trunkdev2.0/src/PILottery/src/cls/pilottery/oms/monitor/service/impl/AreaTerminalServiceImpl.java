package cls.pilottery.oms.monitor.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.oms.monitor.dao.AreaTerminalDao;
import cls.pilottery.oms.monitor.model.AreaTerminal;
import cls.pilottery.oms.monitor.service.AreaTerminalService;

@Service
public class AreaTerminalServiceImpl implements AreaTerminalService {

	@Autowired
	private AreaTerminalDao areaTerminalDao;
	
	@Override
	public List<AreaTerminal> listAllAreaTerminal() {
		return areaTerminalDao.listAllAreaTerminal();
	}

	@Override
	public List<AreaTerminal> listAllAreas(AreaTerminal areaTerminal) {
		return areaTerminalDao.listAllAreas(areaTerminal);
	}

}
