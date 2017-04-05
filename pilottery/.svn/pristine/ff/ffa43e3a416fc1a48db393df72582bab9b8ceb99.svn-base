<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>
    <link type="text/css" rel="stylesheet" href="${basePath}/views/oms/game-draw/css/myStyle.css" />
    <link href="${basePath}/css/zxcx.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css"/>

    <link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
    <script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>

    <script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
    <script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

    <title>FBS彩票查询</title>

    <script type="text/javascript">
window.onload=function(){
    <c:if test="${not empty reservedSuccessMsg}">
       doChecquerykMsg("tsnSend",'${reservedSuccessMsg}');
    </c:if>
}
        function doSubmit() {
            var result = true;

            if (!doCheck("tsnSend", checkTsn(), '请输入正确tsn')) {
                result = false;
            }
            
            if(checkTsn()){
           
            	if (!doCheck("tsnSend", /^[a-zA-Z0-9]{24}|[0-9]{16}$/, '请输入正确tsn')) {
                    result = false;
                }
            }
            var tsnval = $("#tsnSend").val();
        	if(getStrlen(tsnval)!=16 && getStrlen(tsnval)!=24){
        		result= false;
        		doCheckMsg("tsnSend",false,'请输入正确tsn');
        		
        	}
        	return result;
        	/**
            if (result) {
                button_off("okBtn");
                $('#centerSelectForm').submit();
            }**/
        }

        function checkTsn() {
            if ($("#tsnSend").val()=='') {
                return false;
            }
            return true;
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
        function doCheckMsg(id,regex,msg) {

        	if(!regex) {
        		$("#"+id+"Tip").text("");
        		$("#"+id+"Tip").text(msg);
        		
        		$("#"+id+"Tip").removeClass("tip_init").addClass("tip_error");
        		
        	} else {

        			$("#"+id+"Tip").text("");

        		$("#"+id+"Tip").text("*");
        	  
        	    $("#"+id+"Tip").removeClass("tip_error").addClass("tip_init");
        	}

  }
    function doChecquerykMsg(id,msg) {
        		$("#"+id+"Tip").text("");
        		$("#"+id+"Tip").text(msg);
        		$("#"+id+"Tip").removeClass("tip_init").addClass("tip_error");
  }
    function exportPdf() {
        //var html = document.documentElement.outerHTML;
        var html = printDiv.innerHTML;

        var input1 = document.createElement("input");
        input1.type = "hidden";
        input1.name = "htmlStr";
        input1.value = encodeURIComponent(html);

        var form1 = document.createElement("form");
        form1.appendChild(input1);
        //document.body.appendChild(form1);
        form1.action = "export.do";
        form1.method="post";
        form1.submit();

    }
    </script>
</head>

<body style="overflow-y:auto; ">
    <form action="fbsPayout.do?method=initTicketInquiry" method="post" id="centerSelectForm" name="centerSelectForm" onsubmit="return doSubmit();">
    <div id="title">中心查询</div>
    <div class="queryDiv">彩票票号:
        <input id="tsnSend" style="width:275px;" value="" class="text-normal" name="tsnSend" type="text" maxlength="24"/>
        <input id="okBtn" type="submit" value="查&nbsp;&nbsp;&nbsp;&nbsp;询" onclick="" class="button-normal"></input>
        <span id="tsnSendTip" class="tip_init">*</span>
        
    </div>
      <div class="right">
              <table width="95%" border="0" cellspacing="0" cellpadding="0">
                <tr style="height:50px;line-height:50px">
                      
                  <td align="right">
                  
                   <!--<a href="#" class="icon-lz" onclick="exportPdf();"><img src="img/daochu.png" width="21" height="16" /> 打印</a>
                  -->
                  <a href="#" class="icon-lz" onclick="showPage('centerSelect.do?method=inintPrint','打印');"> 打印</a>
                  
                  </td>
                </tr>
              </table>
            </div>
 
     <div id="printDiv">
    <div id="tck">
        <div id="nr">
            <div class="title-mbx">彩票信息</div>
            <div class="border">
                <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom:10px;">
                 <tr>
                        <td width="36%">彩票票号: ${tsn}</td>
                        <td width="37%">&nbsp;</td>
                        <td width="27%">&nbsp;</td>
                    </tr>
                    <tr>
                        <td width="36%">售票终端编码: ${centerSelectReq.sale_termCode }</td>
                        <td width="37%">售票销售员编码: ${centerSelectReq.sale_tellerCode }</td>
                        <td width="27%">&nbsp;</td>
                    </tr>
                    <tr>
                        <td>游戏名称:${centerSelectReq.gameName}</td>
                        <td>游戏编码:${centerSelectReq.gameCode}</td>
                        <td><!--
                         -->销售期号:
                            <c:choose>
                                <c:when test="${!empty centerSelectReq.startIssueNumber}">${centerSelectReq.startIssueNumber}</c:when>
                                <c:when test="${!empty centerSelectReq.startIssueNumber && !empty centerSelectReq.lastIssueNumber}"><!--
                                 -->${centerSelectReq.startIssueNumber}-${centerSelectReq.lastIssueNumber}
                                </c:when>
                            </c:choose><!--
                     --></td>
                    </tr>
                    <tr>
                        <td>购买期数:${centerSelectReq.periods}</td>
                        <td>投注行数目:${centerSelectReq.bettinglinenumber}</td>
                        <td>票面总金额:<fmt:formatNumber value="${centerSelectReq.tickAmount}" pattern="#,###"/></td>
                    </tr>
                </table>
                <c:if test="${!empty centerSelectReq.betlist}">
                    <table width="100%" cellspacing="0" cellpadding="0" class="tabxian" border="0">
                        <tr class="biaot">
                            <th width="10%">玩法</th>
                            <th width="16%">投注方式</th>
                            <th width="45%">投注号码区</th>
                            <th width="13%">倍数</th>
                        </tr>
                        <c:forEach items="${centerSelectReq.betlist}" var="be">
                            <tr class="jjzi">
                                <td class="tabxian-td">${be.play}</td>
                                <td class="tabxian-td">${be.bet}</td>
                                <td class="tabxian-td">${be.bettingnumber}</td>
                                <td class="tabxian-td">${be.multiple}</td>
                            </tr>
                        </c:forEach>
                    </table>
                </c:if>
            </div>
        </div>
        <div id="nr">
            <div class="title-mbx">培训票信息</div>
            <div class="border">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td width="36%"><!--
                         -->是否是培训票:
                            <c:choose>
                                <c:when test="${centerSelectReq.isTrain ==1}">是</c:when>
                                <c:otherwise>否</c:otherwise>
                            </c:choose><!--
                     --></td>
                        <%-- <td width="37%">
                         		票面来源:
                            <c:choose>
                                <c:when test="${centerSelectReq.from_sale==1}">终端机</c:when>
                                <c:when test="${centerSelectReq.from_sale==2}">网站</c:when>
                                <c:when test="${centerSelectReq.from_sale==3}">手机</c:when>
                                <c:when test="${centerSelectReq.from_sale==4}">手持POS机</c:when>
                            </c:choose>
                     </td> --%>
                        <td width="27%">&nbsp;</td>
                    </tr>
                </table>
            </div>
        </div>
        <div id="nr">
            <div class="title-mbx">中奖信息</div>
            <div class="border">
                <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom:10px;">
                <tr>
                    <td width="36%"><!--
                     -->是否是大奖:
                        <c:choose >
                            <c:when test="${centerSelectReq.isBigPrize==0}">否</c:when>
                            <c:when test="${centerSelectReq.isBigPrize==1}">是</c:when>
                        </c:choose><!--
                 --></td>
                    <td width="37%">中奖金额(税前): <fmt:formatNumber value="${centerSelectReq.amountBeforeTax}" pattern="#,###"/></td>
                    <td width="27%">&nbsp;</td>
                </tr>
                <tr>
                    <td>税金:<fmt:formatNumber value="${centerSelectReq.taxAmount}" pattern="#,###"/></td>
                    <td> 中奖金额(税后): <fmt:formatNumber value="${centerSelectReq.amountAfterTax}" pattern="#,###"/></td>
                    <td>&nbsp; </td>
                </tr>
                </table>
            </div>
        </div>
        <div id="nr">
            <c:if test="${centerSelectReq.isPayed==1}">
                <div class="title-mbx">兑奖信息</div>
                <div class="border">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom:10px;">
                        <tr>
                            <td width="36%"><!--
                             -->是否已兑奖:
                                <c:choose>
                                    <c:when test="${centerSelectReq.isPayed==0}">未兑奖</c:when>
                                    <c:when test="${centerSelectReq.isPayed==1}">已兑奖</c:when>
                                </c:choose><!--
                         --></td>
                            <td width="37%"><!--
                             -->是否是大奖: <c:choose>
                                <c:when test="${centerSelectReq.isBigPrize==0}">否</c:when>
                                <c:when test="${centerSelectReq.isBigPrize==1}">是</c:when>
                                </c:choose><!--
                         --></td>
                            <td width="27%"><!--
                             -->兑奖时间: 
                                <fmt:formatDate value="${centerSelectReq.pay_timeformat}" pattern="yyyy-MM-dd HH:mm:ss"/><!--
                         --></td>
                        </tr>
                        <tr>
                            <td>姓名: ${centerSelectReq.customName}</td>
                            <td><!--
                             -->证件类型: 
                                <c:choose>
                                    <c:when test="${centerSelectReq.cardType ==1}">身份证</c:when>
                                    <c:when test="${centerSelectReq.cardType ==2}">护照</c:when>
                                    <c:when test="${centerSelectReq.cardType ==3}">军官证</c:when>
                                    <c:when test="${centerSelectReq.cardType ==4}">士兵证</c:when>
                                    <c:when test="${centerSelectReq.cardType ==5}">回乡证</c:when>
                                    <c:when test="${centerSelectReq.cardType ==9}">其他证件</c:when>
                                </c:choose><!--
                         --></td>
                            <td>证件号码: ${centerSelectReq.cardCode}</td>
                        </tr>
                        <tr>
                            <td>兑奖终端编码: ${centerSelectReq.pay_termCode}</td>
                            <td>兑奖销售员编码: ${centerSelectReq.pay_tellerCode}</td>
                            <td>玩法名称：怎么玩</td>
                            <td>投注方式：3串1</td>
                            <td>倍数：N倍</td>
                        </tr>
                    </table>
                    <c:if test="${not empty centerSelectReq.prizes}">
                        <table width="100%"  cellspacing="0" cellpadding="0" class="tabxian" border="0">
                            <tr class="biaot">
                                <!-- <th>奖级编号</th>
                                <th>奖等名称</th> -->
                                <th>中奖注数</th>
                                <th>单注中奖金额</th>
                            </tr>
                            <c:forEach items="${centerSelectReq.prizes}" var="prize">
                                <tr class="jjzi">
                                    <td class="tabxian-td">${prize.prizeCode}</td>
                                    <td class="tabxian-td">${prize.prizeName}</td>
                                    <td class="tabxian-td">${prize.betCount}</td>
                                    <td class="tabxian-td"><fmt:formatNumber value="${prize.prizeAmount}" pattern="#,###"/></td>
                                </tr>
                            </c:forEach>
                        </table>
                    </c:if>
                </div>
            </c:if>
            <c:if test="${centerSelectReq.isCancel==1}">
                <div class="title-mbx">退票信息</div>
                <div class="border">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom:10px;">
                        <tr>
                            <td width="36%">退票终端编码: ${centerSelectReq.cancel_termCode}</td>
                            <td width="37%">退票销售员编码: ${centerSelectReq.cancel_tellerCode}</td>
                            <td width="27%">退票时间:
                                <fmt:formatDate value="${centerSelectReq.cancel_timeformat}" pattern="yyyy-MM-dd HH:mm:ss"/>
                         </td>
                        </tr>
                    </table>
                </div>
            </c:if>
        </div>
        <div style="height:15px"></div>
    </div>
    </div> 
    </form>
</body>
</html>
