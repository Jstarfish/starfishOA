package cls.taishan.system.model;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class Institution {

	private static final long serialVersionUID = 1L;
	private String orgCode;// 部门编码（00代表总公司，01代表分公司） ORG_CODE
	private String orgName;// 部门名称 ORG_NAME
	private int orgType;// 部门类别1-公司,2-代理 ORG_TYPE
	private String superOrg;// 所属上级 SUPER_ORG
	private String phone;// 部门联系电话 PHONE
	private String directorAdmin;// 负责人 DIRECTOR_ADMIN
	private Long persons;// 部门人数 PERSONS
	private String address;// 地址 ADDRESS
	private Integer orgStatus;// 部门状态
}
