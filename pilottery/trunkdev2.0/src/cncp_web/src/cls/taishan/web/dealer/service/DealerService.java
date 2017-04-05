package cls.taishan.web.dealer.service;

import java.util.List;

import cls.taishan.web.dealer.form.DealerForm;
import cls.taishan.web.dealer.model.Dealer;
import cls.taishan.web.dealer.model.DealerAccount;
import cls.taishan.web.dealer.model.GamePermission;
import cls.taishan.web.dealer.model.PermissionArray;
import cls.taishan.web.dealer.model.Security;


public interface DealerService {

	List<Dealer> getDealerList(DealerForm form);

	Dealer getDealerDetail(String dealerCode);

	void updateDealer(Dealer dealer);

	void changeDealerStatus(Dealer dealer);

	List<GamePermission> getGamePermissions(String dealerCode);

	void updateGamePermissions(PermissionArray guth);

	void addDealer(Dealer dealer);

	void updateMsg(Security security);

	Security getSecurity(String dealerCode);

	int getIfExistDealer(String dealerCode);

	DealerAccount getDealerCredit(String dealerCode);

	void updateDealerCredit(DealerAccount account);

}
