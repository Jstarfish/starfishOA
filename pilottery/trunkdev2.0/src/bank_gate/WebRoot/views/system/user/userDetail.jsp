<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/views/common/meta.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Demo Table</title>
<link rel="stylesheet" href="${basePath}/css/bootstrap.min.css?v=3.3.6">
</head>
<body style="overflow-x: hidden;">
	<div class="ibox-content" style="margin-top: 15px;">
        <div class="row form-body form-horizontal m-t">
			    <div class="form-group">
			        <label class="col-sm-2 control-label">User Name：</label>
			        <div class="col-sm-3">
			            <p class="form-control-static">${user.loginId }</p>
			        </div>
			        <label class="col-sm-2 control-label">Real Name：</label>
			        <div class="col-sm-3">
			            <p class="form-control-static">${user.realName }</p>
			        </div>
			    </div>
			    <div class="form-group">
			        <label class="col-sm-2 control-label">Institution：：</label>
			        <div class="col-sm-3">
			            <p class="form-control-static">${user.institutionName }</p>
			        </div>
			        <label class="col-sm-2 control-label">Remark：</label>
			        <div class="col-sm-3">
			            <p class="form-control-static">${user.remark }</p>
			        </div>
			    </div>
			    <div class="form-group">
			        <label class="col-sm-2 control-label">纯文本1：</label>
			        <div class="col-sm-3">
			            <p class="form-control-static">这里是纯文字信息11111111</p>
			        </div>
			        <label class="col-sm-2 control-label">纯文本2：</label>
			        <div class="col-sm-3">
			            <p class="form-control-static">这里是纯文字信息2222222233333333333333333333333</p>
			        </div>
			    </div>
        </div>
    </div>
</body>
</html>