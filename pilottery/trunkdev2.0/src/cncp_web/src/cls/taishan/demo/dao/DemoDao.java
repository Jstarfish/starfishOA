package cls.taishan.demo.dao;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import cls.taishan.demo.form.DemoForm;
import cls.taishan.demo.model.DemoOrgInfo;
import cls.taishan.demo.model.DemoUser;

public interface DemoDao {
	
	@Select("SELECT admin_id id, admin_realname realName, admin_login loginId, admin_org institutionCode,org_name institutionName,admin_mobile mobilePhone,ADMIN_ADDRESS homeAddress,is_collecter isCollector FROM adm_info JOIN inf_orgs ON (admin_org = org_code) where admin_id = #{_parameter}")
	DemoUser getUserById(int userId);
	
	List<DemoUser> getUserList(DemoForm form);

	@Insert("INSERT INTO ADM_INFO(ADMIN_ID, ADMIN_REALNAME, ADMIN_LOGIN, ADMIN_PASSWORD, ADMIN_GENDER, ADMIN_STATUS, LOGIN_STATUS, IS_COLLECTER, IS_WAREHOUSE_M) VALUES (#{id},#{realName},#{loginId},#{password},1,1,1,0,0)")
	void saveUser(DemoUser user);

	@Delete("DELETE FROM ADM_INFO WHERE ADMIN_ID = #{_parameter}")
	void deleteUser(int userId);

	//@Update("UPDATE ADM_INFO SET ADMIN_ADDRESS=#{homeAddress} WHERE ADMIN_ID = #{id}")
	void updateUser(DemoUser user);

	@Select("select org_code orgCode,org_name orgName from inf_orgs")
	List<DemoOrgInfo> getOrgList();

	List<DemoUser> getUserList2(DemoForm form);
 
	@Select("select count(1) from adm_info")
	int getTotalCount(DemoForm form);
	
}
