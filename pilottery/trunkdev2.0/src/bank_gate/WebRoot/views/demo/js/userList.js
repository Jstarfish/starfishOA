$(function () {
	initTable();
	initDate();
	
	$(window).resize(function(){
		$('#demo-table').bootstrapTable('refresh'); 
	});
});

function doQuery(params){
	$('#demo-table').bootstrapTable('refresh');  
}

function initTable(){
	var url = "demo.do?method=listUsers&random="+Math.random();
	$('#demo-table').bootstrapTable({
		method:'POST',
		dataType:'json',
		contentType: "application/x-www-form-urlencoded",
		cache: false,
		striped: true,                      //是否显示行间隔色
		sidePagination: "client",           //分页方式：client客户端分页，server服务端分页（*）
		url:url,
		height: $(window).height() - 120,
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
        	fileName: '示例列表'
        },
		columns: [
 		{
			field : 'id',
			title : 'User ID',
			align : 'center',
			valign : 'middle',
			sortable : true
		}, {
			field : 'institutionCode',
			title : 'Institution Code',
			align : 'center',
			valign : 'middle',
			sortable : true
		}, {
			field : 'institutionName',
			title : 'Institution Name',
			align : 'center',
			valign : 'middle'
		}, {
			field : 'loginId',
			title : 'Login Name',
			align : 'center',
			valign : 'middle',
			sortable : true
		}, {
			field : 'realName',
			title : 'Real Name',
			align : 'center',
			valign : 'middle'
		}, {
			field : 'homeAddress',
			title : 'Address',
			align : 'center',
			valign : 'middle'
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
    return [
        '<a class="edit" href="javascript:void(0)" title="Edit">',
        '<i class="glyphicon glyphicon-pencil">&nbsp;</i>',
        '</a>  ',
        '<a class="remove" href="javascript:void(0)" title="Remove">',
        '<i class="glyphicon glyphicon-remove">&nbsp;</i>',
        '</a>  ',
        '<a class="detail" href="javascript:void(0)" title="Detail">',
        '<i class="glyphicon glyphicon-file"></i>',
        '</a>'
    ].join('');
}
window.operateEvents = {
    'click .edit': function (e, value, row, index) {
		  layer.open({
		    		  type: 2,
		    		  title: '编辑用户',
		    		  maxmin: true,
		    		  shadeClose: true, //点击遮罩关闭层
		    		  area : ['800px' , '520px'],
		    		  content: 'demo.do?method=editUser&userId='+row.id,
		    		  end : doQuery
				  });
    },
    'click .remove': function (e, value, row, index) {
    	swal({
	        title: "您确定要删除这条信息吗",
	        text: "删除后将无法恢复，请谨慎操作！",
	        type: "warning",
	        showCancelButton: true,
	        cancelButtonText:"取消",
	        confirmButtonColor: "#DD6B55",
	        confirmButtonText: "删除",
	        closeOnConfirm: false
	    }, function () {
	    	deleteUser(row.id);
	    });
    },
    'click .detail': function (e, value, row, index) {
		  layer.open({
		    		  type: 2,
		    		  title: '用户详情',
		    		  maxmin: true,
		    		  shadeClose: true, //点击遮罩关闭层
		    		  area : ['800px' , '520px'],
		    		  content: 'demo.do?method=userDetail&userId='+row.id,
		    		  end : doQuery
				  });
    }
};

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

function queryParams(params) {
	var param = {
		orgCode : $("#orgCode").val(),
		userName : $("#userName").val(),
		startDate : $("#startDate").val(),
		endDate : $("#endDate").val(),
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
		  title: '新增用户',
		  maxmin: true,
		  shadeClose: true, //点击遮罩关闭层
		  area : ['800px' , '520px'],
		  content: 'demo.do?method=addUser',
		  end : doQuery
	  });
}
function deleteUser(userId){
	$.ajax({
	   type: "get",
	   url: "demo.do?method=deleteUser&userId="+userId,
	   success: function(msg){
	     if(msg=='success'){
	    	 sweetAlert("删除成功", "", "success");
	    	 doQuery();
	     }else{
	    	 sweetAlert("删除失败", msg, "error");
	     }
	   }
	});
}