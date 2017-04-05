package cls.taishan.web.order.dao;

import java.util.List;

import cls.taishan.web.order.form.OrderForm;
import cls.taishan.web.order.model.Game;
import cls.taishan.web.order.model.Order;

public interface OrderDao {

	List<Order> getOrderList(OrderForm form);

	Order getOrderDeatil(String saleFlow);

	List<String> getTicketDetail(String saleFlow);

	int getTotalCount(OrderForm form);

	List<Game> getGameList();

}
