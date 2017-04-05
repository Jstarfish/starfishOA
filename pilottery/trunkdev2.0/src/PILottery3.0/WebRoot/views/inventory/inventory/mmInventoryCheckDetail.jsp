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

  <!--<div class="mid">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" >
      <tr>
        <td  align="right" class="td" width="25%">部门编码：</td>
        <td  align="left" class="td" width="20%">${infOrgs.orgCode}	</td>
        <td  class="td" align="right" width="25%">部门名称：</td>
        <td class="td" align="left" > ${infOrgs.orgName}</td>
      </tr>
    </table>
  </div>
  --><div style="padding:0 20px 20px 20px;">
       <div style="position:relative; z-index:1000px;margin-top: 10px;">
         <table class="datatable" id="table1_head" width="100%">
           <tbody><tr>
             <th width="18%">Plan Code </th>
             <th width="2%">|</th>
             <th width="18%">Plan Name</th>
             <th width="2%">|</th>
             <th width="18%">Batch No.</th>
             <th width="2%">|</th>
             <th width="18%">Specification</th>
             <th width="2%">|</th>
             <th width="*%">Result</th>
           </tr>
         </tbody></table>
       </div>
       <div id="box" style="border:1px solid #ccc;">
         <table id="fatable" class="datatable" cellpadding="0" cellspacing="0" width="100%">
           <tbody>
            <c:forEach var="data" items="${itemList}">
           	<tr>
              <td width="18%">${data.planCode }</td>
              <td width="2%">&nbsp;</td>
              <td width="18%">${data.planName }</td>
              <td width="2%">&nbsp;</td>
              <td width="18%">${data.batchNo }</td>
              <td width="2%">&nbsp;</td>
              <td width="18%">${data.tagNo }</td>
              <td width="2%">&nbsp;</td>
              <td width="*%">
              		<c:choose>
						<c:when test="${data.status == 1}">
							<font color="blue">No Exist</font>
						</c:when>
						<c:when test="${data.status == 2}">
							<font color="red">No Check</font>
						</c:when>
					</c:choose>
              </td>
            </tr>
            </c:forEach>
           
         </tbody></table>
       </div>
 </div>
</div>

</body>
</html>
