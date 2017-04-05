package cls.taishan.app.model.generic;

import java.util.List;

import lombok.Getter;
import lombok.Setter;
import cls.taishan.common.model.BaseResponse;

/*
 * 获取地区信息列表--响应
 */
@Getter
@Setter
public class Res9204Msg extends BaseResponse implements java.io.Serializable{	
	private static final long serialVersionUID = 2169511544973260840L;
	/*
	 * 通知列表
	 */
	private List<RegionInfo> regions;
	

}