<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/views/common/meta.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

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
<script src="${basePath}/views/dealer/js/dealerList.js"></script>

<title>Dealer List</title>
</head>
<body>
	<div class="row base-margin" id="query">
		<ol class="breadcrumb">
			<li><strong><span style="color: #27a0d7">Dealer List</span></strong></li>
		</ol>
		<form class="form-inline" role="form" style="float: left; width: 100%;margin-bottom:0;" method="post" id="queryForm">
			<div class="form-group">
				<label>Dealer Code:</label> 
				<input type="text" class="form-control" name="dealerCode" id="dealerCode" placeholder="Please input dealer code" maxlength="4"/>
			</div>
			<div class="form-group">
				<label>Dealer Name:</label> 
				<input type="text" class="form-control" name="dealerName" id="dealerName"  placeholder="Please input dealer name" maxlength="50">
			</div>
			<div class="form-group">
				<label >Date:</label>
				<input placeholder="StartDate" class="form-control layer-date" id="startDate" name="startDate">
				<input placeholder="EndDate" class="form-control layer-date" id="endDate" name="endDate">
			</div>
			<div class="form-group">
				<button type="button" id="queryBtn" onclick="doQuery();" class="btn btn-primary">Query</button>
			</div>
			<div class="form-group btn-right">
				<button type="button" class="btn btn-primary" id="addBtn" onclick="addDealer();">New Dealer</button>
			</div> 
		</form>
	</div>
	<div class="container" style="width: 100%">
	    <table id="dealerList-table">
	    </table>
	</div>
</body>
</html>