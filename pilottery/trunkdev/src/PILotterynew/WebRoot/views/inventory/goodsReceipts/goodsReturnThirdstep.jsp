<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
	<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>无标题文档</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/views/inventory/goodsReceipts/js/TransCodeHandler.js"></script>
<link href="${basePath}/views/inventory/goodsReceipts/css/style3.css" rel="stylesheet" type="text/css" />
<style type="text/css">
body {
	margin: 0;
	padding: 0;
	margin: 0px;
	padding: 0px;
	font: 14px/20px "微软雅黑", Arial, Helvetica, sans-serif;
	background: #f2f1f1;
	width: 100%;
	height: 100%;
}
select {
	outline: none;
}
ul {
	list-style: none;
}
a {
	text-decoration: none;
}
</style>
<script type="text/javascript">

function prompt() {
	showDialog("submitInfo()","Confirm","Are you sure that you have completed?");
}

function submitInfo()
{
	switch_obj("okbton","waitBtn");
	$("#operType").val('3');
	$("#goodReceiptParamt").attr("action", "goodsReceipts.do?method=goodsReturnThird");
	$("#goodReceiptParamt").submit();
}

function findObj(id) {
	var obj = document.getElementById(id);
	return obj;
}
function switch_obj(btnId1, btnId2) {
	var btnObj1 = findObj(btnId1);
	btnObj1.style.display = "none";
	var btnObj2 = findObj(btnId2);
	btnObj2.style.display = "inline";
}
</script>
</head>

<body>
<form method="post" action=""  id="goodReceiptParamt" name="goodReceiptParamt" >
<input type="hidden" name="sgrNo" value="${sgrNo}">
<input type="hidden" name="planCode" value="${planCode}">
<input type="hidden" name="batchNo" value="${batchNo}">
<input type="hidden" name=returnNo value="${returnNo}">

<input type="hidden" name="operType" value="3">
<div id="container"> 
  <!--header-->
  <div class="header"><!--用户信息区开始--><!--用户信息区结束-->
    <div id="title">Return Delivery Order</div>
  </div>
  <!--header end--> 
  <!--开奖开始-->
  <div id="main"> 
   <div class="jdt">
      <img src="views/inventory/goodsReceipts/images/jdt4_3.png" width="1000" height="30" />
      <div class="xd"><span class="zi" >1.Select Goods Receipt</span><span class="zi" >2.Scan Goods Receipt</span><span class="zi" >3.Complete Goods Receipt</span><span >4.Summary Goods Receipt</span></div></div>
    <div class="bd">
      <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          
          <td  ><div class="tab">
              <div class="tabn">
                <table  border="0"  cellpadding="0" cellspacing="0" width="100%;" valign="top">
                
                
                  <tr>
                    <td >
                    
                       <div style="position:relative; z-index:1000px;  ">
                       <table  class="datatable" cellpadding= "0 " cellspacing= "0 " id="table1_head" width="100%" >
                          <tr>
                            <th width="10%" >Plan Code</th>
                            <th width="1%" >|</th>
                            <th width="10%" >Plan</th>
                            <th width="1%" >|</th>
                            <th width="10%" >Deliverable</th>
                            <th width="1%" >|</th>
                            <th width="10%" >Delivered </th>
                            <th width="1%" >|</th>
                            <th width="10%" >Differences</th>
                          </tr>
                        </table>
                      </div>
                       <div id="planbox" style="border:1px solid #ccc;">
                        <table class="datatable" id="planBoxTable" cellpadding= "0 " cellspacing= "0 " id="table1_body" width="100%" >
                          <c:forEach var="vo" items="${listvo}"  varStatus="status">
                          <tr>
                              <td width="10%">${vo.planCode}</td>
                              <td width="1%" >&nbsp;</td>
                               <td width="10%">${vo.planName}</td>
                              <td width="1%" >&nbsp;</td>
                              <td width="10%"><fmt:formatNumber value='${vo.receivableTickets}' type='number' /></td>
                              <td width="1%" >&nbsp;</td>
                               <td width="10%" ><fmt:formatNumber value='${vo.receivabedTickets}' type='number' /></td>
                              <td width="1%" >&nbsp;</td>
                              <td width="10%" style="color:#F00;"><fmt:formatNumber value='${vo.diff}' type='number' /></td>
                              
                            
                         </tr>
                         
                           </c:forEach>
                      
                        </table>
                        </div>
                    
                    </td>
                  </tr>
                  <tr>
                    <td><div style="margin:10px 30px; float:right;">
                            
                            <button class="gl-btn2" type="button" id="okbton" onclick="prompt();">Complete</button>
                             <img id="waitBtn"  class="gl-btn2"  style="display:none" src="views/inventory/goodsReceipts/images/wait.gif" height="25px" width="35px"/>
                      </div></td>
                  </tr>
                </table>
              </div>
            </div></td>
         
        </tr>
      </table>
    </div>
   
  </div>
  <!--开奖结束--> 
  
</div>
</form>
</body>
</html>
