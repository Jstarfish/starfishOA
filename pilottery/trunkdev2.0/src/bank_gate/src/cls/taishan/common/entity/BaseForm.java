package cls.taishan.common.entity;

import java.io.Serializable;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BaseForm implements Serializable {
	private static final long serialVersionUID = 107647244048758615L;
	private int pageSize = 1;
	private int pageindex = 50;
	// 分页参数
	private Integer beginNum;
	private Integer endNum;
	
	private String sortName;
	private String sortOrder;
	
	// 调用sp返回的错误参数
	private Integer procErrorCode;
	private String procErrorMsg;
}
