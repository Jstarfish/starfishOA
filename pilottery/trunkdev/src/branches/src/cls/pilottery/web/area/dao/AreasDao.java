package cls.pilottery.web.area.dao;

import java.util.List;

import cls.pilottery.web.area.form.AreaForm;


public interface AreasDao {
    List<AreaForm> selectAllAreas();

	Integer getAreaCount(AreaForm form);

	List<AreaForm> getAreaList(AreaForm form);
}