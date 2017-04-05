<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>

<html>
<head>
<title>Check Detail</title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<style type="text/css">
textarea{
    resize:none;
    width:600px;
    height:100px;
    max-height:100px;
    max-width:700px;
    overflow:auto;
    border:0px
}

</style>
</head>

<body style="margin:0;">
<div id="tck" >
  <div class="mid">	
	<table width="100%" border="0" cellspacing="0" cellpadding="0" >
		<tr>
			<td align="right" class="td" width="25%">Check Code：</td>
			<td align="left" class="td" width="20%">&nbsp;${vo.cpNo}</td>
			<td class="td" align="right" width="25%">Check Name：</td>
			<td class="td" align="left">&nbsp;${vo.cpName}</td>
		</tr>
		<tr>
			<td align="right" class="td">Checked By：</td>
			<td class="td" align="left">&nbsp;${vo.chName}</td>
			<td align="right" class="td">Warehouse：</td>
			<td class="td" align="left">&nbsp;${vo.houseName}(${vo.houseCode})</td>
		</tr>
		<tr>
			<td align="right" class="td">Date of Check：</td>
			<td class="td" align="left">&nbsp;<fmt:formatDate  value="${vo.cpDate}"  pattern="yyyy-MM-dd HH:mm:ss" /></td>
			<td align="right" class="td">Result：</td>
			<td class="td" align="left">
				<c:choose>
					<c:when test="${vo.result=='1' }">Balanced</c:when>
					<c:when test="${vo.result=='2' }">Deficit</c:when>
					<c:otherwise>
	                            Surplus
	                     	</c:otherwise>
	                  </c:choose>
			</td>
		</tr>
	</table>
		
	<div style="padding:0 20px 20px 20px;">
		<!-- table header -->
		<div style="position:relative; z-index:1000px;margin-top: 10px;">
         <table class="datatable" id="table1_head" width="100%" style="line-height:35px;">
	           <tr style="height:35px;">
	           	<th width="10%" align="center">Plan</th>
	           	<th width="1%">|</th>
				<th width="10%">Batch</th>
				<th width="1%">|</th>
				<th width="8%">Unit</th>
				<th width="1%">|</th>
				<th width="10%">Sign</th>
				<th width="1%">|</th>
				<th width="17%">Before Check (Pkg)</th>
				<th width="1%">|</th>
				<th width="15%">After Check (Pkg)</th>
				<th width="1%">|</th>
				<th width="15%">Difference (Pkg)</th>
	           </tr>
         </table>
       </div>
       <!-- table header end-->
       
       <!-- table list -->
       <div id="box" style="border:1px solid #ccc;">
         <table id="fatable" class="datatable" cellpadding="0" cellspacing="0" width="100%" style="line-height:normal">
           	<c:set var="totaldiff" value="0" scope="page"/>
           	<c:forEach var="item" items="${itemList}" varStatus="status">
				<tr style="height:30px;">
					<td width="10%" align="center">${item.planCode}</td>
					<td width="1%">&nbsp;</td>
					<td width="10%">${item.batchNo}</td>
					<td width="1%">&nbsp;</td>
					<td width="8%">
						<c:choose>
							<c:when test="${item.validNumber=='1' }">Trunk</c:when>
							<c:when test="${item.validNumber=='2' }">Box</c:when>
							<c:otherwise>
                                Pack
                           	</c:otherwise>
                        </c:choose>
					</td>
					<td width="1%">&nbsp;</td>
					<td width="10%">
						<c:choose>
							<c:when test="${item.validNumber=='1' }">
								${item.trunNo}
							</c:when>
							<c:when test="${item.validNumber=='2' }">
								${item.boxNo}
							</c:when>
							<c:otherwise>
                                ${item.packageNo}
                           	</c:otherwise>
                        </c:choose>
					</td>
					<td width="1%">&nbsp;</td>
					<td width="17%" align="right">${item.beforePkg}</td>
					<td width="2%">&nbsp;</td>
					<td width="15%" align="right">${item.afterPkg}</td>
					<td width="1%">&nbsp;</td>
					<c:choose>
						<c:when test="${item.diffPkg > 0 }">
							<td width="15%" align="right" style="color:green">${item.diffPkg}</td>
						</c:when>
						<c:when test="${item.diffPkg < 0 }">
							<td width="15%" align="right" style="color:red">${item.diffPkg}</td>
						</c:when>
						<c:otherwise>
                            <td width="15%" align="right" >${item.diffPkg}</td>
                       </c:otherwise>
                     </c:choose>
										
					<c:set value="${totaldiff + item.diffPkg}" var="totaldiff" />  
				</tr>
			</c:forEach>
        	<tr>
				<td colspan="13" align="right"> total difference ：${totaldiff} package</td>
			</tr>
			<tr>
		
				<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" style="margin-top:10px;">                    
                	<tr>
                  		<td style="padding-top:20px; " colspan="4" >Remarks :
                    	<textarea name="remarks" rows="5" readonly="readonly" class="textarea" >${vo.remark }</textarea></td>
                	</tr>
              	</table>
              	
            </tr>
        </table>
       </div>
       <!-- table list end-->
       
	</div>
		
 </div>
</div>

</html>
