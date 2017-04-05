<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>区域列表</title>
<%@ include file="/views/common/meta.jsp" %>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />

<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>

<style type="text/css">

</style>
 

<script type="text/javascript" charset="UTF-8" > 

</script>

</head>
<body>
  <div class="queryDiv">
            <form action="area.do?method=queryArea" id="queryForm">
                <input type="hidden" name="excelTitle" id="excelTitle"/>
                <div class="left">                      
                        <span>区域编码：<input id="areaCodeQuery" class="text-normal" maxlength="4"/></span>
                        <span>区域名称：<input id="areaNameQuery" maxlength="100" class="text-normal"/></span>
                        <input type="button" value="查询" onclick="updateQuery();" class="button-normal"></input>
                </div>
                <div class="right">
                  <table width="260" border="0" cellspacing="0" cellpadding="0">
                    <tr style="height:50px;line-height:50px">
                      <td align="right">
                        <input type="button" value="增加区域" onclick="showBox('addArea.jsp','增加区域',400,700)" class="button-normal"></input>
                      </td>
                      
                    
                    </tr>
                  </table>
                </div>
            </form>
        </div>

    <div id="headDiv">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr><td>
            <table class="datatable">
                <tr class="headRow">
                    <td title="编码编码编码编码编码">编码编码编码编码编码</td>
                    <td>区域名称</td>
                    <td>区域级别 </td>
                    <td>上级名称</td>
                    <td>销售站数量</td>
                    <td>终端机数量</td>
                    <td>销售员数量</td>
                    <td>操作</td>
                </tr>
            </table>
           </td><td style="width:17px;background:#2aa1d9"></td></tr>
       </table>
    </div>

    <div id="bodyDiv">
        <table class="datatable">
            <tr class="dataRow">
                <td>编1</td><td>区域名称</td><td>区域级别 </td><td>上级名称</td><td>销售站数量</td><td>终端机数量</td><td>销售员数量</td><td>操作</td>
            </tr>
            <tr class="dataRow">
                <td>编码</td><td>区域名称</td><td>区域级别 </td><td>上级名称</td><td>销售站数量</td><td>终端机数量</td><td>销售员数量</td><td>操作</td>
            </tr>
            <tr class="dataRow">
                <td>编码</td><td>区域名称</td><td>区域级别 </td><td>上级名称</td><td>销售站数量</td><td>终端机数量</td><td>销售员数量</td><td>操作</td>
            </tr>
            <tr class="dataRow">
                <td>编码</td><td>区域名称</td><td>区域级别 </td><td>上级名称</td><td>销售站数量</td><td>终端机数量</td><td>销售员数量</td><td>操作</td>
            </tr>
            <tr class="dataRow">
                <td>编码</td><td>区域名称</td><td>区域级别 </td><td>上级名称</td><td>销售站数量</td><td>终端机数量</td><td>销售员数量</td><td>操作</td>
            </tr>
            <tr class="dataRow">
                <td>编码</td><td>区域名称</td><td>区域级别 </td><td>上级名称</td><td>销售站数量</td><td>终端机数量</td><td>销售员数量</td><td>操作</td>
            </tr>
            <tr class="dataRow">
                <td>编码</td><td>区域名称</td><td>区域级别 </td><td>上级名称</td><td>销售站数量</td><td>终端机数量</td><td>销售员数量</td><td>操作</td>
            </tr>
            <tr class="dataRow">
                <td>编码</td><td>区域名称</td><td>区域级别 </td><td>上级名称</td><td>销售站数量</td><td>终端机数量</td><td>销售员数量</td><td>操作</td>
            </tr>
            <tr class="dataRow">
                <td>编码</td><td>区域名称</td><td>区域级别 </td><td>上级名称</td><td>销售站数量</td><td>终端机数量</td><td>销售员数量</td><td>操作</td>
            </tr>
            <tr class="dataRow">
                <td>编码</td><td>区域名称</td><td>区域级别 </td><td>上级名称</td><td>销售站数量</td><td>终端机数量</td><td>销售员数量</td><td>操作</td>
            </tr>
            <tr class="dataRow">
                <td>编码</td><td>区域名称</td><td>区域级别 </td><td>上级名称</td><td>销售站数量</td><td>终端机数量</td><td>销售员数量</td><td>操作</td>
            </tr>
            <tr class="dataRow">
                <td>编码</td><td>区域名称</td><td>区域级别 </td><td>上级名称</td><td>销售站数量</td><td>终端机数量</td><td>销售员数量</td><td>操作</td>
            </tr>
            <tr class="dataRow">
                <td>编码</td><td>区域名称</td><td>区域级别 </td><td>上级名称</td><td>销售站数量</td><td>终端机数量</td><td>销售员数量</td><td>操作</td>
            </tr>
            <tr class="dataRow">
                <td>编码</td><td>区域名称</td><td>区域级别 </td><td>上级名称</td><td>销售站数量</td><td>终端机数量</td><td>销售员数量</td><td>操作</td>
            </tr>
            <tr class="dataRow">
                <td>编码</td><td>区域名称</td><td>区域级别 </td><td>上级名称</td><td>销售站数量</td><td>终端机数量</td><td>销售员数量</td><td>操作</td>
            </tr>
            <tr class="dataRow">
                <td>编码</td><td>区域名称</td><td>区域级别 </td><td>上级名称</td><td>销售站数量</td><td>终端机数量</td><td>销售员数量</td><td>操作</td>
            </tr>
            <tr class="dataRow">
                <td>编码</td><td>区域名称</td><td>区域级别 </td><td>上级名称</td><td>销售站数量</td><td>终端机数量</td><td>销售员数量</td><td>操作</td>
            </tr>
            <tr class="dataRow">
                <td>编码</td><td>区域名称</td><td>区域级别 </td><td>上级名称</td><td>销售站数量</td><td>终端机数量</td><td>销售员数量</td><td>操作</td>
            </tr>
            <tr class="dataRow">
                <td>编码</td><td>区域名称</td><td>区域级别 </td><td>上级名称</td><td>销售站数量</td><td>终端机数量</td><td>销售员数量</td><td>操作</td>
            </tr>
            <tr class="dataRow">
                <td>编码</td><td>区域名称</td><td>区域级别 </td><td>上级名称</td><td>销售站数量</td><td>终端机数量</td><td>销售员数量</td><td>操作</td>
            </tr>
            <tr class="dataRow">
                <td>编码</td><td>区域名称</td><td>区域级别 </td><td>上级名称</td><td>销售站数量</td><td>终端机数量</td><td>销售员数量</td><td>操作</td>
            </tr>
            <tr class="dataRow">
                <td>编码</td><td>区域名称</td><td>区域级别 </td><td>上级名称</td><td>销售站数量</td><td>终端机数量</td><td>销售员数量</td><td>操作</td>
            </tr>
            <tr class="dataRow">
                <td>编码</td><td>区域名称</td><td>区域级别 </td><td>上级名称</td><td>销售站数量</td><td>终端机数量</td><td>销售员数量</td><td>操作</td>
            </tr>
            <tr class="dataRow">
                <td>编码</td><td>区域名称</td><td>区域级别 </td><td>上级名称</td><td>销售站数量</td><td>终端机数量</td><td>销售员数量</td><td>操作</td>
            </tr>
        </table>
        
        ${pageStr }
    </div>

</body>
</html>