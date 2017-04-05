
/**
 * 
 */

function getObj(id) {
    var obj = document.getElementById(id);
    return obj;
}

function initPop(){

	var tableHtml = getObj("city-table") != null ? getObj("city-table").innerHTML : "";

    var myPop = document.getElementById("myPop");
    if(myPop == null) {
    	myPop = document.createElement("myPop"); 
    	myPop.id = "myPop";

        var str = 
            '<div id="city-list">' +
	            '<div class="hei">'+
		            '<div class="l">Switching City</div>'+
		            '<img class="r" onclick="closePop()" src="img/close-hei.png"/>'+
	            '</div>'+
	            '<div class="tab">' + tableHtml + '</div>'+
	            '<div style="height:15px;"></div>'+
            '</div>';

        myPop.innerHTML= str;

        document.body.appendChild(myPop);
    }

    document.onclick = function(e){
    	getObj("city-list").style.display = "none";
    };

    getObj("switchBtn").onclick = function(e){
	    getObj("city-list").style.left = (getObj("switchBtn").offsetLeft + 20) + "px";
	    getObj("city-list").style.top = (getObj("switchBtn").offsetTop + 50) + "px";
	    getObj("city-list").style.display = "block";

	    e.stopPropagation ? e.stopPropagation() : e.cancelBubble=true;
    };

    getObj("city-list").onclick = function(e){
    	e.stopPropagation ? e.stopPropagation() : e.cancelBubble=true;
    };
}

function closePop(){
	getObj('city-list').style.display='none';
}

