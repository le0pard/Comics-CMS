/**
 * @author leo
 */

var ComicsObj = {
	init: function(){
		document.observe('keydown', function(event){
			if (event.ctrlKey) {
				if (event.keyCode == Event.KEY_LEFT) {
					if ($('previous_comics')){
						location.href = $('previous_comics').href;
					}
				}
				else 
					if (event.keyCode == Event.KEY_RIGHT) {
						if ($('next_comics')){
							location.href = $('next_comics').href;
						}
					}
			}
		});
	}
}
 
Event.observe(window, 'load', function() {
  ComicsObj.init();
});

