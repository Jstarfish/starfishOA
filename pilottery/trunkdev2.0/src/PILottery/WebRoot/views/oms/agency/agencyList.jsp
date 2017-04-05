<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>区域列表</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/city-list.css" />

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>

<script type="text/javascript" charset="UTF-8" > 
function updateQuery(){
    var req= /^[-_\~!@#\$%\^&\*\.\(\)\[\]\{\}<>\?\\\/\'\"]/;
    var str=$("#agencyNameQuery").val();
   
    var result = true;
    if(req.test(str)){
      doCheckMsg("agencyNameQuery",false,"Contain special characters")
		result = false;
    
    }
   // if(req.test(agencyNameQuery))
   if(result){
    $("#queryForm").submit();
   }
}

function prompt(areaCode,areaName,msg,msg1,url) {
	
	var msgbox =msg1+"\r\n"+areaName+"?";
	//button_off("ok_button");
	showDialog("operAte('"+url+"')",msg,msgbox);
}
function operAte(url) {
	button_off("ok_button");

	$.ajax({
		url : url,
		dataType : "json",
		async : false,
		success : function(r){
	            if(r.reservedSuccessMsg!='' && r.reservedSuccessMsg!=null){
		            closeDialog();
	            	showError(decodeURI(r.reservedSuccessMsg));
		        }
	            else{

	            	window.location.reload(); 
		       }
	}
	});
}
function doCheckMsg(id,regex,msg) {

	if(!regex) {
		$("#"+id+"Tip").text("");
		$("#"+id+"Tip").text(msg);
		
		$("#"+id+"Tip").removeClass("tip_init").addClass("tip_error");
		
	} else {

			$("#"+id+"Tip").text("");

		$("#"+id+"Tip").text("*");
	  
	    $("#"+id+"Tip").removeClass("tip_error").addClass("tip_init");
	}

	}
function onclear(){
	 $('#agencyCodeQuery').val('');
	 $('#agencyNameQuery').val('');

	 $("#areaCode option:first").prop("selected", 'selected');
	 $("#agencyStatus option:first").prop("selected", 'selected');
	 $("#agencytype option:first").prop("selected", 'selected');
}
function doclear(areaName,url) {

	  var delmsg='Are you sure you want to remove outlet';

	var msg =delmsg+"\r\n"+areaName+"?";
	
	showDialog("showClear('"+url+"')",'Remove',msg);
	
}

function showClear(url){
	button_off("ok_button");
	closeDialog();
	// showBox(url,'Remove',600,800)
	showPage(url,'Remove');
	 
}
</script>

</head>
<body>
    <div id="title">
        <span  id="curdisplay">Outlet Authorization</span> 
    </div>

    <div class="queryDiv">
       <form:form modelAttribute="agencyForm" action="agency.do?method=listAgency" method="POST" id="queryForm">
            <div class="left">
                     <span>Institution:
                       <select name="areaCode" class="select-normal" id="areaCode">
						    <option value="">--All--</option>
						    <c:forEach var="data" items="${orgList}">
						     <option value="${data.orgCode}" <c:if test="${agencyForm.areaCode==data.orgCode }">selected</c:if>>${data.orgName }</option>
						    </c:forEach>
						</select>
				  </span>
                     <span>Outlet Code:
                     <form:input path="agencyCode" id="agencyCodeQuery" class="text-normal" maxlength="10" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" autocomplete="off"/>
                     </span>
                     <span>Outlet Name:
                      		<form:input path="agencyName" id="agencyNameQuery" maxlength="100" class="text-normal"/>
                      </span>
                      <span>Status:
                          <select name="agencyStatus.value" class="select-normal" id="agencyStatus">
					    <option value="0">--All--</option>
					   <c:forEach var="data" items="${agencyStatusItems}">
					     <option value="${data.key}" <c:if test="${agencyForm.agencyStatus.value==data.key }">selected</c:if>>${data.value }</option>
					    </c:forEach>
					</select>
				</span>
                   <span>Outlet Type:
                      	<select name="agencytype" id="agencytype" class="select-normal"> 
					     <option value="0">--All--</option>
						<option value="1" <c:if test="${agencyForm.agencytype==1}">selected</c:if>>Prepaid</option>
						<option value="2" <c:if test="${agencyForm.agencytype==2}">selected</c:if>>Accredited</option>							       		
						<option value="4" <c:if test="${agencyForm.agencytype==4}">selected</c:if>>Regional Center</option>								       		
			     	</select>
			    </span>
			    </div>
			 <div class="right"> 
			 	 <input type="button" value="Query" onclick="updateQuery();" class="button-normal"></input>
                 <input type="button"  class="button-normal" value="Clear" onclick="onclear();">
             </div>                     
         </form:form>
    </div>
    <div id="headDiv">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr><td>
            <table class="datatable" id="exportPdf">
                <tr class="headRow">
                 <td style="width: 10px;">&nbsp;</td>
                  		<td style="width:10%" title="Code">Code</td>
                  		<th width="1%">|</th>
						<td style="width:10%" title="Outlet">Outlet</td>
						 <th width="1%">|</th>
						<td style="width:10%" title="Institution">Institution</td>
						 <th width="1%">|</th>
						<td style="width:10%" title="Status">Status</td>
						 <th width="1%">|</th>
						<td style="width:10%" title="Type">Type</td>
						 <th width="1%">|</th>
						<td style="width:10%" title="Credit">Credit</td>
						 <th width="1%">|</th>
						<td style="width:10%" title="Account Balance">Account Balance</td>
						 <th width="1%">|</th>
						<td style="width:*%" class="no-print">Operation</td>
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
				<td style="width:10%">${data.agencyCode}</td>
                <td width="1%">&nbsp;</td>
				<td style="width:10%"  title="${data.agencyName}">${data.agencyName}</td>
				<td width="1%">&nbsp;</td>
				<td style="width:10%"  title="${data.orgName}">${data.orgName}</td>
				<td width="1%">&nbsp;</td>
				<td style="width:10%">
					<c:forEach var="data1" items="${agencyStatusItems}">
				     	<c:if test="${data1.key==data.agencyStatus.value}">${data1.value}</c:if>
				    </c:forEach></td>
				<td width="1%">&nbsp;</td>
				<td style="width:10%">
					<c:choose>
					 	<c:when test="${data.agencyType.value==1}">Prepaid</c:when>
				  		<c:when test="${data.agencyType.value==2}">Accredited</c:when>
				        <c:otherwise>Regional Center</c:otherwise>
					</c:choose></td>
				<td width="1%">&nbsp;</td>
				<td style="width:10%" align="right"><fmt:formatNumber value="${data.creditLimit}" /></td>
				<td width="1%">&nbsp;</td>
				<td style="width:10%" align="right"><fmt:formatNumber value="${data.accountBalance}" /></td>
				<td width="1%">&nbsp;</td>
				<td style="width:*%" class="no-print">
                 	<c:if test="${data.agencyStatus.value == 1 && data.agencyType.value != 4}">
						<span><a href="#" onclick="prompt('${data.agencyCode}','${data.agencyName}','Disable','Are you sure you want to disable','agency.do?method=disableAgencyByCode&agencycode=${data.agencyCode}')" >Disable</a></span> |
						<span><a href="#" onclick="doclear('${data.agencyName}','agency.do?method=returnAgency&agencycode=${data.agencyCode}')" >Clear</a></span> |				
						<span><a href="#" onclick="showBox('agency.do?method=gameAuthen&agencycode=${data.agencyCode}&areaCode=${data.orgCode}','Game Authentication',300,1000)">Game Auth</a></span> |
						<span><a href="#" onclick="showBox('agency.do?method=detailAgency&agencycode=${data.agencyCode}','Details',550,930)">Details</a></span> |
						<span><a href="#" onclick="showBox('terminal.do?method=addTerminal&agencycode=${data.agencyCode}&agencyCodeTochar=${data.agencyCodeToChar}&fatherArea=${data.agencyCode}&areaType=5','New Terminal',400,700)"><img src="img/add-zdj.png" width="21" height="16" title="New Terminal"/></a></span> |
						<span><a href="#" onclick="showBox('teller.do?method=addTeller&agencycode=${data.agencyCode}&agencyCodeTochar=${data.agencyCodeToChar}','New Teller',300,700)"><img src="img/add-xsy.png" width="21" height="16" title="New Teller"/></a></span>
					</c:if>
					<c:if test="${data.agencyStatus.value == 1 && data.agencyType.value == 4}">
						<span>Enable</span> |
						<span>Clear</span> |
						<span>Game Auth</span> |
						<span><a href="#" onclick="showBox('agency.do?method=detailAgency&agencycode=${data.agencyCode}&agencyCodeTochar=${data.agencyCodeToChar}&agencyname=${data.agencyName}','Details',550,930)">Details</a></span> 
					</c:if>
					<c:if test="${data.agencyStatus.value == 2 && data.agencyType.value != 4}">
						<span><a href="#" onclick="prompt('${data.agencyCode}','${data.agencyName}','Enable','Are you sure you want to enable','agency.do?method=enableAgencyBycode&agencycode=${data.agencyCode}')">Enable</a></span> |						
						<span><a href="#" onclick="doclear('${data.agencyName}','agency.do?method=returnAgency&agencycode=${data.agencyCode}')" >Clear</a></span> |				
						<span><a href="#" onclick="showBox('agency.do?method=gameAuthen&agencycode=${data.agencyCode}&agencyname=${data.agencyName}&areaCode=${data.orgCode}','Game Authentication',300,1000)">Game Auth</a></span> |
						<span><a href="#" onclick="showBox('agency.do?method=detailAgency&agencycode=${data.agencyCode}&agencyname=${data.agencyName}','Details',550,930)">Details</a></span> |
						<span><a href="#" onclick="showBox('terminal.do?method=addTerminal&agencycode=${data.agencyCode}&agencyCodeTochar=${data.agencyCodeToChar}&fatherArea=${data.agencyCode}&areaType=5','New Terminal',400,700)"><img src="img/add-zdj.png" width="21" height="16" title="New Terminal"/></a></span> |
						<span><a href="#" onclick="showBox('teller.do?method=addTeller&agencycode=${data.agencyCode}&agencyCodeTochar=${data.agencyCodeToChar}','New Teller',300,700)"><img src="img/add-xsy.png" width="21" height="16" title="New Teller"/></a></span>
					</c:if>
					<c:if test="${data.agencyStatus.value == 2 && data.agencyType.value == 4}">
						<span>Enable</span> |
						<span>Clear</span> |
						<span>Game Auth</span> |
						<span><a href="#" onclick="showBox('agency.do?method=detailAgency&agencycode=${data.agencyCode}&agencyname=${data.agencyName}','Details',550,930)" >Details</a></span> 
					</c:if>
					<c:if test="${data.agencyStatus.value == 3}">
						<span>Enable</span> |
						<span>Clear</span> |
						<span>Game Auth</span> |
						<%-- <span><a href="#" onclick="showPage('agency.do?method=getRefunce&agencyCode=${data.agencyCode}','Print')">Print</a></span> | --%>
						<span><a href="#" onclick="showBox('agency.do?method=detailAgency&agencycode=${data.agencyCode}&agencyname=${data.agencyName}','Details',550,930)">Details</a></span>
					</c:if>
				</td>
			</tr>
		</c:forEach>
	
        </table>
        ${pageStr }
    </div>

</body>
</html>