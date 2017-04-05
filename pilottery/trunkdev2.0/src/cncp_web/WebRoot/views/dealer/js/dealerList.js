$(function () {
	initTable();
	initDate();
	
	$(window).resize(function(){
		$('#dealerList-table').bootstrapTable('refresh'); 
	});
});

function doQuery(params){
	$('#dealerList-table').bootstrapTable('refresh');  
}

function initTable(){
	var url = "dealer.do?method=listDealers&random="+Math.random();
	$('#dealerList-table').bootstrapTable({
		method:'POST',
		dataType:'json',
		contentType: "application/x-www-form-urlencoded",
		cache: false,
		striped: true,                      //是否显示行间隔色
		sidePagination: "client",           //分页方式：client客户端分页，server服务端分页（*）
		url:url,
		height: $(window).height() - 85,
		width:$(window).width(),
		showColumns:true,
		pagination:true,
		queryParams : queryParams,
		minimumCountColumns:2,
		pageNumber:1,                       //初始化加载第一页，默认第一页
        pageSize: 20,                       //每页的记录行数（*）
        pageList: [10, 25, 50, 100],        //可供选择的每页的行数（*）
        uniqueId: "id",                     //每一行的唯一标识，一般为主键列
		showExport: true,                    
        exportDataType: 'all',
        exportOptions:{
        	fileName: 'Dealer Info'
        },
		columns: [
 		{
            title: 'No.',
            align : 'center',
			valign : 'middle',
            formatter: function (value, row, index) {
                return index+1;
            }
		}, {
			field : 'dealerCode',
			title : 'Dealer Code',
			align : 'center',
			valign : 'middle',
			sortable : true
		}, {
			field : 'dealerName',
			title : 'Dealer Name',
			align : 'center',
			valign : 'middle'
		}, {
			field : 'openTime',
			title : 'Date',
			align : 'center',
			valign : 'middle',
			sortable : true
		}, {
			field : 'accountBalance',
			title : 'Account Balance',
			halign :'center',
			align : 'right',
			valign : 'middle',
			formatter : function (value, row, index){
				return toThousand(value);
			}
		}, {
			field : 'operate',
			title : 'Operation',
			align : 'center',
			events : operateEvents,
			formatter : operateFormatter
		} ]
	});
}

function operateFormatter(value, row, index) {
	var status = row.dealerStatus;
	var deatilButton = '<a class="detail" href="javascript:void(0)" title="Details">'+
					   '<i class="glyphicon glyphicon glyphicon-file">&nbsp;</i>'+
					   '</a>';
	var editButton = '<a class="edit" href="javascript:void(0)" title="Edit">'+
    				 '<i class="glyphicon glyphicon-pencil">&nbsp;</i>'+
    				 '</a>';
    var pauseButton = '<a class="pause" href="javascript:void(0)" title="Lock">'+
    				   '<i class="glyphicon glyphicon-pause">&nbsp;</i>'+
    				   '</a>  ';
	var playButton = '<a class="play" href="javascript:void(0)" title="Unlock">'+
	    		     '<i class="glyphicon glyphicon-play">&nbsp;</i>'+
	    		     '</a>';
    var perButton = '<a class="permission" href="javascript:void(0)" title="Game Auth">'+
    				'<i class="glyphicon glyphicon-wrench">&nbsp;</i>'+
    				'</a>';
    var infButton =  '<a class="information" href="javascript:void(0)" title="Security">'+
    			     '<i class="glyphicon glyphicon-briefcase">&nbsp;</i>'+
    			     '</a>';
    var creditButton = '<a class="credit" href="javascript:void(0)" title="Credit Setting">'+
				    '<i class="glyphicon glyphicon-credit-card">&nbsp;</i>'+
				    '</a>';
    
    var deatilButton2 = '<a class="icon-disabled" href="javascript:void(0)" title="Details">'+
					    '<i class="glyphicon glyphicon glyphicon-file">&nbsp;</i>'+
					    '</a>';
	var editButton2 = '<a class="icon-disabled" href="javascript:void(0)" title="Edit">'+
					  '<i class="glyphicon glyphicon-pencil">&nbsp;</i>'+
					  '</a>';
	var pauseButton2 = '<a class="icon-disabled" href="javascript:void(0)" title="Lock">'+
					   '<i class="glyphicon glyphicon-pause">&nbsp;</i>'+
					   '</a>  ';
	var playButton2 = '<a class="icon-disabled" href="javascript:void(0)" title="Unlock">'+
					  '<i class="glyphicon glyphicon-play">&nbsp;</i>'+
					  '</a>';
	var perButton2 = '<a class="icon-disabled" href="javascript:void(0)" title="Game Auth">'+
					 '<i class="glyphicon glyphicon-wrench">&nbsp;</i>'+
					 '</a>';
	var infButton2 =  '<a class="icon-disabled" href="javascript:void(0)" title="Security">'+
					  '<i class="glyphicon glyphicon-briefcase">&nbsp;</i>'+
					  '</a>';
	var creditButton2 = '<a class="icon-disabled" href="javascript:void(0)" title="Credit Setting">'+
					    '<i class="glyphicon glyphicon-credit-card">&nbsp;</i>'+
					    '</a>';
   if(status == 1){
	   return deatilButton + editButton + creditButton + pauseButton +  perButton + infButton;
   } else{
	   return deatilButton2 + editButton2 + creditButton2 + playButton +  perButton2 + infButton2;
   }
}
window.operateEvents = {
	'click .detail': function (e, value, row, index) {
		  layer.open({
		    		  type: 2,
		    		  title: 'Dealer Info',
		    		  maxmin: true,
		    		  shadeClose: true, //点击遮罩关闭层
		    		  area : ['800px' , '520px'],
		    		  content: 'dealer.do?method=detailDealer&dealerCode='+row.dealerCode,
		    		  end : doQuery
				  });
    },
    'click .edit': function (e, value, row, index) {
		  layer.open({
		    		  type: 2,
		    		  title: 'Edit Dealer',
		    		  maxmin: true,
		    		  shadeClose: true, //点击遮罩关闭层
		    		  area : ['800px' , '520px'],
		    		  content: 'dealer.do?method=initEditDealer&dealerCode='+row.dealerCode,
		    		  end : doQuery
				  });
    },
    'click .permission': function (e, value, row, index) {
    	layer.open({
    		type: 2,
    		title: 'Game Auth',
    		maxmin: true,
    		shadeClose: true, //点击遮罩关闭层
    		area : ['800px' , '400px'],
    		content: 'dealer.do?method=initSetGamePermissions&dealerCode='+row.dealerCode,
    		end : doQuery
    	});
    },
    'click .pause': function (e, value, row, index) {
    	swal({
	        title: "Are you sure you want to lock the dealer?",
	        text: "After the lock will not be able to use, please be careful to operate！",
	        type: "warning",
	        showCancelButton: true,
	        cancelButtonText:"Cancel",
	        confirmButtonColor: "#DD6B55",
	        confirmButtonText: "Confirm",
	        closeOnConfirm: false
	    }, function () {
	    	pauseDealer(row.dealerCode);
	    });
    },
    'click .play': function (e, value, row, index) {
    	swal({
    		title: "Are you sure you want to unlock the dealer?",
    		text: "After the unlock, the dealer can be used normally",
    		type: "warning",
    		showCancelButton: true,
    		cancelButtonText:"Cancel",
    		confirmButtonColor: "#DD6B55",
    		confirmButtonText: "Confirm",
    		closeOnConfirm: false
    	}, function () {
    		playDealer(row.dealerCode);
    	});
    },
    'click .information': function (e, value, row, index) {
    	layer.open({
    		type: 2,
    		title: 'Secure information access',
    		maxmin: true,
    		shadeClose: true, //点击遮罩关闭层
    		area : ['400px' , '280px'],
    		content: 'dealer.do?method=initUpdateMsg&dealerCode='+row.dealerCode,
    		end : doQuery
    	});
    },
    'click .credit': function (e, value, row, index) {
    	layer.open({
    		type: 2,
    		title: 'Credit Setting',
    		maxmin: true,
    		shadeClose: true, //点击遮罩关闭层
    		area : ['800px' , '300px'],
    		content: 'dealer.do?method=initCreditSetting&dealerCode='+row.dealerCode,
    		end : doQuery
    	});
    }
};

