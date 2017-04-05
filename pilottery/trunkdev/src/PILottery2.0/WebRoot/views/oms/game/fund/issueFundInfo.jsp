<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title></title>
<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript">
function submit(){
	$("#fundManagementForm").submit();
}
</script>
</head>
<body>
<div id="title">Adjustment Fund by Issue</div>
<div class="queryDiv">
	<form:form modelAttribute="fundManagementForm" action="fundManagement.do?method=issueFundInfo">
		<div class="cx">
		  <div class="tj">
		  	<span>Game:
		   	 	<form:select path="fundAdjHistoryVo.gameCode"  class="select-normal">
					<c:forEach items="${games}" var="s">
						<form:option value="${s.gameCode}">${s.shortName}</form:option>
					</c:forEach>
				</form:select>
		    </span>
		    <span>Issue:
		    	<form:input path="beginIssue" maxlength="12" onblur="value=value.replace(/[^0-9]/g,'')" class="text-normal"/> - 
		    	<form:input path="fundAdjHistoryVo.issueNumber" maxlength="12" onblur="value=value.replace(/[^0-9]/g,'')" class="text-normal"/>
		    </span> 
		    <a href="#" onclick="submit();"><button class="button-normal">Query</button></a>
	      </div>
		</div>
	</form:form>
</div>
<div id="headDiv">
	<table width="100%"  border="0" cellpadding="0" cellspacing="0">
		<tr><td>
			<table class="datatable">
				<tr class="headRow">
					<td style="width:10px;">&nbsp;</td>
					<td>Issue</td>
					<td width="1%">|</td>
                    <td>Draw Time </td>
                    <td width="1%">|</td>
                    <td>Start-of-Issue Amount</td>
                    <td width="1%">|</td>
                    <td>End-of-Issue Amount</td>
                    <td width="1%">|</td>
                    <td>Adjusting Amount</td>
				</tr>
			</table>
		<td style="width:17px;background:#2aa1d9;"></td></tr>
	</table>
</div>
<div id="bodyDiv">
    <table class="datatable">
       	<c:forEach var="row" items="${pageDataList}">
        <tr class="dataRow">
        	<td style="width:10px;">&nbsp;</td>
        	<td>${row.issueNumber}</td>
        	<td width="1%">&nbsp;</td>
        	<td><fmt:formatDate value="${row.realRewardTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
        	<td width="1%">&nbsp;</td>
        	<td align="right"><fmt:formatNumber type="number" value="${row.adjAmountBefore}" /></td>
        	<td width="1%">&nbsp;</td>
        	<td align="right"><fmt:formatNumber type="number" value="${row.adjAmountAfter}" /></td>
        	<td width="1%">&nbsp;</td>
        	<td align="right"><fmt:formatNumber type="number" value="${row.adjAmount}" /></td>
        </tr>
        </c:forEach>
    </table>
    ${pageStr }
</div>
</body>
</html>
