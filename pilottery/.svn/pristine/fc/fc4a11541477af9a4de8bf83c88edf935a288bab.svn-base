<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>退票信息</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />

<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<link type="text/css" rel="stylesheet" href="${basePath}/views/oms/game-draw/css/myStyle.css" />
<script type="text/javascript" src="${basePath}/views/oms/game-draw/js/myJs.js"></script>
<script type="text/javascript">
function doSubmit() {
 
     document.refundForm.submit();
}

</script>
</head>

<body>
<form:form modelAttribute="refundForm" action="refundquery.do?method=refunInfoPrintInit" method="post" id="refundForm" name="refundForm">
<form:hidden path="reqtsn"/>
 
<div id="title">中心退票 </div>
<div id="mainDiv">
    <div class="jdt" style="background: url(views/oms/game-draw/img/zxtpbj-2.png) no-repeat left top;">
    </div>
    <div class="xd">
        <span >1.退票</span>
        <span class="zi">2.退票信息</span>
        <span>3.打印退票信息</span>
    </div>
    <div class="CPage">
        <table width="900" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td width="820" align="left" valign="middle">
                    <div class="tab">
                    <c:choose>
                    <c:when test="${status==0}">
                        <table border="1" cellpadding="0" cellspacing="0" height="100%" width="100%">
                            <tr>
                                <td colspan="6" class="tit">
                                    <span style="font-size: 24px;">2.退票信息</span>
                                </td>
                                 			
                            </tr>
                       		<tr height="55px">
                                <td align="right"><img src="<%=request.getContextPath() %>/img/happy1.png" width="45" height="45" /></td>
                                <td colspan="5" valign="top"><span style="font-size:16px;">恭喜退票成功！</span><br/>
                                <span style="color:#000">退票销售站：${refundForm.cancelAgencyCodeFormat}<br/>  
									退票时间：${currdatetime}<br/>
									彩票票号：${refundForm.reqtsn}<br/>
									游戏名称：${refundForm.gameName}<br/>
									游戏期号：${refundForm.issuenumber}<br/>
									销售金额：<fmt:formatNumber value="${refundForm.cancelamount}" pattern="#,###"/></span>
                                 </td>
                            </tr>
                           
							<tr></tr>
                        </table>
  						</c:when>
  						 <c:otherwise>
                        <table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%;">
	                        <tr>
	                            <td class="tit">
	                                <span style="font-size: 24px;">2. 退票信息</span>
	                            </td>
	                        </tr>
	                        <tr height="90">
	                            <td align="center">
	                                <img id="p_img" src="<%=request.getContextPath() %>/img/kul.png" width="120" height="120" style="margin-top:50px;"/>
	                            </td>
	                        </tr>
	                        <tr>
	                            <td align="center" height="80">
	                                <span id="msg" style="color: red">${reservedSuccessMsg}</span>
	                            </td>
	                        </tr>
	                        <tr><td></td></tr>
                        </table>
                           </c:otherwise>
                         </c:choose>	 
                    </div>

                </td>
                <td align="right">
                 <c:if test="${status==0}">
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