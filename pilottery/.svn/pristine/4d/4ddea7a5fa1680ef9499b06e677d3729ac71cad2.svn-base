<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>

<title>出库信息查询列表 (Lottery)</title>

<%@ include file="/views/common/meta.jsp" %>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/component/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

<script type="text/javascript" charset="UTF-8">
function updateQuery() {
    

    $("#goodsIssuesForm").attr("action","goodsIssues.do?method=listGoodsIssues");
   $("#goodsIssuesForm").submit();
}
function onNextGoodrecipts(val,type,refNo){

	if(type=='2'){
		$("#sgiNo").val(val);
		$("#doNo").val(refNo);
		$("#goodsIssuesForm").attr("action","goodsIssues.do?method=continueGoodsIssues&sgiNo="+val+"&refNo="+refNo);
	}
	if(type=='1'){
		$("#sgiNo").val(val);
		$("#stbNo").val(refNo);
		$("#goodsIssuesForm").attr("action","goodsIssues.do?method=continueGoodTranser&sgiNo="+val+"&refNo="+refNo);
	}

	$("#goodsIssuesForm").submit();
}
function doComplete(type,refNo,sgiNo){
	window.location.href="goodsIssues.do?method=completeGoodsIssues&type="+type+"&refNo="+refNo+"&sgiNo="+sgiNo;
}
</script>

</head>
<body>
    <!-- 顶部标题块 -->
    <div id="title">出库列表</div>
    
    <!-- 查询条件块 -->
    <div class="queryDiv">
       <form action="" id="goodsIssuesForm" method="post">
         <input type="hidden" name="sgiNo" value="" id="sgiNo" >
         <input type="hidden" name="stbNo" id="stbNo" >
         <input  type="hidden" name="doNo"  id="doNo">
          <input type="hidden" name="operType" id="operType" value="2">
            <div class="left">
                <span>出库单编号: <input id="sgiNo1" name="sgiNo1" class="text-normal" /></span>
                <span>出库时间:
                    <input id="sendDate" name="sendDate" class="Wdate text-normal" onfocus="WdatePicker({lang:'zh-cn',dateFmt:'yyyy-MM-dd',readOnly:true})"/>
                </span>
                
                <input type="button" value="查询" onclick="updateQuery();" class="button-normal"></input>
            </div>
        </form>
    </div>
    
    <!-- 列表表头块 -->
    <div id="headDiv">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <table class="datatable">
                        <tr class="headRow">
                        <td style="width:10px;">&nbsp;</td>
                            <td style="width:10%">出库单编号</td>
                              <td width="1%" >|</td>
                            <td style="width:10%">出库时间</td>
                              <td width="1%" >|</td>
                            <td style="width:12%">总数量(张)</td>
                              <td width="1%" >|</td>
                            <td style="width:12%">总金额(瑞尔)</td>
                              <td width="1%" >|</td>
                            <td style="width:10%">出库人</td>
                              <td width="1%" >|</td>
                            <td style="width:10%">出库类型</td>
                              <td width="1%" >|</td>
                            <td style="width:10%">状态</td>
                             <td width="1%" >|</td>
                            <td style="width:*%">操作</td>
                        </tr>
                    </table>
                 </td>
                 <!-- 表头和下方数据对齐 -->
                 <td style="width:17px;background:#2aa1d9"></td>
             </tr>
        </table>
    </div>
    
    <!-- 列表内容块 -->
    <div id="bodyDiv">
        <table class="datatable">
        <c:forEach var="data" items="${pageDataList}" varStatus="status" >
            <tr class="dataRow">
            <td style="width:10px;">&nbsp;</td>
                <td style="width:10%">${data.sgiNo}</td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:10%"><fmt:formatDate  value="${data.sendDate}"  pattern="yyyy-MM-dd HH:mm:ss" /></td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:12%"><fmt:formatNumber value="${data.actTickets}" type="number"/></td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:12%" align="right"><fmt:formatNumber value="${data.actAmount}" type="number"/></td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:10%">${data.sendManger}</td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:10%"><c:forEach var="item" items="${goodsIssuesType}"><c:if test="${!empty data }"><c:if test="${data.issueType==item.key }">${item.value}</c:if></c:if></c:forEach></td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:10%"><c:forEach var="item" items="${goodsIssuesStatus}"><c:if test="${!empty data }"><c:if test="${data.status==item.key }">${item.value}</c:if></c:if></c:forEach></td>
                 <td width="1%" >&nbsp;</td>
                <td style="width:*%">
                    
                    <c:if test="${data.status==1}">
                    <c:if test="${data.tickets!=data.actTickets }">
                     <span><a href="#" onclick="onNextGoodrecipts('${data.sgiNo}','${data.issueType}','${data.refNo}')">继续</a></span>&nbsp;|
                     </c:if>
                      <span><a href="#" onclick="doComplete('${data.issueType}','${data.refNo}','${data.sgiNo}')">完成</a></span>&nbsp;|
                    </c:if>
                    <c:if test="${data.status==2}">
                      <a href="#" onclick="showPage('goodsIssues.do?method=printGoodsAll&refNo=${data.refNo}&type=${data.issueType}','打印')">打印</a>&nbsp;|
                    </c:if>
                   
                    <span><a href="#" onclick="showBox('goodsIssues.do?method=getGoodsIssuesDetailBysgiNo&sgiNo=${data.sgiNo}&issueType=${data.issueType}','详情',550,1020)">详情</a></span>&nbsp;
                   
                </td>
            </tr>
          </c:forEach>
        </table>
        ${pageStr} 
    </div>
</body>
</html>