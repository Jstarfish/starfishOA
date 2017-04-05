package cls.pilottery.oms.common.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.oms.common.dao.LogDao;
import cls.pilottery.oms.common.entity.MessageLog;

@Service
public class LogService{

    @Autowired
	private LogDao logDao;

	public List<MessageLog> selectMaxFailed() {
		return logDao.selectMaxFailed();
	}

    public long getNextSeq() {
        return logDao.getNextSeq();
    }

	public int insertLog(MessageLog log) {
	    return logDao.insertLog(log);
	}

	public void updateLog(MessageLog log) {
		logDao.updateLog(log);
	}

}
