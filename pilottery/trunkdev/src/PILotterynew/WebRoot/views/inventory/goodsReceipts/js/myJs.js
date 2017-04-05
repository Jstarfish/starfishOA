function deleteGame(rowNum,obj){
	 var del=$("#planCode"+rowNum).val()+$("#batchCode"+rowNum).val()+$("#packUnitCode"+rowNum).val();
	
	 SJZPrinter.removeObject(del);
	 var tb = document.getElementById("gameBatchInfo");  
	 var rnum=tb.rows.length;  

			 var html='';
				$("#divBethdetail").empty();	
				html+='<table width="100%" border="0" cellspacing="0" cellpadding="0">';
				html+='<tr>';
				  var unitype=$("#packUnit"+rowNum).val();
				
				if(unitype=='Trunk'){
					var trunkamout=$("#trunkhAmount").val();
					
					
					trunkval=parseInt(trunkamout)-1;
					
					$("#trunkhAmount").val(trunkval);
					html+='<td width="13%">箱 :<span class="lz2">'+formatNumber(trunkval);
				}
				 if(unitype=='Box'){
					var boxAmount=$("#boxAmount").val();
					
					 boxval=parseInt(boxAmount)-1;
					 $("#boxAmount").val(boxval);
					html+='<td width="11%">盒 :<span class="lz2" >'+formatNumber(boxval);
				}
				if(unitype=='Package'){
					var packageAmount=$("#packageAmount").val();
					packval=parseInt(packageAmount)-1;
					$("#packageAmount").val(packval);
					html+='<td width="35%">本：<span class="lz2">'+formatNumber(packval);
				}
				
				html+='</span> </td>';
				 var tickets=$("#tickets").val();
				   
				  totaltickts=parseInt(tickets)-parseInt($("#ticketNum"+rowNum).val());
				  $("#tickets").val(totaltickts);
				html+='<td width="19%" class="hoz">总票数 :<span class="lz2">'+formatNumber(totaltickts);
				html+='</span> </td>';
				 var amount=$("#amount").val();
				 
				  totalvalue=parseInt(amount)-parseInt($("#bachamount"+rowNum).val());
				  $("#amount").val(totalvalue);
				html+=' <td width="22%" align="right" class="hoz">总金额 :<span class="lz2">'+formatNumber(totalvalue);
				html+='</span> 瑞尔</td>'; 
				html+='</tr></table>';
				initDiv(html);
				$(obj).parent().parent().remove(); 
		
		    
		   
		    	rownum--;
		 		   
				    if(rownum<0){
				    	
				    	rownum=0;
				    }
 
}


