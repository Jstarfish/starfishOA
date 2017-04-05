package cls.pilottery.oms.lottery.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import cls.pilottery.oms.lottery.dao.RefundqueryDao;
import cls.pilottery.oms.lottery.form.RefundForm;
import cls.pilottery.oms.lottery.form.SaleCancelInfoForm;
import cls.pilottery.oms.lottery.service.RefundqueryService;
import cls.pilottery.oms.lottery.vo.SaleCancelInfoVo;

@Service
public class RefundqueryServiceImpl implements RefundqueryService {
	@Autowired
	private RefundqueryDao refundqueryDao;

	@Override
	public Integer getSaleCancelcount(SaleCancelInfoForm saleCancelInfoForm) {
		return this.refundqueryDao.getSaleCancelcount(saleCancelInfoForm);
	}

	@Override
	public List<SaleCancelInfoVo> getSaleCancelList(
			SaleCancelInfoForm saleCancelInfoForm) {

		return this.refundqueryDao.getSaleCancelList(saleCancelInfoForm);
	}

	@Override
	public String getRefundflow(Long pcode) {
		return this.refundqueryDao.getRefundflow(pcode);
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, noRollbackFor = Exception.class)
	public void saveRefund(RefundForm refundForm) {

		this.refundqueryDao.saveRefund(refundForm);

	}

	@Override
	public SaleCancelInfoVo getSaleCanelinfoByid(String id) {

		return this.refundqueryDao.getSaleCanelinfoByid(id);
	}

	@Override
	public String getGameName(Long gameCode) {
		// TODO Auto-generated method stub
		return this.refundqueryDao.getGameName(gameCode);
	}

	@Override
	public SaleCancelInfoVo getSaleCanelinfoByTsn(String tsn) {
		// TODO Auto-generated method stub
		return this.refundqueryDao.getSaleCanelinfoByTsn(tsn);
	}
}
