package cls.pilottery.oms.monitor.dao;

import java.util.List;

import cls.pilottery.oms.monitor.form.LogForm;
import cls.pilottery.oms.monitor.model.TaishanLog;

public interface MLogDao {

	public List<TaishanLog> getLogList(LogForm form);
	
	public int getLogCount(LogForm form);
}
