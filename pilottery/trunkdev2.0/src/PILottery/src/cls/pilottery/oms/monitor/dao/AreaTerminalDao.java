package cls.pilottery.oms.monitor.dao;

import java.util.List;

import cls.pilottery.oms.monitor.model.AreaTerminal;

public interface AreaTerminalDao {

	public List<AreaTerminal> listAllAreaTerminal();

    public List<AreaTerminal> listAllAreas(AreaTerminal areaTerminal);
    
}
