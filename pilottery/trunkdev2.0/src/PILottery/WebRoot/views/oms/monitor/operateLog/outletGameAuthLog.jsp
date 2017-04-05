<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title>Game Authentication Log</title>

<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/pop-up.css" />
<link rel="stylesheet" type="text/css" href="${basePath}/css/validate.css" />
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox_zh.js"></script>
<script type="text/javascript" src="${basePath}/js/oms/myJs.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<style type="text/css">
	.datatable tr:hover, .datatable tr.hilite {
	    background-color: #2aa1d9;
	    color: #ffffff;
	}
</style>

</head>
<body>
  <form:form action="agency.do?method=gameAuthen" method="POST" id="form1"> 
	    <div class="pop-body" >
	      <table class="datatable" border="0">
		 	<tr class="headRow">
			  <td width="12%">Game</td>
			  <td width="10%">Type</td>
			  <td width="12%">Sale</td>
			  <td width="7%">Payout</td>
			  <td width="7%">Refund</td>
			  <td width="14%">Sales Commission</td>
			  <td width="14%">Payout Commission</td>
			  <td width="*%">Payout Scope</td>
			</tr>
				<c:forEach var="game" items="${games}" varStatus="s"> 
    			<tr class="dataRow">
						<td><c:out value="${game.name}" /><input type="hidden" name="guth[${s.index}].agencyCode" value="${agencyCode}" /></td>
						<td>
						<c:choose>
							<c:when test="${game.type == 1}">
								KENO
							</c:when>
							<c:when test="${game.type == 2}">
								Lotto
							</c:when>
							<c:when test="${game.type == 3}">
								Digit
							</c:when>
							<c:otherwise>
								Other
							</c:otherwise>
						</c:choose>
						<input type="hidden" name="guth[${s.index}].gameCode" value="${game.gameCode}" />
						</td>
						<td>
						<c:if test="${game.flag==0}">
						  <c:choose>
							<c:when test="${game.sellStatus == 1}">
								<input type="checkbox" name="guth[${s.index}].sellStatus" value="1" checked="checked" disabled="disabled"/>
							</c:when>
							<c:otherwise>
								<input type="checkbox" name="guth[${s.index}].sellStatus"  value="1" disabled="disabled"/>
							</c:otherwise>
						  </c:choose>
						  </c:if>
						  <c:if test="${game.flag==1}">
						  <input type="checkbox" name="guth[${s.index}].sellStatus"  value="1" disabled="disabled"/>
						  </c:if>
						</td>
									
						<td>
						 <c:if test="${game.flag==0}">
						  <c:choose>
							<c:when test="${game.payStatus == 1}">
								<input type="checkbox" name="guth[${s.index}].payStatus" value="1" checked="checked" disabled="disabled"/>
							</c:when>
							<c:otherwise>
								<input type="checkbox" name="guth[${s.index}].payStatus"  value="1" disabled="disabled"/>
							</c:otherwise>
						  </c:choose>
						  </c:if>
						  <c:if test="${game.flag==1}">
						  <input type="checkbox" name="guth[${s.index}].payStatus"  value="1" disabled="disabled"/>
						  </c:if>
						</td>
						
					     <td>
					      <c:if test="${game.flag==0}">
						  <c:choose>
							<c:when test="${game.cancelStatus == 1}">
								<input type="checkbox" name="guth[${s.index}].cancelStatus" value="1" checked="checked" disabled="disabled"/>
							</c:when>
							<c:otherwise>
								<input type="checkbox" name="guth[${s.index}].cancelStatus"  value="1" disabled="disabled"/>
							</c:otherwise>
						  </c:choose>
						  </c:if>
						   <c:if test="${game.flag==1}">
						    <input type="checkbox" name="guth[${s.index}].cancelStatus"  value="1" disabled="disabled"/>
						   </c:if>
						</td>
					
						<td>
						 <c:if test="${game.flag==0}">${game.saleCommissionRate}</c:if>
						 <c:if test="${game.flag==1}">0</c:if> ‰
						</td>

						<td><c:if test="${game.flag==0}">${game.payCommissionRate}</c:if>
							<c:if test="${game.flag==1}">0</c:if> ‰
					    </td>
							
						<td><c:if test="${game.flag==0}">
								<c:choose>
									<c:when test="${game.claimingScope == 0}">Center</c:when>
									<c:when test="${game.claimingScope == 1}">Institution</c:when>
									<c:when test="${game.claimingScope == 4}">Outlet</c:when>
									<c:otherwise>Center</c:otherwise>
								</c:choose>
							</c:if> 
							<c:if test="${game.flag==1}">Center
						  </c:if>
						</td>
					</tr>
     			</c:forEach>	  
			</table>		
        </div>
    </form:form>
</body>
</html>