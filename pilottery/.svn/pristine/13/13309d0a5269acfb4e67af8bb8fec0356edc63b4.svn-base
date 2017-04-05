package cls.pilottery.web.report.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.report.dao.PayoutReportDao;
import cls.pilottery.web.report.form.SaleReportForm;
import cls.pilottery.web.report.model.PayoutReportModel;
import cls.pilottery.web.report.service.PayoutReportService;

@Service
public class PayoutReportServiceImpl implements PayoutReportService{
	@Autowired
	private PayoutReportDao dao;
	@Override
	public List<PayoutReportModel> getPayoutList(SaleReportForm form) {

		return dao.getPayoutList(form);
	}
	@Override
	public PayoutReportModel getPayout(SaleReportForm form) {

		return dao.getPayout(form);
	}}
