<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" type="text/css" href="${basePath}/css/style.css"/>
    <link href="${basePath}/css/zxcx.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css"/>

    <link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
    <script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>

    <script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
    <script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>

    <title>
        Ticket Query
    </title>

    <script type="text/javascript">
window.onload=function(){
    <c:if test="${not empty reservedSuccessMsg}">
       doChecquerykMsg("tsnSend",'${reservedSuccessMsg}');
    </c:if>
}
        function doSubmit() {
            var result = true;

            if (!doCheck("tsnSend", checkTsn(), 'Please enter a correct TSN')) {
                result = false;
            }
            
            if(checkTsn()){
           
            	if (!doCheck("tsnSend", /^[a-zA-Z0-9]{24}|[0-9]{16}$/, 'Please enter a correct TSN')) {
                    result = false;
                }
            }
            var tsnval = $("#tsnSend").val();
        	if(getStrlen(tsnval)!=16 && getStrlen(tsnval)!=24){
        		result= false;
        		doCheckMsg("tsnSend",false,'Please enter a correct TSN');
        		
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

<body>
    <form action="centerSelect.do?method=centerSelect" method="post" id="centerSelectForm" name="centerSelectForm" onsubmit="return doSubmit();">
    <div id="title">Ticket Inquiry</div>
    <div class="queryDiv">Ticket No.:
        <input id="tsnSend" style="width:275px;" value="" class="text-normal" name="tsnSend" type="text" maxlength="24"/>
        <input id="okBtn" type="submit" value="Query" onclick="" class="button-normal"></input>
        <span id="tsnSendTip" class="tip_init">*</span>
        
    </div>
      <div class="right">
              <table width="95%" border="0" cellspacing="0" cellpadding="0">
                <tr style="height:50px;line-height:50px">
                      
                  <td align="right">
                  
                   <!--<a href="#" class="icon-lz" onclick="exportPdf();"><img src="img/daochu.png" width="21" height="16" /> Print</a>
                  -->
                  <a href="#" class="icon-lz" onclick="showPage('centerSelect.do?method=inintPrint','Print');"> Print</a>
                  
                  </td>
                </tr>
              </table>
            </div>
 
    <div id="printDiv">
    <div id="tck">
        <div id="nr">
            <div class="title-mbx">Ticket Message</div>
            <div class="border">
                <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom:10px;">
                 <tr>
                        <td width="36%">Ticket No.: ${tsn}</td>
                        <td width="37%">&nbsp;</td>
                        <td width="27%">&nbsp;</td>
                    </tr>
                    <tr>
                        <td width="36%">Terminal Code for Sales: ${centerSelectReq.sale_termCode }</td>
                        <td width="37%">Teller Code for Sales: ${centerSelectReq.sale_tellerCode }</td>
                        <td width="27%">&nbsp;</td>
                    </tr>
                    <tr>
                        <td>Game:${centerSelectReq.gameName}</td>
                        <td>Game Code:${centerSelectReq.gameCode}</td>
                        <td><!--
                         -->Issue:
                            <c:choose>
                                <c:when test="${!empty centerSelectReq.startIssueNumber}">${centerSelectReq.startIssueNumber}</c:when>
                                <c:when test="${!empty centerSelectReq.startIssueNumber && !empty centerSelectReq.lastIssueNumber}"><!--
                                 -->${centerSelectReq.startIssueNumber}-${centerSelectReq.lastIssueNumber}
                                </c:when>
                            </c:choose><!--
                     --></td>
                    </tr>
                    <tr>
                        <td>Issues Bought:${centerSelectReq.periods}</td>
                        <td>Number of Bet Lines:${centerSelectReq.bettinglinenumber}</td>
                        <td>Ticket Amount:<fmt:formatNumber value="${centerSelectReq.tickAmount}" pattern="#,###"/></td>
                    </tr>
                </table>
                <c:if test="${!empty centerSelectReq.betlist}">
                    <table width="100%" cellspacing="0" cellpadding="0" class="tabxian" border="0">
                        <tr class="biaot">
                            <th width="10%">Game Subtype</th>
                            <th width="16%">Betting</th>
                            <th width="45%">Bet Numbers</th>
                            <th width="13%">Multiple</th>
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
            <div class="title-mbx">Training Ticket Information</div>
            <div class="border">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td width="36%"><!--
                         -->Training Ticket:
                            <c:choose>
                                <c:when test="${centerSelectReq.isTrain ==1}">Yes</c:when>
                                <c:otherwise>No</c:otherwise>
                            </c:choose><!--
                     --></td>
                        <td width="37%"><!--
                         -->Ticket  Source:
                            <c:choose>
                                <c:when test="${centerSelectReq.from_sale==1}">Terminal</c:when>
                                <c:when test="${centerSelectReq.from_sale==2}">Website</c:when>
                                <c:when test="${centerSelectReq.from_sale==3}">Mobile phone</c:when>
                                <c:when test="${centerSelectReq.from_sale==4}">Handset POS machine</c:when>
                            </c:choose><!--
                     --></td>
                        <td width="27%">&nbsp;</td>
                    </tr>
                </table>
            </div>
        </div>
        <div id="nr">
            <div class="title-mbx">Winning Information</div>
            <div class="border">
                <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom:10px;">
                <tr>
                    <td width="36%"><!--
                     -->Big Prize:
                        <c:choose >
                            <c:when test="${centerSelectReq.isBigPrize==0}">No</c:when>
                            <c:when test="${centerSelectReq.isBigPrize==1}">Yes</c:when>
                        </c:choose><!--
                 --></td>
                    <td width="37%">Winning Before Tax: <fmt:formatNumber value="${centerSelectReq.amountBeforeTax}" pattern="#,###"/></td>
                    <td width="27%">&nbsp;</td>
                </tr>
                <tr>
                    <td>Tax:<fmt:formatNumber value="${centerSelectReq.taxAmount}" pattern="#,###"/></td>
                    <td> Winning After Tax: <fmt:formatNumber value="${centerSelectReq.amountAfterTax}" pattern="#,###"/></td>
                    <td>&nbsp; </td>
                </tr>
                </table>
            </div>
        </div>
        <div id="nr">
            <c:if test="${centerSelectReq.isPayed==1}">
                <div class="title-mbx">Payout Information</div>
                <div class="border">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom:10px;">
                        <tr>
                            <td width="36%"><!--
                             -->Paid:
                                <c:choose>
                                    <c:when test="${centerSelectReq.isPayed==0}">Not Paid</c:when>
                                    <c:when test="${centerSelectReq.isPayed==1}">Paid</c:when>
                                </c:choose><!--
                         --></td>
                            <td width="37%"><!--
                             -->Big Prize: <c:choose>
                                <c:when test="${centerSelectReq.isBigPrize==0}">No</c:when>
                                <c:when test="${centerSelectReq.isBigPrize==1}">Yes</c:when>
                                </c:choose><!--
                         --></td>
                            <td width="27%"><!--
                             -->Payout Time: 
                                <fmt:formatDate value="${centerSelectReq.pay_timeformat}" pattern="yyyy-MM-dd HH:mm:ss"/><!--
                         --></td>
                        </tr>
                        <tr>
                            <td>Name: ${centerSelectReq.customName}</td>
                            <td><!--
                             -->Certificate Type: 
                                <c:choose>
                                    <c:when test="${centerSelectReq.cardType ==1}">ID Card</c:when>
                                    <c:when test="${centerSelectReq.cardType ==2}">Passport</c:when>
                                    <c:when test="${centerSelectReq.cardType ==3}">Officer Card</c:when>
                                    <c:when test="${centerSelectReq.cardType ==4}">Soldier Card</c:when>
                                    <c:when test="${centerSelectReq.cardType ==5}">Home-Visit Permit</c:when>
                                    <c:when test="${centerSelectReq.cardType ==9}">Other Certificate</c:when>
                                </c:choose><!--
                         --></td>
                            <td>Certificate Code: ${centerSelectReq.cardCode}</td>
                        </tr>
                        <tr>
                            <td>Terminal Code for Payout: ${centerSelectReq.pay_termCode}</td>
                            <td>Teller Code for Payout: ${centerSelectReq.pay_tellerCode}</td>
                            <td></td>
                        </tr>
                    </table>
                    <c:if test="${not empty centerSelectReq.prizes}">
                        <table width="100%"  cellspacing="0" cellpadding="0" class="tabxian" border="0">
                            <tr class="biaot">
                                <th>Prize Code</th>
                                <th>Prize Name</th>
                                <th>Winning Bets</th>
                                <th>Winning Amount per Bet</th>
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
                <div class="title-mbx">Refund Information</div>
                <div class="border">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom:10px;">
                        <tr>
                            <td width="36%">Terminal Code for Refund: ${centerSelectReq.cancel_termCode}</td>
                            <td width="37%">Teller Code for Refund: ${centerSelectReq.cancel_tellerCode}</td>
                            <td width="27%">
                           Refund Time:
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
