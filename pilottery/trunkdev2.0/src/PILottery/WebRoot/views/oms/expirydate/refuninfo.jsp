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
<form action="refundquery.do?method=refunInfoPrintInit" method="post" id="refundForm" name="refundForm">
<input type="hidden" name="reqtsn" id="reqtsn" value="${refundForm.reqtsn }"> 
 
<div id="title">Refund at Center </div>
<div id="mainDiv">
    <div class="jdt" style="background: url(views/oms/game-draw/img/zxtpbj-2.png) no-repeat left top;">
    </div>
    <div class="xd">
        <span style="margin-left: 20px;">1.Refund</span>
        <span class="zi" style="margin-left: 60px;">2.Refund Information</span>
        <span style="margin-left: 40px;">3.Print Refund Information</span>
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
                                    <span style="font-size: 24px;">2.Refund Information</span>
                                </td>
                                 			
                            </tr>
                       		<tr height="80px">
                                <td colspan="6" valign="top">
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td style="text-align: right;height: 30px;width: 150px" class="lz">Refund Outlet：</td>
                                            <td style="text-align: left;height: 30px">${refundForm.cancelAgencyCodeFormat}</td>
                                        </tr>
                                        <tr>
                                            <td style="text-align: right;height: 30px;width: 150px" class="lz">Refund Time：</td>
                                            <td style="text-align: left;height: 30px">${currdatetime}</td>
                                        </tr>
                                        <tr>
                                            <td style="text-align: right;height: 30px;width: 150px" class="lz">Ticket No.：</td>
                                            <td style="text-align: left;height: 30px">${refundForm.reqtsn}</td>
                                        </tr>
                                        <tr>
                                            <td style="text-align: right;height: 30px;width: 150px" class="lz">Game：</td>
                                            <td style="text-align: left;height: 30px">${refundForm.gameName}</td>
                                        </tr>
                                        <tr>
                                            <td style="text-align: right;height: 30px;width: 150px" class="lz">Issue Number：</td>
                                            <td style="text-align: left;height: 30px">${refundForm.issuenumber}</td>
                                        </tr>
                                        <tr>
                                            <td style="text-align: right;height: 30px;width: 150px" class="lz">Amount：</td>
                                            <td style="text-align: left;height: 30px"><fmt:formatNumber value="${refundForm.cancelamount}" pattern="#,###"/></td>
                                        </tr>
                                    </table>
                   <%-- <span style="color:#000">Refund Outlet：${refundForm.cancelAgencyCodeFormat}<br/>
									Refund Time：${currdatetime}<br/>
									Ticket No.：${refundForm.reqtsn}<br/>
									Game：${refundForm.gameName}<br/>
									Issue Number：${refundForm.issuenumber}<br/>
									Amount：<fmt:formatNumber value="${refundForm.cancelamount}" pattern="#,###"/></span>--%>
                                 </td>
                            </tr>
                           
							<tr></tr>
                        </table>
  						</c:when>
  						 <c:otherwise>
                        <table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%;">
	                        <tr>
	                            <td class="tit">
	                                <span style="font-size: 24px;">2. Refund Information</span>
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
                    <img id="nextBtn" onclick="doSubmit()" src="views/oms/game-draw/img/right-hover.png" alt="Next"/>
                     </c:if>
                </td>
            </tr>
            <tr height="60"></tr>
        </table>
    </div>

</div>

</form>
</body>
</html>