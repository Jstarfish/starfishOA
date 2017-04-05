package cls.pilottery.web.area.dao;

import java.util.List;
import java.util.Map;

import cls.pilottery.oms.business.model.OrgInfo;
import cls.pilottery.web.area.form.AreaForm;
import cls.pilottery.web.area.model.City;
import cls.pilottery.web.institutions.model.Area;

public interface AreasDao {
	List<AreaForm> selectAllAreas();

	Integer getAreaCount(AreaForm form);

	List<AreaForm> getAreaList(AreaForm form);

	// 根据区域编号查询区域
	Area selectAreaByCode(String code);

	public List<City> selectCityAreaCode(Map<String, Object> map);

	public List<Area> getAreaListByareaCode(Map<String, Object> map);

	public Area getAreaInfoByareacode(String areaCode);

	public String getAreaById(Map<?, ?> map);

	public String getAreaCodeByparendId(Map<?, ?> map);

	public String getPareCodebyCode(String areaCode);

	List<OrgInfo> getOrgListByOrgCode(String orgCode);
}