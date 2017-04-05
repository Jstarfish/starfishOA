package cls.taishan.web.dealer.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cls.taishan.web.dealer.dao.DealerDao;
import cls.taishan.web.dealer.form.DealerForm;
import cls.taishan.web.dealer.model.Dealer;
import cls.taishan.web.dealer.model.DealerAccount;
import cls.taishan.web.dealer.model.GamePermission;
import cls.taishan.web.dealer.model.PermissionArray;
import cls.taishan.web.dealer.model.Security;
import cls.taishan.web.dealer.service.DealerService;
@Service
public class DealerServiceImpl implements DealerService {
	@Autowired
	private DealerDao dealerDao;
	@Override
	public List<Dealer> getDealerList(DealerForm form) {
		return dealerDao.getDealerList(form);
	}
	@Override
	public Dealer getDealerDetail(String dealerCode) {
		return dealerDao.getDealerDetail(dealerCode);
	}
	@Override
	public void updateDealer(Dealer dealer) {
		dealerDao.updateDealer(dealer);
	}
	@Override
	public void changeDealerStatus(Dealer dealer) {
		dealerDao.changeDealerStatus(dealer);
	}
	@Override
	public List<GamePermission> getGamePermissions(String dealerCode) {
		return dealerDao.getGamePermissons(dealerCode);
	}
	
	@Transactional(rollbackFor={Exception.class}) 
	@Override
	public void updateGamePermissions(PermissionArray guth) {
		for(int i=0;i<guth.getGpList().size();i++){
			GamePermission permission = guth.getGpList().get(i);
			permission.setDealerCode(permission.getDealerCode());
			permission.setGameCode(permission.getGameCode());
			if(permission.getIsSale() == null || permission.getIsSale().equals("")){
				permission.setIsSale(0);
			}else{
				permission.setIsSale(permission.getIsSale());
			}
			permission.setSaleCommissionRate(permission.getSaleCommissionRate());
			dealerDao.updateGamePermissions(permission);
		}
	}
	@Override
	public void addDealer(Dealer dealer) {
		dealerDao.addDealer(dealer);
	}
	@Override
	public void updateMsg(Security security) {
		dealerDao.updateMsg(security);
		
	}
	@Override
	public Security getSecurity(String dealerCode) {
		return dealerDao.getSecurity(dealerCode);
	}
	@Override
	public int getIfExistDealer(String dealerCode) {
		return dealerDao.getIfExistDealer(dealerCode);
	}
	@Override
	public DealerAccount getDealerCredit(String dealerCode) {
		return dealerDao.getDealerCredit(dealerCode);
	}
	@Override
	public void updateDealerCredit(DealerAccount account) {
		dealerDao.updateDealerCredit(account);
	}
	
}
