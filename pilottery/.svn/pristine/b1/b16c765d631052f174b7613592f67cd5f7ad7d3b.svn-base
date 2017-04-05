package cls.pilottery.web.system.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.system.dao.PrivilegeDao;
import cls.pilottery.web.system.model.Privilege;
import cls.pilottery.web.system.model.Role;
import cls.pilottery.web.system.service.PrivilegeService;

@Service
public class PrivilegeServiceImpl implements PrivilegeService {

	@Autowired
	private PrivilegeDao privilegeDao;
	
	@Override
	public List<Privilege> getPrivilegeByUserId(Long userId,String system) {
		Map<String,Integer> map = new HashMap<String,Integer>();
		map.put("userId", userId.intValue());
		if(system == null){
			map.put("system", 1);
		}else{
			if(system.equals("oms")){
				map.put("system", 1);
			}else{
				map.put("system", 0);
			}
		}
		
		return privilegeDao.getPrivilegeByUserId(map);
	}

	@Override
	public List<Privilege> getAllPrivilegeList(int areacode) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Privilege> getPrivilegeListByUserId(Long userId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Privilege getPrivilegeById(Long privilegeId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Privilege> getPrivilegeByCode(String code) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Privilege> getRolePrivelege(List<Role> roles, int areacode) {
		// TODO Auto-generated method stub
		return null;
	}

	
}
