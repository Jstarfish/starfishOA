package cls.pilottery.oms.monitor.service;

import java.util.List;

import cls.pilottery.oms.monitor.form.TerminalCheckForm;
import cls.pilottery.oms.monitor.model.TerminalCheck;

public interface CheckService {

	public Integer getCheckCount(TerminalCheckForm form) ;

	public List<TerminalCheck> getCheckList(TerminalCheckForm form);

}
