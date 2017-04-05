package cls.pilottery.web.warehouses.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.plans.form.PlanForm;
import cls.pilottery.web.warehouses.dao.DamageDao;
import cls.pilottery.web.warehouses.model.DamageInfo;
import cls.pilottery.web.warehouses.service.DamageService;

@Service
public class DamageServiceImpl implements DamageService {

	@Autowired
	private DamageDao dao;

	public DamageDao getDao() {

		return dao;
	}

	public void setDao(DamageDao dao) {

		this.dao = dao;
	}

	@Override
	public List<DamageInfo> getDamageList(PlanForm planForm) {

		return dao.getDamageList(planForm);
	}

	@Override
	public Integer getDamageCount(PlanForm planForm) {

		return dao.getDamageCount(planForm);
	}

	@Override
	public List<DamageInfo> getDamageDetails(String record) {

		return dao.getDamageDetails(record);
	}

}
