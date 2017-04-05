package cls.pilottery.web.system.service;

import java.util.List;

import cls.pilottery.web.system.form.UserForm;
import cls.pilottery.web.system.model.User;

/**
 * 用户操作service接口
 */
public interface UserService {

	// 根据用户id获取用户信息
	User getUserByLogin(String regAcct);

	// 得到角色总数
	Integer getUserCount(UserForm userForm);

	// 分页查询
	List<User> getUserList(UserForm userForm);
	
	//判断用户是否还有正在进行的工作
	Integer judgeIfCanDelete(Long userId);

	// add by dzg --根据角色获未删除的用户
	// 两个函数分别表示，根据角色获取当前角色用户，和非当前角色用户
	List<User> getAllUserByRoleId(long id);

	List<User> getAllNotUserByRoleId(long id);

	// 检查帐号 判断是否存在该账号
	boolean ifRegAcctUsed(String regAcct);
	
	User getUserDetail(String userId);
	/**
	 * will modify
	 */

	// 根据user表中的id查询用户信息
	User getUserById(Long id);

	// 插入用户信息
	void saveUser(User user);

	void deleteUser(User user);

	List<User> getAllUser();
	
	boolean ajaxIfExPwdSame(String pwd, Long userId);

	void updatePwd(User user);

	void changeUserActive(User user);

	void updateLoginTime(User user);

	void updateUser(UserForm userForm);

	User getUser(String str);

	void updateLoginStatus(String username, int loginStatus);

	void updateInstSetting(String userId, String[] orgs);

}
