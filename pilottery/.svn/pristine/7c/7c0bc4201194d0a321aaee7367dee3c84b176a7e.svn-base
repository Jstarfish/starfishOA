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
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<script type="text/javascript" src="${basePath}/js/myJs.js"></script>
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
<script>


 $(document).ready(function(){
	  $("#okButton").click(function() { 
			
		  switch_obj("okButton","waitBtn");
			$('#goodReceiptParamt').submit();
	  });
});

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
<form method="post" action="goodsReceipts.do?method=goodsTransterForth"  id="goodReceiptParamt" name="goodReceiptParamt" >
<input type="hidden" name="sgrNo" value="${goodReceiptParamt.sgrNo}">
<input type="hidden" name="planCode" value="${goodReceiptParamt.planCode}">
<input type="hidden" name="batchNo" value="${goodReceiptParamt.batchNo}">
<input type="hidden" name="stbNo" id="stbNo" value="${goodReceiptParamt.stbNo}">
<input type="hidden" name="operType" value="${goodReceiptParamt.operType}">
<input type="hidden" name="receivableAmount" value="${goodReceiptParamt.receivableAmount}">
<input type="hidden" name="differencesAmount" value="${differencesAmount}">
<div id="container"> 
  <!--header-->
  <div class="header"><!--用户信息区开始--><!--用户信息区结束-->
    <div id="title">调拨单入库</div>
  </div>
  <!--header end--> 
  <!--开奖开始-->
  <div id="main">
    <div class="jdt"> <img src="views/inventory/goodsReceipts/images/jdt4_4.png" width="1000" height="30" />
     <div class="xd"><span class="zi">1.选择货物</span><span class="zi">2.扫描货物</span><span class="zi">3.完成收货</span><span class="zi">4.汇总货物</span></div>
    </div>
        <div class="bd">
      <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          
          <td ><div class="tab" >
              <div class="tabn">
                <table  border="0"  cellpadding="0" cellspacing="0" width="100%" valign="top">
                
                  <tr>
                    <td>
                    <div style="margin-bottom:20px;"><span class="dazit" style="font-size:18px;">调拨单编码 :<span class="hz1">${stbNo}</span></span></div>
                       
                      <div class="nr">
                       
                     
                           <div style="position:relative; z-index:1000px;  ">
                       <table  class="datatable" cellpadding= "0 " cellspacing= "0 " id="table1_head" width="100%" >
                          <tr>
                            <th width="10%" >方案名称</th>
                            <th width="1%" >|</th>
                            <th width="10%" >方案名称</th>
                            <th width="1%" >|</th>
                            <th width="10%" >应入库</th>
                            <th width="1%" >|</th>
                            <th width="10%" >实际入库 </th>
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
                       </div>
                      <!--列表开始-->
                      
                   <c:if test="${differencesAmount>0}">
                      <div  style="padding:0 20px; margin-top:15px; ">
                   
                      <div id="box" style="border:1px solid #ccc;">
                        <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" style="margin-top:10px;">
                        
                      
                        <tr>
                          <td style="padding-top:20px; " colspan="4" >备注 :
                            <textarea name="remarks" rows="5" class="edui-editor1" value="填写1-500字符，非强制性" onfocus="if(this.value=='填写1-500字符，非强制性'){this.value='';}"  onblur="if(this.value==''){this.value='填写1-500字符，非强制性';}"></textarea></td>
                        </tr>
                      
                      </table>
              </div>
              </div>
                </c:if>
              <!--列表结束-->
                      
                      <div style="margin-top:10px;  float:right; padding:0 20px;">
                       <button class="gl-btn2" type="button" onclick="showPage('goodsReceipts.do?method=printTranstr&refNo=${goodReceiptParamt.stbNo}','打印')">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr>
                              <td><img src="views/inventory/goodsReceipts/images/printx.png" width="18" height="25"   /></td>
                            <td style="color: #fff;font-size: 14px;">打印</td>
                          </tr>
                        </table>
                        </button>
                         <button class="gl-btn2" id="okButton" type="button" >完成</button>
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
   
  </div>
  <!--开奖结束--> 
  </form>
</body>
</html>