$(function () {
	initTable();
	//initDate();
	
	$(window).resize(function(){
		$('#role-table').bootstrapTable('refresh'); 
	});
});

function doQuery(params){
	$('#role-table').bootstrapTable('refresh');  
}

function initTable(){
	var url = "role.do?method=listRoles&random="+Math.random();
	$('#role-table').bootstrapTable({
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
			field : 'roleId',
			title : 'Role ID',
			align : 'center',
			valign : 'middle'
		}, {
			field : 'roleName',
			title : 'Role Name',
			align : 'center',
			valign : 'middle'
		}, {
			field : 'remark',
			title : 'Remark',
			align : 'center',
			valign : 'middle',
			sortable : true
		},{
			field : 'operate',
			title : 'Operation',
			align : 'center',
			events : operateEvents,
			formatter : operateFormatter
		}]
	});
}

function operateFormatter(value, row, index) {
	return [
     '<a class="edit" href="javascript:void(0)" title="Edit">',
     '<i class="glyphicon glyphicon-pencil">&nbsp;</i>',
     '</a>  ',
     '<a class="remove" href="javascript:void(0)" title="Delete">',
     '<i class="glyphicon glyphicon-remove">&nbsp;</i>',
     '</a>  ',
     '<a class="permission" href="javascript:void(0)" title="Permissions">',
     '<i class="glyphicon glyphicon-eye-open">&nbsp;</i>',
     '</a>'
   ].join('');
}
window.operateEvents = {
    'click .edit': function (e, value, row, index) {
		  layer.open({
		    		  type: 2,
		    		  title: 'Edit Role',
		    		  maxmin: true,
		    		  shadeClose: true, //点击遮罩关闭层
		    		  area : ['800px' , '320px'],
		    		  content: 'role.do?method=editRole&roleId='+row.roleId,
		    		  end : doQuery
				  });
    },
    'click .remove': function (e, value, row, index) {
    	swal({
	        title: "Are you sure you want to delete this role?",
	        text: "Will not be able to recover after deletion, please careful operation！",
	        type: "warning",
	        showCancelButton: true,
	        cancelButtonText:"Cancel",
	        confirmButtonColor: "#DD6B55",
	        confirmButtonText: "Delete",
	        closeOnConfirm: true
	    }, function () {
	    	deleteRole(row.roleId);
	    });
    },
    'click .permission': function (e, value, row, index) {
    	 layer.open({
   		  type: 2,
   		  title: 'Permissions',
   		  maxmin: true,
   		  shadeClose: true, //点击遮罩关闭层
   		  area : ['800px' , '520px'],
   		  content: 'role.do?method=rolePermission&roleId='+row.roleId,
   		  end : doQuery
		  });
    }
};

function queryParams(params) {
	var param = {
		limit : this.limit, // 页面大小
		offset : this.offset, // 页码
		pageindex : this.pageNumber,
		pageSize : this.pageSize
	}
	return param;
} 

function addRole(){
	layer.open({
		  type: 2,
		  title: 'Add Role',
		  maxmin: true,
		  shadeClose: true, //点击遮罩关闭层
		  area : ['800px' , '320px'],
		  content: 'role.do?method=addRole',
		  end : doQuery
	  });
}
function deleteRole(roleId){
	$.ajax({
	   type: "get",
	   url: "role.do?method=deleteRole&roleId="+roleId,
	   success: function(msg){
	     if(msg=='success'){
	    	 doQuery();
	     }else if(msg == '-1'){
	    	 sweetAlert("Fail", "Cannot delete a role having user！", "error");
	     }else{
	    	 sweetAlert("Fail", msg, "error");
	     }
	   }
	});
}