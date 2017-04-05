package cls.taishan.app.model.generic;

import lombok.Getter;
import lombok.Setter;

/*
 * 密保问题信息实体
 */
@Getter
@Setter
public class QuestionInfo implements java.io.Serializable{
	private static final long serialVersionUID = -5592039015152846801L;

	/*
	 * 标题
	 */
	private int questionId;
	
	/*
	 * 内容
	 */
	private String questionTitle;
	

}
