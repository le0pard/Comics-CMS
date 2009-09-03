/**
 * @author leo
 */

var ComicsObj = {
	init: function(){
		document.observe('keydown', function(event){
			var evt = event || window.event;
			var key = evt.keyCode || evt.which;
			//not work in Opera
			if (evt.ctrlKey) {
				
				var keySt = false;
				if (key == Event.KEY_LEFT) {
					if ($('previous_comics')){
						location.href = $('previous_comics').href;
						keySt = true;
					}
				}
				else 
					if (key == Event.KEY_RIGHT) {
						if ($('next_comics')){
							location.href = $('next_comics').href;
							keySt = true;
						}
					}
					
				if (keySt) {
					if ('function' == typeof evt.preventDefault) {
						evt.preventDefault();
					}
					else {
						evt.returnValue = false;
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

