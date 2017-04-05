$(function () {
	initTable();
	//initDate();
	
	$(window).resize(function(){
		$('#user-table').bootstrapTable('refresh'); 
	});
});

function doQuery(params){
	$('#user-table').bootstrapTable('refresh');  
}

function initTable(){
	var url = "user.do?method=listUsers&random="+Math.random();
	$('#user-table').bootstrapTable({
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
        	fileName: 'User Info'
        },
		columns: [
 		{
			field : 'loginId',
			title : 'User Name',
			align : 'center',
			valign : 'middle'
		}, {
			field : 'realName',
			title : 'Real Name',
			align : 'center',
			valign : 'middle'
		}, {
			field : 'orgName',
			title : 'Institution',
			align : 'center',
			valign : 'middle',
			sortable : true
		}, {
			field : 'phone',
			title : 'Contact Phone',
			align : 'center',
			valign : 'middle'
		}, {
			field : 'address',
			title : 'Home Address',
			align : 'center',
			valign : 'middle'
		},{
			field : 'status',
			title : 'Status',
			align : 'center',
			valign : 'middle',
			sortable : true ,
			formatter : function (value, row, index){
				if(value == 1){
					return "unlock";
				}else if(value == 2){
					return "delete";
				}else if(value == 3){
					return "lock";
				}
			}
		},{
			field : 'createTime',
			title : 'Create Date',
			align : 'center',
			valign : 'middle',
			sortable : true
		}, {
			field : 'operate',
			title : 'Operation',
			align : 'center',
			events : operateEvents,
			formatter : operateFormatter
		}]
	});
}

