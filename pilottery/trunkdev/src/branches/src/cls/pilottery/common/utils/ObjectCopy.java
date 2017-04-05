package cls.pilottery.common.utils;

import cls.pilottery.packinfo.PackInfo;
import cls.pilottery.web.goodsreceipts.model.GoodsBatchStruct;

/*
 * add by dzg
 * 用于一些对象copy和转化
 */
public class ObjectCopy {

	public static GoodsBatchStruct fromPackInfoToPInfo(PackInfo pi)
	{
		if(pi == null)
			return null;
		GoodsBatchStruct gs = new GoodsBatchStruct();
		gs.setBatchNo(pi.getBatchCode());
		gs.setPlanCode(pi.getPlanCode());
		gs.setValidNumber(pi.getPackUnit().ordinal());
		switch (pi.getPackUnit()) {
		case Trunck:
			gs.setTrunkNo(pi.getPackUnitCode());
			gs.setPackageNoe(pi.getFirstPkgCode());
			break;
		case Box:
			gs.setBoxNo(pi.getPackUnitCode());
			gs.setPackageNoe(pi.getFirstPkgCode());
			break;
		case pkg:
			gs.setPackageNo(pi.getPackUnitCode());
			break;
		default:
			break;
		}
		
		return gs;
	}
}
