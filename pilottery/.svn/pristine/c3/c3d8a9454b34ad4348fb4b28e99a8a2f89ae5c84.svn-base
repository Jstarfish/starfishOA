<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
	<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>无标题文档</title>
<script type="text/javascript" src="${basePath}/views/inventory/goodsReceipts/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
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

$(document).ready(function(){
	  $("#okbcont").click(function() { 
		  $("#operType").val('2');
			$("#goodIssuesParamt").attr("action", "goodsIssues.do?method=goodsIssuesStockNext");
			$("#goodIssuesParamt").submit();
	  });
	  
});

function prompt() {
	showDialog("submitInfo()","确认","你确定你已经完成了吗？");
}

function submitInfo()
{
	switch_obj("okbcompl","waitBtn");
	$("#operType").val('3');
	$("#goodIssuesParamt").attr("action", "goodsIssues.do?method=goodsIssuesStockThird");
	$("#goodIssuesParamt").submit();
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
<form method="post" action=""  id="goodIssuesParamt" name="goodIssuesParamt" >
<input type="hidden" name="operType" id="operType" value="">
<input type="hidden" name="sgiNo" id="sgiNo" value="${goodIssuesParamt.sgiNo}">
<input type="hidden" name="receivableAmount" id="receivableAmount" value="${receivableAmount}">
<input type="hidden" name="differencesAmount" id="differencesAmount" value="${differencesAmount}">
<input type="hidden" name="receivabedAmount" id="receivabedAmount" value="${receivabedAmount}">
 <input type="hidden" name="receivingUnit" id="receivingUnit" value="${goodIssuesParamt.receivingUnit}" >
 <input type="hidden" name="deliveringUnit" id="deliveringUnit" value="${goodIssuesParamt.deliveringUnit}">
 <input type="hidden" name="sbtNo" id="sbtNo" value="${goodIssuesParamt.sbtNo}">
<div id="container"> 
  <!--header-->
  <div class="header"><!--用户信息区开始--><!--用户信息区结束-->
    <div id="title">调拨单出库</div>
  </div>
  <!--header end--> 
  <!--开奖开始-->
  <div id="main">
    <div class="jdt"> <img src="views/inventory/goodsReceipts/images/jdt4_3.png" width="1000" height="30" />
      <div class="xd-cn"><span class="zi">1.选择出库物品</span><span class="zi">2.扫描出库物品</span><span class="zi">3.完成出库</span><span>4.统计出库物品</span></div>
    </div>
    <div class="bd">
      <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><div class="tab">
              <div class="tabn">
                <table  border="0"  cellpadding="0" cellspacing="0" width="100%;" valign="top">
                  <tr>
                    <td style="border-bottom:1px solid #ccc;  padding-bottom:10px;"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" style="margin-top:10px; ">
                        <tr>
                          <td>调拨单编码 : <span class="lz2"> ${goodIssuesParamt.sgiNo }</span></td>
                        </tr>
                      </table></td>
                  </tr>
                  <tr>
                    <td >
                        <div style="position:relative; z-index:1000px;  ">
                       <table  class="datatable" cellpadding= "0 " cellspacing= "0 " id="table1_head" width="100%" >
                          <tr>
                            <th width="10%" >方案编码</th>
                            <th width="1%" >|</th>
                            <th width="10%" >方案名称</th>
                            <th width="1%" >|</th>
                            <th width="10%" >应出库数量</th>
                            <th width="1%" >|</th>
                            <th width="10%" >实际出库数量 </th>
                            <th width="1%" >|</th>
                            <th width="10%" >差异</th>
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
                    <td><div style="margin:10px 40px; float:right;">
                    <c:if test="${differencesAmount>0 }">
                    <button class="gl-btn2" type="button" id="okbcont">继续</button>
                    </c:if>
                   
                        <button class="gl-btn2" type="button" id="okbcompl" onclick="prompt();">完成</button>
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
