package cls.taishan.web.service;

import cls.taishan.web.model.control.WingChargeInputParam;
import cls.taishan.web.model.control.WingChargeOutputParam;

public interface WingChargeService {
	public WingChargeOutputParam doCharge(WingChargeInputParam in);
}
