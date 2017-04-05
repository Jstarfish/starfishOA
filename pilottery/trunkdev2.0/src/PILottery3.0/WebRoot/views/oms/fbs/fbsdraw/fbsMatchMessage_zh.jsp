<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/views/common/taglibs.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link type="text/css" rel="stylesheet" href="${basePath}/views/oms/fbs/fbsdraw/css/style1.css"/>
    <link type="text/css" rel="stylesheet" href="${basePath}/views/oms/fbs/fbsdraw/css/bootstrap.min.css"/>
    <script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            jQuery.jqtab = function (tabtit, tabcon) {
                $(tabcon).hide();
                $(tabtit + " li:first").addClass("thistab").show();
                $(tabcon + ":first").show();

                $(tabtit + " li").click(function () {
                    $(tabtit + " li").removeClass("thistab");
                    $(this).addClass("thistab");
                    $(tabcon).hide();
                    var activeTab = $(this).find("a").attr("tab");
                    $("#" + activeTab).fadeIn();
                    return false;
                });

            };
            /*调用方法如下：*/
            $.jqtab("#tabs", ".tab_con");

        });
    </script>
    <title>无标题文档</title>
</head>

<body>
<div id="tabbox">
    <ul class="tabs" id="tabs">
        <li><a href="#" tab="tab1">胜平负</a></li>
        <li><a href="#" tab="tab2">胜负过关</a></li>
        <li><a href="#" tab="tab3">总进球数</a></li>
        <li><a href="#" tab="tab4">单场比分</a></li>
        <li><a href="#" tab="tab5">半全场胜平负</a></li>
        <li><a href="#" tab="tab6">上下盘单双数</a></li>
    </ul>
    <ul class="tab_conbox">
        <li id="tab1" class="tab_con">

            <table width="50%" class="ms">
                <tr>
                    <td align="left">全部投注额：<span class="cl-r">$${jsonWIN.sa+jsonWIN.ma}</span></td>
                    <td align="left">单关投注额：<span class="cl-r">$${jsonWIN.sa}</span></td>
                    <td align="left">过关投注额：<span class="cl-r">$${jsonWIN.ma}</span></td>
                </tr>
            </table>

            <table class="table table-striped table-bordered table-advance table-hover">
                <thead>
                <tr>
                    <th class="cl-h">#</th>
                    <th>比赛结果</th>
                    <th class="hidden-phone">全部投注额</th>
                    <th>单关投注额</th>
                    <th>过关投注额</th>
                    <th>参考SP值</th>
                    <th>人气</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${jsonWIN.list}" var="wlist">
                    <tr>
                        <td class="cl-h">1</td>
                        <td>${wlist.ret}</td>
                        <td class="hidden-phone"><span class="cl-r">$${wlist.sa+wlist.ma}</span></td>
                        <td><span class="cl-r">$${wlist.sa}</span></td>
                        <td><span class="cl-r">$${wlist.ma}</span></td>
                        <td>
                            <fmt:formatNumber type="number" value="${wlist.sp/1000>1?(wlist.sp/1000-0.004):(wlist.sp/1000)}" pattern="0.00" maxFractionDigits="2"/>
                        </td>
                        <td><fmt:formatNumber type="number" value="${(((wlist.sa+wlist.ma)/(jsonWIN.sa+jsonWIN.ma))*100)=='NaN'?
                                0:(((wlist.sa+wlist.ma)/(jsonWIN.sa+jsonWIN.ma))*100)}" pattern="0.00" maxFractionDigits="2"/>%</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </li>
        <li id="tab2" class="tab_con">
            <div class="ms">
                <table width="50%">
                    <tr>
                        <td align="left">全部投注额：<span class="cl-r">$${jsonHCP.sa+jsonHCP.ma}</span></td>
                        <td align="left">单关投注额：<span class="cl-r">$${jsonHCP.sa}</span></td>
                        <td align="left">过关投注额：<span class="cl-r">$${jsonHCP.ma}</span></td>
                    </tr>
                </table>
            </div>
            <table class="table table-striped table-bordered table-advance table-hover">
                <thead>
                <tr>
                    <th class="cl-h">#</th>
                    <th>比赛结果</th>
                    <th class="hidden-phone">全部投注额</th>
                    <th>单关投注额</th>
                    <th>过关投注额</th>
                    <th>参考SP值</th>
                    <th>人气</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${jsonHCP.list}" var="hlist">
                    <tr>
                        <td class="cl-h">1</td>
                        <td>${hlist.ret}</td>
                        <td class="hidden-phone"><span class="cl-r">$${hlist.sa+hlist.ma}</span></td>
                        <td><span class="cl-r">$${hlist.sa}</span></td>
                        <td><span class="cl-r">$${hlist.ma}</span></td>
                        <td>
                            <fmt:formatNumber type="number" value="${hlist.sp/1000>1?(hlist.sp/1000-0.004):hlist.sp/1000}" pattern="0.00" maxFractionDigits="2"/>
                        </td>
                        <td><fmt:formatNumber type="number" value="${(((hlist.sa+hlist.ma)/(jsonHCP.sa+jsonHCP.ma))*100)=='NaN'?
                                0:(((hlist.sa+hlist.ma)/(jsonHCP.sa+jsonHCP.ma))*100)}" pattern="0.00" maxFractionDigits="2"/>
                         %</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </li>
        <li id="tab3" class="tab_con">
            <div class="ms">
                <table width="50%">
                    <tr>
                        <td align="left">全部投注额：<span class="cl-r">$${jsonTOT.sa+jsonTOT.ma}</span></td>
                        <td align="left">单关投注额：<span class="cl-r">$${jsonTOT.sa}</span></td>
                        <td align="left">过关投注额：<span class="cl-r">$${jsonTOT.ma}</span></td>
                    </tr>
                </table>
            </div>
            <table class="table table-striped table-bordered table-advance table-hover">
                <thead>
                <tr>
                    <th class="cl-h">#</th>
                    <th>比赛结果</th>
                    <th class="hidden-phone">全部投注额</th>
                    <th>单关投注额</th>
                    <th>过关投注额</th>
                    <th>参考SP值</th>
                    <th>人气</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${jsonTOT.list}" var="tlist">
                    <tr>
                        <td class="cl-h">1</td>
                        <td>${tlist.ret}</td>
                        <td class="hidden-phone"><span class="cl-r">$${tlist.sa+tlist.ma}</span></td>
                        <td><span class="cl-r">$${tlist.sa}</span></td>
                        <td><span class="cl-r">$${tlist.ma}</span></td>
                        <td>
                            <fmt:formatNumber type="number" value="${tlist.sp/1000>1?(tlist.sp/1000-0.004):(tlist.sp/1000)}" pattern="0.00" maxFractionDigits="2"/>
                        </td>
                        <td><fmt:formatNumber type="number" value="${(((tlist.sa+tlist.ma)/(jsonTOT.sa+jsonTOT.ma))*100) == 'NaN'?
                                0:(((tlist.sa+tlist.ma)/(jsonTOT.sa+jsonTOT.ma))*100)}" pattern="0.00" maxFractionDigits="2"/>
                         %</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </li>
        <li id="tab4" class="tab_con">
            <div class="ms">
                <table width="50%">
                    <tr>
                        <td align="left">全部投注额：<span class="cl-r">$${jsonSCR.sa+jsonSCR.ma}</span></td>
                        <td align="left">单关投注额：<span class="cl-r">$${jsonSCR.sa}</span></td>
                        <td align="left">过关投注额：<span class="cl-r">$${jsonSCR.ma}</span></td>
                    </tr>
                </table>
            </div>
            <table class="table table-striped table-bordered table-advance table-hover">
                <thead>
                <tr>
                    <th class="cl-h">#</th>
                    <th>比赛结果</th>
                    <th class="hidden-phone">全部投注额</th>
                    <th>单关投注额</th>
                    <th>过关投注额</th>
                    <th>参考SP值</th>
                    <th>人气</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${jsonSCR.list}" var="slist">
                    <tr>
                        <td class="cl-h">1</td>
                        <td>${slist.ret}</td>
                        <td class="hidden-phone"><span class="cl-r">$${slist.sa+slist.ma}</span></td>
                        <td><span class="cl-r">$${slist.sa}</span></td>
                        <td><span class="cl-r">$${slist.ma}</span></td>
                        <td>
                            <fmt:formatNumber type="number" value="${slist.sp/1000>1?(slist.sp/1000-0.004):(slist.sp/1000)}" pattern="0.00" maxFractionDigits="2"/>
                        </td>
                        <td><fmt:formatNumber type="number" value="${(((slist.sa+slist.ma)/(jsonSCR.sa+jsonSCR.ma))*100)=='NaN'?
                                0:(((slist.sa+slist.ma)/(jsonSCR.sa+jsonSCR.ma))*100)}" pattern="0.00" maxFractionDigits="2"/>
                         %</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </li>
        <li id="tab5" class="tab_con">
            <div class="ms">
                <table width="50%">
                    <tr>
                        <td align="left">全部投注额：<span class="cl-r">$${jsonHFT.sa+jsonHFT.ma}</span></td>
                        <td align="left">单关投注额：<span class="cl-r">$${jsonHFT.sa}</span></td>
                        <td align="left">过关投注额：<span class="cl-r">$${jsonHFT.ma}</span></td>
                    </tr>
                </table>
            </div>
            <table class="table table-striped table-bordered table-advance table-hover">
                <thead>
                <tr>
                    <th class="cl-h">#</th>
                    <th>比赛结果</th>
                    <th class="hidden-phone">全部投注额</th>
                    <th>单关投注额</th>
                    <th>过关投注额</th>
                    <th>参考SP值</th>
                    <th>人气</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${jsonHFT.list}" var="flist">
                    <tr>
                        <td class="cl-h">1</td>
                        <td>${flist.ret}</td>
                        <td class="hidden-phone"><span class="cl-r">$${flist.sa+flist.ma}</span></td>
                        <td><span class="cl-r">$${flist.sa}</span></td>
                        <td><span class="cl-r">$${flist.ma}</span></td>
                        <td>
                            <fmt:formatNumber type="number" value="${flist.sp/1000>1?(flist.sp/1000-0.004):(flist.sp/1000)}" pattern="0.00" maxFractionDigits="2"/>
                        </td>
                        <td><fmt:formatNumber type="number" value="${(((flist.sa+flist.ma)/(jsonHFT.sa+jsonHFT.ma))*100)=='NaN'?
                                0:(((flist.sa+flist.ma)/(jsonHFT.sa+jsonHFT.ma))*100)}" pattern="0.00" maxFractionDigits="2"/>
                         %</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </li>
        <li id="tab6" class="tab_con">
            <div class="ms">
                <table width="50%">
                    <tr>
                        <td align="left">全部投注额：<span class="cl-r">$${jsonOUOD.sa+jsonOUOD.ma}</span></td>
                        <td align="left">单关投注额：<span class="cl-r">$${jsonOUOD.sa}</span></td>
                        <td align="left">过关投注额：<span class="cl-r">$${jsonOUOD.ma}</span></td>
                    </tr>
                </table>
            </div>
            <table class="table table-striped table-bordered table-advance table-hover">
                <thead>
                <tr>
                    <th class="cl-h">#</th>
                    <th>比赛结果</th>
                    <th class="hidden-phone">全部投注额</th>
                    <th>单关投注额</th>
                    <th>过关投注额</th>
                    <th>参考SP值</th>
                    <th>人气</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${jsonOUOD.list}" var="dlist">
                    <tr>
                        <td class="cl-h">1</td>
                        <td>
                            <c:if test="${dlist.ret==1}">上单</c:if>
                            <c:if test="${dlist.ret==2}">上双</c:if>
                            <c:if test="${dlist.ret==3}">下单</c:if>
                            <c:if test="${dlist.ret==4}">下双</c:if>
                        </td>
                        <td class="hidden-phone"><span class="cl-r">$${dlist.sa+dlist.ma}</span></td>
                        <td><span class="cl-r">$${dlist.sa}</span></td>
                        <td><span class="cl-r">$${dlist.ma}</span></td>
                        <td>
                            <fmt:formatNumber type="number" value="${dlist.sp/1000>1?(dlist.sp/1000-0.004):(dlist.sp/1000)}" pattern="0.00" maxFractionDigits="2"/>
                        </td>
                        <td><fmt:formatNumber type="number" value="${(((dlist.sa+dlist.ma)/(jsonOUOD.sa+jsonOUOD.ma))*100)=='NaN'?
                                0:(((dlist.sa+dlist.ma)/(jsonOUOD.sa+jsonOUOD.ma))*100)}" pattern="0.00" maxFractionDigits="2"/>
                         %</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </li>

    </ul>
</div>

</body>
</html>