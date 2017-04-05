package cls.pilottery.demo.dao.db1;

import java.util.List;

import cls.pilottery.demo.form.DemoForm;
import cls.pilottery.demo.model.User;

public interface DemoDao {

	Integer getUserCount(DemoForm demoForm);

	List<User> getUserList(DemoForm demoForm);

	User getUserById(String userId);
    
}
