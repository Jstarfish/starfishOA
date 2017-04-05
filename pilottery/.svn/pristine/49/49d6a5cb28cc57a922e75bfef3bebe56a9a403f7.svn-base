<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title></title>
<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript">
function updateView(){
	$('#fundManagementForm').submit();
}
</script>
</head>
<body>
<div id="title">调节基金流水列表</div>
<div class="queryDiv">
	<form:form modelAttribute="fundManagementForm" action="fundManagement.do?method=fundList">
		<div class="left">
		  	<span>游戏名称:
		   	 	<form:select path="fundAdj.gameCode"  class="select-normal">
					<c:forEach items="${games}" var="s">
						<form:option value="${s.gameCode}">${s.shortName}</form:option>
					</c:forEach>
				</form:select>
		    </span>
		  </div>
		   <div class="tj">
		  	<span>日期区间:
		   	 	<form:input id="str_adjTime1" path="str_adjTime1" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true,isShowClear:true,maxDate:\"#F{$dp.$D('str_adjTime2')}\"})"/> -
		   	 	<form:input id="str_adjTime2" path="str_adjTime2" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true,isShowClear:true,minDate:\"#F{$dp.$D('str_adjTime1')}\"})"/>
		    </span>
		    <a href="#" onclick="updateView();"><button class="button-normal">查询</button></a>
		</div>
	</form:form>
</div>
<div id="headDiv">
	<table width="100%"  border="0" cellpadding="0" cellspacing="0">
		<tr><td>
			<table class="datatable">
				<tr class="headRow">
					<td style="width:10px;">&nbsp;</td>
					<td width="100">调节基金流水</td>
					<td width="1%">|</td>
                    <td width="100">游戏名称 </td>
                    <td width="1%">|</td>
                    <td width="200">变更类型</td>
                    <td width="1%">|</td>
                    <td>变更金额</td>
                    <td width="1%">|</td>
                    <td>变更前金额</td>
                    <td width="1%">|</td>
                    <td>变更后金额</td>
                    <td width="1%">|</td>
                    <td>调整备注</td>
                    <td width="1%">|</td>
                    <td>变更时间</td>
				</tr>
			</table>
		</td><td style="width:17px;background:#2aa1d9"></td></tr>
    </table>
</div>
<div id="bodyDiv">
    <table class="datatable">
    	<c:forEach var="row" items="${pageDataList}">
        <tr class="dataRow">
        	<td style="width:10px;">&nbsp;</td>
        	<td width="100">${row.hisCode}</td>
        	<td width="1%">&nbsp;</td>
        	<td width="100">${gameInfoMap[row.gameCode]}</td>
        	<td width="1%">&nbsp;</td>
        	<td width="200">
				${fundChangeType[row.adjChangeType]}
			</td>
			<td width="1%">&nbsp;</td>
        	<td align="right"><fmt:formatNumber type="number" value="${row.adjAmount}" /></td>
        	<td width="1%">&nbsp;</td>
        	<td align="right"><fmt:formatNumber type="number" value="${row.adjAmountBefore}" /></td>
        	<td width="1%">&nbsp;</td>
        	<td align="right"><fmt:formatNumber type="number" value="${row.adjAmountAfter}" /></td>
        	<td width="1%">&nbsp;</td>
        	<td title="${row.adjReason}">${row.adjReason}</td>
        	<td width="1%">&nbsp;</td>
        	<td><fmt:formatDate value="${row.adjTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
        </tr>
        </c:forEach>
    </table>
    ${pageStr }
</div>
</body>
</html>
