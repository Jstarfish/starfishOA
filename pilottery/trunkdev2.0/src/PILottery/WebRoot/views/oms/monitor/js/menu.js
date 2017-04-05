$(document).ready(function(){

		$("#main-nav li ul").hide();
		$("#main-nav li a.current").parent().find("ul").slideToggle("slow");

		$("#main-nav li a.nav-top-item").click(
			function () {
				$(this).parent().siblings().find("ul").slideUp("normal");
				$(this).next().slideToggle("normal");
			}
		);

		$("#main-nav li a.no-submenu").click(
			function () {
                $("#main-nav a.current").removeClass("current");
                $(this).addClass("current");
			}
		);

		$("#main-nav li .nav-top-item").hover(
			function () {
				$(this).stop().animate({ paddingRight: "25px" }, 200);
			}, 
			function () {
				$(this).stop().animate({ paddingRight: "15px" });
			}
		);

		$("#main-nav li ul li").click(
			function () {
                $("#main-nav a.current").removeClass("current");
            	$(this).find("a").addClass("current");
                $(this).parent().prev().addClass("current");
			}
		);
        

});
