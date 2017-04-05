<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title></title>
<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript">
jQuery(document).ready(function($) { 
    $("input[type='text']").each(  
          function(){  
              $(this).keypress( function(e) {  
                      var key = window.event ? e.keyCode : e.which;  
                      if(key.toString() == "13"){  
                      	  return false;  
                      }  
              });  
    	 }
    );  
});

function updateView(){ 
    $("#issueManagementForm").submit();
}
function prompt(gameCode,issueNumber,isPublish,flag) {
	
	var msg = "Are you sure you want to&nbsp;"+"&nbsp;"+flag+"&nbsp;all issues after&nbsp;"+issueNumber+"?";
	showDialog("deleteIssue("+gameCode+","+issueNumber+","+isPublish+")",flag+"&nbsp;"+"Issue",msg);
}
function deleteIssue(gameCode,issueNumber,isPublish){ 
	$("#issueManagementForm").attr("action","issueManagement.do?method=deleteIssue&fl=confirm&gameCode="+gameCode+"&issueNumber="+issueNumber+"&isPublish="+isPublish);
	button_off("ok_button");
	$("#issueManagementForm").submit();
}
</script>
</head>
<body>
<div id="title">Issue Inquiry</div>
<div class="queryDiv">
    <form:form modelAttribute="issueManagementForm" action="issueManagement.do?method=issueManagementTabs">
        <div class="left">
            <span>Game:
                <form:select path="gameCode"  class="select-normal">
                    <c:forEach items="${games}" var="s">
                        <form:option value="${s.gameCode}">${s.shortName}</form:option>
                    </c:forEach>
                </form:select>
            </span>
            <span>Issue:
                <form:input path="issueNumber" maxlength="12" onblur="value=value.replace(/[^0-9]/g,'')" class="text-normal"/>
            </span> 
            <span>Issue Status:
                <form:select path="issueStatus"  class="select-normal">
                	<form:option value="0">--All--</form:option>
                    <form:options items="${issueStatusMap}" />
                </form:select>
            </span> 
            <span>Published:
                <form:select path="isPublish" class="select-normal">
                    <form:option value="">--All--</form:option>
                    <form:option value="1">yes</form:option>
                    <form:option value="0">no</form:option>
                </form:select>
            </span> 
            <span>Date:
		   	 	<form:input path="openDate" class="Wdate text-normal" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true})"/> 
		    </span>
            <a href="#" onclick="updateView();"><button class="button-normal">Query</button></a>
        </div>
        <div class="right"> 
			<table width="100" border="0" cellspacing="0" cellpadding="0" style="margin-top:2px;">
			  <tr style="height:50px;line-height:50px">
			    <td><input type="button" class="button-normal" value="Publish" 
			    onclick="showBox('issueManagement.do?method=issuePublish','Publish',300,550)"/></td>
			    <td align="right">
					&nbsp;
	              	</td>
			  </tr>
			</table>
	    </div>
    </form:form>    
