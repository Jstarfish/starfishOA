package cls.pilottery.web.checkTickets.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.checkTickets.dao.CheckStatisticDao;
import cls.pilottery.web.checkTickets.form.CheckStatisticForm;
import cls.pilottery.web.checkTickets.model.CheckStatisticVo;
import cls.pilottery.web.checkTickets.model.CheckStatisticsInfo;
import cls.pilottery.web.checkTickets.service.CheckStatisticService;
@Service
public class CheckStatisticServiceImp implements CheckStatisticService {
  @Autowired 
  private CheckStatisticDao checkStatisticDao;

@Override
public List<CheckStatisticVo> getCheckStatisticList(CheckStatisticForm checkStatisticForm) {

	return this.checkStatisticDao.getCheckStatisticList(checkStatisticForm);
}

@Override
public List<CheckStatisticVo> getRefuseRecordsListInfo(CheckStatisticForm checkStatisticForm) {
	
	return this.checkStatisticDao.getRefuseRecordsListInfo(checkStatisticForm);
}

@Override
public List<CheckStatisticsInfo> getStatisticInfo(String flowNo) {
	return checkStatisticDao.getStatisticInfo(flowNo);
}
}