function operateFormatter(value, row, index) {
	var status = row.status;
	var iconStr = "";
	if(status == 1){//可用
		iconStr = [
		           '<a class="edit" href="javascript:void(0)" title="Edit">',
		           '<i class="glyphicon glyphicon-pencil">&nbsp;</i>',
		           '</a>  ',
		           '<a class="remove" href="javascript:void(0)" title="Delete">',
		           '<i class="glyphicon glyphicon-remove">&nbsp;</i>',
		           '</a>  ',
		           '<a class="disable" href="javascript:void(0)" title="Lock">',
		           '<i class="glyphicon glyphicon-pause">&nbsp;</i>',
		           '</a>  ',
		           '<a class="resetPwd" href="javascript:void(0)" title="Reset Password">',
		           '<i class="glyphicon glyphicon-cog"></i>',
		           '</a>'
		       ].join('');
	} else if(status == 2){	//删除
		iconStr = [
		           '<a class="icon-disabled" href="javascript:void(0)" title="Edit">',
		           '<i class="glyphicon glyphicon-pencil">&nbsp;</i>',
		           '</a>  ',
		           '<a class="icon-disabled" href="javascript:void(0)" title="Delete">',
		           '<i class="glyphicon glyphicon-remove">&nbsp;</i>',
		           '</a>  ',
		           '<a class="icon-disabled" href="javascript:void(0)" title="Lock">',
		           '<i class="glyphicon glyphicon-pause">&nbsp;</i>',
		           '</a>  ',
		           '<a class="icon-disabled" href="javascript:void(0)" title="Reset Password">',
		           '<i class="glyphicon glyphicon-cog"></i>',
		           '</a>'
		       ].join('');
	} else { //禁用
		iconStr = [
		           '<a class="icon-disabled" href="javascript:void(0)" title="Edit">',
		           '<i class="glyphicon glyphicon-pencil">&nbsp;</i>',
		           '</a>  ',
		           '<a class="icon-disabled" href="javascript:void(0)" title="Delete">',
		           '<i class="glyphicon glyphicon-remove">&nbsp;</i>',
		           '</a>  ',
		           '<a class="enable" href="javascript:void(0)" title="Unlock">',
		           '<i class="glyphicon glyphicon-play">&nbsp;</i>',
		           '</a>  ',
		           '<a class="icon-disabled" href="javascript:void(0)" title="Reset Password">',
		           '<i class="glyphicon glyphicon-cog"></i>',
		           '</a>'
		       ].join('');
	}
	
    return iconStr;
}
window.operateEvents = {
    'click .edit': function (e, value, row, index) {
		  layer.open({
		    		  type: 2,
		    		  title: 'Edit User',
		    		  maxmin: true,
		    		  shadeClose: true, //点击遮罩关闭层
		    		  area : ['800px' , '520px'],
		    		  content: 'user.do?method=editUser&userId='+row.id,
		    		  end : doQuery
				  });
    },
    'click .remove': function (e, value, row, index) {
    	swal({
	        title: "Are you sure you want to delete this user?",
	        text: "Will not be able to recover after deletion, please careful operation！",
	        type: "warning",
	        showCancelButton: true,
	        cancelButtonText:"Cancel",
	        confirmButtonColor: "#DD6B55",
	        confirmButtonText: "Delete",
	        closeOnConfirm: true
	    }, function () {
	    	deleteUser(row.id);
	    });
    },
    'click .enable': function (e, value, row, index) {
    	swal({
	        title: "Are you sure you want to unlock the user?",
	        text: "",
	        type: "warning",
	        showCancelButton: true,
	        cancelButtonText:"Cancel",
	        confirmButtonColor: "#DD6B55",
	        confirmButtonText: "Confirm",
	        closeOnConfirm: true
	    }, function () {
	    	enableUser(row.id);
	    });
    },
    'click .disable': function (e, value, row, index) {
    	swal({
	        title: "Are you sure you want to lock the user?",
	        text: "",
	        type: "warning",
	        showCancelButton: true,
	        cancelButtonText:"Cancel",
	        confirmButtonColor: "#DD6B55",
	        confirmButtonText: "Confirm",
	        closeOnConfirm: true
	    }, function () {
	    	disableUser(row.id);
	    });
    },
    'click .resetPwd': function (e, value, row, index) {
    	swal({
	        title: "Are you sure you want to reset Password?",
	        text: "",
	        type: "warning",
	        showCancelButton: true,
	        cancelButtonText:"Cancel",
	        confirmButtonColor: "#DD6B55",
	        confirmButtonText: "Confirm",
	        closeOnConfirm: true
	    }, function () {
	    	resetPwd(row.id);
	    });
    }
};
/*
function initDate(){
	var start = {
            elem: '#startDate',
            format: 'YYYY-MM-DD hh:mm:ss',
            min: laydate.now(-7),		
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
            min: laydate.now(-7),		
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
*/
function queryParams(params) {
	var param = {
		orgCode : $("#orgCode").val(),
		loginId : $("#loginId").val(),
		status : $("#status").val(),
		limit : this.limit, // 页面大小
		offset : this.offset, // 页码
		pageindex : this.pageNumber,
		pageSize : this.pageSize
	}
	return param;
} 

function addUser(){
	layer.open({
		  type: 2,
		  title: 'New User',
		  maxmin: true,
		  shadeClose: true, //点击遮罩关闭层
		  area : ['800px' , '520px'],
		  content: 'user.do?method=addUser',
		  end : doQuery
	  });
}
function deleteUser(userId){
	$.ajax({
	   type: "get",
	   url: "user.do?method=deleteUser&userId="+userId,
	   success: function(msg){
	     if(msg=='success'){
	    	 doQuery();
	     }else{
	    	 sweetAlert("Delete Fail", msg, "error");
	     }
	   }
	});
}

function enableUser(userId){
	$.ajax({
	   type: "get",
	   url: "user.do?method=enableUser&userId="+userId,
	   success: function(msg){
	     if(msg=='success'){
	    	 doQuery();
	     }else{
	    	 sweetAlert("Unlock Fail", msg, "error");
	     }
	   }
	});
}

function disableUser(userId){
	$.ajax({
	   type: "get",
	   url: "user.do?method=disableUser&userId="+userId,
	   success: function(msg){
	     if(msg=='success'){
	    	 doQuery();
	     }else{
	    	 sweetAlert("Lock Fail", msg, "error");
	     }
	   }
	});
}

function resetPwd(userId){
	$.ajax({
	   type: "get",
	   url: "user.do?method=resetPwd&userId="+userId,
	   success: function(msg){
	     if(msg=='success'){
	    	 doQuery();
	     }else{
	    	 sweetAlert("Reset Password Fail", msg, "error");
	     }
	   }
	});
}