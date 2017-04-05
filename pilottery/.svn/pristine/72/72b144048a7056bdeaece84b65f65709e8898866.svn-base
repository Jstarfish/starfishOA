package cls.taishan.web.service.Impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.taishan.web.dao.AccountDao;
import cls.taishan.web.model.Account;
import cls.taishan.web.model.TradeRecord;
import cls.taishan.web.service.CapitalService;

@Service
public class CapitalServiceImpl implements CapitalService {

	@Autowired
	private AccountDao accountDao;
	@Override
	public List<Account> getAccountList(Account form) {
		return accountDao.getAccountList(form);
	}
	@Override
	public List<TradeRecord> getTradeRecordList(TradeRecord form) {
		return accountDao.getTradeRecordList(form);
	}

}
