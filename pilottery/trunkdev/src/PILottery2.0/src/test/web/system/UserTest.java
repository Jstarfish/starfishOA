package test.web.system;

import org.springframework.beans.factory.annotation.Autowired;

import test.BaseTest;
import cls.pilottery.web.system.service.UserService;

public class UserTest extends BaseTest {
	
	@Autowired
	private UserService userService;
	
	/*@Test
	public void testGetUserByLogin(){
		User user = userService.getUserByLogin("admin");
		System.out.println(user);
	}*/

}
