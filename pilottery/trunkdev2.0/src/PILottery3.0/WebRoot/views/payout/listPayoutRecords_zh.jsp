<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>兑奖记录</title>

<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css"
	type="text/css" />

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript"
	src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
	function updateQuery() {
		$("#queryForm").submit();
	}
</script>

</head>
<body>
	<!-- 顶部标题块 -->
	<div id="title">兑奖记录</div>

	<!-- 查询条件块 -->
	<div class="queryDiv">
		<form action="payout.do?method=listPayout" id="queryForm" method="POST">
			<div class="left">
				<span>部门:
            		<select class="select-big" name="insCode" >
            			<option value="">--全部--</option>
                   	   <c:forEach var="obj" items="${institutionList}" varStatus="plan">
                   	   		<c:if test="${obj.institutionCode == form.insCode}">
                   	   			<option value="${obj.institutionCode}" selected="selected">${obj.institutionName}</option>
                   	   		</c:if>
                   	   		<c:if test="${obj.institutionCode != form.insCode}">
                   	   			<option value="${obj.institutionCode}">${obj.institutionName}</option>
                   	   		</c:if>
                   	   </c:forEach>
                    </select>
            	</span>
				<span>方案: <select name="planCode" class="select-big">
						<option value="">--请选择--</option>
						<c:forEach var="obj" items="${planList}" varStatus="plan">
							<c:if test="${obj.planCode == form.planCode}">
								<option value="${obj.planCode}" selected="selected">${obj.planName}</option>
							</c:if>
							<c:if test="${obj.planCode != form.planCode}">
								<option value="${obj.planCode}">${obj.planName}</option>
							</c:if>
						</c:forEach>
				</select> 日期: <input id="payoutDateQuery" name="payoutDateQuery" class="Wdate text-normal"
					onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"
					value="${form.payoutDateQuery }" />
				</span> <input type="button" value="查询" onclick="updateQuery();"
					class="button-normal"></input>
			</div>
		</form>
	</div>

	<!-- 列表表头块 -->
	<div id="headDiv">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<table class="datatable">
						<tr class="headRow">
							<td style="width: 10px;">&nbsp;</td>
							<td style="width: 8%">编号</td>
							<th width="1%">|</th>
							<td style="width: 12%">中奖人姓名</td>
							<th width="1%">|</th>
							<td style="width: 12%">联系方式</td>
							<th width="1%">|</th>
							<td style="width: 12%">身份证号码</td>
							<th width="1%">|</th>
							<td style="width: 12%">中奖金额(瑞尔)</td>
							<th width="1%">|</th>
							<td style="width: 10%">方案名称</td>
							<th width="1%">|</th>
							<td style="width: 10%">兑奖日期</td>
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
			<c:forEach items="${payoutList}" var="item" varStatus="status">
				<tr class="dataRow">
					<td style="width: 10px;">&nbsp;</td>
					<td style="width: 8%" title="${item.payNo}">${item.payNo}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 12%" title="${item.winnerName}">${item.winnerName}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 12%" title="${item.contact}">${item.contact}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 12%" title="${item.personalId}">${item.personalId}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 12%;text-align: right"><fmt:formatNumber value="${item.amount}" /></td>
					<td width="1%">&nbsp;</td>
					<td style="width: 10%">${item.planName}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 10%"><fmt:formatDate value="${item.dateOfPayout}"
							pattern="yyyy-MM-dd HH:mm:ss" /></td>
					<td width="1%">&nbsp;</td>
					<td style="width: *%"><span> <a href="#"
							onclick="showBox('payout.do?method=payoutDetail&recordNo=${item.payNo}','兑奖详情',450,800)">详情</a>
					</span>|
					<span><a href="#" onclick="showPage('payout.do?method=print&recordNo=${item.payNo}','打印')">打印</a></span>
					</td>
				</tr>
			</c:forEach>
		</table>
		${pageStr}
	</div>
</body>
</html>
