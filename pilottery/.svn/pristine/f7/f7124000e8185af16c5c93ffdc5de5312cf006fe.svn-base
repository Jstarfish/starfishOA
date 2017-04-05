package test.redis;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import test.BaseTest;
import cls.pilottery.common.service.RedisService;

public class RedisTest extends BaseTest{

	@Autowired
	private RedisService redisService;
	
	@Test
	public void testRedis(){
		redisService.set("test", "Hello World");
		
		System.out.println(redisService.get("test",null));
	}
	
}
