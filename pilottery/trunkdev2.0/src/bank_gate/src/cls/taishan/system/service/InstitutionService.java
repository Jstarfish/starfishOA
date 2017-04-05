package cls.taishan.system.service;

import java.util.List;

import cls.taishan.system.form.InstitutionForm;
import cls.taishan.system.model.Institution;
import cls.taishan.system.model.User;

public interface InstitutionService {

	List<Institution> getInstitutionList(InstitutionForm form);

	List<User> getUser();

	void saveInstitution(Institution institution);

	Institution getOrgInfoByCode(String orgCode);

	void updateOrg(Institution institution);

	void deleteOrg(String orgCode);

	String getOrgCode(String orgCode);
	
}
