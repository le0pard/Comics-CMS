/**
 * @author leo
 */

var ComicsObj = {
	init: function(){
		document.observe('keydown', function(event){
			var evt = event || window.event;
			var key = evt.keyCode || evt.which;
			//not work in Opera
			if (evt.altKey) {
				if ('function' == typeof evt.preventDefault){
					evt.preventDefault();
				} else {
					evt.returnValue = false;
				}
				
				if (key == Event.KEY_LEFT) {
					if ($('previous_comics')){
						location.href = $('previous_comics').href;
					}
				}
				else 
					if (key == Event.KEY_RIGHT) {
						if ($('next_comics')){
							location.href = $('next_comics').href;
						}
					}
					
				window.focus();
				return false;
			}
		});
	}
}
 
Event.observe(window, 'load', function() {
  ComicsObj.init();
});

