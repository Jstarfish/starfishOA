package cls.pilottery.web.area.service;

import java.util.List;

import cls.pilottery.oms.business.model.OrgInfo;
import cls.pilottery.web.area.form.AreaForm;
import cls.pilottery.web.institutions.model.Area;

public interface AreaService {

	Integer getAreaCount(AreaForm form);

	List<AreaForm> getAreaList(AreaForm form);

	public List<Area> getAreaListByareaCode(String areaCode);

	public Area getAreaInfoByareacode(String areaCode);

	public String getAreaById(String areaCode);

	public String getAreaCodeByparendId(Long type, String parentAreaCode);

	public String getPareCodebyCode(String areaCode);

}
