<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>List of Top Ups</title>
<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" charset="UTF-8">
	function topUps() {
		//showBox('topUps.do?method=initTopUps', 'Top Ups', 320,600);
		showBoxRefresh('topUps.do?method=initTopUps', 'Top Ups', 320,650);
	}
	
	function updateQuery(){
	    $("#topUpsForm").submit();
	}
	function print(obj){
		showPage('topUps.do?method=certificate&fundNo=' + obj,'Print');
	} 
	
</script>
</head>
<body>
	<!-- 充值查询 -->
	<div id="title">Top Up Records</div>
	<div class="queryDiv">
		<form action="topUps.do?method=listTopUps" id="topUpsForm"
			method="post">
			<div class="left">
				<%-- <span>Name: 
				<select name="aoCode" class="select-normal" id="aoCode" style="width: 200px"> 
				<option value="">Please select</option>
						<c:forEach items="${orgsMap}" var="orgInfo">
							<option value="${orgInfo.key}">${orgInfo.value}</option>
						</c:forEach>
				</select> 
				</span>  --%>
				
				<span>Date: <input id="operTime" name="operTime" readonly="readonly"
					class="Wdate text-normal"
					onfocus="WdatePicker({lang:'en',dateFmt:'yyyy-MM-dd',readOnly:true})" value="${topUpsForm.operTime }" />
				</span> <input type="button" value="Query" onclick="updateQuery();" class="button-normal"></input>
			</div>
			
			<div class="right">
				<table width="260" border="0" cellspacing="0" cellpadding="0">
					<tr style="height: 50px; line-height: 50px">
						<td align="right">
						 <c:if test="${topUpsForm.aoCode == '00'}"> 
							<input type="button" value="Top Up"
									onclick="topUps();" class="button-normal">
							</input>
						 </c:if> 
						</td>
					</tr>
				</table>
			</div>
		</form>
	</div>
	<div id="headDiv">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<table class="datatable">
						<tr class="headRow">
							<td style="width:10px;">&nbsp;</td>
							<td style="width: 12%">Instiution Code</td>
							<th width="1%">|</th>
							<td style="width: 12%">Institution Name</td>
							<th width="1%">|</th>
							<td style="width: 15%">Date</td>
							<th width="1%">|</th>
							<td style="width: 12%">Top Up Amount(riels)</td>
							<th width="1%">|</th>
							<td style="width: 15%">Balance after Top Up(riels)</td>
							<th width="1%">|</th>
							<td style="width: 15%">operator</td>
							<th width="1%">|</th>
							<td style="width:*%">Operation</td>
						</tr>
					</table>
				</td>
				<td style="width: 17px; background: #2aa1d9"></td>
			</tr>
		</table>
	</div>
	<div id="bodyDiv">
		<table class="datatable">
			<c:forEach var="obj" items="${pageDataList}" varStatus="status">
				<tr class="dataRow">
					<td style="width:10px;">&nbsp;</td>
					<td style="width: 12%">${obj.aoCode}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 12%" title="${obj.aoName }">${obj.aoName}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 15%"><fmt:formatDate value="${obj.operTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
					<td width="1%">&nbsp;</td>
					<td style="width: 12%;text-align:right"><fmt:formatNumber value="${obj.operAmount}" /></td>
					<td width="1%">&nbsp;</td>
					<td style="width: 15%;text-align:right"><fmt:formatNumber value="${obj.afterBalance}" /></td>
					<td width="1%">&nbsp;</td>
					<td style="width: 15%" title="${obj.realName}">${obj.realName}</td>
					<td width="1%">&nbsp;</td>
					<td style="width:*%">
					<span><a href="#" onclick="print('${obj.fundNo}')">Print</a></span>
				</tr>
			</c:forEach>
		</table>
		${pageStr}
	</div>
</body>
</html>