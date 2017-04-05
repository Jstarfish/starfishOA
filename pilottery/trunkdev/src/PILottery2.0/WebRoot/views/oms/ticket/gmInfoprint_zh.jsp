<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link type="text/css" rel="stylesheet" href="${basePath}/views/oms/game-draw/css/myStyle.css" />
<script type="text/javascript" src="${basePath}/views/oms/game-draw/js/myJs.js"></script>
<link href="${basePath}/css/gm-st-css.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/print-button.css"/>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery.jqprint-0.3.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-migrate-1.2.1.min.js"></script>
<title>Delivery Issue Slip</title>
<style>
body {
	font-family:"Times New Roman",Times,serif,"微软雅黑";
}
</style>
<script type="text/javascript">
function exportPdf() {

	$("#printDiv").jqprint();
}
function check(){
	 var ss='${expirydateForm.carId }';
	
	var str=ss.substring (0,1)+" "+ss.substring (1,5)+" "+ss.substring (5,10)+" "+ ss.substring (10,12)+" "+ss.substring (12,13);
	$("#cadId").html(str);
	
	}
</script>
</head>

<body onload="check();">

<div style="margin:10px 70px; float:right;">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td align="right">
      
          <button class="report-print-button" type="button" onclick="exportPdf();">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr  height="50">
                              <td><img src="views/inventory/goodsReceipts/images/printx.png" width="18" height="17"   /></td>
                            <td style="color: #fff;">打印</td>
                          </tr>
                        </table>
                        </button>
      
      </td>
    </tr>
  </table>
</div>
<div id="printDiv">
<table width="1000"  cellspacing="0" cellpadding="0" align="center"  class="normal" style="margin:30px 20px 0px 60px;">
    <tr>
      <td colspan="3" align="right"><img src="views/inventory/goodsReceipts/images/KPW.jpg" width="170" height="55" /></td>
    </tr>
    <tr>
    <table width="1000" border="0" cellspacing="0" cellpadding="0" align="center"  class="normal">
    <tr>
   
			<td colspan="6" align="center" style="font-size:24px; line-height:50px;">兑奖领取单</td>
		</tr>
    
    
    <tr height="40">
      <td colspan="3"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td>兑奖记录编号：${id}</td>
            <td align="right">兑奖日期：${currdate}</td>
          </tr>
        </table></td>
    </tr>
     
    <tr>
      <td colspan="3" style="padding:20px 0;"><table width="1000" border="1" align="center" cellpadding="0" cellspacing="0"  class="normal">
          <tr align="center" height="80">
            
            <td width="126" >姓名</td>
            <td width="269" >${expirydateForm.name }</td>
            <td width="129" >证件号码</td>
            <td width="144" ><div id="cadId"></div></td>
            <td width="142" >彩票票号</td>
            <td width="176" >${expirydateForm.tsnquery}</td>
          </tr>
	
          <tr align="center"  height="50">
			
		 	 <td width="126">游   戏</td>
			    <td width="269">${expirydateForm.playname}</td>
			    <td width="129">游戏期号</td>
			    <td width="144">
			    <c:choose>
			      <c:when test="${empty expirydateForm.issuenumbrend}">
			      ${expirydateForm.issuenumber }
			      </c:when>
			      <c:when test="${!empty expirydateForm.issuenumbrend}">
			      <c:if test="${expirydateForm.issuenumber==expirydateForm.issuenumbrend}">
			       ${expirydateForm.issuenumber }
			      </c:if>
			      <c:if test="${expirydateForm.issuenumber!=expirydateForm.issuenumbrend}">
			      ${expirydateForm.issuenumber }-${expirydateForm.issuenumbrend}
			      </c:if>
			      </c:when>
			    </c:choose>
			    </td>
			    <td  width="142">销售站号</td>
			    <td  width="176">${expirydateForm.agencyCodeFormart}</td>
		</tr>
		<tr align="left" height="80">
            <td colspan="1" align="center">投注号码</td>
			<td colspan="5" align="center"><c:if test="${not empty lotteryReq.betlist}">
		         <c:forEach  var="bet" items="${lotteryReq.betlist}">
		             ${bet.bettingnumber}
		         </c:forEach>
		    </c:if></td>
          </tr>
          <tr align="center" height="80">
          
            <td>中奖等级</td>
            <td>中奖注数</td>
            <td>单注金额</td>
            <td>总中奖金额</td>
            <td>个人所得税</td>
            <td>实际奖金</td>
          </tr>
          <c:if test="${not empty lotteryReq.prizeDetail}">
 			 <c:forEach var="prize" items="${lotteryReq.prizeDetail}">
			  <tr align="center" height="80"> 
			    <td>${prize.name }</td>
			    <td>${prize.prizeCode }</td>
			    <td><fmt:formatNumber value="${prize.amountSingle}" pattern="#,###"/></td>
			    <td class="gm-sty-dj-right"><fmt:formatNumber value="${prize.amountBeforeTax}" pattern="#,###"/></td>
			    <td><fmt:formatNumber value="${prize.amountTax}" pattern="#,###"/></td>
			    <td class="gm-sty-dj-right"><fmt:formatNumber value="${prize.amountAfterTax}" pattern="#,###"/></td>
			  </tr>
		  </c:forEach>
		  </c:if>
          
          
			
         
			
			
          <tr align="left" height="80">
            <td colspan="5" style="padding:10px;">合计:</td>
            <td colspan="1" align="center" style="padding:10px;"><fmt:formatNumber value="${sumprize}" pattern="#,###"/></td>
          </tr>
		  <tr align="left" height="80">
            <td colspan="6" style="padding:10px;">备注：1.本领取单不盖章无效。</td>  
          </tr>
        </table></td>
    </tr>
  
    <tr height="40">
      <td width="103" align="left">领奖人签字:</td>
      <td width="897"><div style="border-bottom:1px solid;width:150px;">&nbsp;</div></td>
    </tr>
    <tr height="80">
      <td align="left">审核:</td>
      <td><div style="border-bottom:1px solid;width:150px;">&nbsp;</div></td>
    </tr>
    <tr height="80">
      <td align="left">领奖人：</td>
      <td><div style="border-bottom:1px solid;width:150px;">&nbsp;</div></td>
    </tr>
  </table>
    
    </tr>
    
</table>
</div>


</body>
</html>
