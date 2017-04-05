package cls.pilottery.web.area.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.oms.business.model.OrgInfo;
import cls.pilottery.web.area.dao.AreasDao;
import cls.pilottery.web.area.form.AreaForm;
import cls.pilottery.web.area.service.AreaService;
import cls.pilottery.web.institutions.model.Area;

@Service
public class AreaServiceImpl implements AreaService {

	@Autowired
	private AreasDao areaDao;

	public AreasDao getAreaDao() {

		return areaDao;
	}

	public void setAreaDao(AreasDao areaDao) {

		this.areaDao = areaDao;
	}



	@Override
	public Integer getAreaCount(AreaForm form) {

		return areaDao.getAreaCount(form);
	}

	@Override
	public List<AreaForm> getAreaList(AreaForm form) {

		return areaDao.getAreaList(form);
	}

	
	@Override
	public List<Area> getAreaListByareaCode(String areaCode) {
		Map<String,Object> map =new HashMap<String,Object>();
		if(areaCode.equals(new Long(0)))
		{
			map.put("stype", 1);
		}
		else{
			map.put("stype", 2);
		}
		map.put("areaCode", areaCode);
		return this.areaDao.getAreaListByareaCode(map);
	}
	@Override
	public Area getAreaInfoByareacode(String areaCode) {
		// TODO Auto-generated method stub
		return this.areaDao.getAreaInfoByareacode(areaCode);
	}
	@Override
	public String getAreaById(String areaCode) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("areaCode", areaCode);
		return this.areaDao.getAreaById(map);
	}
	@Override
	public String getAreaCodeByparendId(Long type, String parentAreaCode) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("type", type);
		map.put("parentAreaCode", parentAreaCode);
		return this.areaDao.getAreaCodeByparendId(map);
	}
	@Override
	public String getPareCodebyCode(String areaCode) {
		return this.areaDao.getPareCodebyCode(areaCode);
	}

}
