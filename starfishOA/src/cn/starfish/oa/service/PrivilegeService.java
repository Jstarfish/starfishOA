package cn.starfish.oa.service;

import java.util.Collection;
import java.util.List;

import cn.starfish.oa.base.DaoSupport;
import cn.starfish.oa.domain.Privilege;

public interface PrivilegeService extends DaoSupport<Privilege> {

	/**
	 * 查询所有顶级的权限
	 * 
	 * @return
	 */
	List<Privilege> findTopList();

	/**
	 * 查询所有权限对应的URL集合（不重复）
	 * @return
	 */
	Collection<String> getAllPrivilegeUrls();

}
