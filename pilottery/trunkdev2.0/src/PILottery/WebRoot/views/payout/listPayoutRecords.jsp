<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>List of Payout Records</title>

<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css"
	type="text/css" />

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
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
	<div id="title">Payout Records</div>

	<!-- 查询条件块 -->
	<div class="queryDiv">
		<form action="payout.do?method=listPayout" id="queryForm" method="POST">
			<div class="left">
				<span>Institution:
            		<select class="select-big" name="insCode" >
            			<option value="">--All--</option>
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
				<span>Plan: <select name="planCode" class="select-big">
						<option value="">--Please Select--</option>
						<c:forEach var="obj" items="${planList}" varStatus="plan">
							<c:if test="${obj.planCode == form.planCode}">
								<option value="${obj.planCode}" selected="selected">${obj.planName}</option>
							</c:if>
							<c:if test="${obj.planCode != form.planCode}">
								<option value="${obj.planCode}">${obj.planName}</option>
							</c:if>
						</c:forEach>
				</select> Date: <input id="payoutDateQuery" name="payoutDateQuery" class="Wdate text-normal"
					onfocus="WdatePicker({lang:'en',dateFmt:'yyyy-MM-dd',readOnly:true})"
					value="${form.payoutDateQuery }" />
				</span> <input type="button" value="Query" onclick="updateQuery();"
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
							<td style="width: 8%">Record No</td>
							<th width="1%">|</th>
							<td style="width: 12%">Name of Winner</td>
							<th width="1%">|</th>
							<td style="width: 12%">Contact of Winner</td>
							<th width="1%">|</th>
							<td style="width: 12%">Personal ID</td>
							<th width="1%">|</th>
							<td style="width: 12%">Winning Amount(riels)</td>
							<th width="1%">|</th>
							<td style="width: 10%">Plan Name</td>
							<th width="1%">|</th>
							<td style="width: 10%">Date of Payout</td>
							<th width="1%">|</th>
							<td style="width: *%">Operation</td>
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
							onclick="showBox('payout.do?method=payoutDetail&recordNo=${item.payNo}','Payout Details',450,800)">Details</a>
					</span>|
					<span><a href="#" onclick="showPage('payout.do?method=print&recordNo=${item.payNo}','Print')">Print</a></span>
					</td>
				</tr>
			</c:forEach>
		</table>
		${pageStr}
	</div>
</body>
</html>
