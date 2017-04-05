<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="/views/common/taglibs.jsp" %>
<%@ include file="/views/common/meta.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Win List</title>
<link rel="stylesheet" href="${basePath}/css/bootstrap.min.css?v=3.3.6">
<link rel="stylesheet" href="${basePath}/css/bootstrap-table/bootstrap-table.min.css">
<link rel="stylesheet" href="${basePath}/css/plugins/sweetalert/sweetalert.css">
<link rel="stylesheet" href="${basePath}/css/cncp/common.css">

<script src="${basePath}/js/jquery.min.js"></script>
<script src="${basePath}/js/bootstrap.min.js"></script>
<script src="${basePath}/js/plugins/bootstrap-table/bootstrap-table.min.js"></script>
<script src="${basePath}/js/plugins/bootstrap-table/bootstrap-table-export.js"></script>
<script src="${basePath}/js/plugins/bootstrap-table/tableExport.js"></script>
<script src="${basePath}/js/plugins/sweetalert/sweetalert.min.js"></script>
<script src="${basePath}/js/plugins/layer/layer.min.js"></script>
<script src="${basePath}/js/plugins/layer/laydate/laydate.js"></script>
<script src="${basePath}/js/cncp/common.js"></script>
<script src="${basePath}/views/order/js/winList.js"></script>
</head>
<body>
	<div class="row base-margin" id="query">
		<ol class="breadcrumb">
			<li><strong><span style="color: #27a0d7">Winning List</span></strong></li>
		</ol>
		<form class="form-inline" role="form" style="float: left; width: 100%;margin-bottom:0;" method="post" id="queryForm">
			<div class="form-group">
				<label for="saleFlow">No.:</label> 
				<input type="text" class="form-control" name="saleFlow" id="saleFlow"  placeholder="Please input No.">
			</div>
			<div class="form-group">
				<label >Date:</label>
				<input placeholder="StartDate" class="form-control layer-date" id="startDate" name="startDate" value="${startDate }">
				<input placeholder="EndDate" class="form-control layer-date" id="endDate" name="endDate" value="${endDate }">
			</div>
			<div class="form-group">
				<label for="issueNumber">Issue:</label> 
				<input type="text" class="form-control" name="issueNumber" id="issueNumber"  placeholder="Please input issue">
			</div>
			<div class="form-group">
				<label for="dealerCode">Dealer:</label> 
				<select class="form-control" id="dealerCode" name="dealerCode">	
					<option value="">--All--</option>
					<c:forEach var="data" items="${dealerList}">
						<option value="${data.dealerCode }">${data.dealerName }</option>
					</c:forEach>
				</select>
			</div>
			<div class="form-group">
				<label for="gameCode">Game:</label> 
				<select class="form-control" id="gameCode" name="gameCode">	
					<option value="">--All--</option>
					<c:forEach var="data" items="${gameList}">
						<option value="${data.gameCode }">${data.gameName }</option>
					</c:forEach>
				</select>
			</div>
			<div class="form-group">
				<label for="isPaid">Status:</label> 
				<select class="form-control" id="isPaid" name="isPaid">	
					<option value="0">Not Payout</option>
					<option value="1">Payout</option>
					<option value="">All</option>
				</select>
			</div>
			<div class="form-group">
				<button type="button" id="queryBtn" onclick="doQuery();" class="btn btn-primary">Query</button>
			</div>
			<div class="form-group">
				<button type="reset" id="resetBtn"  class="btn btn-primary">Reset</button>
			</div>
		</form>
	</div>
	<div class="container" style="width: 100%">
	    <table id="winList-table">
	    </table>
	</div>
</body>
</html>