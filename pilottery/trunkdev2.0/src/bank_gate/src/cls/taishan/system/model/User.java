package cls.taishan.system.model;

import java.util.List;

import cls.taishan.common.entity.BaseForm;
import lombok.Getter;
import lombok.Setter;
@Setter
@Getter
public class User extends BaseForm  {

	private static final long serialVersionUID = 4886146712942662664L;
	private Long id;
	private String realName; // 真实姓名
	private String loginId; // 账户
	private String password; // 密码
	private Integer gender; // 性别
	private String email; // email
	private String birthday; // 生日
	private String phone;// 移动电话
	private String address; // 地址
	private Integer status; // (1-可用，2-删除，3-由于密码原因停用)
	private String createTime;
	private Long createAdminId; // 创建人ID
	private String remark; // 备注信息
	private UserLanguage userLang = UserLanguage.EN;// 用户登陆选择语言默认英文
	private String orgCode;// 所属部门编码
	private String orgName;// 所属部门名称
	private List<Role> roles;
	
	private String roleId;
	
}
