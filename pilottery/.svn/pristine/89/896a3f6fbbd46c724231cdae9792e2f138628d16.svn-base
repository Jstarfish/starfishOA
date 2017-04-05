package cls.pilottery.web.institutions.dao;

import java.util.List;
import java.util.Map;

import cls.pilottery.web.area.model.City;
import cls.pilottery.web.institutions.form.InstitutionsForm;
import cls.pilottery.web.institutions.model.InfOrgArea;
import cls.pilottery.web.institutions.model.InfOrgs;
import cls.pilottery.web.system.model.User;

/**
 * 
    * @ClassName: InstitutionsDao
    * @Description:部门管理Dao
    * @author yuyuanhua
    * @date 2015年9月8日
    *
 */
public interface InstitutionsDao {
	/**
	 * 
	    * @Title: getInstitutionsCount
	    * @Description: 总记录数
	    * @param @param institutionsForm
	    * @param @return    参数
	    * @return Integer    返回类型
	    * @throws
	 */
 public Integer getInstitutionsCount(InstitutionsForm institutionsForm);
 /**
  * 
     * @Title: getInstitutionsList
     * @Description: 每页显示的List
     * @param @param institutionsForm
     * @param @return    参数
     * @return List<InfOrgs>    返回类型
     * @throws
  */
 public List<InfOrgs> getInstitutionsList(InstitutionsForm institutionsForm);
 /**
  * 
     * @Title: selectCityAreaCode
     * @Description: 获取区域列表
     * @param @param map
     * @param @return    参数
     * @return List<City>    返回类型
     * @throws
  */
 public List<City> selectCityAreaCode(Map<String, Object> map);
/**
 * 
    * @Title: getInstitutionsInfo
    * @Description: 查询部门
    * @param @return    参数
    * @return List<InfOrgs>    返回类型
    * @throws
 */
 public List<InfOrgs>getInstitutionsInfo();
 
 public List<InfOrgs>getAllInstitutionsInfo();   // add by:jhx
 
 /**
  * 
     * @Title: addInforgs
     * @Description: 新增部门
     * @param @param infOrgs    参数
     * @return void    返回类型
     * @throws
  */
 public void addInforgs(InfOrgs infOrgs);
 /**
  * 
     * @Title: getUser
     * @Description: 获得部门负责人列表
     * @param @return    参数
     * @return List<User>    返回类型
     * @throws
  */
 public List<User>getUser();
 /**
  * 
     * @Title: getInfOrgByCode
     * @Description: 根据code获得组织部门
     * @param @param orgCode
     * @param @return    参数
     * @return InfOrgs    返回类型
     * @throws
  */
 public List<InfOrgs>  getInfOrgByCode(String orgCode);
 /**
  * 
     * @Title: getInfOrgAreaByCode
     * @Description: 根据Code获得组织区域List
     * @param @param orgCode
     * @param @return    参数
     * @return List<InfOrgArea>    返回类型
     * @throws
  */
 public List<InfOrgArea> getInfOrgAreaByCode(String orgCode);
 /**
  * 
     * @Title: getAreaInfoByorgCode
     * @Description: 根据Code获得组织区域List
     * @param @param orgCode
     * @param @return    参数
     * @return List<InfOrgArea>    返回类型
     * @throws
  */
 public List<InfOrgArea> getAreaInfoByorgCode(String orgCode);
 /**
  * 
     * @Title: updateInforgs
     * @Description: 修改部门管理
     * @param @param inforgs    参数
     * @return void    返回类型
     * @throws
  */
 public void updateInforgs(InfOrgs inforgs);
 /**
  * 
     * @Title: deleteupdeSatus
     * @Description: 逻辑删除部门管理
     * @param @param orgCode    参数
     * @return void    返回类型
     * @throws
  */
 public void deleteupdeSatus(String orgCode);
 /**
  * 
     * @Title: getInstitutionsCode
     * @Description: 查询部门详情
     * @param @param orgCode
     * @param @return    参数
     * @return List<InfOrgs>    返回类型
     * @throws
  */
 public List<InfOrgs>getInstitutionsCode(String orgCode);
 /**
  * 
     * @Title: getArecode
     * @Description: 获得用户所所区域
     * @param @param area
     * @param @return    参数
     * @return String    返回类型
     * @throws
  */
 public String getArecode(InfOrgArea area);
 
 
 List<InfOrgs> getInfOrgsList();
 public Integer getDeleteCount(String orgCode);
 public Integer getAddOrgNameCount(String orgName);
 /**
	 * 
	    * @Title: getInstitutionsCount
	    * @Description: 总记录数
	    * @param @param institutionsForm
	    * @param @return    参数
	    * @return Integer    返回类型
	    * @throws
	 */
public Integer getInstitutionsCount1(InstitutionsForm institutionsForm);
/**
 * 
    * @Title: getInstitutionsList
    * @Description: 每页显示的List
    * @param @param institutionsForm
    * @param @return    参数
    * @return List<InfOrgs>    返回类型
    * @throws
 */
public List<InfOrgs> getInstitutionsList1(InstitutionsForm institutionsForm);
}
