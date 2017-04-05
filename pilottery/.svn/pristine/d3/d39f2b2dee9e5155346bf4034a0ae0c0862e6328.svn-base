<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ include file="/views/common/taglibs.jsp" %>
<%@ include file="/views/common/meta.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Detail</title>
<link rel="stylesheet" href="${basePath}/css/bootstrap.min.css?v=3.3.6">
<link rel="stylesheet" href="${basePath}/css/bootstrap-table/bootstrap-table.min.css">
<link rel="stylesheet" href="${basePath}/css/cncp/common.css">

<script src="${basePath}/js/jquery.min.js"></script>
<script src="${basePath}/js/bootstrap.min.js"></script>
<script src="${basePath}/js/plugins/bootstrap-table/bootstrap-table.min.js"></script>
<script src="${basePath}/js/plugins/bootstrap-table/locale/bootstrap-table-zh-CN.min.js"></script>
<script src="${basePath}/js/plugins/sweetalert/sweetalert.min.js"></script>
</head>
<body class="gray-bg">
	<form class="form-horizontal m-t" id="editForm" novalidate="novalidate">
		<div class="form-group">
			<label class="col-sm-2 control-label">交易流水：</label>
			<div class="col-sm-3">
				<p class="form-control-static">${topUpDetail[0].tradeFlow }</p>
			</div>
			<label class="col-sm-2 control-label">用户编号：</label>
			<div class="col-sm-3">
				<p class="form-control-static">${topUpDetail[0].userId }</p>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">账户编号：</label>
			<div class="col-sm-3">
				<p class="form-control-static">${topUpDetail[0].accNo }</p>
			</div>
			<label class="col-sm-2 control-label">交易状态：</label>
			<div class="col-sm-3">
				<p class="form-control-static">
				<c:if test="${topUpDetail[0].tradeStatus==1 }">收到请求</c:if>
				<c:if test="${topUpDetail[0].tradeStatus==2 }">登录</c:if>
				<c:if test="${topUpDetail[0].tradeStatus==3 }">校验</c:if>
				<c:if test="${topUpDetail[0].tradeStatus==4 }">提交</c:if>
				<c:if test="${topUpDetail[0].tradeStatus==5 }">账户查询</c:if>
				<c:if test="${topUpDetail[0].tradeStatus==6 }">转账收到请求</c:if>
				</p>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">币种：</label>
			<div class="col-sm-3">
				<p class="form-control-static">
				<c:if test="${topUpDetail[0].currency==1 }">瑞尔</c:if>
				<c:if test="${topUpDetail[0].currency==0 }">美元</c:if>
				</p>
			</div>
			<label class="col-sm-2 control-label">商户交易流水：</label>
			<div class="col-sm-3">
				<p class="form-control-static">${topUpDetail[0].euserTradeFlow }</p>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">交易金额：</label>
			<div class="col-sm-3">
				<p class="form-control-static">${topUpDetail[0].amount }</p>
			</div>
			<label class="col-sm-2 control-label">普通用户账号：</label>
			<div class="col-sm-3">
				<p class="form-control-static">${topUpDetail[0].customerAccount }</p>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">普通用户姓名：</label>
			<div class="col-sm-3">
				<p class="form-control-static">${topUpDetail[0].customerName }</p>
			</div>
			<label class="col-sm-2 control-label">手续费：</label>
			<div class="col-sm-3">
				<p class="form-control-static">${topUpDetail[0].fee }</p>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">总金额：</label>
			<div class="col-sm-3">
				<p class="form-control-static">${topUpDetail[0].totalAmount }</p>
			</div>
			<label class="col-sm-2 control-label">费率转换公式：</label>
			<div class="col-sm-3">
				<p class="form-control-static">${topUpDetail[0].context }</p>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">是否成功：</label>
			<div class="col-sm-3">
				<p class="form-control-static">
				<c:if test="${topUpDetail[0].isSucc==1 }">成功</c:if>
				<c:if test="${topUpDetail[0].isSucc==2 }">失败</c:if>
				<c:if test="${topUpDetail[0].isSucc==3 }">超时</c:if>
				</p>
			</div>
			<label class="col-sm-2 control-label">商户余额：</label>
			<div class="col-sm-3">
				<p class="form-control-static">${topUpDetail[0].balance }</p>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">Wing交易ID：</label>
			<div class="col-sm-3">
				<p class="form-control-static">${topUpDetail[0].tradeId }</p>
			</div>
			<label class="col-sm-2 control-label">交易发起时间：</label>
			<div class="col-sm-3">
				<p class="form-control-static">${topUpDetail[0].startTime }</p>
			</div>
		</div>
			<div class="form-group">
			<label class="col-sm-2 control-label">交易结束时间：</label>
			<div class="col-sm-3">
				<p class="form-control-static">${topUpDetail[0].endTime }</p>
			</div>
		</div>
        </form>
</body>
</html>