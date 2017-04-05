package cls.pilottery.demo.service;

import java.util.List;

import cls.pilottery.demo.form.DemoForm;
import cls.pilottery.demo.model.User;

public interface DemoService {

	Integer getUserCount(DemoForm demoForm);

	List<User> getUserList(DemoForm demoForm);

	User getUserById(String userId);
}
