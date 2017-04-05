package cls.taishan.web.order.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.taishan.web.order.dao.OrderDao;
import cls.taishan.web.order.form.OrderForm;
import cls.taishan.web.order.model.Game;
import cls.taishan.web.order.model.Order;
import cls.taishan.web.order.service.OrderService;

@Service
public class OrderServiceImpl implements OrderService {

	@Autowired
	private OrderDao orderDao;

	@Override
	public List<Order> getOrderList(OrderForm form) {
		return orderDao.getOrderList(form);
	}

	@Override
	public Order getOrderDeatil(String saleFlow) {
		return orderDao.getOrderDeatil(saleFlow);
	}

	@Override
	public List<String> getTicketDetail(String saleFlow) {
		return orderDao.getTicketDetail(saleFlow);
	}

	@Override
	public int getTotalCount(OrderForm form) {
		return orderDao.getTotalCount(form);
	}

	@Override
	public List<Game> getGameList() {
		return orderDao.getGameList();
	}

}
