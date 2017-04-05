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
        	fileName: '部门信息'
        },
		columns: [
 		{
			field : 'orgCode',
			title : '部门编号',
			align : 'center',
			valign : 'middle'
		}, {
			field : 'orgName',
			title : '部门名称',
			align : 'center',
			valign : 'middle'
		}, {
			field : 'directorAdmin',
			title : '负责人',
			align : 'center',
			valign : 'middle',
			sortable : true
		}, {
			field : 'phone',
			title : '联系电话',
			align : 'center',
			valign : 'middle'
		},{
			field : 'orgStatus',
			title : '状态',
			align : 'center',
			valign : 'middle',
			sortable : true ,
			formatter : function (value, row, index){
				if(value == 1){
					return "可用";
				}else if(value == 2){
					return "删除";
				}
			} 
		},{
			field : 'operate',
			title : '操作',
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
		           '<a class="edit" href="javascript:void(0)" title="修改">',
		           '<i class="glyphicon glyphicon-pencil">&nbsp;</i>',
		           '</a>  ',
		           '<a class="remove" href="javascript:void(0)" title="删除">',
		           '<i class="glyphicon glyphicon-remove">&nbsp;</i>',
		           '</a>  '
		       ].join('');
		}else{
			iconStr = [
			'<a class="icon-disabled" href="javascript:void(0)" title="修改">',
	           '<i class="glyphicon glyphicon-pencil">&nbsp;</i>',
	           '</a>  ',
	           '<a class="icon-disabled" href="javascript:void(0)" title="删除">',
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
		    		  title: '修改部门信息',
		    		  maxmin: true,
		    		  shadeClose: true, //点击遮罩关闭层
		    		  area : ['800px' , '520px'],
		    		  content: 'institution.do?method=editInstitution&orgCode='+row.orgCode,
		    		  end : doQuery
				  });
    },
    'click .remove': function (e, value, row, index) {
    	swal({
	        title: "您确定要删除这个部门吗",
	        text: "删除后将无法恢复，请谨慎操作！",
	        type: "warning",
	        showCancelButton: true,
	        cancelButtonText:"取消",
	        confirmButtonColor: "#DD6B55",
	        confirmButtonText: "删除",
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
		  title: '新增部门',
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
	    	 sweetAlert("删除部门失败", msg, "error");
	     }
	   }
	});
}