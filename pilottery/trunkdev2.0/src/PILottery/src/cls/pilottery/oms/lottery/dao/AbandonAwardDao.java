package cls.pilottery.oms.lottery.dao;
import java.util.List;
import java.util.Map;

import cls.pilottery.oms.lottery.model.AbandonAward;


public interface AbandonAwardDao {

	public Integer getCount(AbandonAward abandonAward);

	public List<Map<String, Object>> getAbandonAwardList(AbandonAward abandonAward);

	public List<Map<String, Object>> getAbandonAwardDetailList(
			AbandonAward abandonAward);

}