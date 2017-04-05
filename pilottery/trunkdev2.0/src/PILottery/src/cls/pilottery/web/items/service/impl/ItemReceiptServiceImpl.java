package cls.pilottery.web.items.service.impl;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.common.utils.DBConnectUtil;
import cls.pilottery.web.items.dao.ItemReceiptDao;
import cls.pilottery.web.items.form.ItemReceiptQueryForm;
import cls.pilottery.web.items.form.NewItemReceiptForm;
import cls.pilottery.web.items.model.ItemReceipt;
import cls.pilottery.web.items.model.ItemReceiptDetail;
import cls.pilottery.web.items.service.ItemReceiptService;
import oracle.jdbc.OracleTypes;
import oracle.sql.ARRAY;
import oracle.sql.ArrayDescriptor;
import oracle.sql.STRUCT;
import oracle.sql.StructDescriptor;

@Service
public class ItemReceiptServiceImpl implements ItemReceiptService {
	
	@Autowired
	private ItemReceiptDao itemReceiptDao;
    
    /* 获得物品入库记录总数 */
    @Override
    public Integer getItemReceiptCount(ItemReceiptQueryForm itemReceiptQueryForm) {
    	return this.itemReceiptDao.getItemReceiptCount(itemReceiptQueryForm);
    }
    
    /* 获得物品入库记录列表 */
    @Override
    public List<ItemReceipt> getItemReceiptList(ItemReceiptQueryForm itemReceiptQueryForm) {
    	return this.itemReceiptDao.getItemReceiptList(itemReceiptQueryForm);
    }
    
    /* 获得给定入库单下的所有物品记录 */
    @Override
    public List<ItemReceiptDetail> getItemReceiptDetails(String irNo) {
    	return this.itemReceiptDao.getItemReceiptDetails(irNo);
    }
    
    /* 新增物品入库 */
    @Override
    public void addItemReceipt(NewItemReceiptForm newItemReceiptForm) throws Exception
    {
    	//当前form中的itemDetails已经不存在空记录和重复记录
    	Connection conn = null;
    	CallableStatement stmt = null;
    	try {
    		conn = DBConnectUtil.getConnection();
			conn.setAutoCommit(false);
			stmt = conn.prepareCall("{ call p_item_inbound(?,?,?,?,?,?,?) }");
			stmt.setObject(1, newItemReceiptForm.getWarehouseManager());
			stmt.setObject(2, newItemReceiptForm.getWarehouseCode());
			
			StructDescriptor sd = new StructDescriptor("TYPE_ITEM_INFO", conn);
			int length = newItemReceiptForm.getItemDetails().size();
			STRUCT[] result = new STRUCT[length];
			for (int i = 0; i < length; i++)
			{
				ItemReceiptDetail rec = newItemReceiptForm.getItemDetails().get(i);
				Object[] obj = new Object[2];
				obj[0] = new String(rec.getItemCode());
				obj[1] = new Integer(rec.getQuantity());
				result[i] = new STRUCT(sd, conn, obj);
			}
			ArrayDescriptor orc_table = ArrayDescriptor.createDescriptor("TYPE_ITEM_LIST", conn);
			ARRAY oracle_array = new ARRAY(orc_table, conn, result);
			stmt.setObject(3, oracle_array);
			
			stmt.setObject(4, newItemReceiptForm.getRemark());
			
			stmt.registerOutParameter(5, OracleTypes.VARCHAR);
			stmt.registerOutParameter(6, OracleTypes.NUMBER);
			stmt.registerOutParameter(7, OracleTypes.VARCHAR);
			stmt.execute();
			
			newItemReceiptForm.setReceiptCode(stmt.getString(5));
			newItemReceiptForm.setC_errcode(stmt.getInt(6));
			newItemReceiptForm.setC_errmsg(stmt.getString(7));
    	} catch (Exception e) {
    		throw e;
    	} finally {
			DBConnectUtil.close(stmt);
			DBConnectUtil.close(conn);
    	}
    }
}
