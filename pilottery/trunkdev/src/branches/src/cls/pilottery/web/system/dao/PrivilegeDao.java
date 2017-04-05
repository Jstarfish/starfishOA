package cls.pilottery.web.system.dao;

import java.util.List;

import cls.pilottery.web.system.model.Privilege;
import cls.pilottery.web.system.model.User;

public interface PrivilegeDao {
	


	List<Privilege> getPrivilegeByUserId(Long id);
	
	/*
	 * will modify
	 */
	
	public Privilege getPrivilegeById(Long privilegeId);
	
	public List<Privilege> getPrivilegeByCode(String code);

	
}
