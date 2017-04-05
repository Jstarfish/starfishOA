<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>

<html>
<head>
<title>游戏开奖</title>
<link type="text/css" rel="stylesheet" href="${basePath}/views/oms/game-draw/css/myStyle.css" />
<script type="text/javascript" src="${basePath}/views/oms/game-draw/js/myJs.js"></script>

<style type="text/css">

</style>
<script type="text/javascript">
<c:if test="${not empty reservedSuccessMsg}">
alert("${reservedSuccessMsg}");
</c:if>

function doSubmit() {

	
     document.expirydateForm.submit();


}

</script>
</head>

<body>
<form:form modelAttribute="expirydateForm" action="centerSelect.do?method=printinit" method="post" id="expirydateForm" name="expirydateForm">
 <input type="hidden" name="carId" value="${info.id}"/>
<div id="title">中心兑奖 </div>
<div id="mainDiv">
    <div class="jdt" style="background: url(views/oms/game-draw/img/zxdjbj-3.png) no-repeat left top;">
    </div>
    <div class="xd" style="width:650px">
          	<span >1.查询</span>
        	<span >2.中奖录入数据</span>
        	<span class="zi">3.中奖信息</span>
    		<span>4.打印兑奖单</span>
    </div>
    <div class="CPage">
        <table width="900" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td width="820" align="left" valign="middle">
                    <div class="tab">
                    <c:choose>
                    <c:when test="${status==0 && winningamount>0}">
                        <table border="1" cellpadding="0" cellspacing="0" height="100%" width="100%">
                            <tr>
                                <td colspan="6" class="tit">
                                    <span style="font-size: 24px;">3.中奖信息</span>
                                </td>
                                 			
                            </tr>
                       		<tr height="55px">
                                <td align="right"><img src="<%=request.getContextPath() %>/img/happy1.png" width="45" height="45" /></td>
                                <td colspan="5" valign="top"><span style="font-size:16px;">恭喜中奖！</span><br/><span style="color:#000">游戏名称：${info.playname} | 游戏期号：${info.issueNumber } | 票号：${info.saleTsn }</span>  </td>
                            </tr>
                            <c:if test="${not empty lotteryReq.prizeDetail}">
                            <tr class="biaot">
								<th>中奖等级</th>
								<th>中奖注数</th>
								<th>单注金额</th>
								<th>总中奖金额</th>
								<th>个人所得税(20%)元</th>
								<th>实际奖金（元）</th>
							</tr>
							<c:forEach var="prize" items="${lotteryReq.prizeDetail}">
							<tr class="jjzi">
								<td class="tabxian-td">${prize.name }</td>
								<td class="tabxian-td">${prize.prizeCode }</td>
								<td class="tabxian-td"><fmt:formatNumber value="${prize.amountSingle}" pattern="#,###"/></td>
								<td class="tabxian-td"><fmt:formatNumber value="${prize.amountBeforeTax}" pattern="#,###"/></td>
								<td class="tabxian-td"><fmt:formatNumber value="${prize.amountTax}" pattern="#,###"/></td>
								<td class="tabxian-td"><fmt:formatNumber value="${prize.amountAfterTax}" pattern="#,###"/></td>
							</tr>
							</c:forEach>
							 </c:if>
							<tr></tr>
                        </table>
  						</c:when>
  						
                         </c:choose>	 
                    </div>

                </td>
                <td align="right">
                 <c:if test="${status==0 && winningamount>0}">
                    <img id="nextBtn" onclick="doSubmit()" src="views/oms/game-draw/img/right-hover.png" alt="下一步"/>
                     </c:if>
                </td>
            </tr>
            <tr height="60"></tr>
        </table>
    </div>

</div>

</form:form>
</body>
</html>