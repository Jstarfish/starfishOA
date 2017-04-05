package cls.taishan.web.dealer.dao;

import java.util.List;

import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import cls.taishan.web.dealer.form.DealerForm;
import cls.taishan.web.dealer.model.Dealer;
import cls.taishan.web.dealer.model.DealerAccount;
import cls.taishan.web.dealer.model.GamePermission;
import cls.taishan.web.dealer.model.Security;

public interface DealerDao {

	List<Dealer> getDealerList(DealerForm form);

	Dealer getDealerDetail(String dealerCode);

	void updateDealer(Dealer dealer);

	void changeDealerStatus(Dealer dealer);

	List<GamePermission> getGamePermissons(String dealerCode);

	void updateGamePermissions(GamePermission permission);

	void addDealer(Dealer dealer);

	void updateMsg(Security security);

	@Select("SELECT DEALER_CODE dealerCode,PUBLIC_KEY publicKey FROM CNCP_SECURITY_DEALER WHERE DEALER_CODE = #{dealerCode}")
	Security getSecurity(String dealerCode);

	int getIfExistDealer(String dealerCode);

	DealerAccount getDealerCredit(String dealerCode);

	void updateDealerCredit(DealerAccount account);

}
