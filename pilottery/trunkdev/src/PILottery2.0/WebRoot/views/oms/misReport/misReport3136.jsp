<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title></title>
<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript">
//区域下拉框级联
$(document).ready(function() { 
	var title = "Dynamic Prize Table|"
		+ "Game:"+$('#gameCode option:selected').text()
		+ ",Issue Number:"+$("#beginIssue").val();
	$("#reportTitle").val(title);
	$("#gameName").val($('#gameCode option:selected').text());
});

function updateQuery() {
	var beginIssue=$('#beginIssue').val();
	 if(beginIssue==''){
		 showError("Issue cannot be empty!");
		 return false;
		}
	 $("#form").attr("action", "misReport.do?method=misReport3136");
	$("#form").submit();
}
function iframeResize(){
    //var h = parent.document.body.offsetHeight+500;
    var tabth = $("#tabth").height();
    var h = document.body.clientHeight - 89-tabth; 
   // document.getElementById('box').style.height = h+'px';
 //   $("#box").css("margin-top",tabth);
};
window.onresize=function(){
    iframeResize();
};
window.onload = function(){
	iframeResize();
};
function exportcsv(){
	$("#form").attr("action", "misReport.do?method=exportCSV");
	$("#form").submit();
}
</script>
<style type="text/css">

.tab1 td{
	line-height:35px; 
	padding-left:17px;
	padding-right:17px;
]
</style>

</head>
<body style="overflow: hidden;">
	<div id="title"><!-- 资金结算表（税金） -->Dynamic Prize Table</div>
		<div id="queryDiv" class="queryDiv">
			<form:form id="form" modelAttribute="misReportForm" action="misReport.do?method=misReport3136&init=false">
				<div class="left">
					<span>
						<!-- 游戏名称 -->Game:
						<select name="gameCode" id="gameCode" class="select-normal">
							<c:forEach items="${games}" var="g">
								<option value="${g.gameCode}" <c:if test="${misReportForm.gameCode==g.gameCode}">selected</c:if>>${g.shortName}</option>
							</c:forEach>
						</select>
					</span>
	             	<span>
		            <!-- 开始期次 --> Start Issue：
						<form:input path="beginIssue" id="beginIssue" class="text-normal" onkeyup="value=value.replace(/[^0-9]/g,'')" />
	
						<input type="hidden" id="gameName" name="gameName" value=""/>
					</span>
					<input name="submit1" type="button" class="button-normal" onclick="updateQuery();" value= "Query"/>
				</div>
				<div style="overflow: right;">
	            	<span style="position: absolute;right: 80px;">
		        		<input type="hidden" id="reportTitle" name="reportTitle" value="Dynamic Prize Table">
		            	 <er:exportReport url="${pageContext.request.contextPath }/er/exportReportServlet" types="pdfinfo" classs="icon-lz" tableId="exportPdf"  title="exportPdf"></er:exportReport>
		            	<a href="#" class="icon-lz" onclick="exportcsv();"><img src="img/daochu.png" width="21" height="16" /> Excel</a>
		            </span>
	        	</div>
			</form:form>
		</div>
	
	<div id="tabth" style="position:fixed;width:100%;z-index: 1;" style="line-height:35px;">
		<table width="98%" border="1" id="exportPdf" cellspacing="0" cellpadding="0" class="tab1">
		<tr>
			<td align="center">Items</td>
			<td colspan="2" align="center">Adjustment Fund</td>
			<td colspan="2" align="center">Prize Pool</td>
		</tr>
		<tr>
			<td width="20%"></td>
			<td width="20%">Initial Balance</td>
			<td width="20%" align="right"><c:choose>
			       <c:when test="${!empty resultSum.adjbefore}"> <fmt:formatNumber value="${resultSum.adjbefore}"	type="number"/></c:when>
			       <c:otherwise>&nbsp;&nbsp;&nbsp;</c:otherwise>
			</c:choose></td>
			<td width="20%">Initial Balance</td>
			<td width="*%" align="right"><c:choose>
			       <c:when test="${!empty resultSum.poolbefore}"> <fmt:formatNumber value="${resultSum.poolbefore}"	type="number"/></c:when>
			       <c:otherwise>&nbsp;&nbsp;&nbsp;</c:otherwise>
			</c:choose></td>
		</tr>
		<tr>
			<td rowspan="2" align="center">Items Added</td>
			<td>Roll-in</td>
			<td  align="right"><fmt:formatNumber value="${resultSum.adjissue}"	type="number"/></td>
			<td	>Roll-in</td>
			<td	 align="right"><fmt:formatNumber value="${resultSum.poolissue}"	type="number"/></td>
		</tr>
		<tr>
			<td	>From Abandoned Award</td>
			<td	 align="right"><fmt:formatNumber value="${resultSum.adjabandon}"	type="number"/></td>
			<td>From Adjustment Fund</td>
			<td	 align="right"><fmt:formatNumber value="${resultSum.pooladj}"	type="number"/></td>
		</tr>
		<tr>
			<td rowspan="2" align="center">Items Deducted</td>
			<td>Roll to Prize Pool</td>
			<td	 align="right"><fmt:formatNumber value="${resultSum.adjpool}"	type="number"/></td>
			<td>Issue High-Level Payout</td>
			<td	 align="right"><fmt:formatNumber value="${resultSum.poolhdreward}"	type="number"/></td>
		</tr>
		<tr>
			<td>Special Prize</td>
			<td align="right"><fmt:formatNumber value="${resultSum.adspec}"	type="number"/></td>
			<td>--------</td>
			<td>--------</td>
		</tr>
		<tr>
			<td></td>
			<td>Final Balance</td>
			<td	 align="right"><fmt:formatNumber value="${resultSum.adjafter}"	type="number"/></td>
			<td>Final Balance</td>
			<td	 align="right"><fmt:formatNumber value="${resultSum.poolafter}"	type="number"/></td>
		</tr>
	</table>
	</div>
</body>
</html>
