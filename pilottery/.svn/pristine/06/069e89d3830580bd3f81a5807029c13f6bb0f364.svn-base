<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>联赛列表</title>

<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css"
	type="text/css" />

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript"
	src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
	function delte(competitionCode) {
		var msg = "你确定要删除吗 ?";
		showDialog("deleteOutlet('" + competitionCode + "')", "删除", msg);
	}
	function deleteOutlet(competitionCode) {

		var url = "league.do?method=deleteLeague&competitionCode=" + competitionCode;

		$
				.ajax({
					url : url,
					type:"POST",
					dataType : "json",
					async : false,
					success : function(r) {
						if (r.message != ''
								&& r.message != null) {
							closeDialog();
							showError(decodeURI(r.message));
						} else {
							closeDialog();
							window.location.reload();
						}
					}
				});

	}
	function updateQuery() {
		$("#planForm").submit();
	}

	$(document).ready(function() {
		$("#planCodeQuery").keydown(function(event) {
			if (event.keyCode == 13) {
				updateQuery();
			}
		});

		$("#planNameQuery").keydown(function(event) {
			if (event.keyCode == 13) {
				updateQuery();
			}
		});

		$("#publisherNameQuery").keydown(function(event) {
			if (event.keyCode == 13) {
				updateQuery();
			}
		});
	});
</script>

</head>
<body>
	<!-- 顶部标题块 -->
	<div id="title">联赛管理</div>

	<!-- 查询条件块 -->
	<div class="queryDiv">
            <div class="right">
                <table width="260" border="0" cellspacing="0" cellpadding="0">
                    <tr style="height:50px;line-height:50px">
                        <td align="right">
                            <input type="button" value="新增联赛"  onclick="showBox('league.do?method=addLeagueInit','新增联赛',300,600);" class="button-normal"></input>
                        </td>
                    </tr>
                </table>
            </div>
    </div>

	<!-- 列表表头块 -->
	<div id="headDiv">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<table class="datatable">
						<tr class="headRow">
							<td style="width: 10px;">&nbsp;</td>
							<td style="width: 20%">联赛编号</td>
							<th width="1%">|</th>
							<td style="width: 20%">联赛简称</td>
							<th width="1%">|</th>
							<td style="width: 20%">联赛全称</td>
							<th width="1%">|</th>
							<td style="width: *%">操作</td>
						</tr>
					</table>
				</td>
				<!-- 表头和下方数据对齐 -->
				<td style="width: 17px; background: #2aa1d9"></td>
			</tr>
		</table>
	</div>

	<!-- 列表内容块 -->
	<div id="bodyDiv">
		<table class="datatable">
			<c:forEach var="data" items="${pageDataList}" varStatus="status">
				<tr class="dataRow">
					<td style="width: 10px;">&nbsp;</td>
					<td style="width: 20%">${data.competitionCode }</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 20%" title="${data.abbr }">${data.abbr }</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 20%" title="${data.name }">${data.name }</td>
					<td width="1%">&nbsp;</td>
					<td style="width: *%">
				<span><a href="#"
					onclick="showBox('league.do?method=editLeagueInit&competitionCode=${data.competitionCode}','编辑','300','600')">编辑</a></span>&nbsp;|
				<span><a href="#" onclick="delte('${data.competitionCode}')">删除</a></span>
					</td>
				</tr>
			</c:forEach>
		</table>
		${pageStr}
	</div>
</body>
</html>
