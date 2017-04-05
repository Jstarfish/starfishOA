package cls.taishan.cncp.cmi.dao;

import cls.taishan.cncp.cmi.entity.Res5004Model;
import cls.taishan.cncp.cmi.model.*;

import java.util.List;
import java.util.Map;

/**
 * Created by Reno Main on 2016/9/13.
 */

public interface TransFerDao {

	void lotteryBet(Req1002Msg paraMap);

	Res5003Msg lotteryQuery(String ticketId);

	List<Res5004Model> payOffQuery(Map map);

	long getNextSeq();

	void updateLotterySuccess(Map map);

	void updateLotteryFail(Map map);

	String queryGameName(Integer game);

	int getOrderCountByTicketId(String ticketId);
}
