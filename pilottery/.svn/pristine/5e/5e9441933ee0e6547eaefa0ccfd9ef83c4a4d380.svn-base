package cls.pilottery.web.institutions.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cls.pilottery.web.area.model.City;
import cls.pilottery.web.institutions.dao.InstitutionsDao;
import cls.pilottery.web.institutions.form.InstitutionsForm;
import cls.pilottery.web.institutions.model.InfOrgArea;
import cls.pilottery.web.institutions.model.InfOrgs;
import cls.pilottery.web.institutions.service.InstitutionsService;
import cls.pilottery.web.system.model.User;
/**
 * 
    * @ClassName: InstitutionsServiceImpl
    * @Description:部门管理
    * @author yuyuanhua
    * @date 2015年9月8日
    *
 */
@Service
public class InstitutionsServiceImpl implements InstitutionsService {
	@Autowired
	private InstitutionsDao institutionsDao;
	/**
	 * 
	    * @Title: getInstitutionsCount
	    * @Description: 总记录数
	    * @param @param institutionsForm
	    * @param @return    参数
	    * @return Integer    返回类型
	    * @throws
	 */
	@Override
	public Integer getInstitutionsCount(InstitutionsForm institutionsForm) {
		
		return this.institutionsDao.getInstitutionsCount(institutionsForm);
	}
	/**
	  * 
	     * @Title: getInstitutionsList
	     * @Description: 每页显示的List
	     * @param @param institutionsForm
	     * @param @return    参数
	     * @return List<InfOrgs>    返回类型
	     * @throws
	  */
	@Override
	public List<InfOrgs> getInstitutionsList(InstitutionsForm institutionsForm) {
		
		return this.institutionsDao.getInstitutionsList(institutionsForm);
	}
	 /**
	  * 
	     * @Title: selectCityAreaCode
	     * @Description: 获取区域列表
	     * @param @param map
	     * @param @return    参数
	     * @return List<City>    返回类型
	     * @throws
	  */
	@Override
	public List<City> selectCityAreaCode(String pid) {
		
		 int userAreaCode=Integer.parseInt(pid);
		Map<String, Object> map = new HashMap<String, Object>();
		if (userAreaCode == 0) {
			
			map.put("type", 1);
			map.put("pid", pid);
		}
		if (userAreaCode > 0 && userAreaCode < 1000) {
			
			map.put("type", 1);
			map.put("pid", pid);
		}
		if (userAreaCode > 1000) {
			
			map.put("type", 2);
			map.put("pid", pid);
			map.put("areaCode", userAreaCode);
		}
		return this.institutionsDao.selectCityAreaCode(map);
	}
	
	public String getTree(List<City> listcy) {
		String jsonStr="";
		StringBuilder build=new StringBuilder("[");
		  Set<City> cityTreeset = new TreeSet<City>(); 
		  cityTreeset.addAll(listcy);
		if(cityTreeset!=null && cityTreeset.size()>0){
			for(City city:cityTreeset){
				
				boolean flag=true;
				build.append("{" +"id"+":"+city.getCityCode()+","+" pId"+":"+city.getPid()+","+"name"+":"+"\""+city.getCityName()+"\"");
				if(city.getCityCode().equals(new Long(0))){
					build.append(","+"open"+":"+flag+"}"+",");
				}
				else{
					build.append("}"+",");
				}
				jsonStr=build.toString();
				jsonStr=jsonStr.substring(0,jsonStr.length()-1 );
			}
			jsonStr+="]";
		}
		return jsonStr;
	}
	/**
	 * 
	    * @Title: getInstitutionsInfo
	    * @Description: 查询部门
	    * @param @return    参数
	    * @return List<InfOrgs>    返回类型
	    * @throws
	 */
	
	@Override
	public List<InfOrgs> getInstitutionsInfo() {
		
		return this.institutionsDao.getInstitutionsInfo();
	}

	@Override
	public List<InfOrgs> getAllInstitutionsInfo() {
		
		return this.institutionsDao.getAllInstitutionsInfo();
	}
	/**
	  * 
	     * @Title: addInforgs
	     * @Description: 新增部门
	     * @param @param infOrgs    参数
	     * @return void    返回类型
	     * @throws
	  */
	
