<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
	<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>无标题文档</title>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
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
<script>
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

$(document).ready(function(){
	  $("#okbtn").click(function() { 
			 
		  switch_obj("okbtn","waitBtn");
			$('#goodReceiptParamt').submit();
	  });
});


</script>
</head>

<body>
<form method="post" action="goodsReceipts.do?method=goodsReceiptForth"  id="goodReceiptParamt" name="goodReceiptParamt" >
<input type="hidden" name="sgrNo" value="${goodReceiptParamt.sgrNo}">
<input type="hidden" name="planCode" value="${goodReceiptParamt.planCode}">
<input type="hidden" name="batchNo" value="${goodReceiptParamt.batchNo}">
<input type="hidden" name="operType" value="3">
<input type="hidden" name="receivableAmount" value="${receivableAmount}">
<input type="hidden" name="differencesAmount" value="${differencesAmount}">
<div id="container"> 
  <!--header-->
  <div class="header"><!--用户信息区开始--><!--用户信息区结束-->
    <div id="title">Goods Receipt by Batch</div>
  </div>
  <!--header end--> 
  <!--开奖开始-->
  <div id="main">
    <div class="jdt"> <img src="views/inventory/goodsReceipts/images/jdt4_4.png" width="1000" height="30" />
      <div class="xd"><span class="zi">1.Select Goods Receipt</span><span class="zi">2.Scan Goods Receipt</span><span class="zi">3.Complete Goods Receipt</span><span class="zi">4.Summary Goods Receipt</span></div>
    </div>
    <div class="bd">
      <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td  ><div class="tab">
              <div class="tabn">
                <table  border="0"  cellpadding="0" cellspacing="0" width="100%" valign="top">
                  <tr>
                    <td ><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" style="margin-top:30px;">
                        <tr >
                          <td width="36%"  style="border-bottom:1px dashed #ccc; padding-bottom:15px;" class="hoz">Differences :<span class="lz2"><fmt:formatNumber value="${differencesAmount}"  type="number"/> </span>tickets</td>
                          <td width="64%" style="border-bottom:1px dashed #ccc; padding-bottom:15px;">&nbsp;</td>
                        </tr>
                        <tr>
                          <td colspan="2"><div id="djxs">
                              <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0" style="margin-top:10px;">
                                <tr>
                                <td >Plan Code :<span class="lz2"> ${goodReceiptParamt.planCode}</span></td>
                                
                                <td  >Batch :<span class="lz2"> ${goodReceiptParamt.batchNo}</span></td>
                                 
                                  <td  class="hoz">Quantity Damaged : <span class="lz2"><c:choose>
                                  <c:when test="${empty differencesAmount}">0</c:when>
                                  <c:otherwise><fmt:formatNumber value="${differencesAmount}"  type="number"/></c:otherwise>
                                  </c:choose></span>tickets</td>
                                  
                                </tr>
                                <c:if test="${differencesAmount>0}">
                                <tr>
                                  <td style="padding-top:20px; " colspan="4">Remarks:<br/>
                                    <textarea name="remarks" rows="5" class="edui-editor1" value="Fill in the 1-500 character, non mandatory" onfocus="if(this.value=='Fill in the 1-500 character, non mandatory'){this.value='';}"  onblur="if(this.value==''){this.value='Fill in the 1-500 character, non mandatory';}"></textarea></td>
                                </tr>
                                </c:if>
                              </table>
                            </div></td>
                        </tr>
                      </table></td>
                  </tr>
                  <tr>
                    <td><div style="margin:10px 40px; float:right;">
                      <button class="gl-btn2" type="button" onclick="showPage('goodsReceipts.do?method=print&refNo=${goodReceiptParamt.sgrNo}','Print')">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td ><img src="views/inventory/goodsReceipts/images/printx.png" width="18" height="25"/></td>
                            <td style="color: #fff;font-size: 14px;">Print</td>
                          </tr>
                        </table>
                        </button>
                        <button class="gl-btn2" type="button"  id="okbtn">Finish</button>
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
