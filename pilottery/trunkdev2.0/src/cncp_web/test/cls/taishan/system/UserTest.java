package cls.taishan.system;

import java.util.List;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.alibaba.fastjson.JSON;

import cls.taishan.BaseTest;
import cls.taishan.demo.form.DemoForm;
import cls.taishan.demo.model.DemoUser;
import cls.taishan.demo.service.DemoService;
import lombok.extern.java.Log;

@Log
public class UserTest extends BaseTest {
	@Autowired
	private DemoService userService;
	
	@Test
	public void saveUserTest(){
		DemoUser user = new DemoUser();
		user.setId(-99);
		user.setRealName("User Test");
		user.setLoginId("utest");
		user.setPassword("test password");
		userService.saveUser(user);
	}

	@Test
	public void getUserByIdTest(){
		DemoUser user = userService.getUserById(141);
		log.info(user.toString());
	}
	
	@Test
	public void getUserListTest(){
		List<DemoUser> userList = userService.getUserList(new DemoForm());
		log.info("User list size :"+userList.size());
		log.info(JSON.toJSONString(userList));
	}
	
	@Test
	public void updateUserTest(){
		DemoUser user = userService.getUserById(141);
		log.info("update user address before :" + user.getHomeAddress());
		user.setHomeAddress("test address update");
		userService.updateUser(user);
		user = userService.getUserById(141);
		log.info("update user address after :" + user.getHomeAddress());
	}
	
	@Test
	public void deleteUserTest(){
		userService.deleteUser(-99);
	}
}
