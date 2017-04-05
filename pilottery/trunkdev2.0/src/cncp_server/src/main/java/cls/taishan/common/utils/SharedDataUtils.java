package cls.taishan.common.utils;

import io.vertx.core.shareddata.SharedData;

public class SharedDataUtils extends VertxCoreUtils{

	public static SharedData sharedData = vertx.sharedData();

}
