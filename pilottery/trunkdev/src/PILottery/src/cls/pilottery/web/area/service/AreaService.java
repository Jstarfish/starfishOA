package cls.pilottery.web.area.service;

import java.util.List;

import cls.pilottery.web.area.form.AreaForm;

public interface AreaService {



	Integer getAreaCount(AreaForm form);

	List<AreaForm> getAreaList(AreaForm form);
}
