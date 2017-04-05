package cls.pilottery.oms.monitor.service;

import java.util.List;

import cls.pilottery.oms.monitor.form.EventsForm;
import cls.pilottery.oms.monitor.model.Events;


public interface EventsService {

	List<Events> getEventsList(EventsForm form);

	Integer getEventsCount(EventsForm form);
}
