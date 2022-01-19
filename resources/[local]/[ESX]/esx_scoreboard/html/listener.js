$(function(){
	window.addEventListener('message', function(event)
    {
		switch (event.data.action) {
            case 'scroll':
                if(event.data.scroll == "up") {
                    var pos = $("table").scrollTop()
                    $("table").scrollTop(pos - 140);
                } else if(event.data.scroll == "down") {
                    var pos = $("table").scrollTop()
                    $("table").scrollTop(pos + 140);
                }
                break;            
            default:
        
				
		var buf = $('#wrap');

        var item = event.data;
        if (item.data)
        {
			buf.find('table').append("<h1 class=\"heading\">QueRP</h1><img class='image' src='img.png'><p id='website'>QueRP</p><p id='discord'>discord.gg/QueRP</p><p id='duties'>" + item.duties + "</p>");
			buf.find('table').append(item.data);
			if (item.admin) {
				buf.addClass('admin');
			}
			buf.show();
		} else {
            document.getElementById("ptbl").innerHTML = "";
			buf.removeClass('admin');
            buf.hide();
        }

    }
    }, false);
});