	@Override
	public void addInforgs(InfOrgs infOrgs) {
		this.institutionsDao.addInforgs(infOrgs);
		
	}
	  /**
	   * 
	      * @Title: getUser
	      * @Description: 获得部门负责人列表
	      * @param @return    参数
	      * @return List<User>    返回类型
	      * @throws
	   */
	@Override
	public List<User> getUser() {
		
		return this.institutionsDao.getUser();
	}
	  /**
	   * 
	      * @Title: getInfOrgByCode
	      * @Description: 根据code获得组织部门
	      * @param @param orgCode
	      * @param @return    参数
	      * @return InfOrgs    返回类型
	      * @throws
	   */
	@Override
	public InfOrgs getInfOrgByCode(String orgCode) {
	     List<InfOrgs> orgsList=this.institutionsDao.getInfOrgByCode(orgCode);
	     InfOrgs info=new InfOrgs();
	     if(orgsList!=null && orgsList.size()>0){
	    	 info=orgsList.get(0);
	     }
		return info;
	}
	 /**
	   * 
	      * @Title: getInfOrgAreaByCode
	      * @Description: 根据Code获得组织区域List
	      * @param @param orgCode
	      * @param @return    参数
	      * @return List<InfOrgArea>    返回类型
	      * @throws
	   */
	@Override
	public List<InfOrgArea> getInfOrgAreaByCode(String orgCode) {
		
		return this.institutionsDao.getInfOrgAreaByCode(orgCode);
	}
	@Override
	public String getModyTree(String orgCode,String userCode) {
		String jsonStr="";
		List<City> cityTree=new ArrayList<City>();
		List<City> Listcity=this.selectCityAreaCode(userCode);
		List<InfOrgArea> ListOrg=this.getInfOrgAreaByCode(orgCode);
		if(Listcity!=null && ListOrg!=null){
			for(InfOrgArea area:ListOrg){
				for(City city:Listcity){
					if(city.getCityCode().equals(new Long(area.getAreaCode()))){
						city.setChecked(true);
					}
					cityTree.add(city);
				}
			}
		}
		  Set<City> cityTreeset = new TreeSet<City>(); 
		  cityTreeset.addAll(cityTree); 
		  StringBuilder build=new StringBuilder("[");
		  if(cityTreeset.size()>0){
			  for(City city:cityTreeset){
					
					boolean flag=true;
					build.append("{" +"id"+":"+city.getCityCode()+","+" pId"+":"+city.getPid()+","+"name"+":"+"\""+city.getCityName()+"\"");
					if(city.getCityCode().equals(new Long(0)) && city.isChecked()){
						build.append(","+"checked"+":"+flag);
						build.append(","+"open"+":"+flag+"}"+",");
					}
					else if(city.getCityCode().equals(new Long(0))){
						build.append(","+"open"+":"+flag+"}"+",");
					}
					else if(city.isChecked()){
						build.append(","+"checked"+":"+flag+"}"+",");
					}
					else{
						build.append("}"+",");
					}
					jsonStr=build.toString();
					jsonStr=jsonStr.substring(0,jsonStr.length()-1 );
				}
				jsonStr+="]";
		  }
		return jsonStr;
	}
	
	 /**
	  * 
	     * @Title: getAreaInfoByorgCode
	     * @Description: 根据Code获得组织区域List
	     * @param @param orgCode
	     * @param @return    参数
	     * @return List<InfOrgArea>    返回类型
	     * @throws
	  */

	@Override
	public List<InfOrgArea> getAreaInfoByorgCode(String orgCode) {
	
		return this.institutionsDao.getAreaInfoByorgCode(orgCode);
	}
	 /**
	  * 
	     * @Title: updateInforgs
	     * @Description: 修改部门管理
	     * @param @param inforgs    参数
	     * @return void    返回类型
	     * @throws
	  */
	@Override
	public void updateInforgs(InfOrgs inforgs) {
		this.institutionsDao.updateInforgs(inforgs);
		
	}
	 /**
	  * 
	     * @Title: deleteupdeSatus
	     * @Description: 逻辑删除部门管理
	     * @param @param orgCode    参数
	     * @return void    返回类型
	     * @throws
	  */
	@Transactional(rollbackFor=RuntimeException.class)
	@Override
	public int deleteupdeSatus(String orgCode) {
		int result=0;
	try{
		this.institutionsDao.deleteupdeSatus(orgCode);
	}catch(Exception e){
		result=1;
	}
	return result;
	}
	 /**
	  * 
	     * @Title: getInstitutionsCode
	     * @Description: 查询部门详情
	     * @param @param orgCode
	     * @param @return    参数
	     * @return List<InfOrgs>    返回类型
	     * @throws
	  */
	@Override
	public InfOrgs getInstitutionsCode(String orgCode) {
		InfOrgs infOrgs=new InfOrgs();
		List<InfOrgs> listOrgs=this.institutionsDao.getInstitutionsCode(orgCode);
		if(listOrgs!=null && listOrgs.size()>0){
			infOrgs=listOrgs.get(0);
		}
		return infOrgs;
	}
	 /**
	  * 
	     * @Title: getArecode
	     * @Description: 获得用户所所区域
	     * @param @param area
	     * @param @return    参数
	     * @return String    返回类型
	     * @throws
	  */
	@Override
	public String getArecode(InfOrgArea area) {
		// TODO Auto-generated method stub
		return this.institutionsDao.getArecode(area);
	}
	
	/**
	 * add:jhx
	 */
	@Override
	public List<InfOrgs> getInfOrgsList() {
		return this.institutionsDao.getInfOrgsList();
	}
	@Override
	public Integer getDeleteCount(String orgCode) {
		
		return this.institutionsDao.getDeleteCount(orgCode);
	}
	@Override
	public Integer getAddOrgNameCount(String orgName) {
	
		return this.institutionsDao.getAddOrgNameCount(orgName);
	}
	@Override
	public Integer getInstitutionsCount1(InstitutionsForm institutionsForm) {
		// TODO Auto-generated method stub
		return this.institutionsDao.getInstitutionsCount1(institutionsForm);
	}
	@Override
	public List<InfOrgs> getInstitutionsList1(InstitutionsForm institutionsForm) {
		// TODO Auto-generated method stub
		return this.institutionsDao.getInstitutionsList1(institutionsForm);
	}
	

}
