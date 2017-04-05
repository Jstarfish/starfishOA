package cls.pilottery.web.items.service.impl;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cls.pilottery.common.utils.DBConnectUtil;
import cls.pilottery.web.items.dao.ItemCheckDao;
import cls.pilottery.web.items.form.ItemCheckQueryForm;
import cls.pilottery.web.items.form.NewItemCheckForm;
import cls.pilottery.web.items.form.ProcItemCheckForm;
import cls.pilottery.web.items.model.ItemCheck;
import cls.pilottery.web.items.model.ItemCheckDetail;
import cls.pilottery.web.items.model.ItemQuantity;
import cls.pilottery.web.items.service.ItemCheckService;
import cls.pilottery.web.warehouses.dao.WarehouseDao;
import oracle.jdbc.OracleTypes;
import oracle.sql.ARRAY;
import oracle.sql.ArrayDescriptor;
import oracle.sql.STRUCT;
import oracle.sql.StructDescriptor;

@Service
public class ItemCheckServiceImpl implements ItemCheckService {

	@Autowired
	private ItemCheckDao itemCheckDao;
	
	@Autowired
	private WarehouseDao warehouseDao;
	
	/* 获得物品盘点记录总数 */
	@Override
	public Integer getItemCheckCount(ItemCheckQueryForm itemCheckQueryForm) {
		return this.itemCheckDao.getItemCheckCount(itemCheckQueryForm);
	}
	
	/* 获得物品盘点记录列表 */
	@Override
	public List<ItemCheck> getItemCheckList(ItemCheckQueryForm itemCheckQueryForm) {
		return this.itemCheckDao.getItemCheckList(itemCheckQueryForm);
	}
	
	/* 获得选择仓库下所有的在库物品（用于添加盘点记录） */
	@Override
	public List<ItemQuantity> getAvailableItemForCheck(String warehouseCode) {
		return this.itemCheckDao.getAvailableItemForCheck(warehouseCode);
	}
	
	/* 新增盘点记录 */
	@Override
	public void addItemCheck(NewItemCheckForm newItemCheckForm) {
		this.itemCheckDao.addItemCheck(newItemCheckForm);
	}
	
	/* 获得盘点物品记录明细（盘点前及盘点后） */
	@Override
	public List<ItemCheckDetail> getItemCheckListDetails(String checkNo) {
		return this.itemCheckDao.getItemCheckListDetails(checkNo);
	}
	
	/* 获得盘点备注 */
	@Override
	public String getRemarkByCheckNo(String checkNo) {
		return this.itemCheckDao.getRemarkByCheckNo(checkNo);
	}
	
	/* 处理盘点记录 */
	@Override
	public void procItemCheck(ProcItemCheckForm procItemCheckForm) throws Exception
	{
		Connection conn = null;
    	CallableStatement stmt = null;
    	try {
    		conn = DBConnectUtil.getConnection();
			conn.setAutoCommit(false);
			stmt = conn.prepareCall("{ call p_item_check_step2(?,?,?,?,?,?,?,?) }");
			stmt.setObject(1, procItemCheckForm.getCheckAdmin());
			stmt.setObject(2, procItemCheckForm.getCheckNo());
			stmt.setObject(3, procItemCheckForm.getCheckWarehouse());
			stmt.setObject(4, procItemCheckForm.getCheckOp());
			stmt.setObject(5, procItemCheckForm.getRemark());
			
			StructDescriptor sd = new StructDescriptor("TYPE_ITEM_INFO", conn);
			int length = procItemCheckForm.getItemDetails().size();
			STRUCT[] result = new STRUCT[length];
			for (int i = 0; i < length; i++)
			{
				ItemCheckDetail rec = procItemCheckForm.getItemDetails().get(i);
				Object[] obj = new Object[2];
				obj[0] = new String(rec.getItemCode());
				obj[1] = new Integer(rec.getCheckQuantity());
				result[i] = new STRUCT(sd, conn, obj);
			}
			ArrayDescriptor orc_table = ArrayDescriptor.createDescriptor("TYPE_ITEM_LIST", conn);
			ARRAY oracle_array = new ARRAY(orc_table, conn, result);
			stmt.setObject(6, oracle_array);
			
			stmt.registerOutParameter(7, OracleTypes.NUMBER);
			stmt.registerOutParameter(8, OracleTypes.VARCHAR);
			stmt.execute();
			
			procItemCheckForm.setC_errcode(stmt.getInt(7));
			procItemCheckForm.setC_errmsg(stmt.getString(8));
    	} catch (Exception e) {
    		throw e;
    	} finally {
			DBConnectUtil.close(stmt);
			DBConnectUtil.close(conn);
    	}
	}
	
	/* 修改物品盘点单状态 */
	@Override
	public void updateStatusCompleteCheck(String checkNo)
	{
		this.itemCheckDao.updateStatusCompleteCheck(checkNo);
	}
	
	/* 操作完结物品盘点 */
	@Transactional(rollbackFor={Exception.class})
	@Override
	public void procCompleteItemCheck(String checkNo, String warehouseCode) throws Exception {
		this.itemCheckDao.updateStatusCompleteCheck(checkNo);
		this.warehouseDao.updateStatusEnableWarehouse(warehouseCode);
	}
	
	/* 删除物品盘点记录 */
	@Override
	public void deleteItemCheck(String checkNo) {
		this.itemCheckDao.deleteItemCheck(checkNo);
	}
	
	/* 删除物品盘点前明细记录 */
	@Override
	public void deleteItemCheckDetailBefore(String checkNo) {
		this.itemCheckDao.deleteItemCheckDetailBefore(checkNo);
	}
	
	/* 删除物品盘点后明细记录 */
	@Override
	public void deleteItemCheckDetailAfter(String checkNo) {
		this.itemCheckDao.deleteItemCheckDetailAfter(checkNo);
	}
	
	/* 操作删除物品盘点 */
	@Transactional(rollbackFor={Exception.class})
	@Override
	public void procDeleteItemCheck(String checkNo, String warehouseCode) throws Exception {
		this.itemCheckDao.deleteItemCheckDetailAfter(checkNo);
		this.itemCheckDao.deleteItemCheckDetailBefore(checkNo);
		this.itemCheckDao.deleteItemCheck(checkNo);
		this.warehouseDao.updateStatusEnableWarehouse(warehouseCode);
	}
}
