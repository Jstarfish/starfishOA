<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
	<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>无标题文档</title>

 <script type="text/javascript" src="${basePath}/js/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
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

ul {
	list-style: none;
}
a {
	text-decoration: none;
}
</style>
<script type="text/javascript">

$(document).ready(function(){
	  $("#returnNo").change(function() { 
		  var val=$('#returnNo').val();
			initData(val);
	  });
});
 function initData(val){
	 var url="goodsReceipts.do?method=getReturnDitalList&returnNo=" + val;
	  
	 
		$.ajax({
			url : url,
			dataType : "json",
			async : false,
			success : function(r){
		          $("#box").empty();
		           var attr=r.rows;
		          var html='';
		          html+='<table class="datatable"  cellpadding= "0 " cellspacing= "0 " id="table1_body" width="100%" >';
		          for(var i = 0; i < attr.length; i++) { 
		        	
		        	  html+='<tr><td  width="20%">'+attr[i].planCode+'</td>'; 
		        	  html+='<td  width="1%">&nbsp;</td>';
		        	  html+='<td  width="20%" style="text-align:left">'+attr[i].planName+'</td>';
		        	  html+='<td  width="1%">&nbsp;</td>';
		        	  html+=' <td  width="20%" style="text-align:left">'+formatNumber(attr[i].tickets)+'</td>';
		        	  html+='<td  width="1%">&nbsp;</td>';
		        	  html+='<td  width="20%" style="text-align:right">'+formatNumber(attr[i].amount)+'</td></tr>'

                  }
		          
		          $("#marketManager").val(r.marketManager);
		        
		          $("#box").html(html);
		}
		});
 }

function onSubmit(){
	if($('#returnNo').val()==''){
		showError('选择还货单号!');
		
		return ;
	}
	
		
		$("#goodReceiptParamt").submit();
	

}

function formatNumber(num, precision, separator) {
    var parts;
    // 判断是否为数字
    if (!isNaN(parseFloat(num)) && isFinite(num)) {
        // 把类似 .5, 5. 之类的数据转化成0.5, 5, 为数据精度处理做准, 至于为什么
        // 不在判断中直接写 if (!isNaN(num = parseFloat(num)) && isFinite(num))
        // 是因为parseFloat有一个奇怪的精度问题, 比如 parseFloat(12312312.1234567119)
        // 的值变成了 12312312.123456713
        num = Number(num);
        // 处理小数点位数
        num = (typeof precision !== 'undefined' ? num.toFixed(precision) : num).toString();
        // 分离数字的小数部分和整数部分
        parts = num.split('.');
        // 整数部分加[separator]分隔, 借用一个著名的正则表达式
        parts[0] = parts[0].toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1' + (separator || ','));

        return parts.join('.');
    }
    return NaN;
}
</script>
</head>

<body>
<form method="post" action="goodsReceipts.do?method=goodsRetrurnFirst"  id="goodReceiptParamt" name="goodReceiptParamt" >

<input type="hidden" name="operType" value="1">
<div id="container"> 
  <!--header-->
  <div class="header"><!--用户信息区开始--><!--用户信息区结束-->
    <div id="title">还货单入库</div>
  </div>
  <!--header end--> 
  <!--开奖开始-->
  <div id="main"> 
   <div class="jdt">
      <img src="views/inventory/goodsReceipts/images/jdt4_1.png" width="1000" height="30" />
      <div class="xd-cn"><span class="zi">1.选择货物</span><span >2.扫描货物</span><span >3.完成收货</span><span>4.汇总货物</span></div></div>
    <div class="bd">
      <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
         
          <td><div class="tab">
              <div class="tabn">
                <table  border="0"  cellpadding="0" cellspacing="0" width="100%;" valign="top">
                  
                  <tr>
                    <td><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" style="margin-top:10px; ">
                        <tr>
                      
                          <td width="16%"  class="lz1">还货单号 :</td>
                          <td width="20%" ><select name="returnNo" id="returnNo" class="select-big">
                              <option value=""></option>
                              <c:forEach items ="${returnList}"  var ="recordal">
                                   <option value="${recordal.returnNo }">${recordal.returnNo }</option>
                              </c:forEach>
                            </select></td>
                             <td width="16%"  class="lz1">交货人</td>
                            <td width="21%"  ><input type="text" name="marketManager" id="marketManager" class="text-big-noedit"></td>
                           
                        </tr>

                       
                      
                      </table></td>
                  </tr>
                  <tr>
                  <td>
                          <div class="nr" style="width:90%;">
                        <div class="title-mbx"> </div>
                      </div>
                      <div  style="padding:0 20px; margin-top:15px; ">
                      <div  style="border:1px solid #ccc;">
                         <table  class="datatable"  id="table1_head" width="100%" >
                          <tr>
                            <th width="20%"  align="left">方案编码</th>
                            <th width="1%">|</th>
                            <th width="20%"  align="left">方案名称</th>
                            <th width="1%">|</th>
                            <th  width="20%"  align="left">票数(张)</th>
                            <th width="1%" >|</th>
                            <th width="20%"  align="left">金额(瑞尔)</th>
                            
                          </tr>
                        </table>
                      </div>
                      <div id="box" style="border:1px solid #ccc;">
                        <table class="datatable"  cellpadding= "0 " cellspacing= "0 " id="table1_body" width="100%" >
                    
                        </table>
                        </div>
              </div>
                  </td>
                  </tr>
                  
                 <tr>
                       <td colspan="4"> 
                       <div style="margin:10px 20px; float:right;">
                       <button class="gl-btn2" type="button" onclick="onSubmit()" style="display:block">下一步</button>
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