function addGame(rowhtml){
	 

    var tb = document.getElementById("gameBatchInfo");
	  var rnum=tb.rows.length;
	  
	  if(parseInt(rnum) ==parseInt('0')){
		   $("#gameBatchInfo").append(rowhtml);    
	  }
	  if(parseInt(rnum)>0){
		  var r=parseInt(rnum)-1;
    	   $(rowhtml).insertAfter($("#gameBatchInfo tr:eq("+r+")")); 
	  }
    	 
    
}
function initDivhtml(obj){
	 var html='';
		$("#divBethdetail").empty();
		
		html+='<table width="100%" border="0" cellspacing="0" cellpadding="0">';
		html+='<tr>';
		
		if(obj.packUnit=='Trunk'){
			var trunkamout=$("#trunkhAmount").val();
			
			if(trunkamout==''){
				trunkamout=0;
			}
			trunkval=parseInt(trunkamout)+1;
			
			$("#trunkhAmount").val(trunkval);
			html+='<td width="13%">Trunk :<span class="lz2">'+formatNumber(trunkval);
		}
		 if(obj.packUnit=='Box'){
			var boxAmount=$("#boxAmount").val();
			if(boxAmount==''){
				boxAmount=0;
			}
			 boxval=1+parseInt(boxAmount);
			 $("#boxAmount").val(boxval);
			html+='<td width="11%">Box :<span class="lz2" >'+formatNumber(boxval);
		}
		if(obj.packUnit=='Package'){
			var packageAmount=$("#packageAmount").val();
			if(packageAmount==''){
				packageAmount=0;
			}
			packval=parseInt(packageAmount)+1;
			$("#packageAmount").val(packval);
			html+='<td width="35%">Pack：<span class="lz2">'+formatNumber(packval);
		}
		
		html+='</span> </td>';
		 var tickets=$("#tickets").val();
		  if(tickets==''){
			  tickets=0;
		  }
		  totaltickts=parseInt(checkNaN(obj.ticketNum))+parseInt(checkNaN(tickets));
		  $("#tickets").val(totaltickts);
		html+='<td width="19%" class="hoz">Total Tickets :<span class="lz2">'+formatNumber(totaltickts);
		html+='</span> </td>';
		 var amount=$("#amount").val();
		  if(amount==''){
			  amount=0;
		  }
		 
		  totalvalue=parseInt(checkNaN(obj.amount))+parseInt(checkNaN(amount));
		  $("#amount").val(totalvalue);
		html+=' <td width="22%" align="right" class="hoz">Total Amount :<span class="lz2">'+formatNumber(totalvalue);
		html+='</span> riels</td>'; 
		html+='</tr></table>';
		return html;
}
function initDivhtmlzh(obj){
	 var html='';
		$("#divBethdetail").empty();
		
		html+='<table width="100%" border="0" cellspacing="0" cellpadding="0">';
		html+='<tr>';
		
		if(obj.packUnit=='Trunk'){
			var trunkamout=$("#trunkhAmount").val();
			
			if(trunkamout==''){
				trunkamout=0;
			}
			trunkval=parseInt(trunkamout)+1;
			
			$("#trunkhAmount").val(trunkval);
			html+='<td width="13%">箱 :<span class="lz2">'+formatNumber(trunkval);
		}
		 if(obj.packUnit=='Box'){
			var boxAmount=$("#boxAmount").val();
			if(boxAmount==''){
				boxAmount=0;
			}
			 boxval=1+parseInt(boxAmount);
			 $("#boxAmount").val(boxval);
			html+='<td width="11%">盒 :<span class="lz2" >'+formatNumber(boxval);
		}
		if(obj.packUnit=='Package'){
			var packageAmount=$("#packageAmount").val();
			if(packageAmount==''){
				packageAmount=0;
			}
			packval=parseInt(packageAmount)+1;
			$("#packageAmount").val(packval);
			html+='<td width="35%">本：<span class="lz2">'+formatNumber(packval);
		}
		
		html+='</span> </td>';
		 var tickets=$("#tickets").val();
		  if(tickets==''){
			  tickets=0;
		  }
		  totaltickts=parseInt(checkNaN(obj.ticketNum))+parseInt(checkNaN(tickets));
		  $("#tickets").val(totaltickts);
		html+='<td width="19%" class="hoz">总票数 :<span class="lz2">'+formatNumber(totaltickts);
		html+='</span> </td>';
		 var amount=$("#amount").val();
		  if(amount==''){
			  amount=0;
		  }
		 
		  totalvalue=parseInt(checkNaN(obj.amount))+parseInt(checkNaN(amount));
		  $("#amount").val(totalvalue);
		html+=' <td width="22%" align="right" class="hoz">总金额 :<span class="lz2">'+formatNumber(totalvalue);
		html+='</span> 瑞尔</td>'; 
		html+='</tr></table>';
		return html;
}
function initRow(obj){
	 var row='<tr><td width="10%" >'+obj.planCode;
    row+='</td>';
    row+='<td width="1%" >&nbsp;</td>';
    row+='<td width="10%" >'+obj.planName;
    row+='</td>';
    row+=' <td width="1%" >&nbsp;</td>';
    row+='<td width="10%" >'+obj.batchCode;
    row+='</td>';
    row+='<td width="1%" >&nbsp;</td>';
    row+=' <td width="10%" >'+obj.groupCode;
    row+='</td>';
    row+='<td width="1%" >&nbsp;</td>';
    var packName="";
    if(obj.packUnit=='Trunk'){
    	packName="箱";
     }
    if(obj.packUnit=='Box'){
    	packName="盒";
     }
    if(obj.packUnit=='Package'){
    	packName="本";
     }
    row+=' <td width="10%" >'+packName;
    row+='</td>';
    row+=' <td width="1%" >&nbsp;</td>';
    row+=' <td width="10%" >'+obj.packUnitCode
    row+='</td>';
    row+=' <td width="1%" >&nbsp;</td>';
    row+='<td width="10%" >'+formatNumber(obj.ticketNum);
    row+='</td>';
    row+=' <td width="1%" >&nbsp;</td>';
    row+='<td width="10%"><a href="javascript:void(0)" onclick="deleteGame('+rownum+',this)" title="Delete"><img src="././img/cross.png" alt="Delete" /></a></td>';
    row+='<input type="hidden" name="para['+rownum+'].planCode" id="planCode'+rownum+'" value='+obj.planCode+'>';
    row+='<input type="hidden" name="para['+rownum+'].batchCode" id="batchCode'+rownum+'" value='+obj.batchCode+'>';
    row+='<input type="hidden" name="para['+rownum+'].packUnit" id="packUnit'+rownum+'"value='+obj.packUnit+'>';
    row+='<input type="hidden" name="para['+rownum+'].packUnitCode" id="packUnitCode'+rownum+'" value='+obj.packUnitCode+'>';
    row+='<input type="hidden" name="para['+rownum+'].ticketNum" id="ticketNum'+rownum+'" value='+checkNaN(obj.ticketNum)+'>';
    row+='<input type="hidden" name="para['+rownum+'].bachamount" id="bachamount'+rownum+'" value='+checkNaN(obj.amount)+'>';
    row+='<input type="hidden" name="para['+rownum+'].groupCode" id="groupCode'+rownum+'" value='+obj.groupCode+'>';
    row+='<input type="hidden" name="para['+rownum+'].firstPkgCode" id="firstPkgCode'+rownum+'" value='+obj.firstPkgCode+'>';
    row+='<input type="hidden" name="para['+rownum+'].packUnitValue" id="packUnitValue'+rownum+'" value='+obj.packUnitValue+'>';
    
    row+='</tr>'
    rownum++; 
    return row;
}
function initRow1(obj){
	 var row='<tr><td width="10%" >'+obj.planCode;
   row+='</td>';
   row+='<td width="1%" >&nbsp;</td>';
   row+='<td width="10%" >'+obj.planName;
   row+='</td>';
   row+=' <td width="1%" >&nbsp;</td>';
   row+='<td width="10%" >'+obj.batchCode;
   row+='</td>';
   row+='<td width="1%" >&nbsp;</td>';
   row+=' <td width="10%" >'+obj.groupCode;
   row+='</td>';
   row+='<td width="1%" >&nbsp;</td>';
   row+=' <td width="10%" >'+obj.packUnit;
   row+='</td>';
   row+=' <td width="1%" >&nbsp;</td>';
   row+=' <td width="10%" >'+obj.packUnitCode
   row+='</td>';
   row+=' <td width="1%" >&nbsp;</td>';
   row+='<td width="10%" >'+formatNumber(obj.ticketNum);
   row+='</td>';
   row+=' <td width="1%" >&nbsp;</td>';
   row+='<td width="10%"><a href="javascript:void(0)" onclick="deleteGame1('+rownum+',this)" title="Delete"><img src="././img/cross.png" alt="Delete" /></a></td>';
   row+='<input type="hidden" name="para['+rownum+'].planCode" id="planCode'+rownum+'" value='+obj.planCode+'>';
   row+='<input type="hidden" name="para['+rownum+'].batchCode" id="batchCode'+rownum+'" value='+obj.batchCode+'>';
   row+='<input type="hidden" name="para['+rownum+'].packUnit" id="packUnit'+rownum+'"value='+obj.packUnit+'>';
   row+='<input type="hidden" name="para['+rownum+'].packUnitCode" id="packUnitCode'+rownum+'" value='+obj.packUnitCode+'>';
   row+='<input type="hidden" name="para['+rownum+'].ticketNum" id="ticketNum'+rownum+'" value='+checkNaN(obj.ticketNum)+'>';
   row+='<input type="hidden" name="para['+rownum+'].bachamount" id="bachamount'+rownum+'" value='+checkNaN(obj.amount)+'>';
   row+='<input type="hidden" name="para['+rownum+'].groupCode" id="groupCode'+rownum+'" value='+obj.groupCode+'>';
   row+='<input type="hidden" name="para['+rownum+'].firstPkgCode" id="firstPkgCode'+rownum+'" value='+obj.firstPkgCode+'>';
   row+='<input type="hidden" name="para['+rownum+'].packUnitValue" id="packUnitValue'+rownum+'" value='+obj.packUnitValue+'>';
   
   row+='</tr>'
   rownum++; 
   return row;
}

