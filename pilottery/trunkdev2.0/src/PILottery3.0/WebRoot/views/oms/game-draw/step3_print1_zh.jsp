<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>print</title>
<link type="text/css" rel="stylesheet" href="${basePath}/views/oms/game-draw/css/printStyle.css" />

<style type="text/css">

</style>
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
		<td align="center" valign="top" colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td align="center" valign="top" colspan="3">
			<h1>柬埔寨高棉彩池“${gameDrawInfo.shortName }”销售报表</h1>
            <br/>
            <h1>第${gameDrawInfo.issueNumber }期</h1>
		</td>
	</tr>
	<tr>
		<td colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="3"><h2>单位：（瑞尔）</h2></td>
	</tr>

	<tr>
		<td colspan="3" valign="top" height="">
		<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#000">

			<tr>
				<td width="40%" align="center"><h2>区域</h2></td>
				<td width="30%" align="center"><h2>销售额</h2></td>
				<td width="30%" align="center"><h2>销售收入</h2></td>
			</tr>
			<c:forEach var="item" items="${areaSaleList}">
			<tr>
                <td width="40%" align="center"><h2>${item.areaName }</h2></td>
                <td width="30%" align="right"><h2><fmt:formatNumber value="${empty item.s_amount ? 0 : item.s_amount }" pattern="#,###"/></h2></td>
                <td width="30%" align="right"><h2><fmt:formatNumber value="${empty item.s_amount_r ? 0 : item.s_amount_r }" pattern="#,###"/></h2></td>
            </tr>
			</c:forEach>
            <tr>
                <td width="40%" align="center"><h2>合计</h2></td>
                <td width="30%" align="right"><h2><fmt:formatNumber value="${areaSaleXml.s_amount }" pattern="#,###"/></h2></td>
                <td width="30%" align="right"><h2><fmt:formatNumber value="${areaSaleXml.s_amount_r }" pattern="#,###"/></h2></td>
            </tr>
		</table>
		</td>
	</tr>
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr><td colspan="3"><h2>以上数据核对无误，以此打印签字盖章为准。</h2></td></tr>
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr>
		<td colspan="3">
		<table width="460" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td align="right">
				<table width="460" border="0" cellspacing="0" cellpadding="0">
					<tr><td colspan="3" align="left"><h2>负责人：</h2></td></tr>
					<tr><td align="left"><h2>审核人：</h2></td></tr>
					<tr><td align="left"><h2>操作员：</h2></td></tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr>
		<td align="right" colspan="3">
			<h2>柬埔寨高棉彩池福利彩票有限公司技术部</h2>
			<h2>${gameDrawInfo.realColseTime }</h2>
		</td>
	</tr>
</table>
</div>
</body>
</html>