function initDate(){
	var start = {
            elem: '#startDate',
            format: 'YYYY-MM-DD hh:mm:ss',
            max: laydate.now(),
            istime: true,
            istoday: false,
            choose: function (datas) {
                end.min = datas; //开始日选好后，重置结束日的最小日期
                end.start = datas //将结束日的初始值设定为开始日
            }
        };
        var end = {
            elem: '#endDate',
            format: 'YYYY-MM-DD hh:mm:ss',
            max: laydate.now(),
            istime: true, //是否开启时间选择
            isclear: true, //是否显示清空
            istoday: true, //是否显示今天
            issure: true, //是否显示确认
            choose: function (datas) {
                start.max = datas; //结束日选好后，重置开始日的最大日期
            }
        };
        laydate(start);
        laydate(end);
}

function queryParams(params) {
	var param = {
		dealerCode : $("#dealerCode").val(),
		dealerName : $("#dealerName").val(),
		startDate : $("#startDate").val(),
		endDate : $("#endDate").val(),
		limit : this.limit, // 页面大小
		offset : this.offset, // 页码
		pageindex : this.pageNumber,
		pageSize : this.pageSize
	}
	return param;
} 

function addDealer(){
	layer.open({
		  type: 2,
		  title: 'New Dealer',
		  maxmin: true,
		  shadeClose: true, //点击遮罩关闭层
		  area : ['800px' , '520px'],
		  content: 'dealer.do?method=initAddDealer',
		  end : doQuery
	  });
}
function pauseDealer(dealerCode){
	$.ajax({
	   type: "get",
	   url: "dealer.do?method=changeDealerStatus&dealerCode="+dealerCode+"&dealerStatus=2",
	   success: function(msg){
	     if(msg=='success'){
	    	 sweetAlert("Success", "", "success");
	    	 doQuery();
	     }else{
	    	 sweetAlert("Fail", msg, "error");
	     }
	   }
	});
}

function playDealer(dealerCode){
	$.ajax({
	   type: "get",
	   url: "dealer.do?method=changeDealerStatus&dealerCode="+dealerCode+"&dealerStatus=1",
	   success: function(msg){
	     if(msg=='success'){
	    	 sweetAlert("Success", "", "success");
	    	 doQuery();
	     }else{
	    	 sweetAlert("Fail", msg, "error");
	     }
	   }
	});
}