function checkNaN(val){
	var value=0;
	 if(isNaN(val)){
		 value=0;
	 }
	 else{
		 value=val;
	 }
	 return value;
}
function initDiv(html){
	

	$("#divBethdetail").append(html);
	
}


function initPlanHtml(objx){

	var objid="";
		
	if(objx.packUnit=='Trunk'){
		
		objid=formatNum($("#plantrunkAmount"+objx.planCode).text());
		
		var trunkamout=parseInt(objid)+1;
		$("#plantrunkAmount"+objx.planCode).text(formatNumber(trunkamout));
	}
	
	if(objx.packUnit=='Box'){
		
		objid=$("#plantrunkBox"+objx.planCode).html();
	
	    var boxAmount=parseInt(formatNum(objid))+1;
		
		$("#plantrunkBox"+objx.planCode).html(formatNumber(boxAmount));
	}
	
	if(objx.packUnit=='Package'){
		var pkgAmount=parseInt(formatNum($("#plantrunkPkg"+objx.planCode).html()))+1;
		$("#plantrunkPkg"+objx.planCode).html(formatNumber(pkgAmount));
	}
	
	var titickts=parseInt(formatNum($("#plantrunkTickts"+objx.planCode).html()))+parseInt(objx.ticketNum);
	$("#plantrunkTickts"+objx.planCode).html(formatNumber(titickts));
	var sum=$("#sumTickets").html();
  
	$("#sumTickets").html(0);

	var sumformat=formatNum(sum);

	var total=parseInt(sumformat)+parseInt(objx.ticketNum);

	$("#sumTickets").html(formatNumber(total));
	
}

