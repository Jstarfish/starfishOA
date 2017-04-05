package cls.taishan.system.service.impl;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cls.taishan.system.dao.UserDao;
import cls.taishan.system.form.UserForm;
import cls.taishan.system.model.OrgInfo;
import cls.taishan.system.model.Role;
import cls.taishan.system.model.User;
import cls.taishan.system.service.UserService;

@Service
public class UserServiceImpl implements UserService {
	@Autowired
	private UserDao userDao;
	
	@Override
	public User getUserByCondition(UserForm form) {
		return userDao.getUserByCondition(form);
	}

	@Override
	public List<User> getAllUsers(UserForm form) {
		return userDao.getAllUsers(form);
	}
	
	@Override
	public List<OrgInfo> getAllOrgs() {
		return userDao.getAllOrgs();
	}

	@Override
	public User getUserByLogin(String regAcct) {
		UserForm form = new UserForm();
		form.setLoginId(regAcct);
		//form.setStatus(1);
		return userDao.getUserByCondition(form);
	}
	
	@Override
	public void updatePwd(User user) {
		userDao.updatePwd(user);	
	}
	
	@Override
	public void updateUserStatus(User user) {
		userDao.updateUserStatus(user);		
	}

	@Override
	@Transactional(rollbackFor={Exception.class})
	public void saveUser(User user) {
		userDao.saveUser(user);
		String roleIds = user.getRoleId();
		if(StringUtils.isNotEmpty(roleIds)){
			String[] roleArr = roleIds.split(",");
			Long userId = this.getUserIdByName(user.getLoginId());
			for (String roleId : roleArr) {
				user.setId(userId);
				user.setRoleId(roleId);
				this.addUserRole(user);
			}
		}
	}

	@Override
	public void updateUser(User user) {
		userDao.updateUser(user);	
		String roleIds = user.getRoleId();
		if(StringUtils.isNotEmpty(roleIds)){
			String[] roleArr = roleIds.split(",");
			for (String roleId : roleArr) {
				user.setId(user.getId());
				user.setRoleId(roleId);
				this.addUserRole(user);
			}
		}
			
	}
	
	
	@Override
	public boolean ifRegAcctUsed(String regAcct) {
		boolean flag = false;
		UserForm form = new UserForm();
		form.setLoginId(regAcct);
		User user = userDao.getUserByCondition(form);
		if(user != null)
			flag = true;
		
		return flag;
	}

	@Override
	public int getRoleByUser(Long id) {
		return userDao.getRoleByUser(id);
	}

	@Override
	public void deleteRoleByUser(Long id) {
		userDao.deleteRoleByUser(id);
	}

	@Override
	public void addUserRole(User user) {
		userDao.addUserRole(user);
	}

	@Override
	public Long getUserIdByName(String loginId) {
		return userDao.getUserIdByName(loginId);
	}

	@Override
	public String getUserRoles(long userId) {
		List<Role> roleList =  userDao.getUserRoles(userId);
		if(roleList!=null&&roleList.size()>0){
			StringBuffer str = new StringBuffer();
			for (Role role : roleList) {
				str.append(role.getRoleId()).append(",");
			}
			str.deleteCharAt(str.length()-1);
			return str.toString();
		}
		return null;
	}
	

	@Override
	public Long getNewUserId() {
		return userDao.getNewUserId();
	}

	
}