package cls.pilottery.web.checkTickets.service;

import java.util.List;

import cls.pilottery.web.checkTickets.form.ScanTicketDataForm;
import cls.pilottery.web.checkTickets.model.GameBatchInfo;

public interface ScanTicketService {
	public List<GameBatchInfo> getGameBatchInfo();
	public void submitTicketData(ScanTicketDataForm scanTicketDataForm);
}
