<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>弃奖查询 </title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript">
	$(function(){
		if ($("#issueNumber").val()==0) {
			$("#issueNumber").val("");
		}
	});

	function query(){
		var issueNumberStart = $("#issueNumberStart").val();
		var issueNumberEnd = $("#issueNumberEnd").val();
		if (Number(issueNumberStart) > Number(issueNumberEnd)) {
			showMsg('信息提示','开始期号不能大于结束期号！',"warn");
			return;
		}
		$("#queryForm").submit();
	}
</script>
<style type="text/css">
.bdinput{
  border:1px solid #40a7da;
  background-color:#FFF;
  width:115px;
  height:24px;
  line-height:24px;
}
</style>
</head>
<body>
	<div id="title"><!-- 弃奖查询 -->弃奖查询
	</div>
	
	<div class="queryDiv">
        <form:form modelAttribute="abandonAward" action="abandon.do?method=abandonAward" id="queryForm">
            <div class="left">                                    
				<span> 
				<!-- 游戏名称 -->游戏名称：				
					<form:select path="gameCode" class="select-normal">
						<form:option value="0">请选择</form:option>
						<c:forEach items="${games}" var="s">
							<form:option value="${s.gameCode}">${s.shortName}</form:option>
						</c:forEach>
					</form:select>
				</span>
				<!-- 游戏期号 -->	
				<span>
					游戏期号：
					<form:input path="issueNumberStart" value="" id="issueNumberStart" class="text-normal" autocomplete="off" maxlength="100" onkeyup="this.value=this.value.replace(/\D/g,'')"/>
				</span> -- 
				<span>
					<form:input path="issueNumberEnd" value="" id="issueNumberEnd" class="text-normal" autocomplete="off" maxlength="100" onkeyup="this.value=this.value.replace(/\D/g,'')"/>
				</span>
				<!-- 弃奖日期 -->
				<span>
					弃奖日期：
					<input readonly="readonly" type="text" id="payDateStart" name="payDateStart" value="${abandonAward.payDateStart }" class="Wdate bdinput" onFocus="var payDateEnd=$dp.$('payDateEnd');WdatePicker({onpicked:function(){payDateEnd.focus();},maxDate:'#F{$dp.$D(\'payDateEnd\')}'})"/>
					<!--<form:input id="payDate" path="payDate" class="Wdate bdinput" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true})"/>-->
				</span> -- 
				<span>
					<input readonly="readonly" type="text" id="payDateEnd" name="payDateEnd" value="${abandonAward.payDateEnd }" class="Wdate bdinput" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'payDateStart\')}'})"/>
				</span>
				<!-- 查询 -->
				<input type="button" value="查询" onclick="query();" class="button-normal"></input>
            </div>
        </form:form>
    </div>
	
	<div id="headDiv">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr><td>
            <table class="datatable">
                <tr class="headRow">
                    <td style="width: 10px;">&nbsp;</td>
                   <td style="width:14%" class="nowrap">游戏</td>
                   <th width="1%">|</th>
                   <td style="width:14%" class="nowrap">日期</td>
                   <th width="1%">|</th>
                   <td style="width:14%" class="nowrap">游戏期号</td>
                   <th width="1%">|</th>
                   <td style="width:14%" class="nowrap">弃奖总注数</td>
                   <th width="1%">|</th>
                   <td style="width:14%" class="nowrap">张数</td>
                   <th width="1%">|</th>
                   <td style="width:14%" class="nowrap">金额</td>
                   <th width="1%">|</th>
                   <td style="width:*%" class="nowrap">操作</td>
                </tr>
            </table>
           </td><td style="width:17px;background:#2aa1d9"></td></tr>
       </table>
    </div>
    
	 <div id="bodyDiv">
        <table class="datatable" id="exportPdfData">
            <c:forEach var="data" items="${pageDataList}" varStatus="status" >
			<tr class="dataRow">
			 <td style="width: 10px;">&nbsp;</td>
				<td style="width:14%">${data.shortName}</td>
				  <td width="1%">&nbsp;</td>
				<td style="width:14%">${data.payDate}</td>
				  <td width="1%">&nbsp;</td>
				<td style="width:14%">${data.issueNumber}</td>
				  <td width="1%">&nbsp;</td>
				<td style="width:14%"><fmt:formatNumber value="${data.allBetCount}" /></td>
				  <td width="1%">&nbsp;</td>
				<td style="width:14%"><fmt:formatNumber value="${data.allTicketCount}" /></td>
				  <td width="1%">&nbsp;</td>
				<td style="width:14%" align="right"><fmt:formatNumber value="${data.allWinningAmountTax}" pattern="#,###"/></td>
				  <td width="1%">&nbsp;</td>
				<td style="width:*%" class="no-print">
				<!-- 详情 -->					
				<c:if test="${data.allBetCount!=0 && data.allTicketCount!=0}">
					<span><a href="#" onclick="showBox('abandon.do?method=detailAbandon&payDate=${data.payDate}&gameCode=${data.gameCode}&issueNumber=${data.issueNumber}','弃奖详细信息',360,603)" 
						rev="弃奖详情">详情</a></span>
				</c:if>
				<c:if test="${data.allBetCount==0 || data.allTicketCount==0}">
					<span>详情</span>
				</c:if>
				</td>
			</tr>
			</c:forEach>
        </table>
        ${pageStr }
    </div>
</body>
</html>
