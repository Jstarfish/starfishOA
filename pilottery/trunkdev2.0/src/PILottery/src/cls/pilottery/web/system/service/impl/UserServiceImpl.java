package cls.pilottery.web.system.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cls.pilottery.common.utils.MD5Util;
import cls.pilottery.web.system.dao.UserDao;
import cls.pilottery.web.system.form.UserForm;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.system.model.UserRoleLink;
import cls.pilottery.web.system.service.UserService;

@Service
public class UserServiceImpl implements UserService {

	@Autowired
	private UserDao userDao;

	@Override
	public User getUserByLogin(String regAcct) {
		return userDao.getUserByLogin(regAcct);
	}

	@Override
	public Integer getUserCount(UserForm userForm) {
		return userDao.getUserCount(userForm);
	}

	@Override
	public List<User> getUserList(UserForm userForm) {
		return userDao.getUserList(userForm);
	}

	@Override
	public Integer judgeIfCanDelete(Long userId) {
		return userDao.judgeIfCanDelete(userId);
	}

	@Override
	public boolean ifRegAcctUsed(String regAcct) {
		User user = getUserByLogin(regAcct);
		if (user != null)
			return true;
		else
			return false;
	}

	@Override
	public User getUserDetail(String userId) {
		return userDao.getUserDetail(userId);
	}

	public User getUserById(Long id) {
		return userDao.getUserById(id);
	}

	public void saveUser(User u) {
		if (u.getIsCollector() == null) {
			u.setIsCollector(0);
		}
		userDao.saveUser(u);
	}

	public void updateUser(UserForm userForm) {
		userDao.updateUser(userForm.getUser());
	}

	public List<User> getAllUser() {
		return userDao.getAllUser();
	}

	public void saveRelativity(UserRoleLink urLink) {
		userDao.saveRelativity(urLink);
	}

	public boolean ajaxIfExPwdSame(String pwd, Long userId) {
		User user = getUserById(userId);
		if (user.getPassword().equals(MD5Util.MD5Encode(pwd)))
			return true;
		else
			return false;
	}

	public void updatePwd(User user) {
		userDao.updatePwd(user);
	}

	public void deleteUser(User user) {
		userDao.deleteUser(user);
	}

	public void changeUserActive(User user) {
		userDao.changeUserActive(user);
	}

	public void updateLoginTime(User user) {
		Date d = user.getLoginTime();
		user.setLoginTime(new Date());
		userDao.updateLoginTime(user);
		user.setLoginTime(d);
	}

	public User getUser(String str) {
		return userDao.getUser(str);
	}

	public void updateLoginStatus(String username, int loginStatus) {

		userDao.updateLoginStatus(username, loginStatus);
	}

	@Override
	public List<User> getAllUserByRoleId(long id) {
		return userDao.getAllUserByRoleId(id);
	}

	@Override
	public List<User> getAllNotUserByRoleId(long id) {
		return userDao.getAllNotUserByRoleId(id);
	}

	@Override
	@Transactional(rollbackFor = { Exception.class })
	public void updateInstSetting(String userId, String[] orgs) {
		userDao.deleteInstSetting(userId);
		Map<String, String> map = new HashMap<String, String>();
		map.put("userId", userId);
		if (orgs != null && orgs.length > 0) {
			for (String orgCode : orgs) {
				map.put("orgCode", orgCode);
				userDao.saveInstSetting(map);
			}
		}
	}
}
