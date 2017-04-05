package cls.taishan.common.helper;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import cls.taishan.common.utils.SerializeUtils;
import cls.taishan.common.utils.VertxConfiguration;
import lombok.extern.log4j.Log4j;
import redis.clients.jedis.JedisPoolConfig;
import redis.clients.jedis.JedisShardInfo;
import redis.clients.jedis.ShardedJedis;
import redis.clients.jedis.ShardedJedisPool;

@Log4j
public class RedisHelper {
	
	public static ShardedJedisPool shardedJedisPool;

	/**
	 * 设置一个key的过期时间（单位：秒）
	 * 
	 * @param key key值
	 * @param seconds 多少秒后过期
	 * @return 1：设置了过期时间 0：没有设置过期时间/不能设置过期时间
	 */
	public static long expire(String key, int seconds) {
		if (key == null || key.equals("")) {
			return 0;
		}
		ShardedJedis shardedJedis = null;
		try {
			shardedJedis = shardedJedisPool.getResource();
			return shardedJedis.expire(key, seconds);
		} catch (Exception ex) {
			log.error("EXPIRE error[key=" + key + " seconds=" + seconds + "]" + ex.getMessage(), ex);
			ex.printStackTrace();
			returnBrokenResource(shardedJedis);
		} finally {
			returnResource(shardedJedis);
		}
		return 0;
	}

	/**
	 * 设置一个key在某个时间点过期
	 * 
	 * @param key
	 * @param unixTimestamp
	 *            unix时间戳，从1970-01-01 00:00:00开始到现在的秒数
	 * @return 1：设置了过期时间 0：没有设置过期时间/不能设置过期时间
	 */
	public static long expireAt(String key, int unixTimestamp) {
		if (key == null || key.equals("")) {
			return 0;
		}

		ShardedJedis shardedJedis = null;
		try {
			shardedJedis = shardedJedisPool.getResource();
			return shardedJedis.expireAt(key, unixTimestamp);
		} catch (Exception ex) {
			log.error("EXPIRE error[key=" + key + " unixTimestamp=" + unixTimestamp + "]" + ex.getMessage(), ex);
			returnBrokenResource(shardedJedis);
		} finally {
			returnResource(shardedJedis);
		}
		return 0;
	}

	
	public static boolean set(String key, String value, int second) {
		ShardedJedis shardedJedis = null;
		try {
			shardedJedis = shardedJedisPool.getResource();
			shardedJedis.setex(key, second, value);
			return true;
		} catch (Exception ex) {
			log.error("set error.", ex);
			returnBrokenResource(shardedJedis);
		} finally {
			returnResource(shardedJedis);
		}
		return false;
	}

	public static boolean set(String key, String value) {
		ShardedJedis shardedJedis = null;
		try {
			shardedJedis = shardedJedisPool.getResource();
			shardedJedis.set(key, value);
			return true;
		} catch (Exception ex) {
			ex.printStackTrace();
			log.error("set error.", ex);
			returnBrokenResource(shardedJedis);
		} finally {
			returnResource(shardedJedis);
		}
		return false;
	}

	public static String get(String key, String defaultValue) {
		ShardedJedis shardedJedis = null;
		try {
			shardedJedis = shardedJedisPool.getResource();
			return shardedJedis.get(key) == null ? defaultValue : shardedJedis
					.get(key);
		} catch (Exception ex) {
			log.error("get error.", ex);
			returnBrokenResource(shardedJedis);
		} finally {
			returnResource(shardedJedis);
		}
		return defaultValue;
	}

	public static String get(String key) {
		ShardedJedis shardedJedis = null;
		try {
			shardedJedis = shardedJedisPool.getResource();
			return shardedJedis.get(key);
		} catch (Exception ex) {
			log.error("get error.", ex);
			returnBrokenResource(shardedJedis);
		} finally {
			returnResource(shardedJedis);
		}
		return null;
	}

	public static boolean del(String key) {
		ShardedJedis shardedJedis = null;
		try {
			shardedJedis = shardedJedisPool.getResource();
			shardedJedis.del(key);
			return true;
		} catch (Exception ex) {
			log.error("del error.", ex);
			returnBrokenResource(shardedJedis);
		} finally {
			returnResource(shardedJedis);
		}
		return false;
	}
	
	private static void returnBrokenResource(ShardedJedis shardedJedis) {
		try {
			shardedJedisPool.returnBrokenResource(shardedJedis);
		} catch (Exception e) {
			log.error("returnBrokenResource error.", e);
		}
	}

