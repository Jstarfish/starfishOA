package test.web.system;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import test.BaseTest;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.system.service.UserService;

public class UserTest extends BaseTest {
	
	@Autowired
	private UserService userService;
	
	@Test
	public void testGetUserByLogin(){
		User user = userService.getUserByLogin("super");
		System.out.println(user);
	}

}
