package cls.taishan.system.dao;

import java.util.List;

import cls.taishan.system.form.UserForm;
import cls.taishan.system.model.OrgInfo;
import cls.taishan.system.model.Role;
import cls.taishan.system.model.User;


public interface UserDao {

	User getUserByCondition(UserForm form);

	List<User> getAllUsers(UserForm form);

	List<OrgInfo> getAllOrgs();

	void updatePwd(User user);

	void updateUserStatus(User user);

	void saveUser(User user);

	void updateUser(User user);

	int getRoleByUser(Long id);

	void deleteRoleByUser(Long id);

	void addUserRole(User user);

	Long getUserIdByName(String loginId);

	List<Role> getUserRoles(long userId);

	Long getNewUserId();

}