	private static void returnResource(ShardedJedis shardedJedis) {
		try {
			shardedJedisPool.returnResource(shardedJedis);
		} catch (Exception e) {
			log.error("returnResource error.", e);
		}
	}
	
	/**
	 * 存一个对象 如果key已经存在 覆盖原值 成功返回 OK 失败返回 null
	 */
	public static String setObject(String key, Serializable value) {
		return setObjectImpl(key, value);
	}

	/**
	 * 存一个对象 如果key已经存在 覆盖原值 成功返回 OK 失败返回 null
	 */
	public static String setObject(String key, Object value) {
		return setObjectImpl(key, value);
	}

	/**
	 * 存一个List 对象 如果key已经存在 覆盖原值 成功返回 OK 失败返回 null
	 */
	public static String setObject(String key, List<? extends Serializable> value) {
		return setObjectImpl(key, value);
	}

	/**
	 * 存一个Map对象 如果key已经存在 覆盖原值 成功返回 OK 失败返回 null
	 */
	public static String setObject(String key, Map<?, ? extends Serializable> value) {
		return setObjectImpl(key, value);
	}

	/**
	 * 存一个Set集合 如果key已经存在 覆盖原值 成功返回 OK 失败返回 null
	 */
	public static String setObject(String key, Set<? extends Serializable> value) {
		return setObjectImpl(key, value);
	}
	
	public static Object getObject(String key) {
		ShardedJedis shardedJedis = null;
		try {
			shardedJedis = shardedJedisPool.getResource();
			byte[] bs = shardedJedis.get(key.getBytes());
			if (null != bs) {
				Object obj = SerializeUtils.unserialize(bs);
				return obj;
			}
		} catch (Exception e) {
			shardedJedisPool.returnBrokenResource(shardedJedis);
			log.error("从redis取数据时出错", e);
		} finally {
			shardedJedisPool.returnResource(shardedJedis);
		}
		return null;
	}

	@SuppressWarnings("unchecked")
	public static <T> T getObject(Class<T> clazz, String key) {
		ShardedJedis shardedJedis = null;
		try {
			shardedJedis = shardedJedisPool.getResource();
			byte[] bs = shardedJedis.get(key.getBytes());
			if (null != bs) {
				return (T) SerializeUtils.unserialize(bs);
			}
		} catch (Exception e) {
			shardedJedisPool.returnBrokenResource(shardedJedis);
			log.error("从redis取数据时出错", e);
		} finally {
			shardedJedisPool.returnResource(shardedJedis);
		}
		return null;
	}

	

	private static String setObjectImpl(String key, Object value) {
		ShardedJedis shardedJedis = null;
		try {
			shardedJedis = shardedJedisPool.getResource();
			byte[] byteArray = SerializeUtils.serialize(value);
			String setObjectRet = shardedJedis.set(key.getBytes(), byteArray);
			return setObjectRet;
		} catch (Exception e) {
			shardedJedisPool.returnBrokenResource(shardedJedis);
			log.error("向redis存储对象时出错", e);
		} finally {
			shardedJedisPool.returnResource(shardedJedis);
		}
		return null;
	}
	
	public static void createShardedJedisPool(){
		JedisPoolConfig config =new JedisPoolConfig();//Jedis池配置
		//VertxConfiguration
		config.setMaxTotal(VertxConfiguration.redisInt("redis.pool.maxTotal"));
		config.setMaxIdle(VertxConfiguration.redisInt("redis.pool.maxIdle"));//对象最大空闲时间
		config.setMaxWaitMillis(VertxConfiguration.redisInt("redis.maxWaitMillis"));
		config.setTestOnBorrow(true);
		config.setTestWhileIdle(true);
		config.setTestOnReturn(false);
		config.setJmxEnabled(true);
		config.setBlockWhenExhausted(false);
		config.setTimeBetweenEvictionRunsMillis(30000);
		config.setNumTestsPerEvictionRun(1024);
		config.setMinEvictableIdleTimeMillis(-1);
		config.setSoftMinEvictableIdleTimeMillis(10000);
		
		List<JedisShardInfo> jdsInfoList =new ArrayList<JedisShardInfo>(2);
		JedisShardInfo master = new JedisShardInfo(VertxConfiguration.redisStr("redis.master.host"), VertxConfiguration.redisInt("redis.master.port"));
		JedisShardInfo slaver = new JedisShardInfo(VertxConfiguration.redisStr("redis.slaver.host"), VertxConfiguration.redisInt("redis.slaver.port"));
		jdsInfoList.add(master);
		jdsInfoList.add(slaver);
		shardedJedisPool =new ShardedJedisPool(config, jdsInfoList);
	}
}
