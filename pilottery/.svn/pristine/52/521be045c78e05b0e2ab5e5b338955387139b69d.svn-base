-- 授权Oracle数据库连接应用服务器发送URL请求，用于期次转换
-- 这里的配置，需要和系统参数对应。也就是，需要使用系统参数（2004）中，使用的IP地址。
-- 需要使用sys用户进行如下操作
BEGIN
  DBMS_NETWORK_ACL_ADMIN.CREATE_ACL(acl         => 'kws_cncp_issue_notify.xml',
                                    description => '用于KWS中，CNCP无纸化系统。当期次发生切换时，推送消息给应用服务器',
                                    principal   => 'KWS',       -- 用户名
                                    is_grant    => true,
                                    privilege   => 'connect');

  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(acl       => 'kws_cncp_issue_notify.xml',
                                       principal => 'KWS',      -- 用户名
                                       is_grant  => true,
                                       privilege => 'resolve');

  DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL(acl  => 'kws_cncp_issue_notify.xml',host => '192.168.26.112');

  commit;
END;
/
