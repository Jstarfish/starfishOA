package cls.pilottery.web.warehouses.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.institutions.model.InfOrgs;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.warehouses.dao.WarehouseDao;
import cls.pilottery.web.warehouses.form.NewWarehouseForm;
import cls.pilottery.web.warehouses.form.UserSessionForm;
import cls.pilottery.web.warehouses.form.WarehouseDeleteForm;
import cls.pilottery.web.warehouses.form.WarehouseQueryForm;
import cls.pilottery.web.warehouses.model.WarehouseInfo;
import cls.pilottery.web.warehouses.model.WarehouseManager;
import cls.pilottery.web.warehouses.service.WarehouseService;

@Service
public class WarehouseServiceImpl implements WarehouseService {

    @Autowired
    WarehouseDao warehouseDao;
    
    /* 获得当前用户能够看到的所有组织机构 */
    @Override
    public List<InfOrgs> getAvailableInstitution(UserSessionForm userSessionForm) {
        return warehouseDao.getAvailableInstitution(userSessionForm);
    }
    
    /* 获得推荐的可添加的仓库编码 */
    @Override
    public String getRecommendedWarehouseCode(String orgCode) {
        return warehouseDao.getRecommendedWarehouseCode(orgCode);
    }
    
    /* 获得当前区域下的所有用户 */
    @Override
    public List<User> getUserUnder(String orgCode) {
    	return warehouseDao.getUserUnder(orgCode);
    }
    
    /* 获得仓库列表总数 */
    @Override
    public Integer getWarehouseCount(WarehouseQueryForm warehouseQueryForm) {
        return warehouseDao.getWarehouseCount(warehouseQueryForm);
    }
    
    /* 获得仓库列表信息 */
    @Override
    public List<WarehouseInfo> getWarehouseList(WarehouseQueryForm warehouseQueryForm) {
        return warehouseDao.getWarehouseList(warehouseQueryForm);
    }
    
    /* 添加仓库 */
    @Override
    public void addWarehouse(NewWarehouseForm newWarehouseForm) {
    	this.warehouseDao.addWarehouse(newWarehouseForm);
    }
    
    /* 获得仓库详细信息 */
    @Override
    public WarehouseInfo getWarehouseDetails(String curWarehouseCode)
    {
    	return warehouseDao.getWarehouseDetails(curWarehouseCode);
    }
    
    /* 获得仓库管理员列表 */
    @Override
    public List<WarehouseManager> getWarehouseManagers(UserSessionForm userSessionForm) {
    	return warehouseDao.getWarehouseManagers(userSessionForm);
    }
    
    /* 删除仓库 */
    public void deleteWarehouse(WarehouseDeleteForm warehouseDeleteForm) {
    	this.warehouseDao.deleteWarehouse(warehouseDeleteForm);
    }
    
    /* 获得可以做当前仓库的负责人的所有用户 */
    @Override
    public List<User> getAvailableDirector(String warehouseCode) {
    	return warehouseDao.getAvailableDirector(warehouseCode);
    }
    
    /* 获得可以做当前仓库的管理员的所有用户 */
    @Override
    public List<User> getAvailableManager(String warehouseCode) {
    	return warehouseDao.getAvailableManager(warehouseCode);
    }
    
    /* 修改仓库信息 */
    @Override
    public void modifyWarehouse(NewWarehouseForm newWarehouseForm) {
    	this.warehouseDao.modifyWarehouse(newWarehouseForm);
    }
    
    /* 获得当前用户能够看到的的所有仓库信息 */
    @Override
    public List<WarehouseInfo> getAvailableWarehouse(UserSessionForm userSessionForm) {
    	return this.warehouseDao.getAvailableWarehouse(userSessionForm);
    }
    
    /* 更新仓库状态为“启用” */
    @Override
    public void updateStatusEnableWarehouse(String warehouseCode) {
    	this.warehouseDao.updateStatusEnableWarehouse(warehouseCode);
    }
}
