package cls.pilottery.oms.lottery.dao;

import java.util.List;
import java.util.Map;

import cls.pilottery.oms.lottery.form.ExpirydateForm;
import cls.pilottery.oms.lottery.form.ReconciliationForm;
import cls.pilottery.oms.lottery.form.SaleGamepayinfoForm;
import cls.pilottery.oms.lottery.model.ReconciliationVo;
import cls.pilottery.oms.lottery.model.SaleGamepayinfo;
import cls.pilottery.oms.lottery.vo.SaleGamepayinfoVo;


public interface ExpirydateDao {
	public Integer getSaleGamepaycount(SaleGamepayinfoForm saleGamepayform);

	public List<SaleGamepayinfoVo> getSaleGameList(
			SaleGamepayinfoForm saleGamepayform);

	public String getTicketpay(Long pcode);

	public void insertSalegame(ExpirydateForm expirydateForm);

	public SaleGamepayinfo getSalegameById(String id);

	public Integer getReconciliationCount(ReconciliationForm reconciliationForm);

	public List<ReconciliationVo> getReconciliationList(
			ReconciliationForm reconciliationForm);

	public SaleGamepayinfo getSalegameByTsn(String tsn);

	public String getPrizeName(Map<String, Object> map);
}
