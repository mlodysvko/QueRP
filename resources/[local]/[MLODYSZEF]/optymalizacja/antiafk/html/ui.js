(function ($) {
  $.extend({
      playSound: function () {
        return $(
        '<audio class="sound-player" autoplay="autoplay" style="display:none;">'
        +'<source src="' + arguments[0] + '" />'
        +'<embed src="' + arguments[0] + '" hidden="true" autostart="true" loop="false"/>'
        +'</audio>'
        ).appendTo('body');
      },
      stopSound: function () {
          $(".sound-player").remove();
      }
  });
})(jQuery);

$(function() {
  window.addEventListener('message', function(event) {
    if (event.data.name == "custom"){
      createnotify(event.data.color, event.data.title, event.data.message);
    }
  });
});

var index = 0, notifys = [], maxOpened = 2;
function createnotify(color, title,message, img) {
  var notify = {}
  notify.id = index++;
   if (title == ""){
	   notify.code = '<div id="notify-'+notify.id+'" style="border-left: 5px '+color+' solid;" class="notify">'+
	  '<b><span>'+message+'</span></b>' +
	  '</div>';

   }else{
	   notify.code = '<div id="notify-'+notify.id+'" style="border-left: 5px '+color+' solid;" class="notify">'+
	  '<b><span style="color: #FFFFFF;">'+title+'</span></b> </br><span>'+message+'</span>' +
	  '</div>';
   }
  
  if (maxOpened && notifys.length >= maxOpened) {
    remove(notifys[0].id)
  }

  notifys.push(notify);
  $(notify.code).appendTo('notification-box')
  $('#notify-'+notify.id).addClass('notify-enter');
    setTimeout(function(){
      $('#notify-'+notify.id).removeClass('notify-enter');
      remove(notify.id);
    }, 5000);
}

function remove(id) {
    var notify = findnotify(id);

    if (notify) {
        $('#notify-'+id).addClass('notify-leave')
        setTimeout(function() {
        $('#notify-'+id).css('display', 'none');
        $('#notify-'+id).remove();
        }, 500);
        var index = notifys.indexOf(notify)
        notifys.splice(index, 1)
    }
    
    function findnotify(notifyId) {
      for (var i = 0; i < notifys.length; i++) {
        if (notifys[i].id == id) {
          return notifys[i]
        }
      }
    }

}