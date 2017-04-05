package cls.pilottery.oms.game.model;

import cls.pilottery.common.model.BaseEntity;
/**
 * 系统参数表（SYS_PARAMETER）
 * @author Woo
 *
 */
public class SystemParameter extends BaseEntity{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -5813090016685401111L;
	private Long sysDefaultSeq;
	private String sysDefaultDesc;
	private String sysDefaultValue;
	
	public Long getSysDefaultSeq() {
		return sysDefaultSeq;
	}
	public void setSysDefaultSeq(Long sysDefaultSeq) {
		this.sysDefaultSeq = sysDefaultSeq;
	}
	public String getSysDefaultDesc() {
		return sysDefaultDesc;
	}
	public void setSysDefaultDesc(String sysDefaultDesc) {
		this.sysDefaultDesc = sysDefaultDesc;
	}
	public String getSysDefaultValue() {
		return sysDefaultValue;
	}
	public void setSysDefaultValue(String sysDefaultValue) {
		this.sysDefaultValue = sysDefaultValue;
	}
	
}
