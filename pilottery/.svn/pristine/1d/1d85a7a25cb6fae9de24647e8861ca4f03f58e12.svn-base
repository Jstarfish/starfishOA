package cls.taishan.web.order.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.taishan.web.order.dao.PrizeDao;
import cls.taishan.web.order.form.PrizeForm;
import cls.taishan.web.order.model.Prize;
import cls.taishan.web.order.service.PrizeService;

@Service
public class PrizeServiceImpl implements PrizeService {

	@Autowired
	private PrizeDao prizeDao;

	@Override
	public List<Prize> getPrizeList(PrizeForm form) {
		return prizeDao.getPrizeList(form);
	}

	@Override
	public Prize getPrizeDetail(String saleFlow) {
		return prizeDao.getPrizeDetail(saleFlow);
	}

	@Override
	public int getTotalCount(PrizeForm form) {
		return prizeDao.getTotalCount(form);
	}

}
