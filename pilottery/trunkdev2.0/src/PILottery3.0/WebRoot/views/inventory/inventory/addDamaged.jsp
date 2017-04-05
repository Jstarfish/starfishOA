<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title></title>

<%@ include file="/views/common/meta.jsp"%>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet"	href="${basePath}/component/messageBox/myJsBox.css" type="text/css" />
<script type="text/javascript"	src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript"	src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript"	src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<style>
body{
	font-family:"微软雅黑";}
.datatable {
	border-collapse: collapse;
	background: #fff;
	font-family: "微软雅黑";
	font-size: 12px;
}
.datatable img {
	line-height: 20px;
	vertical-align: middle;
	display:block;
}
.datatable th {
	background-color: #2aa1d9;
	height: 35px;
	line-height: 35px;
	color: #fff;
	text-align: left;
	padding-left: 10px;
}
.datatable td {
	border-bottom: 1px solid #e4e5e5;
	height: 35px;
	line-height: 35px;
	text-align: left;
	padding-left: 10px;
}
.datatable caption {
	color: #33517A;
	padding-top: 3px;
	padding-bottom: 8px;
}
.datatable tr:hover, .datatable tr.hilite {
	background-color: #f3f4f4;
	color: #000000;
}
</style>
<script type="text/javascript">

</script>

</head>
<body style="text-align:center">
	<form  id="editForm" method="post" action="delivery.do?method=saveDeliveryOrder">
		<div class="pop-body">
		<div style="padding:0 20px; margin-top:15px; ">
                 <div style="position:relative; z-index:1000px;">
                   <table class="datatable" id="table1_head" width="100%">
                     <tbody><tr>
                       <th width="5%">&nbsp;</th>
                       <th width="15%">Plan Code</th>
                       <th width="5%">|</th>
                       <th width="15%">Plan Name</th>
                       <th width="5%">|</th>
                       <th width="15%">Batch No</th>
                       <th width="5%">|</th>
                       <th width="15%">Value(riels)</th>
                     </tr>
                   </tbody></table>
                 </div>
                 <div id="box" style="border:1px solid #ccc;">
                   <table id="oltable" class="datatable" cellpadding="0" cellspacing="0" width="100%">
                     <tbody>
                      <c:forEach var="item"	items="${orderList}" varStatus="i">
	                     <tr>
	                       <td style="width:5%">
	                       		<input type="checkbox" name="doRelation[${i.index}].orderNo" onchange="sumPlan(this,'${item.orderNo}');">
	                       		
	                       </td>
	                       <td style="width:20%">${item.orderNo}</td>
	                       <td style="width:5%">&nbsp;</td>
	                       <td style="width:20%"><fmt:formatDate value="${item.applyDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
	                       <td style="width:5%">&nbsp;</td>
	                       <td style="width:20%">${item.applyTickets}</td>
	                       <td style="width:5%">&nbsp;</td>
	                       <td style="width:20%"><fmt:formatNumber value="${item.applyAmount}" /></td>
	                     </tr>
                     </c:forEach>
                   </tbody></table>
                 </div>
			<table width="100%" border="0" cellspacing="0" cellpadding="0"	height="80px"  style="margin-top:25px; ">
				 <tr>
                    <td ><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" style="margin-top:10px;">

                        <tr>
                          <td style="padding-top:20px; " colspan="4" >Remarks :
                            <textarea name="remarks" rows="5" class="edui-editor1" value="填写1-500字符间，非必填项" onfocus="if(this.value=='填写1-500字符间，非必填项'){this.value='';}"  onblur="if(this.value==''){this.value='填写1-500字符间，非必填项';}"></textarea></td>
                        </tr>
                      </table></td>
                  </tr>
			</table>
			
                 
               
           
      
              
           </div>
		</div>
		<div class="pop-footer" style="margin-top: 30px">
				<input id="okBtn" type="submit" value="Submit" class="button-normal"></input>&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="Reset" value="Reset" class="button-normal"></input>
		</div>
	</form>

</body>
</html>