package cls.taishan.common.handler;

import java.lang.reflect.Method;
import java.util.Set;

import org.reflections.Reflections;

import com.google.inject.Injector;

import cls.taishan.common.annotations.RouteHandler;
import cls.taishan.common.annotations.RouteMapping;
import cls.taishan.common.helper.MethodHelper;
import cls.taishan.common.utils.VertxConfiguration;
import io.vertx.core.Handler;
import io.vertx.core.http.HttpMethod;
import io.vertx.ext.web.Router;
import io.vertx.ext.web.RoutingContext;
import lombok.extern.log4j.Log4j;

@Log4j
public class HandlersFactory {

	private static final Reflections reflections = new Reflections(VertxConfiguration.configStr("scan.route.url"));

	/**
	 * 注册Handlers
	 * 
	 * @see
	 */
	public static void registerHandlers(Router router,Injector injector) {
		log.info("Register available request handlers...");

		Set<Class<?>> handlers = reflections.getTypesAnnotatedWith(RouteHandler.class);
		for (Class<?> handlerClass : handlers) {
			try {
				invokeHandlers(handlerClass, router,injector);
			} catch (Exception e) {
				log.error("Error register " + handlerClass, e);
			}
		}
	}

	@SuppressWarnings("unchecked")
	private static void invokeHandlers(Class<?> handlerClass, Router router,Injector injector) throws Exception {
		String root = "";
		if (handlerClass.isAnnotationPresent(RouteHandler.class)) {
			RouteHandler routeHandler = handlerClass.getAnnotation(RouteHandler.class);
			root = routeHandler.value();
		}

		Object handler = handlerClass.newInstance();
		injector.injectMembers(handler);
		for (Method method : handlerClass.getMethods()) {
			if (method.isAnnotationPresent(RouteMapping.class)) {
				RouteMapping mapping = method.getAnnotation(RouteMapping.class);
				HttpMethod routeMethod = mapping.method();
				String url = root + "/" + mapping.value();
				log.info("Register Handler -> " + routeMethod + ":" + url + "");
				MethodHelper.methodMap.put(mapping.value(),url);
				Handler<RoutingContext> methodHandler = (Handler<RoutingContext>) method.invoke(handler);
				switch (routeMethod) {
				case POST:
					router.post(url).handler(methodHandler);
					break;
				case PUT:
					router.put(url).handler(methodHandler);
					break;
				case DELETE:
					router.delete(url).handler(methodHandler);
					break;
				case GET: // fall through
				default:
					router.get(url).handler(methodHandler);
					break;
				}
			}
		}
	}

}
