package cls.pilottery.oms.monitor.service;

import java.util.List;

import cls.pilottery.oms.monitor.model.AreaTerminal;

public interface AreaTerminalService {

	public List<AreaTerminal> listAllAreaTerminal();

    public List<AreaTerminal> listAllAreas(AreaTerminal areaTerminal);
    
}
