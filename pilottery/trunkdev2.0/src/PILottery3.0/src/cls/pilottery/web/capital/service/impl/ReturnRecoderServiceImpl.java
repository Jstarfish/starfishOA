package cls.pilottery.web.capital.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cls.pilottery.web.capital.dao.ReturnRecoderDao;
import cls.pilottery.web.capital.form.ReturnRecoderForm;
import cls.pilottery.web.capital.model.returnmodel.ReturnRecoder;
import cls.pilottery.web.capital.service.ReturnRecoderService;

@Service
public class ReturnRecoderServiceImpl implements ReturnRecoderService {

	@Autowired
	private ReturnRecoderDao returnRecoderDao;

	@Override
	public Integer getReturnCount(ReturnRecoderForm returnRecoderForm) {
		return returnRecoderDao.getReturnCount(returnRecoderForm);
	}

	@Override
	public List<ReturnRecoder> getReturnList(ReturnRecoderForm returnRecoderForm) {
		return returnRecoderDao.getReturnList(returnRecoderForm);
	}

	@Override
	public ReturnRecoder getReturnInfoById(String returnNo) {
		return returnRecoderDao.getReturnInfoById(returnNo);
	}

	@Transactional(rollbackFor = { Exception.class })
	@Override
	public void updateReturnApproval(ReturnRecoder returnRecoder) {
		returnRecoderDao.updateReturnApproval(returnRecoder);
	}

}
