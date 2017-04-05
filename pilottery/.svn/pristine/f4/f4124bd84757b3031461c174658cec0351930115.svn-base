$(function () {
    initTable();
    $(window).resize(function () {
        $('#issueSys').bootstrapTable('refresh');
    });
});

function doQuery(params) {
    $('#issueSys').bootstrapTable('refresh');
}

function initTable() {
    var url = "report.do?method=issueSysReport&random=" + Math.random();
    $('#issueSys').bootstrapTable({
        method: 'post',
        dataType: 'json',
        contentType: "application/x-www-form-urlencoded",
        cache: false,
        striped: true,
        search: false,
        sidePagination: "server",
        url: url,
        height: $(window).height() - 85,
        width: $(window).width(),
        showColumns: true,
        pagination: true,
        sortable: true,
        silentSort: false,
        queryParams: queryParams,
        minimumCountColumns: 2,
        pageNumber: 1,
        pageSize: 20,                       //每页的记录行数（*）
        pageList: [10, 25, 50, 100, 500, 'All'],        //可供选择的每页的行数（*）
        uniqueId: "issueCode",
        showExport: true,
        exportDataType: 'all',
        exportOptions: {
            fileName: 'System Issue Report'
        },
        responseHandler: responseHandler,
        columns: [
            {
                field: 'gameName',
                title: 'Game',
                align: 'center',
                sortable: true
            },{
                field: 'issueCode',
                title: 'Issue',
                align: 'center',
                sortable: true
            }, {
                field: 'issueSaleBegin',
                title: 'Sales Start Date',
                align: 'center',
                sortable: true
            }, {
                field: 'issueSaleEnd',
                title: 'Sales End Date',
                align: 'center',
                sortable: true
            }, {
                field: 'issueStatus',
                title: 'Issue Status',
                align: 'center',
                formatter: function (value, row, index) {
                	if(value == 0){
    					return "PreSale";
    				}else if(value == 1){
    					return "Opened";
    				}else if(value == 2){
    					return "Paused";
    				}else if(value == 3){
    					return "Closed";
    				}else if(value == 4){
    					return "Draw";
    				}else{
    					return "Completed";
    				}
                }
            }, {
                field: 'awardNumber',
                title: 'winning Number',
                align: 'center'
            }, {
                field: 'rewardTime',
                title: 'Payout Date',
                align: 'center',
                sortable: true
            }, {
                field: 'saleAmount',
                title: 'Sales Amount',
                halign :'center',
                align: 'right',
                sortable: true,
                formatter: function (value, row, index) {
                    return toThousand(value);
                }
            }, {
                field: 'bingoAmount',
                title: 'Winning Amount',
                align: 'right',
                halign :'center',
                sortable: true,
                formatter: function (value, row, index) {
                    return toThousand(value);
                }
            }, {
                field: 'rwardAmount',
                title: 'Payout Amount',
                halign :'center',
                align: 'right',
                sortable: true,
                formatter: function (value, row, index) {
                    return toThousand(value);
                }
            }]
    });
}

function queryParams(params) {
    var param = {
    	gameCode:$("#gameCode").val(),
        reportIssue: $("#issueCode").val(),
        limit: this.limit, // 页面大小
        offset: this.offset, // 页码
        pageindex: this.pageNumber,
        pageSize: this.pageSize,
        sortName: this.sortName,
        sortOrder: this.sortOrder
    }
    if (param.pageSize == 'All') {
        param.pageSize = -1;
    }
    return param;
}

function responseHandler(res) {
    if (res) {
        return {
            "rows": res.result,
            "total": res.totalCount
        };
    } else {
        return {
            "rows": [],
            "total": 0
        };
    }
}