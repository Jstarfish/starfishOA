package cls.pilottery.oms.lottery.dao;

import cls.pilottery.oms.lottery.form.BadTicketForm;
import cls.pilottery.oms.lottery.model.BadTicket;
import cls.pilottery.oms.lottery.model.Betinfo;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * Created by Reno Main on 2016/5/19.
 */
@Component
public interface BadTicketDao {

    public List<BadTicket> queryBadTicket(
            BadTicketForm badTicketForm);

    public Integer queryBadTicketCount(
            BadTicketForm badTicketForm);

}
