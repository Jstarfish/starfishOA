package cls.pilottery.oms.lottery.service;

import java.util.List;

import cls.pilottery.oms.lottery.form.RefundForm;
import cls.pilottery.oms.lottery.form.SaleCancelInfoForm;
import cls.pilottery.oms.lottery.vo.SaleCancelInfoVo;

public interface RefundqueryService {
	public Integer getSaleCancelcount(SaleCancelInfoForm saleCancelInfoForm);

	public List<SaleCancelInfoVo> getSaleCancelList(
			SaleCancelInfoForm saleCancelInfoForm);

	public String getRefundflow(Long pcode);

	public void saveRefund(RefundForm refundForm);

	public SaleCancelInfoVo getSaleCanelinfoByid(String id);

	public String getGameName(Long gameCode);

	public SaleCancelInfoVo getSaleCanelinfoByTsn(String tsn);
}
