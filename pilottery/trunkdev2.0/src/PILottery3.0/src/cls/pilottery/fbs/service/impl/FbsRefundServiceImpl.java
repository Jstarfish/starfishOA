package cls.pilottery.fbs.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.fbs.dao.FbsRefundDao;
import cls.pilottery.fbs.service.FbsRefundService;
import cls.pilottery.oms.lottery.form.SaleCancelInfoForm;
import cls.pilottery.oms.lottery.vo.SaleCancelInfoVo;

@Service
public class FbsRefundServiceImpl implements FbsRefundService {
	@Autowired
	private FbsRefundDao fbsRefundDao;

	@Override
	public List<SaleCancelInfoVo> getSaleCancelList(SaleCancelInfoForm saleCancelInfoForm) {
		return fbsRefundDao.getSaleCancelList(saleCancelInfoForm);
	}

	@Override
	public Integer getSaleCancelCount(SaleCancelInfoForm saleCancelInfoForm) {
		return fbsRefundDao.getSaleCancelCount(saleCancelInfoForm);
	}

}
