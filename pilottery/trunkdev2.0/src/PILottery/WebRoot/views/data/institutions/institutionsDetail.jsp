<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
</head>

<script type="text/javascript" >
	function doClose(){
		window.parent.closeBox();
	}
</script>
<body style="margin:0;">
<div id="tck" >

  <div class="mid">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" >
      <tr>
        <td  align="right" class="td" width="25%">Institution Code：</td>
        <td  align="left" class="td" width="20%">${infOrgs.orgCode}	</td>
        <td  class="td" align="right" width="25%">Institution Name：</td>
        <td class="td" align="left" > ${infOrgs.orgName}</td>
      </tr>

      <tr>
       <td class="td"  align="right">Head of Institution：</td>
        <td class="td" align="left">${infOrgs.directorAdmin}</td>  
        <td  class="td" align="right">Contact Phone：</td>
     <td class="td" align="left"> ${infOrgs.phone}</td> 
      </tr>
 
      <tr>
       <td class="td"  align="right">Number of Employees：</td>
        <td class="td" align="left">${infOrgs.persons}</td>  
        <td  class="td" align="right">Address：</td>
     <td class="td" align="left"> ${infOrgs.address}</td> 
      </tr>
         
    </table>
  </div>
  <div style="padding:0 20px 20px 20px;">
       <div style="position:relative; z-index:1000px;margin-top: 10px;">
         <table class="datatable" id="table1_head" width="100%">
           <tbody><tr>
             <th width="20%">Institution Code </th>
             <th width="2%">|</th>
             <th width="22%">Area Code</th>
             <th width="2%">|</th>
             <th width="22%">Area Name</th>
             <th width="2%"></th>
           
           </tr>
         </tbody></table>
       </div>
       <div id="box" style="border:1px solid #ccc;">
         <table id="fatable" class="datatable" cellpadding="0" cellspacing="0" width="100%">
           <tbody>
            <c:forEach var="data" items="${Listara}">
           	<tr>
              <td width="20%">
             	${data.orgCode }
              </td>
              <td width="2%">&nbsp;</td>
              <td width="22%">${data.areaCode }</td>
              <td width="2%">&nbsp;</td>
              <td width="22%">${data.areaName }</td>
              <td width="2%">&nbsp;</td>
              
            </tr>
            </c:forEach>
           
         </tbody></table>
       </div>
 </div>
</div>

</body>
</html>
