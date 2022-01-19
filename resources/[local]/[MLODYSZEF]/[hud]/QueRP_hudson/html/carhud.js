let engineOn = false
$(document).ready(function(){
  $('.speedometer').hide();
  $(".mapborder").hide();
  window.addEventListener("message", function(event){
    if(event.data.showhud == true){
      if(event.data.stylex == 'classic'){
        $('.speedometer').show();
        $('.speedometer-minimalistic').hide();
        $('.streetlabel').removeClass("streetminimalist");
      }
      else{
        $('.streetlabel').addClass("streetminimalist");
        $(".speedometer-minimalistic").css('display', 'inline-flex')
        $('.speedometer').hide();
      }
      engineOn = true
    }
    if(event.data.showhud == false){
      $('.speedometer').hide();
      $('.speedometer-minimalistic').hide();
      $('.streetlabel').hide();
      engineOn = false
    }

    if(event.data.style){
      if(engineOn == true){
        if(event.data.style == 'classic'){
          $('.streetlabel').removeClass("streetminimalist");
          $('.speedometer').show();
          $('.speedometer-minimalistic').hide();
        }
        else{
          $('.streetlabel').addClass("streetminimalist");
          $(".speedometer-minimalistic").css('display', 'inline-flex')
          $('.speedometer').hide();
        }
      }
    }

    if(event.data.showCompass) {
      if(event.data.showCompass == 'on'){
        $(".streetlabel").css('display', 'inline-flex')
      }
      else if(event.data.showCompass == 'off'){
        $('.streetlabel').hide();
      }
    }

    if(event.data.aspectratio){
      setAspectRatio(Math.round(event.data.aspectratio * 100) /  100)
    }

    if(event.data.speedometer) {
      let speed = Number(event.data.speed)
      let percent = Number(event.data.percent)
      let showpercent = (percent * 0.82)
      if(speed < 10){
        $(".speed-digital").text("00" + speed)
        $(".minimalistic-speed").text("00" + speed + " MPH")
      }
      else if(speed < 100){
        $(".speed-digital").text("0" + speed)
        $(".minimalistic-speed").text("0" + speed + " MPH")
      }
      else{
        $(".speed-digital").text(speed)
        $(".minimalistic-speed").text(speed + " MPH")
      }

      $('.speed').attr('stroke-dasharray', showpercent + ' 100')
    }
    if(event.data.tachometer) {
      let rpm = (Number(event.data.rpmx) * 0.65)
      $('.tacho path').attr('stroke-dasharray', rpm + ' 100')
    }

    if(event.data.fuel) {
      $('#sgrad1').html('<stop offset="0%" style="stop-color:#2feaa8;stop-opacity:1" /><stop offset="' + Number(event.data.fuel) + '%" style="stop-color:#028cf3;stop-opacity:1" /><stop offset="' + Number(event.data.fuel) + '%" style="stop-color:rgb(255, 255, 255);stop-opacity:1"/>')
      $('#sxgrad1').html('<stop offset="0%" style="stop-color:#2feaa8;stop-opacity:1" /><stop offset="' + Number(event.data.fuel) + '%" style="stop-color:#028cf3;stop-opacity:1" /><stop offset="' + Number(event.data.fuel) + '%" style="stop-color:rgb(255, 255, 255);stop-opacity:1"/>')
    }

    if(event.data.lights) {
      let lightlevel = Number(event.data.lights)

      if(lightlevel == 2){
        $('.lights').attr('fill', '#1d9b6f')
      }
      else if(lightlevel == 3){
        $('.lights').attr('fill', '#2feaa8')
      }
      else{
        $('.lights').attr('fill', 'rgb(255, 255, 255)')
      }
    }

    if(event.data.seatbelt) {
      $('.seatbelt').addClass('active')
    } else if (event.data.seatbelt == false) {
      $('.seatbelt').removeClass('active')
    }

    if(event.data.street){
      $(".street").html(event.data.street)
      $(".streetlabel").css('display', 'inline-flex')
    }
    if(event.data.direction){
      $(".direction").text(event.data.direction)
    }
  })

  function setAspectRatio(x){
    $("body").removeClass()
    if(x == 1.5){
      $("body").addClass("threetwo")
    }
    else if(x == 1.33){
      $("body").addClass("fourthree")
    }
    else if(x == 1.67){
      $("body").addClass("fivethree")
    }
    else if(x == 1.67){
      $("body").addClass("fivethree")
    }
    else if(x == 1.25){
      $("body").addClass("fivefour")
    }
    else if(x == 1.6){
      $("body").addClass("sixteenten")
    }
  }

});

$('.huds').hide();
$(".mapborder").hide();