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
<script src="${basePath}/js/plugins/bootstrap-table/locale/bootstrap-table-zh-CN.min.js"></script>
<script src="${basePath}/js/plugins/bootstrap-table/bootstrap-table-export.js"></script>
<script src="${basePath}/js/plugins/bootstrap-table/tableExport.js"></script>
<script src="${basePath}/js/plugins/sweetalert/sweetalert.min.js"></script>
<script src="${basePath}/js/plugins/layer/layer.min.js"></script>
<script src="${basePath}/js/plugins/layer/laydate/laydate.js"></script>
<script src="${basePath}/js/cncp/common.js"></script>
<script src="${basePath}/views/issue/js/issueList_zh.js"></script>
<title>期次查询列表</title>
<script type="text/javascript">
 var map1 = '${issueStatus}';
 
</script>
</head>
<body>
	<div class="row base-margin" id="query">
		<ol class="breadcrumb">
			<li><strong><span style="color: #27a0d7">期次查询</span></strong></li>
		</ol>
		<form class="form-inline" role="form" style="float: left; width: 100%;margin-bottom:0;" method="post" id="queryForm">
			
			<div class="form-group">
				<label>游戏期号:</label> 
				<input type="text" class="form-control" name="issueNumber" id="issueNumber"  placeholder="请输入游戏期号">
			</div>
			
			<div class="form-group">
				<label for="gameCode">游戏名称:</label> 
				<select class="form-control" id="gameCode" name="gameCode">	
					<option value="">--全部--</option>
					<c:forEach var="data" items="${gameList}">
						<option value="${data.gameCode }">${data.gameName }</option>
					</c:forEach>
				</select>
			</div>
			<div class="form-group">
				<label for="issueStatus">期次状态:</label> 
				<select class="form-control" id="issueStatus" name="issueStatus">	
					<option value="">--全部--</option>
					<c:forEach var="item" items="${issueStatus }">
						<option value="${item.key }">${item.value }</option>
					</c:forEach>
				</select>
			</div>
			<!-- <div class="form-group">
				<label for="issueStatus">期次状态:</label> 
				<select class="form-control" id="issueStatus" name="issueStatus">	
					<option value="">默认选择</option>
					<option value="0">预售</option>
					<option value="1">开启</option>
					<option value="2">暂停</option>
					<option value="3">关闭</option>
					<option value="4">开奖</option>
					<option value="5">期结</option>
				</select>
			</div> -->
			<div class="form-group">
				<label >日期:</label>
				<input placeholder="日期" class="form-control layer-date" id="startSaleTime" name="startSaleTime">
			</div>
			<div class="form-group">
				<button type="button" id="queryBtn" onclick="doQuery();" class="btn btn-primary">查询</button>
			</div>
		</form>
	</div>
	<div class="container" style="width: 100%">
	    <table id="issueList-table">
	    </table>
	</div>
</body>
</html>