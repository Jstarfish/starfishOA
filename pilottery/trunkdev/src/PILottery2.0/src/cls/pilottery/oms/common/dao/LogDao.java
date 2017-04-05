package cls.pilottery.oms.common.dao;

import java.util.List;

import cls.pilottery.oms.common.entity.MessageLog;

public interface LogDao {

	List<MessageLog> selectMaxFailed();

    long getNextSeq();

	int insertLog(MessageLog log);
	
	void updateLog(MessageLog log);

}
