package cls.taishan.demo.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.taishan.demo.dao.DemoDao;
import cls.taishan.demo.form.DemoForm;
import cls.taishan.demo.model.DemoOrgInfo;
import cls.taishan.demo.model.DemoUser;
import cls.taishan.demo.service.DemoService;

@Service
public class DemoServiceImpl implements DemoService {
	@Autowired
	private DemoDao userDao;

	@Override
	public DemoUser getUserById(int userId) {
		return userDao.getUserById(userId);
	}

	@Override
	public List<DemoUser> getUserList(DemoForm form) {
		return userDao.getUserList(form);
	}

	@Override
	public void saveUser(DemoUser user) {
		userDao.saveUser(user);
	}

	@Override
	public void deleteUser(int userId) {
		userDao.deleteUser(userId);
	}

	@Override
	public void updateUser(DemoUser user) {
		userDao.updateUser(user);
	}

	@Override
	public List<DemoOrgInfo> getOrgList() {
		return userDao.getOrgList();
	}

	@Override
	public List<DemoUser> getUserList2(DemoForm form) {
		return userDao.getUserList2(form);
	}

	@Override
	public int getTotalCount(DemoForm form) {
		return userDao.getTotalCount(form);
	}
	
}
