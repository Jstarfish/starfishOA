package cls.pilottery.web.checkTickets.service;

import java.util.List;

import cls.pilottery.web.checkTickets.form.CheckInquiryForm;
import cls.pilottery.web.checkTickets.model.CheckStatisticsInfo;
import cls.pilottery.web.checkTickets.model.InquiryMain;
import cls.pilottery.web.checkTickets.model.InquirySecondary;

public interface InquiryService {

	int getScanCount(CheckInquiryForm form);// 获取列表行数

	List<InquiryMain> getScanList(CheckInquiryForm form);// 获取列表

	List<InquirySecondary> getScanDetail(String payFlow);// 详情页面

	List<InquirySecondary> getInquiryByFlow(String flow);

	List<CheckStatisticsInfo> getStatisticInfo(String flow);
}
