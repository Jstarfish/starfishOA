package cls.pilottery.web.area.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.area.dao.AreasDao;
import cls.pilottery.web.area.form.AreaForm;
import cls.pilottery.web.area.service.AreaService;

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
}
