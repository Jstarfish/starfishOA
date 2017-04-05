<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>List of Institutions</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
function updateQuery() {
	 $("#institutionsForm").submit();
}
function delte(orgCode){
	var msg = "Are you sure you want to delete ?";
	showDialog("delteInstitutions('"+orgCode+"')","Delete",msg);
}
function delteInstitutions(areaCode) {
   

	var url="institutions.do?method=deleteInstitutions&orgCode=" + areaCode;
	  
	 
			$.ajax({
				url : url,
				dataType : "json",
				async : false,
				success : function(r){
			            if(r.message!='' && r.message!=null){
				            closeDialog();
			            	showError(r.message);
				        }
			            else{
			            	closeDialog();	
			            	window.location.reload(); 
				       }
			}
			});
	  
}
function openwin(url,title,height,width) { 
	window.open (url, title, "height='+height, width='+width, toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no")

}
</script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">Institutions</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
        <form action="institutions.do?method=listInstitutions" method="POST" id="institutionsForm" method="post">
            <div class="left">
                <span>Institution Code: <input id="orgCode" name="orgCode" value="${institutionsForm.orgCode }" class="text-normal" maxlength="4"/></span>
                <span>Institution Name: <input id="orgName" name="orgName" value="${institutionsForm.orgName }" class="text-normal" /></span>
                <input type="button" value="Query" onclick="updateQuery();" class="button-normal"></input>
            </div>
            <div class="right">
                <table width="260" border="0" cellspacing="0" cellpadding="0">
                 <c:if test="${orgCode=='00'}">
                    <tr style="height:50px;line-height:50px">
                        <td align="right">
                            <input type="button" value="New Institution"  onclick="showBox('institutions.do?method=addInit','New Institution',550,700);" class="button-normal"></input>
                        </td>
                    </tr>
                    </c:if>
                </table>
            </div>
        </form>
    </div>
    
    <!-- 列表表头块 -->
    <div id="headDiv">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <table class="datatable">
                        <tr class="headRow">
                        <td style="width:10px;">&nbsp;</td>
                            <td style="width:20%">Institution Code</td>
                             <td width="1%" >|</td>
                            <td style="width:20%">Institution Name</td>
                             <td width="1%" >|</td>
                            <td style="width:20%">Head of Institution</td>
                             <td width="1%" >|</td>
                            <td style="width:20%">Contact Phone</td>
                             <td width="1%" >|</td>
                            <td style="width:*%">Operations</td>
                        </tr>
                    </table>
                 </td>
                 <!-- 表头和下方数据对齐 -->
                 <td style="width:17px;background:#2aa1d9"></td>
             </tr>
        </table>
    </div>
    
    <!-- 列表内容块 -->
    <div id="bodyDiv">
        <table class="datatable">
         <c:forEach var="data" items="${pageDataList}" varStatus="status" >
            <tr class="dataRow">
            <td style="width:10px;">&nbsp;</td>
                <td style="width:20%">${data.orgCode }</td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:20%" title="${data.orgName }">${data.orgName }</td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:20%" title="${data.directorAdmin }">${data.directorAdmin }</td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:20%">${data.phone }</td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:*%">
                    <span><a href="#" onclick="showBox('institutions.do?method=getInstitutionsCode&orgCode=${data.orgCode }','Institution Details',550,930)">Details</a></span>&nbsp;|
                    <c:if test="${orgCode=='00'}">
                    <span><a href="#" onclick="showBox('institutions.do?method=modyInit&orgCode=${data.orgCode }','Edit Institution',550,700);">Edit</a></span>&nbsp;|
                    </c:if>
                    <span><a href="#" onclick="delte('${data.orgCode }')">Delete</a></span>
                </td>
            </tr>
            </c:forEach>
        </table>
      ${pageStr} 
    </div>
</body>
</html>