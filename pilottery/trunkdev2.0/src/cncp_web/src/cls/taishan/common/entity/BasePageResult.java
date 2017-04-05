package cls.taishan.common.entity;

import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class BasePageResult<T> implements java.io.Serializable {
	private static final long serialVersionUID = -6185619507779929698L;
	private int totalCount;
	private List<T> result;
}
