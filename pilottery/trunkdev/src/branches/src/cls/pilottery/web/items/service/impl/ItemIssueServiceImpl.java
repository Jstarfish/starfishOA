package cls.pilottery.web.items.service.impl;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.common.utils.DBConnectUtil;
import cls.pilottery.web.institutions.model.InfOrgs;
import cls.pilottery.web.items.dao.ItemIssueDao;
import cls.pilottery.web.items.form.ItemIssueQueryForm;
import cls.pilottery.web.items.form.NewItemIssueForm;
import cls.pilottery.web.items.model.ItemIssue;
import cls.pilottery.web.items.model.ItemIssueDetail;
import cls.pilottery.web.items.service.ItemIssueService;
import oracle.jdbc.internal.OracleTypes;
import oracle.sql.ARRAY;
import oracle.sql.ArrayDescriptor;
import oracle.sql.STRUCT;
import oracle.sql.StructDescriptor;

@Service
public class ItemIssueServiceImpl implements ItemIssueService {

	@Autowired
	private ItemIssueDao itemIssueDao;
	
	/* 获得物品出库记录总数 */
	@Override
	public Integer getItemIssueCount(ItemIssueQueryForm itemIssueQueryForm) {
		return this.itemIssueDao.getItemIssueCount(itemIssueQueryForm);
	}
	
	/* 获得物品出库记录列表 */
	@Override
	public List<ItemIssue> getItemIssueList(ItemIssueQueryForm itemIssueQueryForm) {
		return this.itemIssueDao.getItemIssueList(itemIssueQueryForm);
	}
	
	/* 获得给定出库单下的所有物品记录 */
	@Override
	public List<ItemIssueDetail> getItemIssueDetails(String iiNo) {
		return this.itemIssueDao.getItemIssueDetails(iiNo);
	}
	
	/* 获得收货机构用于下拉框选择 */
	@Override
	public List<InfOrgs> getReceivingUnitForSelect() {
		return this.itemIssueDao.getReceivingUnitForSelect();
	}
	
	/* 新增物品出库 */
	@Override
	public void addItemIssue(NewItemIssueForm newItemIssueForm) throws Exception
	{
		//当前form中的itemDetails已经不存在空记录和重复记录
		Connection conn = null;
    	CallableStatement stmt = null;
    	try {
    		conn = DBConnectUtil.getConnection();
			conn.setAutoCommit(false);
			stmt = conn.prepareCall("{ call p_item_outbound(?,?,?,?,?,?,?) }");
			stmt.setObject(1, newItemIssueForm.getWarehouseManager());
			stmt.setObject(2, newItemIssueForm.getWarehouseCode());
			stmt.setObject(3, newItemIssueForm.getReceivingUnit());
			
			StructDescriptor sd = new StructDescriptor("TYPE_ITEM_INFO", conn);
			int length = newItemIssueForm.getItemDetails().size();
			STRUCT[] result = new STRUCT[length];
			for (int i = 0; i < length; i++)
			{
				ItemIssueDetail rec = newItemIssueForm.getItemDetails().get(i);
				Object[] obj = new Object[2];
				obj[0] = new String(rec.getItemCode());
				obj[1] = new Integer(rec.getQuantity());
				result[i] = new STRUCT(sd, conn, obj);
			}
			ArrayDescriptor orc_table = ArrayDescriptor.createDescriptor("TYPE_ITEM_LIST", conn);
			ARRAY oracle_array = new ARRAY(orc_table, conn, result);
			stmt.setObject(4, oracle_array);
			
			stmt.registerOutParameter(5, OracleTypes.VARCHAR);
			stmt.registerOutParameter(6, OracleTypes.NUMBER);
			stmt.registerOutParameter(7, OracleTypes.VARCHAR);
			stmt.execute();
			
			newItemIssueForm.setIssueCode(stmt.getString(5));
			newItemIssueForm.setC_errcode(stmt.getInt(6));
			newItemIssueForm.setC_errmsg(stmt.getString(7));
    	} catch (Exception e) {
    		throw e;
    	} finally {
			DBConnectUtil.close(stmt);
			DBConnectUtil.close(conn);
    	}
	}
}
