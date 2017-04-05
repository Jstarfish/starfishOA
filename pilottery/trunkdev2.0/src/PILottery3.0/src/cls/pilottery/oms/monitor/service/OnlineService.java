package cls.pilottery.oms.monitor.service;

import java.util.List;

import cls.pilottery.oms.monitor.form.TerminalOnlineForm;
import cls.pilottery.oms.monitor.model.TerminalOnline;

public interface OnlineService {

	Integer getOnlineCount(TerminalOnlineForm form);

	List<TerminalOnline> getOnlineList(TerminalOnlineForm form);
}
