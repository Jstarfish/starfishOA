package cls.taishan.common.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * 
 * @author huangchy
 *
 * @2016年8月31日
 */
@Setter
@Getter
@ToString
public class BaseMessage<T> implements Serializable {
	private static final long serialVersionUID = -6293361236226082507L;
	
	private String messengerId;
	private String token;
	private String timestamp;
	private int transType;
	private T body;

	public BaseMessage() {
	}
	public BaseMessage(T body) {
		this.setBody(body);
	}
}
