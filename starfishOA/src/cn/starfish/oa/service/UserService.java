package cn.starfish.oa.service;

import cn.starfish.oa.base.DaoSupport;
import cn.starfish.oa.domain.User;

public interface UserService extends DaoSupport<User> {

	/**
	 * 根据登录名与密码查询用户
	 * 
	 * @param loginName
	 * @param password
	 *            明文密码
	 * @return
	 */
	User findByLoginNameAndPassword(String loginName, String password);

}
