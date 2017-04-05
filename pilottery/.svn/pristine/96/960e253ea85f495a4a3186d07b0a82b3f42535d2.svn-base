package cls.taishan.common.annotations;

import io.vertx.core.http.HttpMethod;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 自定义Route注解
 * 
 * @author huangchy
 *
 * @2016年8月28日
 *
 */
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface RouteMapping {

    String value() default "";

    HttpMethod method() default HttpMethod.GET;

}
