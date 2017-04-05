package cls.taishan.demo.dao;

import java.util.List;

import org.apache.ibatis.annotations.Select;

import cls.taishan.demo.entity.User;

public interface DemoDao {
	
	User getUserById(int userId);
	
	@Select("select admin_id userId,ADMIN_REALNAME userName from adm_info where admin_id=#{_parameter}")
	User getUserByAnnotation(int userId);
	
	@Select("select ADMIN_ID userId, ADMIN_REALNAME userName, ADMIN_LOGIN loginName, ADMIN_CREATE_TIME createTime from adm_info")
	List<User> getUserList();

}
