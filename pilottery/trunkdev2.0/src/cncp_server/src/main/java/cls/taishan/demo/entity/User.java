package cls.taishan.demo.entity;

import java.util.Date;

import lombok.Data;

@Data
public class User{
	private String userName;
	private int userId;
	private String loginName;
	private Date createTime;
}