</div>
<div id="headDiv">
    <table width="100%"  border="0" cellpadding="0" cellspacing="0">
       <tr><td>
            <table class="datatable">
            	<tr class="headRow">
            		<td style="width:10px;">&nbsp;</td>
					<td>Issue</td>
					<td width="1%">|</td>
                    <td>Begin At</td>
                    <td width="1%">|</td>
                    <td>Close Time</td>
                    <td width="1%">|</td>
                    <td>Draw Time</td>
                    <td width="1%">|</td>
                    <td>Issue Status</td>
                    <td width="1%">|</td>
                    <td>Sales Amount</td>
                    <td width="1%">|</td>
                    <td>Start-of-Issue Pool</td>
                    <td width="1%">|</td>
                    <td>End-of-Issue Pool</td>
                    <td width="1%">|</td>
                    <td>Published</td>
                    <td width="1%">|</td>
                    <td width="330">Operation</td>
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
        	<td>${row.issueNumber}</td>
			<c:if test="${row.issueStatus==2 || row.issueStatus==3}">
				<td
					title="<fmt:formatDate value="${row.realStartTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"><fmt:formatDate
					value="${row.realStartTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
					<td width="1%">&nbsp;</td>
			</c:if>
			<c:if test="${row.issueStatus!=2 && row.issueStatus!=3}">
				<td
					title="<fmt:formatDate value="${row.planStartTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"><fmt:formatDate
					value="${row.planStartTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
					<td width="1%">&nbsp;</td>
			</c:if>
			<c:if test="${row.issueStatus>=4}">
				<td
					title="<fmt:formatDate value="${row.realCloseTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"><fmt:formatDate
					value="${row.realCloseTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
					<td width="1%">&nbsp;</td>
			</c:if>
			<c:if test="${row.issueStatus<4}">
				<td
					title="<fmt:formatDate value="${row.planCloseTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"><fmt:formatDate
					value="${row.planCloseTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
					<td width="1%">&nbsp;</td>
			</c:if>
			<c:if test="${row.issueStatus==13}">
				<td
					title="<fmt:formatDate value="${row.issueEndTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"><fmt:formatDate
					value="${row.issueEndTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
					<td width="1%">&nbsp;</td>
			</c:if>
			<c:if test="${row.issueStatus!=13}">
				<td
					title="<fmt:formatDate value="${row.planRewardTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"><fmt:formatDate
					value="${row.planRewardTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
					<td width="1%">&nbsp;</td>
			</c:if>
			<td>${issueStatusRefMap[row.issueStatus]}</td>
			<td width="1%">&nbsp;</td>
			<td align="right">
        		<c:choose>
                <c:when test="${row.issueStatus==13}"><!-- 销售额（期结期次显示，未期结不显示）  -->
					<fmt:formatNumber type="number" value="${row.issueSaleAmount}" />
                </c:when>
                <c:otherwise>
                	—
                </c:otherwise>
                </c:choose>
	        </td>
	        <td width="1%">&nbsp;</td>
	        <td align="right">
	        	<c:choose>
                <c:when test="${row.issueStatus==13}"><!-- 期初奖池（期结期次显示，未期结不显示）  -->
					<fmt:formatNumber type="number" value="${row.poolStartAmount}" />
                </c:when>
                <c:otherwise>
                	—
                </c:otherwise>
                </c:choose>
	        </td>
	        <td width="1%">&nbsp;</td>
	        <td align="right">
	        	<c:choose>
                <c:when test="${row.issueStatus==13}"><!-- 期末奖池（期结期次显示，未期结不显示）  -->
					<fmt:formatNumber type="number" value="${row.poolCloseAmount}" />
                </c:when>
                <c:otherwise>
                	—
                </c:otherwise>
                </c:choose>
	        </td>
	        <td width="1%">&nbsp;</td>
        	<td>
				<c:if test="${row.isPublish==1}">yes</c:if>
                <c:if test="${row.isPublish==0}">no</c:if>
			</td>
			<td width="1%">&nbsp;</td>
        	<td width="330">
           	    	<a href="#" onclick="showPage('issueManagement.do?method=detail&gameCode=${row.gameCode}&issueNumber=${row.issueNumber}','Details')">Details</a> |
                	<a href="#" onclick="showPage('issueManagement.do?method=issueParam&gameCode=${row.gameCode}&issueNumber=${row.issueNumber}','Param')">Param</a> |
                <c:choose>
                <c:when test="${row.isPublish==0 && row.issueStatus==0}">
                	<a href="#" onclick="showBox('issueManagement.do?method=editPrize&gameCode=${row.gameCode}&issueNumber=${row.issueNumber}','Prizes',400,550)">Prizes</a> |
                </c:when>
                <c:when test="${row.issueStatus==13}">
                </c:when>
                <c:otherwise>
                	<span style="color:#CDC9C9">Prizes</span> | 
                </c:otherwise>
                </c:choose>
                
                <c:choose>
                <c:when test="${row.isPublish==0 && row.issueStatus==0 && (row.gameCode==6 || row.gameCode==7)}">
               		<a href="#" onclick="showBox('issueManagement.do?method=editCalcWinningParam&gameCode=${row.gameCode}&issueNumber=${row.issueNumber}','Calc Param',240,450)">Calc Param</a> |
                </c:when>
                <c:when test="${row.issueStatus==13}">
                </c:when>
                <c:otherwise>
                	<span style="color:#CDC9C9">Calc Param</span> |
                </c:otherwise>
                </c:choose>

                <c:choose>
                <c:when test="${row.isPublish==0 && row.issueStatus==0}">
                	<a href="#" onclick="prompt('${row.gameCode}','${row.issueNumber}','${row.isPublish}','Delete')">Delete</a> |
                </c:when>
                <c:when test="${row.isPublish==1 && row.issueStatus==0}">
                	<a href="#" onclick="prompt('${row.gameCode}','${row.issueNumber}','${row.isPublish}','Cancel')">Cancel</a> |
                </c:when>
                <c:when test="${row.issueStatus==13}">
                </c:when>
                <c:otherwise>
                	<span style="color:#CDC9C9">Delete</span> |
                </c:otherwise>
                </c:choose>
                
                <c:choose>
                <c:when test="${row.issueStatus==13 && (row.gameCode==6 || row.gameCode==7)}">
                	<a href="#" onclick="showPage('gameDraw.do?method=printDrawNotice&gameCode=${row.gameCode}&issueNumber=${row.issueNumber}','Notice')">Notice</a> | 
            		<a href="#" onclick="showPage('gameDraw.do?method=step3_print&type=1&gameCode=${row.gameCode}&issueNumber=${row.issueNumber}','Statement')">Statement</a> | 
            		<a href="#" onclick="showPage('gameDraw.do?method=step3_print&type=2&gameCode=${row.gameCode}&issueNumber=${row.issueNumber}','Report')">Report</a>
            	</c:when>
            	<c:when test="${row.issueStatus==13 && (row.gameCode==12 || row.gameCode==11 || row.gameCode==5)}">
                	<a href="#" onclick="showPage('gameDraw.do?method=printDrawNotice&gameCode=${row.gameCode}&issueNumber=${row.issueNumber}','Notice')">Notice</a> 
            	</c:when>
                <c:otherwise>
                	<span style="color:#CDC9C9">Notice</span>
                </c:otherwise>
                </c:choose>
			</td>
        </tr>
        </c:forEach>
    </table>
    ${pageStr }
</div>
</body>
</html>
