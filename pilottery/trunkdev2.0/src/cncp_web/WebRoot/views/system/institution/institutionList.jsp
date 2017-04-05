<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="/views/common/taglibs.jsp" %>
<%@ include file="/views/common/meta.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>institution List</title>
<%@ include file="/views/common/meta.jsp" %>
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
<script src="${basePath}/views/system/institution/js/institutionList.js"></script>
</head>
<body>
	<div class="row base-margin" id="query">
		<ol class="breadcrumb">
			<li><strong><span style="color: #27a0d7">Institution List</span></strong></li>
		</ol>
		<form class="form-inline" role="form" style="float: left; width: 100%" method="post" id="queryForm">
			<div class="form-group">
				<label for="orgName">Institution Name:</label> 
				<input type="text" class="form-control" name="orgName" id="orgName"  placeholder="Please input institution">
			</div>
			<div class="form-group">
				<label for="orgStatus">Status:</label> 
				<select class="form-control" id="orgStatus" name="orgStatus">	
					<option value="">--All--</option>
					<option value="1">Normal</option>
					<option value="2">Delete</option>
				</select>
			</div>
			
			<div class="form-group">
				<button type="button" id="queryBtn" onclick="doQuery();" class="btn btn-primary">Query</button>
			</div>
			<div class="form-group btn-right">
				<button type="button" class="btn btn-primary" id="addBtn" onclick="addOrg();">New Institution</button>
			</div>
		</form>
	</div>
	<div class="container" style="width: 100%">
	    <table id="institution-table">
	    </table>
	</div>
</body>
</html>