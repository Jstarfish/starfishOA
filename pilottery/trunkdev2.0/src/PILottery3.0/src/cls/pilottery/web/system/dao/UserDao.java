package cls.pilottery.web.system.dao;

import java.util.List;
import java.util.Map;

import cls.pilottery.web.system.form.UserForm;
import cls.pilottery.web.system.model.Role;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.system.model.UserRoleLink;

public interface UserDao {

	User getUserByLogin(String regAcct);

	Integer getUserCount(UserForm userForm);

	List<User> getUserList(UserForm userForm);

	// add by dzg --根据角色获未删除的用户
	// 两个函数分别表示，根据角色获取当前角色用户，和非当前角色用户
	List<User> getAllUserByRoleId(long id);

	List<User> getAllNotUserByRoleId(long id);

	void saveUser(User user);
	
	//判断用户是否还有正在进行的工作
	Integer judgeIfCanDelete(Long userId);


	User getUserDetail(String userId);
	
	/**
	 * will modify
	 */

	User getUserById(Long id);
	


	void updateUser(User user);

	void deleteUser(User user);

	List<User> getAllUser();

	List<Role> selectUserRole(Long id);

	void saveRelativity(UserRoleLink urLink);

	Integer getCount(UserForm userForm);



	void deleteUserRole(User user);

	void updatePwd(User user);

	void changeUserActive(User user);

	void updateLoginTime(User user);

	User getUser(String str);

	void updateLoginStatus(String username, int loginStatus);

	void deleteInstSetting(String userId);

	void saveInstSetting(Map<String, String> map);

}
