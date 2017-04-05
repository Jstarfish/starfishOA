package cls.taishan.common.service;

import java.io.Serializable;
import java.util.List;
import java.util.Map;
import java.util.Set;

public interface RedisService {
	public long expire(String key, int seconds);

	public long expireAt(String key, int unixTimestamp);

	public String trimList(String key, long start, long end);

	public long countSet(String key);

	public boolean addSet(String key, int seconds, String... value);

	public boolean addSet(String key, String... value);

	public boolean containsInSet(String key, String value);

	public Set<String> getSet(String key);

	public boolean removeSetValue(String key, String... value);

	public int removeListValue(String key, List<String> values);

	public int removeListValue(String key, long count, List<String> values);

	public boolean removeListValue(String key, long count, String value);

	public List<String> rangeList(String key, long start, long end);

	public long countList(String key);

	public boolean addList(String key, int seconds, String... value);

	public boolean addList(String key, String... value);

	public boolean addList(String key, List<String> list);

	public List<String> getList(String key);

	public boolean setHSet(String domain, String key, String value);

	public String getHSet(String domain, String key);

	public long delHSet(String domain, String key);

	public long delHSet(String domain, String... key);

	public boolean existsHSet(String domain, String key);

	public List<Map.Entry<String, String>> scanHSet(String domain, String match);

	public List<String> hvals(String domain);

	public Set<String> hkeys(String domain);

	public long lenHset(String domain);

	public boolean setSortedSet(String key, long score, String value);

	public Set<String> getSoredSet(String key, long startScore, long endScore,
			boolean orderByDesc);

	public long countSoredSet(String key, long startScore, long endScore);

	public boolean delSortedSet(String key, String value);

	public Set<String> getSoredSetByRange(String key, int startRange,
			int endRange, boolean orderByDesc);

	public Double getScore(String key, String member);

	public boolean set(String key, String value, int second);

	public boolean set(String key, String value);

	public String get(String key, String defaultValue);

	public String get(String key);

	public boolean del(String key);

	public long incr(String key);

	public long decr(String key);

	public String setObject(String key, Serializable value);

	public String setObject(String key, Object value);

	public String setObject(String key, List<? extends Serializable> value);

	public String setObject(String key, Map<?, ? extends Serializable> value);

	public String setObject(String key, Set<? extends Serializable> value);

	public Object getObject(String key);

	public <T> T getObject(Class<T> clazz, String key);

}
