<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>提现记录</title>
<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" charset="UTF-8">
	function delet(fundNo) {
		var msg = "你确定要删除该提现申请吗?";
		showDialog("deleteWithdrawn('"+fundNo+"')","删除",msg);
	}
	function deleteWithdrawn(fundNo) {
		var url = "orgsWithdrawnRecords.do?method=deleteWithdrawn&fundNo="+ fundNo;
				$.ajax({
					url : url,
					dataType : "json",
					async : false,
					success : function(r){
				            if(r.message!='' && r.message!=null){
					            closeDialog();
				            	showError(r.message);
					        }
				            else{
				            	closeDialog();	
				            	window.location.reload(); 
					       }
				}
				});
	}
//ajax执行操作之后 进行刷新
/* 		$.ajax({
			url : url,
			dataType : "json",
			async : false,
			success : function(r) {
				if (r.message != '' && r.message != null) {
					showError(decodeURI(r.message));
				} else {
					window.location.reload();
				}
			}
		});
	}; */

	function cancel(fundNo) {
		var url = "orgsWithdrawnRecords.do?method=cancelWithdrawn&fundNo="
				+ fundNo;
		showDialog("doCancel('" + url + "')", 'Cancel',
				'你确定要取消提现申请 : '
						+ fundNo);
	}
	function doCancel(url) {
		$.ajax({
			url : url,
			dataType : "",
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
	<!-- 提现申请 -->
	<div id="title">提现记录</div>
	<div class="queryDiv">
		<form action="orgsWithdrawnRecords.do?method=listRecords" id="cashWithdrawnForm" method="post">
			<div class="left">
			<%-- 	 <span>Name: <input id="aoName"
					name="aoName" value="${cashWithdrawnForm.aoName}" class="text-big"
					maxlength="10" />
				 </span>  --%>
				
				 <span>日期: <input id="applyDate"
					name="applyDate" class="Wdate text-normal"
					onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true})" value="${cashWithdrawnForm.applyDate }" />
				</span> <input type="submit" value="查询" class="button-normal"></input>
			</div>

			<div class="right">
				<table width="260" border="0" cellspacing="0" cellpadding="0">
					<tr style="height: 50px; line-height: 50px">
						<td align="right"><input type="button" value="提现"
							onclick="showBox('orgsWithdrawnRecords.do?method=addWithdrawnInit', '提现', 300, 650);"
							class="button-normal"></input></td>
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
							<td style="width: 10%">申请单编号</td>
							<th width="1%">|</th>
							<td style="width: 8%">部门编码</td>
							<th width="1%">|</th>
							<td style="width: 10%">部门名称</td>
							<th width="1%">|</th>
							<td style="width: 15%">提现后余额(瑞尔)</td>
							<th width="1%">|</th>
							<td style="width: 15%">提现金额(瑞尔)</td>
							<th width="1%">|</th>
							<td style="width: 12%">提现时间</td>
							<th width="1%">|</th>
							<td style="width: 8%">提现状态</td>
							<th width="1%">|</th>
							<td style="width: *%">操作人</td>
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
					<td style="width: 10%">${obj.fundNo}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 8%">${obj.aoCode}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 10%" title="${obj.aoName}">${obj.aoName}</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 15%;text-align:right">
					<c:choose>
						<c:when test="${obj.afterAccountBalance == 0}">
							--
						</c:when>
						<c:otherwise>
							<fmt:formatNumber value="${obj.afterAccountBalance}" />
						</c:otherwise>
					</c:choose>
					</td>
					<td width="1%">&nbsp;</td>
					<td style="width: 15%;text-align:right"><fmt:formatNumber value="${obj.applyAmount}" /></td>
					<td width="1%">&nbsp;</td>
					<td style="width: 12%"><fmt:formatDate
							value="${obj.applyDate}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
					<td width="1%">&nbsp;</td>
					<td style="width: 8%">${obj.statusValue }</td>
					<td width="1%">&nbsp;</td>
					<td style="width: *%">
					<span> 
						<c:if test="${obj.applyStatus == 1}">
							<a href="#" onclick="cancel('${obj.fundNo}')">取消</a>
						</c:if> 
						<c:if test="${obj.applyStatus != 1 }"> 取消</c:if>
					</span>
					 | 
					<span> 
					<c:if test="${obj.applyStatus == 2}">
						<a href="#" onclick="delet('${obj.fundNo}')">删除</a>
					</c:if> <c:if test="${obj.applyStatus != 2}">删除</c:if>
					</span>
					</td>
				</tr>
			</c:forEach>
		</table>
		${pageStr}
	</div>
</body>
</html>