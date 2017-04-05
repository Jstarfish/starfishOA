<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/views/common/meta.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Win Detail</title>
<link rel="stylesheet" href="${basePath}/css/bootstrap.min.css?v=3.3.6">
<link rel="stylesheet" href="${basePath}/css/bootstrap-table/bootstrap-table.min.css">
<link rel="stylesheet" href="${basePath}/css/plugins/sweetalert/sweetalert.css">
<link rel="stylesheet" href="${basePath}/css/cncp/common.css">

<script src="${basePath}/js/jquery.min.js"></script>
<script src="${basePath}/js/bootstrap.min.js"></script>
<script src="${basePath}/js/plugins/bootstrap-table/bootstrap-table.min.js"></script>
<script src="${basePath}/js/plugins/bootstrap-table/locale/bootstrap-table-zh-CN.min.js"></script>
<script src="${basePath}/js/plugins/bootstrap-table/bootstrap-table-export.js"></script>
<script src="${basePath}/js/plugins/bootstrap-table/tableExport.js"></script>
<script src="${basePath}/js/plugins/sweetalert/sweetalert.min.js"></script>
<script src="${basePath}/js/plugins/layer/layer.min.js"></script>
<script src="${basePath}/js/plugins/layer/laydate/laydate.js"></script>
<script src="${basePath}/js/cncp/common.js"></script>
<script src="${basePath}/views/order/js/orderList.js"></script>
</head>
<body style="overflow-x: hidden;">
	<div class="ibox-content" style="margin-top: 15px;">
        <div class="row form-body form-horizontal m-t">
	<div class="form-group">
		<label class="col-sm-2 control-label">No.：</label>
		<div class="col-sm-3">
			<p class="form-control-static">${prizeDetail.saleFlow }</p>
		</div>
		<label class="col-sm-2 control-label">TSN：</label>
		<div class="col-sm-3">
			<p class="form-control-static">${prizeDetail.saleTsn }</p>
		</div>
	</div>
	<div class="form-group">
		<label class="col-sm-2 control-label">Game：</label>
		<div class="col-sm-3">
			<p class="form-control-static">${prizeDetail.gameName }</p>
		</div>
		<label class="col-sm-2 control-label">Issue：</label>
		<div class="col-sm-3">
			<p class="form-control-static">${prizeDetail.issueNumber }</p>
		</div>
	</div>		
     <div class="form-group">
		<label class="col-sm-2 control-label">Dealer Code：</label>
		<div class="col-sm-3">
			<p class="form-control-static">${prizeDetail.dealerCode }</p>
		</div>
		<label class="col-sm-2 control-label">Dealer Name：</label>
		<div class="col-sm-3">
			<p class="form-control-static">${prizeDetail.dealerName }</p>
		</div>
	</div>
	<div class="form-group">
		<label class="col-sm-2 control-label">Order Amount：</label>
		<div class="col-sm-3">
			<p class="form-control-static"><fmt:formatNumber value="${prizeDetail.orderAmount }"/></p>
		</div>
		<label class="col-sm-2 control-label">Reward Amount：</label>
		<div class="col-sm-3">
			<p class="form-control-static"><fmt:formatNumber value="${prizeDetail.rewardAmount }" /></p>
		</div>
	</div>
	<div class="form-group">
		<label class="col-sm-2 control-label">Status：</label>
		<div class="col-sm-3">
			<p class="form-control-static">
			<c:if test="${prizeDetail.isPaid == 0 }">No Payout</c:if>
			<c:if test="${prizeDetail.isPaid == 1 }">Payout</c:if>
			</p>
		</div>
		<label class="col-sm-2 control-label">Payout Date：</label>
		<div class="col-sm-3">
			<p class="form-control-static">${prizeDetail.paidTime }</p>
		</div>
	</div>
	</div>
	</div>
</body>
</html>