package cls.pilottery.web.items.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.items.dao.ItemQuantityDao;
import cls.pilottery.web.items.form.ItemQuantityQueryForm;
import cls.pilottery.web.items.model.ItemQuantity;
import cls.pilottery.web.items.model.ItemType;
import cls.pilottery.web.items.service.ItemQuantityService;
import cls.pilottery.web.warehouses.form.UserSessionForm;
import cls.pilottery.web.warehouses.model.WarehouseInfo;

@Service
public class ItemQuantityServiceImpl implements ItemQuantityService {

	@Autowired
	private ItemQuantityDao itemQuantityDao;
	
    /* 获得库存信息记录总数 */
    @Override
    public Integer getItemQuantityCount(ItemQuantityQueryForm itemQuantityQueryForm) {
    	return this.itemQuantityDao.getItemQuantityCount(itemQuantityQueryForm);
    }
    
    /* 获得库存信息记录列表 */
    @Override
    public List<ItemQuantity> getItemQuantityList(ItemQuantityQueryForm itemQuantityQueryForm) {
    	return this.itemQuantityDao.getItemQuantityList(itemQuantityQueryForm);
    }
    
    /* 获得全部有库存的仓库 */
    @Override
    public List<WarehouseInfo> getStorageWarehouseForSelect(UserSessionForm userSessionForm) {
    	return this.itemQuantityDao.getStorageWarehouseForSelect(userSessionForm);
    }
    
    /* 获得全部有库存的物品 */
    @Override
    public List<ItemType> getStorageItemForSelect() {
    	return this.itemQuantityDao.getStorageItemForSelect();
    }
    
    /* 获得物品在制定仓库下的库存量 */
    @Override
    public Integer getItemQuantityByWarehouse(ItemQuantity itemQuantity) {
    	return this.itemQuantityDao.getItemQuantityByWarehouse(itemQuantity);
    }
}