function deleteGame1(rowNum,obj){
	 var del=$("#planCode"+rowNum).val()+$("#batchCode"+rowNum).val()+$("#packUnitCode"+rowNum).val();
		
	 SJZPrinter.removeObject(del);
	 var tb = document.getElementById("gameBatchInfo");  
	 var rnum=tb.rows.length;  

			 var html='';
				$("#divBethdetail").empty();	
				html+='<table width="100%" border="0" cellspacing="0" cellpadding="0">';
				html+='<tr>';
				  var unitype=$("#packUnit"+rowNum).val();
				
				if(unitype=='Trunk'){
					var trunkamout=$("#trunkhAmount").val();
					
					
					trunkval=parseInt(trunkamout)-1;
					
					$("#trunkhAmount").val(trunkval);
					html+='<td width="13%">Trunk :<span class="lz2">'+formatNumber(trunkval);
				}
				 if(unitype=='Box'){
					var boxAmount=$("#boxAmount").val();
					
					 boxval=parseInt(boxAmount)-1;
					 $("#boxAmount").val(boxval);
					html+='<td width="11%">Box :<span class="lz2" >'+formatNumber(boxval);
				}
				if(unitype=='Package'){
					var packageAmount=$("#packageAmount").val();
					packval=parseInt(packageAmount)-1;
					$("#packageAmount").val(packval);
					html+='<td width="35%">Package：<span class="lz2">'+formatNumber(packval);
				}
				
				html+='</span> </td>';
				 var tickets=$("#tickets").val();
				   
				  totaltickts=parseInt(tickets)-parseInt($("#ticketNum"+rowNum).val());
				  $("#tickets").val(totaltickts);
				html+='<td width="19%" class="hoz">Total tickets :<span class="lz2">'+formatNumber(totaltickts);
				html+='</span> </td>';
				 var amount=$("#amount").val();
				 
				  totalvalue=parseInt(amount)-parseInt($("#bachamount"+rowNum).val());
				  $("#amount").val(totalvalue);
				html+=' <td width="22%" align="right" class="hoz">Total Amount :<span class="lz2">'+formatNumber(totalvalue);
				html+='</span> Reals</td>'; 
				html+='</tr></table>';
				initDiv(html);
				$(obj).parent().parent().remove(); 
		    	rownum--;
		 		   
				    if(rownum<0){
				    	
				    	rownum=0;
				    }
 

}
function formatNumber(num, precision, separator) {
    var parts;
    // 判断是否为数字
    if (!isNaN(parseFloat(num)) && isFinite(num)) {
        // 把类似 .5, 5. 之类的数据转化成0.5, 5, 为数据精度处理做准, 至于为什么
        // 不在判断中直接写 if (!isNaN(num = parseFloat(num)) && isFinite(num))
        // 是因为parseFloat有一个奇怪的精度问题, 比如 parseFloat(12312312.1234567119)
        // 的值变成了 12312312.123456713
        num = Number(num);
        // 处理小数点位数
        num = (typeof precision !== 'undefined' ? num.toFixed(precision) : num).toString();
        // 分离数字的小数部分和整数部分
        parts = num.split('.');
        // 整数部分加[separator]分隔, 借用一个著名的正则表达式
        parts[0] = parts[0].toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1' + (separator || ','));

        return parts.join('.');
    }
    return NaN;
}
function formatNum(val){
	val=val.replace(/\$|\,/g,'');
	return val;
}


