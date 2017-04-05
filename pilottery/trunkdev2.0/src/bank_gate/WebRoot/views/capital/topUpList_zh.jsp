<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ include file="/views/common/taglibs.jsp" %>
<%@ include file="/views/common/meta.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>充值列表</title>
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
<script src="${basePath}/views/capital/js/topup_zh.js"></script>
</head>
<body>
	<div class="row base-margin" id="query">
		<ol class="breadcrumb">
			<li><strong><span style="color: #27a0d7">充值查询</span></strong></li>
		</ol>
		<form class="form-inline" role="form" style="float: left; width: 100%;margin-bottom:0;" method="post" id="queryForm">
			
			<div class="form-group">
				<label for="userName">账号编码:</label> 
				<input type="text" class="form-control" name="accNo" id="accNo"  placeholder="请输入用户账号">
			</div>
			<div class="form-group">
				<label for="userName">流水号:</label> 
				<input type="text" class="form-control" name="tradeFlow" id="tradeFlow"  placeholder="请输入流水号">
			</div>
			
            <div class="form-group">
				<label >日期:</label>
				<input placeholder="开始日期" class="form-control layer-date" id="startDate" name="startDate">
				<input placeholder="结束日期" class="form-control layer-date" id="endDate" name="endDate">
			</div>
			
			<div class="form-group">
				<label for="tradeStatus">状态:</label> 
				<select class="form-control" id="tradeStatus" name="tradeStatus">	
					<option value="">--全部--</option>
					<option value="1">收到请求</option>
					<option value="3">校验</option>
					<option value="2">登录</option>
					<option value="4">提交</option>
					<option value="5">失败</option>
					<option value="6">超时</option>
				</select>
			</div>
			<div class="form-group">
				<button type="button" id="queryBtn" onclick="doQuery();" class="btn btn-primary">查询</button>
			</div>
			<div class="form-group">
				<button type="reset" id="resetBtn"  class="btn btn-primary">重置</button>
			</div>
		</form>
	</div>
	<div class="container" style="width: 100%">
	    <table id="topuprecords-table">
	    </table>
	</div>
</body>
</html>
