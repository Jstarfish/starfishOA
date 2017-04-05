package cls.pilottery.pos.system.model.mm;

import java.io.Serializable;

public class MMLogistics020506Res implements Serializable {
	private static final long serialVersionUID = 4305588478278190241L;
	private String time;
	private String operation;
	private String warehouse;
	private String operator;
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
	}
	public String getOperation() {
		return operation;
	}
	public void setOperation(String operation) {
		this.operation = operation;
	}
	public String getWarehouse() {
		return warehouse;
	}
	public void setWarehouse(String warehouse) {
		this.warehouse = warehouse;
	}
	public String getOperator() {
		return operator;
	}
	public void setOperator(String operator) {
		this.operator = operator;
	}
}
