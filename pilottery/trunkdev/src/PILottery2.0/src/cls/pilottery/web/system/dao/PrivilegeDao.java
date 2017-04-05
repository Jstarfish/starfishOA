package cls.pilottery.web.system.dao;

import java.util.List;
import java.util.Map;

import cls.pilottery.web.system.model.Privilege;

public interface PrivilegeDao {

	List<Privilege> getPrivilegeByUserId(Map<String,Integer> map);
	
	public Privilege getPrivilegeById(Long privilegeId);
	
	public List<Privilege> getPrivilegeByCode(String code);

	
}
