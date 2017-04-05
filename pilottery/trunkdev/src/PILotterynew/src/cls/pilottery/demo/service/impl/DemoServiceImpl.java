package cls.pilottery.demo.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.demo.dao.db1.DemoDao;
import cls.pilottery.demo.form.DemoForm;
import cls.pilottery.demo.model.User;
import cls.pilottery.demo.service.DemoService;

@Service
public class DemoServiceImpl implements DemoService {

	@Autowired
	private DemoDao userDao;

	@Override
	public Integer getUserCount(DemoForm demoForm) {
		return userDao.getUserCount(demoForm);
	}

	@Override
	public List<User> getUserList(DemoForm demoForm) {
		return userDao.getUserList(demoForm);
	}

	@Override
	public User getUserById(String userId) {
		return userDao.getUserById(userId);
	}
	
}
