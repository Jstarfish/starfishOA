<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title></title>
<%@ include file="/views/common/meta.jsp" %>
<style type="text/css">

#error_page table {
	margin-left: auto;
	margin-right: auto;
}


.button{
	font-family: "microsoft yahei", "微软雅黑";
	position: relative;
	display: inline-block;
	line-height: 25px;
	padding: 1px 12px;
	transition: all .3s ease-out;
	text-transform: uppercase;
	border: 1px solid #90cd00;
	color: #fff;
	cursor: pointer;
	border-radius: 2px;
	/* -webkit-border-radius: 2px; */
	background-color: #90cd00;
	font-size: 14px;
	outline:none;
}
.button:hover {
	background-color: #9bdb03;
}
</style>

	<script type="text/javascript">

		function doReload(){

			window.parent.location.reload();
		}
	</script>
</head>

<body>
	<div id="error_page">
		<table border="0" cellspacing="0" cellpadding="0" width="600" height="100px" style="background:#fff;padding:40px 0px;margin-top:50px; border:1px solid #f1f1f1;">
		   	<tr>
		   		<td align="right" width="20%">
		   			<img alt="error" src="${basePath}/img/error.png">
		   		</td>
		   		<td align="left" style="padding: 0px 20px 0px 10px;">
	   				<c:if test="${not empty system_message}">没有数据：${system_message}</c:if>
					<c:if test="${empty system_message}">没有可用的数据</c:if>
		   		</td>
		   	</tr>

			<tr>
				<td></td>
				<td style="padding-left:10px;">
					<input type="button" value="确定" class="button" onclick="doReload()"></input>
				</td>
			</tr>
		</table>
	</div>

</body>
</html>