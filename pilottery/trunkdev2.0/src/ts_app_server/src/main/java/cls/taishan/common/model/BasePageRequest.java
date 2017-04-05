package cls.taishan.common.model;

import lombok.Getter;
import lombok.Setter;

/**
 * 有分页的请求消息通用基类
 * 
 * @author huangchy
 *
 * @2016年12月14日
 *
 */
@Getter
@Setter
public class BasePageRequest implements java.io.Serializable{
	private static final long serialVersionUID = 6113160460145776164L;
	private int pageSize;
	private String lastRecordId;
}
