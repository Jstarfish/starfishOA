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
<span class="print" onclick="exportPdf()"><a href="#">Print</a></span>
</div>
<div id="printDiv">
<table width="900" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
        <td align="center" valign="top">&nbsp; </td>
    </tr>
    <tr>
        <td align="center" valign="top">
            <h1>National Sports Lottery "${gameDrawInfo.shortName }" Sales Report</h1>
            <br/>
            <h1>Issue${gameDrawInfo.issueNumber }</h1>
        </td>
    </tr>
    <tr><td>&nbsp;</td></tr>
    <tr>
        <td height="126" valign="top">
            <table width="460" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td align="right">
                        <table width="460" border="0" cellspacing="0" cellpadding="0">
                            <tr><td align="left"> <h2>Sales Amount:&nbsp;</h2></td>
                                <td align="right"><h2><fmt:formatNumber value="${areaSaleXml.s_amount }" pattern="#,###"/></h2></td>
                                <td align="right"><h2>&nbsp;riels</h2></td>
                            </tr>
                            <tr>
                                <td align="left"><h2>Sales Income:&nbsp;</h2></td>
                                <td align="right"><h2><fmt:formatNumber value="${areaSaleXml.s_amount_r }" pattern="#,###"/></h2></td>
                                <td align="right"><h2>&nbsp;riels</h2></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td valign="top"><h2>The data have been sealed and recorded by disc. Lottery drawing can be conducted.</h2></td></tr>
    <tr><td>&nbsp;</td></tr>
    <tr><td>&nbsp;</td></tr>
    <tr><td>&nbsp;</td></tr>
    <tr><td>&nbsp;</td></tr>

    <tr><td colspan="3" align="left"><h2>Report Person:&nbsp;</h2></td></tr>
    <tr><td align="left"><h2>Auditor:&nbsp;</h2></td></tr>
    <tr><td align="left"><h2>Contact Phone:&nbsp;</h2></td></tr>

    <tr><td>&nbsp;</td></tr>
    <tr><td>&nbsp;</td></tr>
    <tr><td>&nbsp;</td></tr>
    <tr>
        <td align="right" colspan="3">
			<h2>Technical Department, National Sports Lottery Ltd.</h2>
			<h2>${gameDrawInfo.realColseTime }</h2>
        </td>
    </tr>
</table>
</div>
</body>
</html>