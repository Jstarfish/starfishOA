package cls.taishan.system.service;

import java.util.List;

import cls.taishan.system.form.UserForm;
import cls.taishan.system.model.OrgInfo;
import cls.taishan.system.model.Role;
import cls.taishan.system.model.User;

/**
 * 用户操作service接口
 */
public interface UserService {

	// 根据用户id获取用户信息
	User getUserByCondition(UserForm form);
	
	List<User> getAllUsers(UserForm form);
	
	List<OrgInfo> getAllOrgs();

	User getUserByLogin(String regAcct);
	
	void updateUserStatus(User user);
	
	void updatePwd(User user);
	
	void saveUser(User user);

	void updateUser(User user);
	
	boolean ifRegAcctUsed(String regAcct);

	int getRoleByUser(Long id);

	void deleteRoleByUser(Long id);

	void addUserRole(User user);

	Long getUserIdByName(String loginId);

	String getUserRoles(long userId);

	Long getNewUserId();

}
