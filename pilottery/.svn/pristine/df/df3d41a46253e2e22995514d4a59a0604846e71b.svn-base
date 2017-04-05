package cls.pilottery.oms.monitor.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.oms.monitor.dao.OnlineDao;
import cls.pilottery.oms.monitor.form.TerminalOnlineForm;
import cls.pilottery.oms.monitor.model.TerminalOnline;
import cls.pilottery.oms.monitor.service.OnlineService;

@Service
public class OnlineServiceImpl implements OnlineService {

	@Autowired
	private OnlineDao onlineDao;

	@Override
	public Integer getOnlineCount(TerminalOnlineForm form) {
		/*if (form!= null && form.getOnlineTime().equals("0")) {
			return onlineDao.getOfflineCount(form);
		} else {
			return onlineDao.getOnlineCount(form);
		}*/
		return onlineDao.getOnlineCount(form);
	}

	@Override
	public List<TerminalOnline> getOnlineList(TerminalOnlineForm form) {
		/*if (form!= null && form.getOnlineTime().equals("0")) {
			return onlineDao.getOfflineList(form);
		} else {
			return onlineDao.getOnlineList(form);
		}*/
		return onlineDao.getOnlineList(form);
	}

}
