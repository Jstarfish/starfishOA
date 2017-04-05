package cls.taishan.system.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.taishan.system.dao.InstitutionDao;
import cls.taishan.system.form.InstitutionForm;
import cls.taishan.system.model.Institution;
import cls.taishan.system.model.User;
import cls.taishan.system.service.InstitutionService;

@Service
public class InstitutionServiceImpl implements InstitutionService {

	@Autowired
	private InstitutionDao institutionDao;
	@Override
	public List<Institution> getInstitutionList(InstitutionForm form) {
		return institutionDao.getInstitutionList(form);
	}
	@Override
	public List<User> getUser() {
		return institutionDao.getUser();
	}
	@Override
	public void saveInstitution(Institution institution) {
		institutionDao.saveInstitution(institution);
	}
	@Override
	public Institution getOrgInfoByCode(String orgCode) {
		return institutionDao.getOrgInfoByCode(orgCode);
	}
	@Override
	public void updateOrg(Institution institution) {
		institutionDao.updateOrg(institution);
	}
	@Override
	public void deleteOrg(String orgCode) {
		institutionDao.deleteOrg(orgCode);
	}
	@Override
	public String getOrgCode(String orgCode) {
		return institutionDao.getOrgCode(orgCode);
	}

}
