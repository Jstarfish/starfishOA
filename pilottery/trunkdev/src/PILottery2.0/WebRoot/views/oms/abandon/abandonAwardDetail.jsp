<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>Abandon Details</title>
<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" charset="UTF-8">
	function closeCur(){
		window.parent.closeBox();
	}
</script>
</head>
<body>
 	<div class="pop-body">
        <table class="datatable">
            <tr class="headRow">
               <!-- 弃奖日期 -->
               <td style="width:20%;"><spring:message code="abandon.abandonAwardDate"/></td>
               <!-- 游戏期号 -->
               <td style="width:20%;"><spring:message code="abandon.gameSeries"/></td>
               <!-- 弃奖总注数 -->
               <td style="width:20%;"><spring:message code="abandon.totalNum"/></td>
               <!-- 张数 -->
               <!--<td style="width:12%;"><spring:message code="abandon.ticketNumber"/></td>-->
               <!-- 金额 -->
               <td style="width:20%;"><spring:message code="abandon.money"/></td>
               <!-- 奖等 -->
               <td style="width:*%;"><spring:message code="abandon.numberAward"/></td>
            </tr>
           <c:forEach var="data" items="${abandonWardDetailList}" varStatus="status" >
			<tr class="dataRow">
				<td><fmt:formatDate value="${data.payDate}" pattern="yyyy-MM-dd"/></td>
				<td>${data.issueNumber}</td>
				<td>${data.allBetCount}</td>
				<td><fmt:formatNumber value="${data.allWinningAmountTax}" pattern="#,###"/></td>
				<td>${data.ruleName}</td>
			</tr>
		  </c:forEach>
        </table>
    </div>
    <div class="pop-footer" style="position: inherit;"></div>
	<div class="pop-footer" style="position: fixed; left: 0; right: 0;">
        <span class="right">
        	<input type="button" class="button-normal" onclick="closeCur()" value="<spring:message code='abandon.close'/>" ></input>
        </span>
    </div>
</body>
</html>
