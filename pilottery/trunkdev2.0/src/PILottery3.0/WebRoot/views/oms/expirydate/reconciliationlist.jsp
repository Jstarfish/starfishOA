<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%><html>
<head>
<title>Refund Record</title>
<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript">
$(document).ready(function() { 
	initinfo();
});
function initinfo(){
	var areaCode=$('#agencyCode').val();

	
	var title = "Account Item|"
		+"Outlet Code:"+areaCode;
	$("#reportTitle").val(title);
}
function updateQuery(){
	//$("#curdisplay").empty();	
	//$("#curdisplay").html('${queryForm.curCityName}');
	
	initinfo();
	
    $("#queryForm").submit();
	
}
</script>
</head>
<body>
<div id="title">Account Item</div>

<div class="queryDiv">
    <form:form modelAttribute="reconciliationForm" action="expirydate.do?method=reconciliationQuery" id="queryForm">
    	<input type="hidden" id="reportTitle" name="reportTitle" value="">
        <div class="left">                      
   			<span>Outlet Code：
         		<input path="agencyCode" name="agencyCode" id="agencyCode" value="${reconciliationForm.agencyCode }" maxlength="20" class="text-normal" 
	 				 onkeyup="this.value=this.value.replace(/\D/g,'')" 
	 				 onafterpaste="this.value=this.value.replace(/\D/g,'')" />
  			 </span>
            
             <input type="button" value="Query" onclick="updateQuery();" class="button-normal"></input>
        </div>
        <div class="right">
        	 <table width="260" border="0" cellspacing="0" cellpadding="0" style="margin-top:2px;">
                <tr>
            
                 
                   <td style="width:30px"></td>
                  <td align="right">
                   
                  </td>
                  <td align="right">
                   <er:exportReport url="${pageContext.request.contextPath }/er/exportReportServlet"  classs="icon-lz"types="pdfList" tableId="exportPdf"  title="exportPdf"></er:exportReport>
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
					<td style="width:10%" scope="col">Account Item</td>
					<td style="width:10%" scope="col">Outlet Code</td>
					<td style="width:10%" scope="col">Outlet Name</td>
					<td style="width:10%" scope="col">Type</td>
					<td style="width:10%" scope="col">Amount</td>
					<td style="width:10%" scope="col">Record Time</td>
			  	 </tr>
               </table>
          </td><td style="width:17px;background:#2aa1d9"></td></tr>
      </table>		
</div>																									
   
<div id="bodyDiv">
   <table class="datatable" id="exportPdfData">
      <c:forEach var="data" items="${pageDataList}" varStatus="status" >
	    <tr class="dataRow">
		<td style="width:10%">${data.id}</td>
		<td style="width:10%" >${data.agencyCode}</td>
		<td style="width:10%">${data.agencyName}</td>
		<td style="width:10%">
			<c:choose>
			   <c:when test="${data.state==1}">Manual Deposit</c:when>
			    <c:when test="${data.state==2}">Transaction</c:when>
			    <c:when test="${data.state==3}">Clear</c:when>
			</c:choose>
		</td>
		<td style="width:10%" align="right"><fmt:formatNumber value="${data.operAmount}" type="number"/></td>
		<td style="width:10%">
			<fmt:formatDate value="${data.operTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
		</td>
	  </tr>
	</c:forEach>
  </table>
      ${pageStr }
</div>
</body>
</html>
