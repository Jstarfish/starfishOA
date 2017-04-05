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
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
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
	  $("#okbcent").click(function() { 
		  $("#operType").val('2');
			$("#goodReceiptParamt").attr("action", "goodsReceipts.do?method=goodsReceiptNext");
			$("#goodReceiptParamt").submit();
	  });
	  
});

function prompt() {
	showDialog("submitInfo()","Confirm","Are you sure that you have completed?");
}

function submitInfo()
{
	switch_obj("okbcompl","waitBtn");
	$("#operType").val('3');
	$("#goodReceiptParamt").attr("action", "goodsReceipts.do?method=goodsReceiptThird");
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
<input type="hidden" name="operType" id="operType" value="">
<input type="hidden" name="warehouseCode" value="${warehouseCode}"/>
<div id="container"> 
  <!--header-->
  <div class="header"><!--用户信息区开始--><!--用户信息区结束-->
    <div id="title">Goods Receipt by Batch</div>
  </div>
  <!--header end--> 
  <!--开奖开始-->
  <div id="main">
    <div class="jdt"> <img src="views/inventory/goodsReceipts/images/jdt4_3.png" width="1000" height="30" />
      <div class="xd"><span class="zi">1.Select Goods Receipt</span><span class="zi">2.Scan Goods Receipt</span><span class="zi">3.Complete Goods Receipt</span><span>4.Summary Goods Receipt</span></div>
    </div>
    <div class="bd">
      <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td  ><div class="tab">
              <div class="tabn" >
                <table  border="0"  cellpadding="0" cellspacing="0" width="100%;" valign="top">
                  <tr>
                    <td ><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" style="margin-top:30px;">
                        <tr>
                          <td width="13%" >Plan code :</td>
                          <td width="23%"><span class="lz2">${planCode}</span></td>
                          
                          <td width="10%" >Batch : </td>
                          <td width="20%"><span class="lz2">${batchNo}</span></td>
                        </tr>
                        <tr>
                          <td >Receivable : </td>
                          <td><span class="lz2"><fmt:formatNumber value='${sumAmount}'  type='number'/></span>tickets</td>
                          
                          <td>Received : </td>
                          <td><span class="lz2"><fmt:formatNumber value='${receivableAmount}'  type='number'/></span>tickets</td>
                        </tr>
                         <tr>
                          
                          
                          <td class="hoz">Differences : </td>
                          <td><span class="lz2"><fmt:formatNumber value='${differencesAmount}'  type='number'/></span>tickets</td>
                          <td ></td>
                          <td></td>
                        </tr>
                      </table></td>
                  </tr>
                  <tr>
                    <td><div style="margin:10px 30px; float:right;">
                        <c:if test="${differencesAmount>0}">
                        <button class="gl-btn2" type="button" id="okbcent">Continue</button>
                        </c:if>
                        
                        <button class="gl-btn2" type="button" id="okbcompl" onclick="prompt();">Complete</button>
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