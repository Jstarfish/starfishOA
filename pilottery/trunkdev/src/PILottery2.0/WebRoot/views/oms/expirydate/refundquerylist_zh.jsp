<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>区域列表</title>
<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />

<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>

<style type="text/css">

</style>
 



<script type="text/javascript" charset="UTF-8" > 

function submit(){
	
	
	$("#saleCancelInfoForm").submit();
}

</script>

</head>
<body>
 <div id="title">退票记录查询  </div>

    <div class="queryDiv">
      <form:form modelAttribute="saleCancelInfoForm" action="refundquery.do?method=list">
         
            <div class="left">                      

                     <span>操作员用户：<form:input path="canceler" maxlength="20" class="text-normal"/></span>
                      <span>
                     日期: <input id="satrtcancelTime" name="satrtcancelTime" value="${satrtcancelTime }" class="Wdate" type="text" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'endcancelTime\')}'})"/> 
						-
			   	<input id="endcancelTime" class="Wdate " value="${endcancelTime}" name="endcancelTime" type="text"  onFocus="WdatePicker({minDate:'#F{$dp.$D(\'satrtcancelTime\')}'})"/>
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
						<td style="width:7%" >操作员</td> 
						<th width="1%">|</th>
						<td style="width:7%" >操作时间</td>
						<th width="1%">|</th>
						<td style="width:7%" >彩票TSN</td> 
						<th width="1%">|</th>
						<td style="width:7%" >退票游戏</td>
						<th width="1%">|</th>
						<td style="width:7%" >退票结果</td> 
						<th width="1%">|</th>
						<td style="width:7%" >退票金额</td> 
						<th width="1%">|</th>
						<td style="width:7%" >退票TSN</td> 
						<th width="1%">|</th>
						<td style="width:7%" >退票销售站</td>
						<th width="1%">|</th>
						<td style="width:7%" >扣除佣金</td>
						<th width="1%">|</th>
						<td style="width:*%">操作</td>
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
				<td style="width:7%">${data.canceler}</td>
				<td width="1%">&nbsp;</td>
				<td style="width:7%"><fmt:formatDate value="${data.cancelTime}"  pattern="yyyy-MM-dd HH:mm"/></td>
				<td width="1%">&nbsp;</td>
				<td style="width:7%" >${data.saleTsn}</td>
				<td width="1%">&nbsp;</td>
				<td style="width:7%">${data.gameName}</td>
				<td width="1%">&nbsp;</td>
				<td style="width:7%">
					<c:if test="${data.isSuccess==0}">
							成功
					</c:if>
				</td>
				<td width="1%">&nbsp;</td>
				<td style="width:7%" align="right"><fmt:formatNumber value="${data.cancelAmount}" type="number"/></td>
				<td width="1%">&nbsp;</td>
				<td style="width:7%">${data.cancelTsn}</td>
				<td width="1%">&nbsp;</td>
				<td style="width:7%">${data.saleAgencyCode}</td>
				<td width="1%">&nbsp;</td>
				<td style="width:7%" align="right"><fmt:formatNumber value="${data.cancelComm}" type="number"/></td>
				<td width="1%">&nbsp;</td>
				<td style="width: *%">
				<a href="#" onclick="showPage('refundquery.do?method=cancelInfoPrint&id=${data.id}','打印')">打印</a>
				</td>
			</tr>
		</c:forEach>
        </table>
        ${pageStr }
    </div>

</body>
</html>