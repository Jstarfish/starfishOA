/**
 * displaytag导航直接跳转函数
 * 2010-10-26
 *  
 */
function displaytagURL() {	
	var skipURL = "";
	var initParam = "&page=";
	var firstParam = "&page=1";
	
	//首页url
	var firstPageURL = $("#firstPageURL").val();	
	if(firstPageURL==""){
		return;
	} else if (firstPageURL.indexOf(initParam)<0){
		if(firstPageURL.indexOf("d-16544-p=")>0){	//内存分页时，页号参数名为d-16544-p
			initParam = "d-16544-p=";
			firstParam = "d-16544-p==1";			
			firstPageURL = firstPageURL.replace(initParam, firstParam);
		} else {
			return;
		}
	} else if (firstPageURL.indexOf(firstParam)<0){
		firstPageURL = firstPageURL.replace("&page=", firstParam);
	}	

	var totalPageNum = $("#totalPageNum").val();
	var targetPage =  $.trim($("#targetPage").val());
	if(targetPage == "" || isNaN(targetPage || isNaN(totalPageNum))){
		return;		
	}else if (parseInt(targetPage) <=1 ){
		window.location = firstPageURL;
	}else if (parseInt(targetPage) >= parseInt(totalPageNum)){
		skipURL = firstPageURL.replace(firstParam, (initParam + totalPageNum));
		window.location = skipURL;
	}else{
		skipURL = firstPageURL.replace(firstParam, (initParam + targetPage));
		window.location = skipURL;
	}
}


/**
 * 回车直接跳转到目标页面
 * 2010-11-23
 *  
 */
function directToTarget(evt) {
	
	var evt = evt || window.event;
	var elem = evt.srcElement || evt.target;
	var key =  evt.keyCode || evt.which;
	if(key == 13){	
		displaytagURL();
	}
}