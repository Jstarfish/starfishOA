<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>区域列表</title>
<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/city-list.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />

<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/city-list.js"></script>
<style type="text/css">

</style>
 

<script type="text/javascript" charset="UTF-8" > 

function submit(){
	
	
	$("#salegamepayinfoForm").submit();
}

</script>

</head>
<body>
  <div id="title">兑奖记录查询  </div>

    <div class="queryDiv">
  
       <form:form modelAttribute="salegamepayinfoForm" action="expirydate.do?method=list">
         
            <div class="left">                      

                     <span>操作员用户：<form:input path="payer" maxlength="20" class="text-normal"/></span>
                      <span>
                     时间:
                     开始<input id="startpayTime" name="startpayTime" value="${startpayTime }" class="Wdate" type="text" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'endpayTime\')}'})"/> 
						--
			   	 	结束<input id="endpayTime" class="Wdate " value="${endpayTime}" name="endpayTime" type="text"  onFocus="WdatePicker({minDate:'#F{$dp.$D(\'startpayTime\')}'})"/>
                     </span>
                   
                    <input type="button" value="查询" onclick="submit();" class="button-normal"></input>
      
            </div>
            <div class="right">
              <table width="260" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td align="right">
                   
                  </td>
                  <td style="width:30px"></td>
                  <td align="right">
                   
                  </td>
                  <td align="right">
                   
                  </td>
                </tr>
              </table>
            </div>
         </form:form>
    </div>
    <div id="headDiv">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr><td>
            <table class="datatable" id="exportPdf">
                <tr class="headRow">
                		<td style="width: 10px;">&nbsp;</td>
                      	<td style="width:15%" >兑奖记录编号</td>
                      	<th width="1%">|</th>
						<td style="width:10%" >操作员用户</td> 
                      	<th width="1%">|</th>
						<td style="width:10%" >申请时间</td> 
                      	<th width="1%">|</th>
						<td style="width:10%" >彩票TSN</td> 
                      	<th width="1%">|</th>
						<td style="width:10%" >兑奖游戏</td>
                      	<th width="1%">|</th>
				        <td style="width:7%" >兑奖结果</td> 
                      	<th width="1%">|</th>
						<td style="width:10%" >兑奖金额</td> 
                      	<th width="1%">|</th>
						<td style="width:*%" >操作</td>   
                        
                </tr>
            </table>
           </td><td style="width:17px;background:#2aa1d9"></td></tr>
       </table>
    </div>

    <div id="bodyDiv">
        <table class="datatable" id="exportPdfData">
            <c:forEach var="data" items="${pageDataList}" varStatus="status" >
			<tr class="dataRow">
				<td style="width: 10px;">&nbsp;</td>
				<td style="width:15%">${data.id}</td>
				<td width="1%">&nbsp;</td>
				<td style="width:10%">${data.payer}</td>
				<td width="1%">&nbsp;</td>
				<td style="width:10%"><fmt:formatDate value="${data.payTime}"  pattern="yyyy-MM-dd HH:mm"/></td>
				<td width="1%">&nbsp;</td>
				<td style="width:10%" >${data.saleTsn}</td>
				<td width="1%">&nbsp;</td>
				<td style="width:10%">${data.playName}</td>
				<td width="1%">&nbsp;</td>
				<td style="width:7%"><c:if test="${data.isSucess==0}">
						失败
					</c:if>
					<c:if test="${data.isSucess==1}">
						成功
					</c:if>
					</td>
				<td width="1%">&nbsp;</td>
				<td style="width:10%" align="right"><fmt:formatNumber value="${data.payAmount}" type="number"/></td>
								<td width="1%">&nbsp;</td>
				<td style="width:*%" class="no-print">
				<a href="#" onclick="showPage('centerSelect.do?method=printExpir&id=${data.id}','打印')">打印</a>
				</td>
			</tr>
		</c:forEach>
        </table>
        ${pageStr }
    </div>

</body>
</html>