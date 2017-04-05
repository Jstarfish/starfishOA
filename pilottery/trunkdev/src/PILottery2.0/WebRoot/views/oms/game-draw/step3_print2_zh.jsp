<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title></title>
<link type="text/css" rel="stylesheet" href="${basePath}/views/oms/game-draw/css/printStyle.css" />

<script type="text/javascript">

function exportPdf() {
    //var html = document.documentElement.outerHTML;
    var html = printDiv.innerHTML;

    var input1 = document.createElement("input");
    input1.type = "hidden";
    input1.name = "htmlStr";
    input1.value = encodeURIComponent(html);

    var form1 = document.createElement("form");
    form1.appendChild(input1);
    //document.body.appendChild(form1);
    form1.action = "export.do";
    form1.method="post";
    form1.submit();

}


</script>

</head>

<body class="body">
<div style="height:30px;">
<span class="print" onclick="exportPdf()"><a href="#">打印</a></span>
</div>
<div id="printDiv">
<table width="900" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
        <td align="center" valign="top">&nbsp; </td>
    </tr>
    <tr>
        <td align="center" valign="top">
            <h1>国家体育彩票“${gameDrawInfo.shortName }”销售报告单</h1>
            <br/>
            <h1>第${gameDrawInfo.issueNumber }期</h1>
        </td>
    </tr>
    <tr><td>&nbsp;</td></tr>
    <tr>
        <td height="126" valign="top">
            <table width="460" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td align="right">
                        <table width="460" border="0" cellspacing="0" cellpadding="0">
                            <tr><td align="left"> <h2>销售额：</h2></td>
                                <td align="right"><h2><fmt:formatNumber value="${areaSaleXml.s_amount }" pattern="#,###"/></h2></td>
                                <td align="right"><h2>瑞尔</h2></td>
                            </tr>
                            <tr>
                                <td align="left"><h2>销售收入：</h2></td>
                                <td align="right"><h2><fmt:formatNumber value="${areaSaleXml.s_amount_r }" pattern="#,###"/></h2></td>
                                <td align="right"><h2>瑞尔</h2></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td valign="top"><h2>数据已封存并刻录光盘，可以开奖</h2></td></tr>
    <tr><td>&nbsp;</td></tr>
    <tr><td>&nbsp;</td></tr>
    <tr><td>&nbsp;</td></tr>
    <tr><td>&nbsp;</td></tr>

    <tr><td colspan="3" align="left"><h2>报告人：</h2></td></tr>
    <tr><td align="left"><h2>审核人：</h2></td></tr>
    <tr><td align="left"><h2>联系电话：</h2></td></tr>

    <tr><td>&nbsp;</td></tr>
    <tr><td>&nbsp;</td></tr>
    <tr><td>&nbsp;</td></tr>
    <tr>
        <td align="right" colspan="3">
			<h2>国家体育彩票公司技术部</h2>
			<h2>${gameDrawInfo.realColseTime }</h2>
        </td>
    </tr>
</table>
</div>
</body>
</html>