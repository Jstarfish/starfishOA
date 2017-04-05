package cls.pilottery.oms.common.msg;

import cls.pilottery.oms.common.entity.BaseMessageRes;

public class RefundRes4005 extends BaseMessageRes {
	private static final long serialVersionUID = -1741055227183524176L;
	
	private RefundRes4005Result result;
	
	public RefundRes4005Result getResult() {
		return result;
	}

	public void setResult(RefundRes4005Result result) {
		this.result = result;
	}

	@Override
	public String toString() {
		return "RefundRes4005 [result=" + result + "]";
	}
}
