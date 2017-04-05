<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>游戏开奖</title>
<%@ include file="/views/common/meta.jsp" %>

<link type="text/css" rel="stylesheet" href="${basePath}/views/oms/game-draw/css/myStyle.css" />
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>

<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<style type="text/css">
.ul1{
	font-size:14px;
	line-height:35px;
}
.ul1 li{
    margin-top: 20px;
}

.p_span {
	height: 20px;
	line-height: 20px;
	margin-top: 3px;
	margin-right: 20%;
	float:right;
}
#title a {
    font-size: 14px;
    color:#2aa1d9;
    text-decoration: blink;
	float: right;
}
#title a:hover {
    text-decoration: underline;
}
#exportPdf{

    line-height:40px;
}

.td-head {
    border: 1px;
    border-style:solid;
    background:lightgray;
}
.td-body{
    border: 1px;
    border-style:solid;
    padding-left:10px;
}
</style>


<script type="text/javascript">

function myPrint(id){
    var newWindow=window.open('打印窗口',"_blank");//打印窗口要换成页面的url
    var docStr = findObj(id).innerHTML;
    newWindow.document.write(docStr);
    newWindow.document.close();
    newWindow.print();
    newWindow.close();
}

</script>

</head>
<body onload="">

<div id="title">
    开奖公告
	<span class="print p_span" onclick="exportPdf()">
	    <a href="#">打印</a>
	</span>

    <!--<er:exportReport url="${pageContext.request.contextPath }/er/exportReportServlet"  classs="icon-lz"types="pdf" tableId="exportPdf"  title="exportPdf"></er:exportReport>
 -->
</div>

<div id="mainDiv"style="background-color:white;">
    <div style="width:900px;margin-left:auto;margin-right:auto;">
    <table id="exportPdf" width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr><td colspan="3">
	    <div style="height:120px;font-size:24px;line-height:35px;text-align:center;">
		    柬埔寨国家彩票[${gameDrawInfo.shortName }] 
		    开奖公告<br/>
		    第${gameDrawInfo.issueNumber}期
	    </div>
	    </td></tr>

        <tr><td colspan="3">
	       一丶本期销售额：${drawNotice.saleAmount} KHR
	    </td></tr>
	    <tr><td colspan="3">
	       二丶中奖号码：${drawNotice.codeResult }
	    </td></tr>
        <tr><td colspan="3">
	       三丶中奖结果：
	    </td></tr>
        <tr>
	       <td class="td-head" align="center">奖等</td>
	       <td class="td-head" align="center">中奖注数</td>
	       <td class="td-head" align="center">中奖金额</td>
	    </tr>
		<c:forEach items="${drawNotice.lotteryDetails}" var="item">
		    <tr>
		        <td class="td-body">${item.prizeLevel}</td>
		        <td class="td-body">${item.betCount}</td>
		        <td class="td-body">${item.awardAmount}</td>
		    </tr>
		</c:forEach>

        <tr><td colspan="3">
            四丶奖池累计金额：${drawNotice.poolScroll }
        </td></tr>
        <tr><td colspan="3">
            五丶&lt;高等奖&gt;中奖情况：
        </td></tr>
        <tr><td colspan="3" style="padding-left:80px;">
            <c:forEach items="${drawNotice.highPrizeAreas}" var="item">
                <span>&lt;${item.areaName }&gt;
                <c:forEach items="${item.areaLotteryDetails}" var="subitem">
                    <span>${subitem.prizeLevel }：${subitem.betCount }注</span>
                </c:forEach>; 
                </span>
            </c:forEach>
        </td></tr>
        <tr><td colspan="3">
            六丶咨询电话：
            <div style="margin-left:80px;">
	            -<br/>
	            -<br/>
	            <br/>
            </div>

	   </td></tr>
       <tr><td colspan="3" style="padding-left:80px;">
            开奖值班员：
       </td></tr>
       <tr><td colspan="3"><div style="width:100%;height:80px;">&nbsp;</div></td></tr>
        </table>
    </div>

</div>

</body>
</html>
