package cls.pilottery.oms.lottery.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.oms.lottery.dao.AbandonAwardDao;
import cls.pilottery.oms.lottery.model.AbandonAward;
import cls.pilottery.oms.lottery.service.AbandonAwardService;


@Service
public class AbandonAwardServiceImpl implements AbandonAwardService {

	@Autowired
	private AbandonAwardDao abandonAwardDao;

	public Integer getCount(AbandonAward abandonAward) {
		
		return abandonAwardDao.getCount(abandonAward);
	}

	public List<Map<String, Object>> getAbandonAwardList(AbandonAward abandonAward) {
		
		return abandonAwardDao.getAbandonAwardList(abandonAward);
	}

	@Override
	public List<Map<String, Object>> getAbandonAwardDetailList(
			AbandonAward abandonAward) {
		
		return abandonAwardDao.getAbandonAwardDetailList(abandonAward);
	}
}
