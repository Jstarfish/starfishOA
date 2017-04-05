
document.write('<style type="text/css">'
		+'.sticky {position: fixed;top:0px;right: 10px;left: 10px;}'
		+'</style>');



function thead_flow(){
    function onScroll(e) {
        var thead = document.querySelector('.thead');
        var tbody = document.querySelector('.tbody');
        
        var origOffsetY = tbody.offsetTop - thead.offsetHeight;
        if(window.scrollY > origOffsetY) {
            thead.classList.add('sticky');
        } else if(thead.classList.contains("sticky")) {
            thead.classList.remove('sticky');
        }

        if(window.scrollY > tbody.offsetTop + tbody.offsetHeight) {
            thead.classList.remove('sticky');
        }
    }
    document.addEventListener('scroll', onScroll);
};








