<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title></title>
<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>

<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript">
//区域下拉框级联
$(document).ready(function() { 
	var title = "兑奖期次统计表(按奖金统计)|"
		  + " 游戏名称:"+$('#gameCode').find("option:selected").text()
		  + " 开始期次:"+$('#beginIssue').val()
		  + " 结束期次:"+$('#endIssue').val()
		  + " 单位:瑞尔";
	$("#reportTitle").val(title);
});

function updateQuery() {
	var beginIssue=$('#beginIssue').val();
	var endIssue=$('#endIssue').val();
	if(beginIssue==''){
		showError("开始期次,不能为空");
	   //alert('开始期次,不能为空');
	   return false;
	}
	if(endIssue==''){
	   //alert('结束期次,不能为空');
	   showError("结束期次,不能为空");
	   return false;
	}
	if(beginIssue!='' && endIssue!=''){
		if(parseInt(beginIssue)>parseInt(endIssue)){
			//alert('开始期次不能大于结束期次!');
			showError("开始期次不能大于结束期次");
			return false;
		}
	}
	$("#form").submit();
}
function iframeResize(){
    //var h = parent.document.body.offsetHeight+500;
    var tabth = $("#tabth").height();
    var h = document.body.clientHeight - 89-tabth; 
    document.getElementById('box').style.height = h+'px';
    $("#box").css("margin-top",tabth);
};
window.onresize=function(){
    iframeResize();
};
window.onload = function(){
	iframeResize();
};
</script>
</head>
<body style="overflow: hidden;">
	<div id="title"><!-- 体育彩票兑奖统计表（各区域中心用） -->兑奖期次统计表(按奖金统计)</div>
		<div id="queryDiv" class="queryDiv">
			<form:form id="form" modelAttribute="misReportForm" action="misReport.do?method=misReport3134&init=false">
				<div class="left">
					<span>
						<!-- 游戏名称 -->游戏名称:
						<select name="gameCode" id="gameCode" class="select-normal">
							<c:forEach items="${games}" var="g">
								<option value="${g.gameCode}" <c:if test="${misReportForm.gameCode==g.gameCode}">selected</c:if>>${g.shortName}</option>
							</c:forEach>
						</select>
					</span>
					<span>
						<!-- 开始期次 -->开始期次:
						<input name="beginIssue" id="beginIssue" value="${misReportForm.beginIssue }" maxlength="12" class="text-normal" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')"/>
						<!-- 结束期次 -->结束期次:
						<input name="endIssue" id="endIssue" value="${misReportForm.endIssue }" maxlength="12" class="text-normal" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')"/>
					</span>
					<input name="submit1" type="button" class="button-normal" onclick="updateQuery();" value="查询"/>
				</div>
				<div style="overflow: right;">
	            	<span style="position: absolute;right: 80px;">
		        		<input type="hidden" id="reportTitle" name="reportTitle" value="兑奖期次统计表(按奖金统计)">
		        		<er:exportReport url="${pageContext.request.contextPath }/er/exportReportServlet" types="pdf" classs="icon-lz" tableId="exportPdf"  title="exportPdf"></er:exportReport>
		            	<er:exportReport url="${pageContext.request.contextPath }/er/exportReportServlet" types="excel" classs="icon-lz" tableId="exportPdf"  title="exportPdf"></er:exportReport>
		            </span>
	        	</div>
			</form:form>
		</div>
	
	<div id="headDiv">
		<table width="100%"  border="0" cellpadding="0" cellspacing="0">
            <tr><td>	
			<table class="datatable" id="exportPdf">
			  <thead>
				<tr class="headRow">
					<td style="width:10px;" noExp="true">&nbsp;</td>
					<td width="5%"><!--序号-->序号</td>
					<td width="1%" noExp="true">|</td>
					<td width="15%"><!--期次-->期次</td>	
					<td width="1%" noExp="true">|</td>
					<td width="15%"><!--销售总额-->销售总额</td>	
					<td width="1%" noExp="true">|</td>
					<td width="15%"><!--大额兑奖张数-->大额兑奖张数</td>
					<td width="1%" noExp="true">|</td>
					<td width="15%"><!--大额兑奖金额-->大额兑奖金额</td>
					<td width="1%" noExp="true">|</td>
					<td width="15%"><!--小额兑奖金额-->小额兑奖金额</td>
					<td width="1%" noExp="true">|</td>
					<td width="*%"><!--兑奖合计-->兑奖合计</td>
				</tr>
				</thead>
			</table>
			</td><td style="width:17px;background:#2aa1d9"></td></tr>
        </table>
	</div>
	
	<div id="box" style="margin-top:35px;position: relative; width: 100%; z-index: 1; overflow-y: scroll;">
		<table class="datatable" id="exportPdfData">
			<c:if test="${!empty resultList}">
			<c:forEach items="${resultList}" var="item" begin="0" step="1" varStatus="status">
			<tr class="dataRow">
				<td style="width:10px;" noExp="true">&nbsp;</td>
				<td width="5%">${status.index+1 }</td>
				<td width="1%" noExp="true">&nbsp;</td>
				<td width="15%">${item.issueNumber }</td>
				<td width="1%" noExp="true">&nbsp;</td>
				<td width="15%" style="text-align:right; padding-right: 4%;"><fmt:formatNumber value="${item.saleAmount}" type="number"/></td>
				<td width="1%" noExp="true">&nbsp;</td>
				<td width="15%" style="text-align:right; padding-right: 4%;"><fmt:formatNumber value="${item.bigPayCount}" type="number"/></td>
				<td width="1%" noExp="true">&nbsp;</td>
				<td width="15%" style="text-align:right; padding-right: 4%;"><fmt:formatNumber value="${item.bigPayAmount}" type="number"/></td>
				<td width="1%" noExp="true">&nbsp;</td>
				<td width="15%" style="text-align:right; padding-right: 4%;"><fmt:formatNumber value="${item.smallPayAmount}" type="number"/></td>
				<td width="1%" noExp="true">&nbsp;</td>
				<td width="*%" style="text-align:right; padding-right: 4%;"><fmt:formatNumber value="${item.paySum}" type="number"/></td>
			  </tr>
			  </c:forEach>
			  </c:if>
			<tr class="dataRow" bgcolor="#F8F8FF">
				<td style="width:10px;" noExp="true">&nbsp;</td>
				<td colspan="4">
					<!--总计-->总计
				</td>
				<c:if test="${!empty resultSum}">
					<td style="text-align:right; padding-right: 4%;"><fmt:formatNumber value="${resultSum.saleAmount}" type="number"/></td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td style="text-align:right; padding-right: 4%;"><fmt:formatNumber value="${resultSum.bigPayCount}" type="number"/></td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td style="text-align:right; padding-right: 4%;"><fmt:formatNumber value="${resultSum.bigPayAmount}" type="number"/></td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td style="text-align:right; padding-right: 4%;"><fmt:formatNumber value="${resultSum.smallPayAmount}" type="number"/></td>
					<td width="1%" noExp="true">&nbsp;</td>
					<td style="text-align:right; padding-right: 4%;"><fmt:formatNumber value="${resultSum.paySum}" type="number"/></td>
				</c:if>
			</tr>
		</table>
	</div>
</body>
</html>
