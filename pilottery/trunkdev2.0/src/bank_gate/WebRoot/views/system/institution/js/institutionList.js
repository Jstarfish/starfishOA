$(function () {
	initTable();
	$(window).resize(function(){
		$('#institution-table').bootstrapTable('refresh'); 
	});
});

function doQuery(params){
	$('#institution-table').bootstrapTable('refresh');  
}

function initTable(){
	var url = "institution.do?method=listInstitution&random="+Math.random();
	$('#institution-table').bootstrapTable({
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
        	fileName: 'Institutions Info'
        },
		columns: [
 		{
			field : 'orgCode',
			title : 'Institution Code',
			align : 'center',
			valign : 'middle'
		}, {
			field : 'orgName',
			title : 'Institution Name',
			align : 'center',
			valign : 'middle'
		}, {
			field : 'directorAdmin',
			title : 'Head of Institution',
			align : 'center',
			valign : 'middle',
			sortable : true
		}, {
			field : 'phone',
			title : 'Contact Phone',
			align : 'center',
			valign : 'middle'
		},{
			field : 'orgStatus',
			title : 'Status',
			align : 'center',
			valign : 'middle',
			sortable : true ,
			formatter : function (value, row, index){
				if(value == 1){
					return "normal";
				}else if(value == 2){
					return "delete";
				}
			} 
		},{
			field : 'operate',
			title : 'Operations',
			align : 'center',
			events : operateEvents,
			formatter : operateFormatter
		}]
	});
}

function operateFormatter(value, row, index) {
	var orgStatus = row.orgStatus;
	var iconStr = "";
	if(orgStatus == 1){//可用
		iconStr = [
		           '<a class="edit" href="javascript:void(0)" title="Edit">',
		           '<i class="glyphicon glyphicon-pencil">&nbsp;</i>',
		           '</a>  ',
		           '<a class="remove" href="javascript:void(0)" title="Delete">',
		           '<i class="glyphicon glyphicon-remove">&nbsp;</i>',
		           '</a>  '
		       ].join('');
		}else{
			iconStr = [
			'<a class="icon-disabled" href="javascript:void(0)" title="Edit">',
	           '<i class="glyphicon glyphicon-pencil">&nbsp;</i>',
	           '</a>  ',
	           '<a class="icon-disabled" href="javascript:void(0)" title="Delete">',
	           '<i class="glyphicon glyphicon-remove">&nbsp;</i>',
	           '</a>  '
	           ].join('');
		}
    return iconStr;
}
window.operateEvents = {
    'click .edit': function (e, value, row, index) {
		  layer.open({
		    		  type: 2,
		    		  title: 'Edit Institution',
		    		  maxmin: true,
		    		  shadeClose: true, //点击遮罩关闭层
		    		  area : ['800px' , '520px'],
		    		  content: 'institution.do?method=editInstitution&orgCode='+row.orgCode,
		    		  end : doQuery
				  });
    },
    'click .remove': function (e, value, row, index) {
    	swal({
    		title: "Are you sure you want to delete this institution",
	        text: "Will not be able to recover after deletion, please careful operation！",
	        type: "warning",
	        showCancelButton: true,
	        cancelButtonText:"Cancel",
	        confirmButtonColor: "#DD6B55",
	        confirmButtonText: "Delete",
	        closeOnConfirm: true
	    }, function () {
	    	deleteOrg(row.orgCode);
	    });
    }
};

function queryParams(params) {
	var param = {
		orgName : $("#orgName").val(),
		orgStatus : $("#orgStatus").val(),
		limit : this.limit, // 页面大小
		offset : this.offset, // 页码
		pageindex : this.pageNumber,
		pageSize : this.pageSize
	}
	return param;
} 

function addOrg(){
	layer.open({
		  type: 2,
		  title: 'New Institution',
		  maxmin: true,
		  shadeClose: true, //点击遮罩关闭层
		  area : ['800px' , '520px'],
		  content: 'institution.do?method=addOrg',
		  end : doQuery
	  });
}
function deleteOrg(orgCode){
	$.ajax({
	   type: "get",
	   url: "institution.do?method=deleteOrg&orgCode="+orgCode,
	   success: function(msg){
	     if(msg=='success'){
	    	 doQuery();
	     }else{
	    	 sweetAlert("Delete Fail", msg, "error");
	     }
	   }
	});
}