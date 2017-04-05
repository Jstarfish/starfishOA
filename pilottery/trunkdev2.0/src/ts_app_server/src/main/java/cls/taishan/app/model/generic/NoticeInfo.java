package cls.taishan.app.model.generic;

import lombok.Getter;
import lombok.Setter;

/*
 * 通知信息实体
 * 为消息9201使用
 */
@Getter
@Setter
public class NoticeInfo implements java.io.Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 8813113385742931265L;

	/*
	 * 标题
	 */
	private String noticeTitle;
	
	/*
	 * 内容
	 */
	private String noticeContent;
	
	/*
	 * 发布日期
	 */
	private String publishedDate;
	
	/*
	 * 图标的Url
	 */
	private String noticePicUrl;
}
