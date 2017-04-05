package cls.pilottery.packinfo;

public interface PackUnitHandle {

	/*
	 * 根据物流码获取包装信息
	 */
	public PackInfo getPackInfo(String transCode);
}
