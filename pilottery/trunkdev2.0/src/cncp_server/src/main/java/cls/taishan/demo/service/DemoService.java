package cls.taishan.demo.service;

import java.util.List;

import javax.inject.Inject;
import javax.inject.Singleton;

import cls.taishan.demo.dao.DemoDao;
import cls.taishan.demo.entity.User;
import lombok.extern.log4j.Log4j;

/**
 * 示例service
 * 
 * @author huangchy
 *
 * @2016年8月24日
 *
 */
@Log4j
@Singleton
public class DemoService {
	@Inject
	private DemoDao demoDao;
	public void test(){
		log.info("demo service,just for test...");
	}

	public User getUserById(int userId) {
		return demoDao.getUserById(userId);
	}

	public List<User> getUserList() {
		return demoDao.getUserList();
	}

	public User getUserByAnnotation(int userId) {
		return demoDao.getUserByAnnotation(userId);
	}

}
