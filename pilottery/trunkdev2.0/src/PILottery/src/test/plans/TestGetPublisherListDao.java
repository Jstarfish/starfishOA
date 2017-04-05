package test.plans;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.web.plans.service.PlanService;
import cls.pilottery.web.plans.model.Publisher;
import test.BaseTest;

public class TestGetPublisherListDao extends BaseTest {
    @Autowired
    private PlanService planService;
    @Test
    public void testGetPublisherListDao() {
        List<Publisher> publisherList = new ArrayList<Publisher>();
        publisherList = planService.getPublisherList();
        ListIterator<Publisher> publisherListIterator = publisherList.listIterator();
        while (publisherListIterator.hasNext()) {
            Publisher p = publisherListIterator.next();
            System.out.println(p.getPublisherCode() + ": " + p.getPublisherName());
        }
    }
}
