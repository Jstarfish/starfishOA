<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title></title>
<%@ include file="/views/common/meta.jsp" %>
<style type="text/css">

#success_page table {
    margin-left: auto;
    margin-right: auto;
}

.button{
    font-family: "microsoft yahei", "微软雅黑";
    position: relative;
    display: inline-block;
    line-height: 25px;
    padding: 1px 12px;
    transition: all .3s ease-out;
    text-transform: uppercase;
    border: 1px solid #90cd00;
    color: #fff;
    cursor: pointer;
    border-radius: 2px;
    /* -webkit-border-radius: 2px; */
    background-color: #90cd00;
    font-size: 14px;
    outline:none;
}
.button:hover {
  background-color: #9bdb03;
}


</style>

<script type="text/javascript">

    function doReload(){
    	window.location.href = "${basePath}/index.do?method=mainRequest";
    }
</script>
</head>

<body>
    <div id="success_page">
         <table border="0" cellspacing="0" cellpadding="0" width="100%" height="100px">
            <tr>
                <td align="right" width="30%">
                    <img alt="success" src="${basePath}/img/success.png" width="49" height="49">
                </td>
                <td align="left" style="padding: 0px 50px 0px 10px;">
                    <c:if test="${not empty system_message}">${system_message}</c:if> 
                    <c:if test="${empty system_message}">您的交易密码已经修改成功!</c:if>
                </td>
            </tr>
            <tr>
                <td></td>
                <td style="padding-left:10px;">
                  <input type="button" value="提交" class="button" onclick="doReload()"></input>
                </td>
            </tr>
           </table>
    </div>
</body>

</html>