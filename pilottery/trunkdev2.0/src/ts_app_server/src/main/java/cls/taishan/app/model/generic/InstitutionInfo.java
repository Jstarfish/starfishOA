package cls.taishan.app.model.generic;

import lombok.Getter;
import lombok.Setter;

/*
 * 机构信息实体
 * 为消息9205使用
 */
@Getter
@Setter
public class InstitutionInfo implements java.io.Serializable{
	private static final long serialVersionUID = -1368718935480533559L;

	/*
	 * 编码
	 */
	private String institutionCode;
	
	/*
	 * 名称
	 */
	private String institutionName;
	
	/*
	 * 联系人
	 */
	private String institutionContact;
	
	/*
	 * 电话
	 */
	private String institutionPhone;
	
	/*
	 * 地址
	 */
	private String institutionAddress;
}
