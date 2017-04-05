package cls.pilottery.web.checkTickets.dao;

import java.util.List;

import cls.pilottery.web.checkTickets.model.GameBatchInfo;

public interface ScanTicketDao {
	public List<GameBatchInfo> getGameBatchInfo();
}
