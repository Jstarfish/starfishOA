package cls.taishan.common.utils;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.Properties;
import java.util.concurrent.ConcurrentMap;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.collect.Maps;

import io.vertx.core.json.JsonObject;
import lombok.extern.log4j.Log4j;

@Log4j
public class VertxConfiguration {

	//private static final String[] CONFIG_NAMES = { "config.json", "jdbc.json", "redis.json" };
	private static final String[] CONFIG_NAMES = { "config.json" ,"redis.json","jdbc.properties"};

	static final VertxConfiguration configuration = new VertxConfiguration();

	private static ConcurrentMap<String, JsonObject> configMaps;

	@SuppressWarnings("unchecked")
	private VertxConfiguration() {
		InputStream is = null;
		try {
			for (String config : CONFIG_NAMES) {
				URL url = getClass().getClassLoader().getResource(config);
				if (VertxEmptyUtils.isEmpty(url)) {
					log.info("file " + config + " is not exist, continue.....");
					continue;
				}
				log.info("Initialize configuration from path : " + url);
				if(config.endsWith("properties")){
					Properties p = new Properties();
					is = url.openConnection().getInputStream();
					p.load(is);
					Map<String, Object> map = new HashMap<String, Object>((Map) p);
					configMaps.put(config.replace("properties", "json"), new JsonObject(map));
				}else{
					ObjectMapper mapper = new ObjectMapper();
					if (VertxEmptyUtils.isEmpty(configMaps)) {
						configMaps = Maps.newConcurrentMap();
					}
					configMaps.put(config, new JsonObject((Map<String, Object>) mapper.readValue(url, Map.class)));
				}
			}
		} catch (Exception ex) {
			log.error(ex.getMessage(), ex);
		} finally {
			if(is != null){
				try {
					is.close();
				} catch (IOException e) {
					log.error(e.getMessage(),e);
				}
			}
		}
	}

	public static String configStr(String configStr) {
		return configMaps.get("config.json").getString(configStr);
	}

	public static String jdbcStr(String configStr) {
		return configMaps.get("jdbc.json").getString(configStr);
	}

	public static boolean existsJsonFile(String json) {
		return VertxEmptyUtils.isEmpty(configMaps.get(json)) ? false : true;
	}

	public static String redisStr(String configStr) {
		Objects.requireNonNull(configMaps.get("redis.json"), "not exists file redis.json");
		return configMaps.get("redis.json").getString(configStr);
	}

	public static int redisInt(String configStr) {
		Objects.requireNonNull(configMaps.get("redis.json"), "not exists file redis.json");
		return configMaps.get("redis.json").getInteger(configStr);
	}

	public static JsonObject jdbcJsonObject() {
		JsonObject config = new JsonObject().put("url", jdbcStr("jdbc.url")).put("driver_class", jdbcStr("jdbc.driver_class"));
		String username = jdbcStr("jdbc.username");
		if (VertxEmptyUtils.isNotEmpty(username))
			config.put("user", username);

		String password = jdbcStr("jdbc.password");
		config.put("password", VertxEmptyUtils.isNotEmpty(password) ? password : "");

		return config;
	}

	public static Integer configInt(String configStr) {
		return configMaps.get("config.json").getInteger(configStr);
	}

	public static Integer jdbcInt(String configStr) {
		return configMaps.get("jdbc.json").getInteger(configStr);
	}

}
