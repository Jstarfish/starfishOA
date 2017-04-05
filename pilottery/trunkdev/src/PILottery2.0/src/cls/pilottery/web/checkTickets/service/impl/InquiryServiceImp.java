package cls.pilottery.web.checkTickets.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.checkTickets.dao.InquiryDao;
import cls.pilottery.web.checkTickets.form.CheckInquiryForm;
import cls.pilottery.web.checkTickets.model.CheckStatisticsInfo;
import cls.pilottery.web.checkTickets.model.InquiryMain;
import cls.pilottery.web.checkTickets.model.InquirySecondary;
import cls.pilottery.web.checkTickets.service.InquiryService;

@Service
public class InquiryServiceImp implements InquiryService {

	@Autowired
	private InquiryDao inquiryDao;

	public InquiryDao getInquiryDao() {

		return inquiryDao;
	}

	public void setInquiryDao(InquiryDao inquiryDao) {

		this.inquiryDao = inquiryDao;
	}

	@Override
	public int getScanCount(CheckInquiryForm form) {

		return inquiryDao.getScanCount(form);
	}

	@Override
	public List<InquiryMain> getScanList(CheckInquiryForm form) {

		return inquiryDao.getScanList(form);
	}

	@Override
	public List<InquirySecondary> getScanDetail(String payFlow) {

		return inquiryDao.getScanDetail(payFlow);
	}

	@Override
	public List<InquirySecondary> getInquiryByFlow(String flow) {

		return inquiryDao.getInquiryByFlow(flow);
	}

	@Override
	public List<CheckStatisticsInfo> getStatisticInfo(String flow) {
		return inquiryDao.getStatisticInfo(flow);
	}
}
