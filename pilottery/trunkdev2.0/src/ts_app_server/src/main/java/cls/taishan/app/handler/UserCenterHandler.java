package cls.taishan.app.handler;

import javax.inject.Singleton;

import cls.taishan.common.annotations.RouteHandler;
import lombok.extern.log4j.Log4j;

/**
 * 用户类业务消息
 * @author huangchy
 *
 * @2016年12月12日
 *
 * 包含消息如下：
 * 1001：用户注册
 * 1002：用户登录
 * 1003：用户签退
 * 1004：个人中心信息汇总
 * 1005：个人信息详情
 * 1101：修改登陆密码
 * 1102：修改交易密码
 * 1103：获取个人安保问题
 * 1104：修改密保问题
 * 1105：修改用户名
 * 1106：修改性别
 * 1107：修改地区
 * 1108：修改身份认证信息
 * 1109：修改绑定手机
 * 1110：获取用户状态
 * 1111：修改个人头像
 * 1201：礼包查询
 * 1203：使用礼包
 *
 */
@Log4j
@Singleton
@RouteHandler("/userCenter")
public class UserCenterHandler {

}
