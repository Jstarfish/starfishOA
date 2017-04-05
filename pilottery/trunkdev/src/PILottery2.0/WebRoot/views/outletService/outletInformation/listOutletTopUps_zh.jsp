<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>站点列表</title>
<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" charset="UTF-8">
	function topUps(obj) {
		showBoxRefresh('outletInfo.do?method=initOutletTopUps&agencyCode=' + obj,'充值',300,650);
	}
	function withdrawn(obj){
		showBox('outletInfo.do?method=initOutletWithdrawn&agencyCode=' + obj,'提现',300,650);
	}
	/* function print(obj){
		showPage('outletInfo.do?method=certificate&funfNo=' + obj,'Print');
	} */
	
	function doCancel(url) {
		$.ajax({
			url : url,
			dataType : "",
			async : false,
			success : function(result) {
				if (result != '' && result != null) {
					closeDialog();
					showError(decodeURI(result));
				} else {
					window.location.reload();
				}
			}
		});
	};
</script>
</head>
<body>
	<!-- 充值查询 -->
	<div id="title">站点列表</div>
	<div class="queryDiv">
		<form action="outletInfo.do?method=listOutletInfo" id="OutletTopUpsForm" method="post">
            <div class="left">
                <span>站点编号: <input id="agencyCode" name="agencyCode" value="${outletTopUpsForm.agencyCode}" class="text-normal" maxlength="8"/></span>
                <input type="submit" value="查询" class="button-normal"></input>
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
							<td style="width: 12%">站点编号</td>
							<th width="1%">|</th>
							<td style="width: 12%">站点名称</td>
							<th width="1%">|</th>
							<td style="width: 12%">负责人</td>
							<th width="1%">|</th>
							<td style="width: 12%">电话</td>
							<th width="1%">|</th>
							<td style="width: 12%">信用额度(瑞尔)</td>
							<th width="1%">|</th>
							<td style="width: 12%">账户余额(瑞尔)</td>
							<th width="1%">|</th>
							<td style="width:*%">操作</td>
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
					<td style="width: 12%">${obj.agencyCode}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 12%" title="${obj.agencyName}">${obj.agencyName}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 12%">${obj.contactPerson}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 12%">${obj.telephone}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 12% ;text-align:right"><fmt:formatNumber value="${obj.creditLimit}"/></td>
					<td width="1%">&nbsp;</td>
					<td style="width: 12%;text-align:right"><fmt:formatNumber value="${obj.accountBalance}"/></td>
					<td width="1%">&nbsp;</td>
					<td style="width:*%">
	                    <span><a href="#" onclick="topUps('${obj.agencyCode}')">充值</a></span>
	                    |
	                    <span><a href="#" onclick="withdrawn('${obj.agencyCode}')">提现</a></span> 
                	</td>
				</tr>
			</c:forEach>
		</table>
		${pageStr}
	</div>
</body>
</html>