$(document).ready(function(){
	/* This code is executed after the DOM has been completely loaded */
	
	$('.bnav a,.nav a,.hnav a,.footer a.up').click(function(e){
										  
		// If a link has been clicked, scroll the page to the link's hash target:
		console.log("slide jump, cool");
		$.scrollTo( this.hash || 0, 1500);
		e.preventDefault();
	});

});
