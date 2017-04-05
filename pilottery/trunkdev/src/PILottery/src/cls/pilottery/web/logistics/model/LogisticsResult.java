package cls.pilottery.web.logistics.model;

import java.io.Serializable;
import java.util.Date;

public class LogisticsResult implements Serializable {

	private static final long serialVersionUID = 1L;

	private Date time;// 变化时间

	private String warehouseNo;// 仓库编号

	private String wareHouseType;// 仓库名称

	private String operator;// 人员

	private String operatorName;// 人员名称

	private String isPayout;//是否兑奖

	private int objType;// 出入库类型

	private String type;// 出入库名称

	public LogisticsResult() {

	}

	public String getIsPayout() {

		return isPayout;
	}

	public int getObjType() {

		return objType;
	}

	public String getOperator() {

		return operator;
	}

	public String getOperatorName() {

		return operatorName;
	}

	public Date getTime() {

		return time;
	}

	public String getType() {

		return type;
	}

	public String getWarehouseNo() {

		return warehouseNo;
	}

	public String getWareHouseType() {

		return wareHouseType;
	}

	public void setIsPayout(String isPayout) {

		this.isPayout = isPayout;
	}

	public void setObjType(int objType) {

		this.objType = objType;
	}

	public void setOperator(String operator) {

		this.operator = operator;
	}

	public void setOperatorName(String operatorName) {

		this.operatorName = operatorName;
	}

	public void setTime(Date time) {

		this.time = time;
	}

	public void setType(String type) {

		this.type = type;
	}

	public void setWarehouseNo(String warehouseNo) {

		this.warehouseNo = warehouseNo;
	}

	public void setWareHouseType(String wareHouseType) {

		this.wareHouseType = wareHouseType;
	}
}
