<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>弃奖详细信息</title>
<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" charset="UTF-8">
	function closeCur(){
		window.parent.closeBox();
	}
</script>
<style type="text/css">
	.datatable tr:hover, .datatable tr.hilite {
	    background-color: #2aa1d9;
	    color: #ffffff;
	}
</style>
</head>
<body>
 	<div class="pop-body">
        <table class="datatable">
            <tr class="headRow">
               <!-- 弃奖日期 -->
               <td style="width:20%;">弃奖日期</td>
               <!-- 游戏期号 -->
               <td style="width:20%;">游戏期号</td>
               <!-- 弃奖总注数 -->
               <td style="width:20%;">弃奖总注数</td>
               <!-- 张数 -->
               <!--<td style="width:12%;">张数</td>-->
               <!-- 金额 -->
               <td style="width:20%;">金额</td>
               <!-- 奖等 -->
               <td style="width:*%;">奖等</td>
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
        	<input type="button" class="button-normal" onclick="closeCur()" value="关闭" ></input>
        </span>
    </div>
</body>
</html>
