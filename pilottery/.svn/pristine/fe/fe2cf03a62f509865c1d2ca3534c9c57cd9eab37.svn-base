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
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
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
	var val=$('#doNo').val();
	
	initData(val);
	  $("#doNo").change(function() { 
		  var val=$('#doNo').val();
			initData(val);
	  });
	  $("#okbtn").click(function() { 
		if($('#doNo').val()==''){
			showError('选择出货单编号');
			
			return;
		}
	
			$('#goodIssuesParamt').submit();
	  });
});
function initData(val){
		var url="goodsIssues.do?method=getSaleDeliverOrderDetailList&doNo=" + val;
		  var sum=0;
		 
				$.ajax({
					url : url,
					dataType : "json",
					async : false,
					success : function(data){
						var r = data.detaiList;
						var info = data.orderInfo;
				          $("#box").empty();
				          $("#labnos").empty();
				          var html='';
				          html+='<table class="datatable"  cellpadding= "0 " cellspacing= "0 " id="table1_body" width="100%" >';
				          for(var i = 0; i < r.length; i++) { 
				        	  sum=sum+r[i].amount;
				        	  html+='<tr><td  width="20%">'+r[i].planCode+'</td>'; 
				        	  html+='<td  width="1%">&nbsp;</td>';
				        	  html+='<td  width="20%" style="text-align:left">'+r[i].planName+'</td>';
				        	  html+='<td  width="1%">&nbsp;</td>';
				        	  html+=' <td  width="20%" style="text-align:left">'+formatNumber(r[i].tickets)+'</td>';
				        	  html+='<td  width="1%">&nbsp;</td>';
				        	  html+='<td  width="20%" style="text-align:right">'+formatNumber(r[i].amount)+'</td></tr>'
	                      }
				          $("#box").html(html);
				          $("#labnos").html(formatNumber(sum));

				          if(info){
					          $("#info1").text('申请人: ');
					          $("#info2").text(info.applyAdminName);
					          $("#info3").text('出货单位: ');
					          $("#info4").text(info.orgName);
					          $("#info5").text(info.applyTime);
					          //$('#info').append("Submitted by: "+info.applyAdminName+"&nbsp;&nbsp;&nbsp;&nbsp;Application unit: "+info.orgName+"&nbsp;&nbsp;&nbsp;&nbsp;Application time: "+info.applyTime);
				          }else{
				        	  $("#info1").text('');
					          $("#info2").text('');
					          $("#info3").text('');
					          $("#info4").text('');
					          $("#info5").text('');
				          }
				}
				});
				
				
}

function getStrlen(str){
    var realLength = 0, len = str.length, charCode = -1;
    for (var i = 0; i < len; i++) {
        charCode = str.charCodeAt(i);
        if (charCode >= 0 && charCode <= 128) realLength += 1;
        else realLength += 2;
    }
    return realLength;
}

function checkNotnull(value){
	
	if(value!=''){
		return true;
	}

	return false;
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
<form method="post" action="goodsIssues.do?method=issueByDeliveryFirstStep" id="goodIssuesParamt">
 <input type="hidden" name="operType" value="1">
<div id="container"> 
  <!--header-->
  <div class="header"><!--用户信息区开始--><!--用户信息区结束-->
    <div id="title">出货单出库</div>
  </div>
  <!--header end--> 
  <!--开奖开始-->
  <div id="main"> 
  <div class="jdt">
      <img src="views/inventory/goodsReceipts/images/jdt4_1.png" width="1000" height="30" />
      <div class="xd-cn"><span class="zi">1.选择出库物品</span><span>2.扫描出库物品</span><span>3.完成出库</span><span>4.统计出库物品</span></div></div>
    <div class="bd">
      <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          
          <td ><div class="tab">
              <div class="tabn" >
                <table  border="0"  cellpadding="0" cellspacing="0" width="100%;" valign="top">
                  
                  <tr>
                    <td style="border-bottom:1px solid #ccc; padding-bottom:10px;"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" style="margin-top:10px; ">
                        <tr>
                         
                          <td  class="lz1">出货单编码:</td>
                          <td ><select name="doNo" id="doNo" class="select-big">
                              <option value=""></option>
                              <c:forEach items ="${salList}"  var ="db">
                                   <option value="${db.doNo}">${db.doNo }</option>
                              </c:forEach>
                            </select></td>
                            <td class="lz1" id="info1">提交人: </td>
                            <td id="info2">tl总部市场</td>
                            <td class="lz1" id="info3">申请单位:</td>
                            <td id="info4">KPW Headquarter</td>
                            <td id="info5">2015-11-25 12:02:06</td>
                          <td align="left">
                            
                            
                            </td>
                          
                        </tr>
                     
                       
                       
                      </table></td>
                  </tr>
                  <tr>
                    <td ><!--列表开始-->
                      
                      <div class="nr">
                        <div class="title-mbx">出货列表</div>
                      </div>
                      <div  style="padding:0 20px; margin-top:15px; ">
                      <div  style="border:1px solid #ccc;">
                         <table  class="datatable"  id="table1_head" width="100%" >
                          <tr>
                            <th width="20%"  align="left">方案编码</th>
                            <th width="1%">|</th>
                            <th width="20%"  align="left">方案名称</th>
                            <th width="1%">|</th>
                            <th  width="20%"  align="left">数量(张)</th>
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
                      金额 :<span class="lz2" id="labnos"></span>瑞尔 
                      </div></td>
                       </tr>
                  <tr>
                       <td colspan="4"> 
                       <div style="margin:10px 20px; float:right;">
                       <button class="gl-btn2" type="button" id="okbtn" style="display:block">下一步</button>
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
