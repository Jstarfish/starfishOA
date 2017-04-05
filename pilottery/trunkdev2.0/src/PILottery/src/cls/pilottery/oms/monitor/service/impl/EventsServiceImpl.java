package cls.pilottery.oms.monitor.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.oms.monitor.dao.EventsDao;
import cls.pilottery.oms.monitor.form.EventsForm;
import cls.pilottery.oms.monitor.model.Events;
import cls.pilottery.oms.monitor.service.EventsService;

@Service
public class EventsServiceImpl implements EventsService {

	@Autowired
	private EventsDao eventsDao;

	@Override
	public List<Events> getEventsList(EventsForm form) {
		return eventsDao.getEventsList(form);
	}

	@Override
	public Integer getEventsCount(EventsForm form) {
		return eventsDao.getEventsCount(form);
	}

	

}
