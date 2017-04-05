package cls.pilottery.oms.lottery.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import cls.pilottery.oms.lottery.dao.ExpirydateDao;
import cls.pilottery.oms.lottery.form.ExpirydateForm;
import cls.pilottery.oms.lottery.form.ReconciliationForm;
import cls.pilottery.oms.lottery.form.SaleGamepayinfoForm;
import cls.pilottery.oms.lottery.model.ReconciliationVo;
import cls.pilottery.oms.lottery.model.SaleGamepayinfo;
import cls.pilottery.oms.lottery.service.ExpirydateService;
import cls.pilottery.oms.lottery.vo.SaleGamepayinfoVo;

@Service
public class ExpirydateServiceImpl implements ExpirydateService {
	@Autowired
	private ExpirydateDao expirydateDao;

	/**
	 * 查询分页的总记录数
	 */
	@Override
	public Integer getSaleGamepaycount(SaleGamepayinfoForm saleGamepayform) {

		return this.expirydateDao.getSaleGamepaycount(saleGamepayform);
	}

	/**
	 * 查询分页的记录
	 */
	@Override
	public List<SaleGamepayinfoVo> getSaleGameList(
			SaleGamepayinfoForm saleGamepayform) {
		return this.expirydateDao.getSaleGameList(saleGamepayform);
	}

	@Override
	public String getTicketpay(Long pcode) {

		return this.expirydateDao.getTicketpay(pcode);
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED)
	public void insertSalegame(ExpirydateForm expirydateForm) {
		this.expirydateDao.insertSalegame(expirydateForm);

	}

	@Override
	public SaleGamepayinfo getSalegameById(String id) {

		return this.expirydateDao.getSalegameById(id);
	}

	@Override
	public Integer getReconciliationCount(ReconciliationForm reconciliationForm) {

		return this.expirydateDao.getReconciliationCount(reconciliationForm);
	}

	@Override
	public List<ReconciliationVo> getReconciliationList(
			ReconciliationForm reconciliationForm) {
		return this.expirydateDao.getReconciliationList(reconciliationForm);
	}

	@Override
	public SaleGamepayinfo getSalegameByTsn(String tsn) {
		// TODO Auto-generated method stub
		return this.expirydateDao.getSalegameByTsn(tsn);
	}

	@Override
	public String getPrizeName(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return this.expirydateDao.getPrizeName(map);
	}

}
