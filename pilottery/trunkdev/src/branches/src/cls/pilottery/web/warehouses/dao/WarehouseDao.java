package cls.pilottery.web.warehouses.dao;

import java.util.List;

import cls.pilottery.web.institutions.model.InfOrgs;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.warehouses.form.NewWarehouseForm;
import cls.pilottery.web.warehouses.form.UserSessionForm;
import cls.pilottery.web.warehouses.form.WarehouseDeleteForm;
import cls.pilottery.web.warehouses.form.WarehouseQueryForm;
import cls.pilottery.web.warehouses.model.WarehouseInfo;
import cls.pilottery.web.warehouses.model.WarehouseManager;

public interface WarehouseDao {

    /* 获得当前用户能够看到的所有组织机构 */
    public List<InfOrgs> getAvailableInstitution(UserSessionForm userSessionForm);
    
    /* 获得推荐的可添加的仓库编码 */
    public String getRecommendedWarehouseCode(String orgCode);
    
    /* 获得当前机构下的所有用户 */
    public List<User> getUserUnder(String orgCode);
    
    /* 获得仓库列表总数 */
    public Integer getWarehouseCount(WarehouseQueryForm warehouseQueryForm);
    
    /* 获得仓库列表信息 */
    public List<WarehouseInfo> getWarehouseList(WarehouseQueryForm warehouseQueryForm);
    
    /* 添加仓库 */
    public void addWarehouse(NewWarehouseForm newWarehouseForm);
    
    /* 获得仓库详细信息 */
    public WarehouseInfo getWarehouseDetails(String curWarehouseCode);
    
    /* 获得仓库管理员列表 */
    public List<WarehouseManager> getWarehouseManagers(UserSessionForm userSessionForm);
    
    /* 删除仓库 */
    public void deleteWarehouse(WarehouseDeleteForm warehouseDeleteForm);
    
    /* 获得可以做当前仓库的负责人的所有用户 */
    public List<User> getAvailableDirector(String warehouseCode);
    
    /* 获得可以做当前仓库的管理员的所有用户 */
    public List<User> getAvailableManager(String warehouseCode);
    
    /* 修改仓库信息 */
    public void modifyWarehouse(NewWarehouseForm newWarehouseForm);
    
    /* 获得当前用户能够看到的的所有仓库信息 */
    public List<WarehouseInfo> getAvailableWarehouse(UserSessionForm userSessionForm);
    
    /* 更新仓库状态为“启用” */
    public void updateStatusEnableWarehouse(String warehouseCode);
}
