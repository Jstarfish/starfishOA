package cls.pilottery.oms.lottery.service.impl;

import cls.pilottery.oms.lottery.dao.BadTicketDao;
import cls.pilottery.oms.lottery.form.BadTicketForm;
import cls.pilottery.oms.lottery.model.BadTicket;
import cls.pilottery.oms.lottery.model.Betinfo;
import cls.pilottery.oms.lottery.service.BadTicketService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created by Reno Main on 2016/5/19.
 */
@Service
public class BadTicketServiceImpl implements BadTicketService {
    @Autowired
    private BadTicketDao badTicketDao;

    @Override
    public List<BadTicket> queryBadTicket(BadTicketForm badTicketForm) {
        return this.badTicketDao.queryBadTicket(badTicketForm);
    }

    @Override
    public Integer queryBadTicketCount(BadTicketForm badTicketForm)
    {
        return this.badTicketDao.queryBadTicketCount(badTicketForm);
    }

}
