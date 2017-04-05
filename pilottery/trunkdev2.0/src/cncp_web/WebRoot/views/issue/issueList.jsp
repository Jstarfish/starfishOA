<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="/views/common/taglibs.jsp" %>
<%@ include file="/views/common/meta.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

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
<script src="${basePath}/views/issue/js/issueList.js"></script>

<title>Issue Inquiry</title>
</head>
<body>
	<div class="row base-margin" id="query">
		<ol class="breadcrumb">
			<li><strong><span style="color: #27a0d7">Issue Inquiry</span></strong></li>
		</ol>
		<form class="form-inline" role="form" style="float: left; width: 100%;margin-bottom:0;" method="post" id="queryForm">
			
			<div class="form-group">
				<label>Issue:</label> 
				<input type="text" class="form-control" name="issueNumber" id="issueNumber"  placeholder="Please input issue">
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
				<label for="issueStatus">Issue Status:</label> 
				<select class="form-control" id="issueStatus" name="issueStatus">	
					<option value="">--All--</option>
					<c:forEach var="item" items="${issueStatus }">
						<option value="${item.key }">${item.value }</option>
					</c:forEach>
				</select>
			</div>
			<div class="form-group">
				<label >Date:</label>
				<input placeholder="Date" class="form-control layer-date" id="startSaleTime" name="startSaleTime">
			</div>
			<div class="form-group">
				<button type="button" id="queryBtn" onclick="doQuery();" class="btn btn-primary">Query</button>
			</div>
		</form>
	</div>
	<div class="container" style="width: 100%">
	    <table id="issueList-table">
	    </table>
	</div>
</body>
</html>