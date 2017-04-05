package cls.pilottery.web.checkTickets.service;

import java.util.List;

import cls.pilottery.web.checkTickets.form.CheckStatisticForm;
import cls.pilottery.web.checkTickets.model.CheckStatisticVo;
import cls.pilottery.web.checkTickets.model.CheckStatisticsInfo;

public interface CheckStatisticService {
	List<CheckStatisticVo> getCheckStatisticList(CheckStatisticForm checkStatisticForm);
	
	List<CheckStatisticVo> getRefuseRecordsListInfo(CheckStatisticForm checkStatisticForm);

	List<CheckStatisticsInfo> getStatisticInfo(String flow);
}
