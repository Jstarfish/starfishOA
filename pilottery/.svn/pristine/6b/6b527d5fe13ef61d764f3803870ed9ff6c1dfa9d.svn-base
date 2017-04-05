<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/views/common/meta.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Order Detail</title>
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
		<label class="col-sm-2 control-label">申请流水：</label>
		<div class="col-sm-3">
			<p class="form-control-static">${orderDetail.saleFlow }</p>
		</div>
		<label class="col-sm-2 control-label">TSN号：</label>
		<div class="col-sm-3">
			<p class="form-control-static">${orderDetail.saleTsn }</p>
		</div>
	</div>
	<div class="form-group">
		<label class="col-sm-2 control-label">游戏名称：</label>
		<div class="col-sm-3">
			<p class="form-control-static">${orderDetail.gameName }</p>
		</div>
		<label class="col-sm-2 control-label">期次编号：</label>
		<div class="col-sm-3">
			<p class="form-control-static">${orderDetail.issueNumber }</p>
		</div>
	</div>		
     <div class="form-group">
		<label class="col-sm-2 control-label">渠道编码：</label>
		<div class="col-sm-3">
			<p class="form-control-static">${orderDetail.dealerCode }</p>
		</div>
		<label class="col-sm-2 control-label">渠道名称：</label>
		<div class="col-sm-3">
			<p class="form-control-static">${orderDetail.dealerName }</p>
		</div>
	</div>
	<div class="form-group">
		<label class="col-sm-2 control-label">订单状态：</label>
		<div class="col-sm-3">
			<p class="form-control-static">
				<c:if test="${orderDetail.orderStatus == 1}">已受理</c:if>
				<c:if test="${orderDetail.orderStatus == 2}">出票成功</c:if>
				<c:if test="${orderDetail.orderStatus == 3}">出票失败</c:if>
			</p>
		</div>
		<label class="col-sm-2 control-label">方案总额：</label>
		<div class="col-sm-3">
			<p class="form-control-static">
			<fmt:formatNumber value="${orderDetail.orderAmount }"/>
			</p>
		</div>
	</div>
	<div class="form-group">
		<label class="col-sm-2 control-label">受理时间：</label>
		<div class="col-sm-3">
			<p class="form-control-static">
			   ${orderDetail.orderTime }
			</p>
		</div>
		<label class="col-sm-2 control-label">出票时间：</label>
		<div class="col-sm-3">
			<p class="form-control-static">
			   ${orderDetail.ticketTime }
			</p>
		</div>
	</div>
	<div class="form-group">
		<label class="col-sm-2 control-label">号码详情：</label>
		<div class="col-sm-5">
			<table class="datatable" width="95%" border="2" cellspacing="1" cellpadding="5">
			    <tr class="headRow">
			       <td align="center">玩法</td>
			       <td align="center">投注方式</td>
			       <td align="center">倍数</td>
			       <td align="center">号码</td>
			    </tr>
			<c:forEach items="${ticketDetail }" var="i">
			    <tr class="dataRow">
			        <td align="center">${i.bettingMethod }</td>
			        <td align="center">${i.playName }</td>
			        <td align="center">${i.betNumber }</td>
			        <td align="right">${i.bettingNum }</td>
			    </tr>
			</c:forEach>
			</table>
		</div>
	</div>
	<div class="form-group">
		<label class="col-sm-2 control-label">备注：</label>
		<div class="col-sm-8">
			<p class="form-control-static">${orderDetail.remark }</p>
		</div>
	</div>
	</div>
	</div>
</body>
</html>