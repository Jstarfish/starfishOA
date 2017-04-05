<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title></title>
<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript">
function submit(){
	$("#fundManagementForm").submit();
}
</script>
</head>
<body>
<div id="title">Issuance Fee Management</div>
<div class="queryDiv">
	<form:form modelAttribute="fundManagementForm" action="fundManagement.do?method=govCommision">
      	<div class="left">
		  	<span>Game:
		   	 	<form:select path="governmentCommision.gameCode"  class="select-normal">
					<c:forEach items="${games}" var="s">
						<form:option value="${s.gameCode}">${s.shortName}</form:option>
					</c:forEach>
				</form:select>
		    </span>
		    <span>Date:
		   	 	<form:input id="str_adjTime1" path="str_adjTime1" class="Wdate text-normal" onfocus="WdatePicker({lang:'en',dateFmt:'yyyy-MM-dd',readOnly:true,isShowClear:true,maxDate:\"#F{$dp.$D('str_adjTime2')}\"})"/> -
		   	 	<form:input id="str_adjTime2" path="str_adjTime2" class="Wdate text-normal" onfocus="WdatePicker({lang:'en',dateFmt:'yyyy-MM-dd',readOnly:true,isShowClear:true,minDate:\"#F{$dp.$D('str_adjTime1')}\"})"/>
		    </span>
		    <a href="#" onclick="submit();"><button class="button-normal">Query</button></a>
		</div>
	</form:form>
</div>
<div id="headDiv">
	<table width="100%"  border="0" cellpadding="0" cellspacing="0">
		<tr><td>
			<table class="datatable">
				<tr class="headRow">
					<td style="width:10px;">&nbsp;</td>
					<td>Item No.</td>
					<td width="1%">|</td>
                    <td>Game</td>
                    <td width="1%">|</td>
                    <td>Issue</td>
                    <td width="1%">|</td>
                    <td>Adjustment Type</td>
                    <td width="1%">|</td>
                    <td>Adjusting Amount</td>
                    <td width="1%">|</td>
                    <td>Before Adjustment</td>
                    <td width="1%">|</td>
                    <td>After Adjustment</td>
                    <td width="1%">|</td>
                    <td>Adjustment Time</td>
                    <td width="1%">|</td>
                    <td>Remarks</td>
				</tr>
			</table>
		</td><td style="width:17px;background:#2aa1d9"></td></tr>
    </table>
</div>
<div id="bodyDiv">
    <table class="datatable">
    	<c:forEach var="row" items="${pageDataList}">
        <tr class="dataRow">
        	<td style="width:10px;">&nbsp;</td>
        	<td>${row.hisCode}</td>
        	<td width="1%">&nbsp;</td>
        	<td>${gameInfoMap[row.gameCode]}</td>
        	<td width="1%">&nbsp;</td>
        	<td>${row.issueNumber}</td>
        	<td width="1%">&nbsp;</td>
        	<td>
        		<c:if test="${row.commChangeType==1}">From Drawing</c:if>
				<c:if test="${row.commChangeType==2}">To Pool</c:if>
				<c:if test="${row.commChangeType==3}">To Adjustment Fund</c:if>
			</td>
			<td width="1%">&nbsp;</td>
        	<td align="right"><fmt:formatNumber type="number" value="${row.adjAmount}" /></td>
        	<td width="1%">&nbsp;</td>
        	<td align="right"><fmt:formatNumber type="number" value="${row.adjAmountBefore}" /></td>
        	<td width="1%">&nbsp;</td>
        	<td align="right"><fmt:formatNumber type="number" value="${row.adjAmountAfter}" /></td>
        	<td width="1%">&nbsp;</td>
        	<td><fmt:formatDate value="${row.adjTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
        	<td width="1%">&nbsp;</td>
        	<td>${row.adjReason}</td>
        </tr>
        </c:forEach>
    </table>
    ${pageStr }
</div>
</body>
</html>
