<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>区域列表</title>
<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />

<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>

<style type="text/css">

</style>
 



<script type="text/javascript" charset="UTF-8" > 

function submit(){
	
	
	$("#saleCancelInfoForm").submit();
}

</script>

</head>
<body>
 <div id="title">Refund Record Inquiry  </div>

    <div class="queryDiv">
      <form:form modelAttribute="saleCancelInfoForm" action="refundquery.do?method=list">
         
            <div class="left">                      

                     <span>Operator：<form:input path="canceler" maxlength="20" class="text-normal"/></span>
                      <span>
                     Time:
                     <input id="satrtcancelTime" name="satrtcancelTime" value="${satrtcancelTime }" class="Wdate" type="text" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'endcancelTime\')}'})"/> 
						-
			   	 	<input id="endcancelTime" class="Wdate " value="${endcancelTime}" name="endcancelTime" type="text"  onFocus="WdatePicker({minDate:'#F{$dp.$D(\'satrtcancelTime\')}'})"/>
                     </span>
                   
                    <input type="button" value="Query" onclick="submit();" class="button-normal"></input>
      
            </div>
            <div class="right">
              <table width="260" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td align="right">
                   
                  </td>
                  <td style="width:30px"></td>
                  <td align="right">
                   
                  </td>
                  <td align="right">
                   
                  </td>
                </tr>
              </table>
            </div>
         </form:form>
    </div>
    <div id="headDiv">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr><td>
            <table class="datatable" id="exportPdf">
                <tr class="headRow">
                		<td style="width: 10px;">&nbsp;</td>
						<td style="width:7%" >Operator</td> 
						<th width="1%">|</th>
						<td style="width:8%" >Operation Time</td>
						<th width="1%">|</th>
						<td style="width:15%" >Ticket TSN</td> 
						<th width="1%">|</th>
						<td style="width:7%" >Game</td>
						<th width="1%">|</th>
						<td style="width:7%" >Refund Result</td> 
						<th width="1%">|</th>
						<td style="width:7%" >Refund Amount</td> 
						<th width="1%">|</th>
						<td style="width:15%" >Refund TSN</td> 
						<th width="1%">|</th>
						<td style="width:7%" >Refund Outlet</td>
						<th width="1%">|</th>
						<td style="width:9%" >Commission Deducted</td>
						<th width="1%">|</th>
						<td style="width:*%">Operation</td>
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
				<td style="width:7%">${data.canceler}</td>
				<td width="1%">&nbsp;</td>
				<td style="width:8%"><fmt:formatDate value="${data.cancelTime}"  pattern="yyyy-MM-dd HH:mm"/></td>
				<td width="1%">&nbsp;</td>
				<td style="width:15%" >${data.saleTsn}</td>
				<td width="1%">&nbsp;</td>
				<td style="width:7%">${data.gameName}</td>
				<td width="1%">&nbsp;</td>
				<td style="width:7%">
					<c:if test="${data.isSuccess==0}">
							Success
					</c:if>
				</td>
				<td width="1%">&nbsp;</td>
				<td style="width:7%" align="right"><fmt:formatNumber value="${data.cancelAmount}" type="number"/></td>
				<td width="1%">&nbsp;</td>
				<td style="width:15%">${data.id}</td>
				<td width="1%">&nbsp;</td>
				<td style="width:7%">${data.saleAgencyCode}</td>
				<td width="1%">&nbsp;</td>
				<td style="width:9%" align="right"><fmt:formatNumber value="${data.cancelComm}" type="number"/></td>
				<td width="1%">&nbsp;</td>
				<td style="width: *%">
				<a href="#" onclick="showPage('refundquery.do?method=cancelInfoPrint&id=${data.id}','Print')">Print</a>
				</td>
			</tr>
		</c:forEach>
        </table>
        ${pageStr }
    </div>

</body>
</html>