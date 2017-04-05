<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/views/common/meta.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Detail</title>
<link rel="stylesheet" href="${basePath}/css/bootstrap.min.css?v=3.3.6">
<link rel="stylesheet" href="${basePath}/css/bootstrap-table/bootstrap-table.min.css">
<link rel="stylesheet" href="${basePath}/css/cncp/common.css">

<script src="${basePath}/js/jquery.min.js"></script>
<script src="${basePath}/js/bootstrap.min.js"></script>
<script src="${basePath}/js/plugins/bootstrap-table/bootstrap-table.min.js"></script>
<script src="${basePath}/js/plugins/sweetalert/sweetalert.min.js"></script>
<script src="${basePath}/views/dealer/js/dealerList.js"></script>
</head>
<body class="gray-bg">
	<form class="form-horizontal m-t" id="editForm" novalidate="novalidate">
            <div class="form-group">
                <label class="col-sm-3 control-label">Dealer Code：</label>
                <div class="col-sm-5" style="margin-top: 6px;">
                    ${dealerDetail.dealerCode }
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Dealer Name：</label>
                 <div class="col-sm-5" style="margin-top: 6px;">
                    ${dealerDetail.dealerName }
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Account Balance：</label>
                 <div class="col-sm-5" style="margin-top: 6px;">
                	${dealerDetail.accountBalance }
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Contact Name：</label>
                <div class="col-sm-5" style="margin-top: 6px;">
                    ${dealerDetail.dealerContact }
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Contact Phone：</label>
                <div class="col-sm-5" style="margin-top: 6px;">
                    ${dealerDetail.dealerPhone }
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">Email：</label>
                <div class="col-sm-5" style="margin-top: 6px;">
                    ${dealerDetail.dealerMail }
                </div>
            </div>
             <div class="form-group" >
                <label class="col-sm-3 control-label">Message Address：</label>
                <div class="col-sm-5" style="margin-top: 6px;">
               		${dealerDetail.msgUrl }
                </div>
            </div> 
        </form>
</body>
</html>