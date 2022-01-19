let hideArmor = true
let toggled = false
let hidden = false
let Compass = true
let cinemamode = false
let style = 'classic'
let crosshair = false
let radio_activated = false;
let not = {
	default: true,
	twitter: true,
	lspdn: true,
}
let index = 0,
	toasts = [],
	maxOpened = 3;

function checkURL(url) {
	return(url.match(/\.(jpeg|jpg|gif|png)$/) != null);
}

function hide() {
	if (hidden) {
		hidden = false
		$('.hud').fadeIn(300)
		$('.hud-collapse').fadeIn(300)
	} else {
		hidden = true
		$('.hud').fadeOut(300)
		$('.hud-collapse').fadeOut(300)
	}
}

function crosshairfc(){
	if(crosshair == true){
		crosshair = false
		$.post('https://esx_custostatus/crosshair', JSON.stringify({crosshair: false}));
	}
	else{
		crosshair = true
		$.post('https://esx_custostatus/crosshair', JSON.stringify({crosshair: true}));
	}
}

function carhud(x){
	switch(x){
		case 'classic':
			style = 'classic'
			$('#custom6').prop('checked', true)
			$('#custom7').prop('checked', false)
			$.post('https://esx_custostatus/carhudstyle', JSON.stringify({style: 'classic'}));
		break
		case 'minimalist':
			style = 'minimalist'
			$('#custom7').prop('checked', true)
			$('#custom6').prop('checked', false)
			$.post('https://esx_custostatus/carhudstyle', JSON.stringify({style: 'minimalist'}));
		break
	}
}

function carhudCompass() {
	if (Compass) {
		Compass = false
		$.post('https://esx_custostatus/Compass', JSON.stringify({compassOn: true}));
	} else {
		Compass = true
		$.post('https://esx_custostatus/Compass', JSON.stringify({compassOn: false}));
	}
}

function cinema() {
	if (cinemamode) {
		cinemamode = false
		Compass = true
		not['lspdn'] = true
		not['twitter'] = true
		not['default'] = true
		$('.hud').fadeIn(300)
		$('.hud-collapse').fadeIn(300)
		$('.cinema').fadeOut(300)
		$('#custom8').prop('checked', true);
		$('#custom8').prop('disabled', false);
		switch(style){
			case 'classic':
				style = 'classic'
				$('#custom6').prop('checked', true)
				$('#custom7').prop('checked', false)
				$('#custom6').prop('disabled', false);
				$('#custom7').prop('disabled', false);
			break
			case 'minimalist':
				style = 'minimalist'
				$('#custom7').prop('checked', true)
				$('#custom6').prop('checked', false)
				$('#custom6').prop('disabled', false);
				$('#custom7').prop('disabled', false);
			break
		}
		$('#custom7').prop('disabled', false);
		$('#custom6').prop('disabled', false);
		$('#custom4').prop('checked', true);
		$('#custom4').prop('disabled', false);
		$('#custom3').prop('checked', true);
		$('#custom3').prop('disabled', false);
		$('#custom2').prop('checked', true);
		$('#custom2').prop('disabled', false);
		$('#custom1').prop('checked', true);
		$('#custom1').prop('disabled', false);
		$.post('https://gc-hud/DisplayRadar', JSON.stringify({
			cinema: false
		}));
	} else {
		cinemamode = true
		Compass = false
		not['lspdn'] = false
		not['twitter'] = false
		not['default'] = false
		$('.hud').fadeOut(300)
		$('.hud-collapse').fadeOut(300)
		$('.cinema').fadeIn(300)
		$('#custom8').prop('checked', false);
		$('#custom8').prop('disabled', true);
		$('#custom7').prop('checked', false);
		$('#custom7').prop('disabled', true);
		$('#custom6').prop('checked', false);
		$('#custom6').prop('disabled', true);
		$('#custom4').prop('checked', false);
		$('#custom4').prop('disabled', true);
		$('#custom3').prop('checked', false);
		$('#custom3').prop('disabled', true);
		$('#custom2').prop('checked', false);
		$('#custom2').prop('disabled', true);
		$('#custom1').prop('checked', false);
		$('#custom1').prop('disabled', true);
		$.post('https://gc-hud/DisplayRadar', JSON.stringify({
			cinema: true
		}));
	}
}

function maxLengthCheck(object) {
	if (object.value.length > object.maxLength)
		object.value = object.value.slice(0, object.maxLength)
}

function changebars(x) {
	let percent = x.value
	$('.cinema-top').height(percent + '%')
	$('.cinema-bottom').height(percent + '%')
}

function exit() {
	$('.containerx').fadeOut(300);
	$.post('https://gc-hud/NUIFocusOff', JSON.stringify({}));
	setSettings()
}

function setSettings() {
	$.post('https://esx_custostatus/SetKVP', JSON.stringify({
		defaultkvp: not.default,
		twitterkvp:  not.twitter,
		lspdnkvp:  not.lspdn,
		hiddenkvp: hidden,
		cinemakvp: cinemamode,
		compasskvp: Compass,
		stylekvp: style,
		crosshairkvp: crosshair
	}));
}

$.extend({
	playSound: function () {
		return $(
			'<audio class="sound-player" autoplay="autoplay" style="display:none;">' +
			'<source src="' + arguments[0] + '" />' +
			'<embed src="' + arguments[0] + '" hidden="true" autostart="true" loop="false"/>' +
			'</audio>'
		).appendTo('body');
	},
	stopSound: function () {
		$(".sound-player").remove();
	}
});

function playSound(url) {
	return $(
		'<audio class="sound-player" autoplay="autoplay" style="display:none;">' +
		'<source src="' + arguments[0] + '" />' +
		'<embed src="' + arguments[0] + '" hidden="true" autostart="true" loop="false"/>' +
		'</audio>'
	).appendTo('body');
} 

function stopSound() {
	$(".sound-player").remove();
} 


$(document).on('keyup', function (e) {
	if (e.key == "Escape") {
		exit()
	}
});

window.addEventListener('message', (event) => {
	if (event.data.type == "SET_SETTINGS"){
		if(event.data.lspd == 'true'){
			not['lspdn'] = true
		}
		else{
			not['lspdn'] = false
		}
		if(event.data.twitter == 'true'){
			not['twitter'] = true
		}
		else{
			not['twitter'] = false
		}
		if(event.data.default == 'true'){
			not['default'] = true
		}
		else{
			not['default'] = false
		}
		if(event.data.compassxx == 'true'){
			Compass = true
			$.post('https://esx_custostatus/Compass', JSON.stringify({compassOn: false}));
			$('#custom8').prop('checked', true)
		}
		else{
			Compass = false
			$.post('https://esx_custostatus/Compass', JSON.stringify({compassOn: true}));
			$('#custom8').prop('checked', false);	
		}
		if(event.data.cinema == 'true'){
			cinemamode = true
			not['lspdn'] = false
			not['twitter'] = false
			not['default'] = false
			$('.hud').fadeOut(300)
			$('.hud-collapse').fadeOut(300)
			$('.cinema').fadeIn(300)
			$('#custom8').prop('checked', false);
			$('#custom8').prop('disabled', true);
			$('#custom7').prop('checked', false);
			$('#custom7').prop('disabled', true);
			$('#custom6').prop('checked', false);
			$('#custom6').prop('disabled', true);
			$('#custom4').prop('checked', false);
			$('#custom4').prop('disabled', true);
			$('#custom3').prop('checked', false);
			$('#custom3').prop('disabled', true);
			$('#custom2').prop('checked', false);
			$('#custom2').prop('disabled', true);
			$('#custom1').prop('checked', false);
			$('#custom1').prop('disabled', true);
			$.post('https://bc-hud/DisplayRadar', JSON.stringify({
				cinema: true
			}));
		}
		else{
			cinemamode = false
		}
		if(event.data.hidden){
			if(event.data.hidden == 'true'){
				hidden = true
				$('.hud').hide()
				$('.hud-collapse').hide()
			}
			else{
				if(event.data.cinema !== 'true'){
					$('.hud').show()
					$('.hud-collapse').show()
					hidden = false
				}
			}
		}
		if(event.data.carhudstylex){
			switch(event.data.carhudstylex){
				case 'classic':
					style = 'classic'
					$('#custom6').prop('checked', true)
					$('#custom7').prop('checked', false)
				break
				case 'minimalist':
					style = 'minimalist'
					$('#custom7').prop('checked', true)
					$('#custom6').prop('checked', false)
				break
			}
		}
		if(event.data.crosshairx){
			if(event.data.crosshairx == 'true'){
				$('#custom9').prop('checked', true)
				crosshair = true
			}
			else{
				$('#custom9').prop('checked', false)
				crosshair = false
			}
		}
	}
	if (event.data.type == "OPEN_SETTINGS") {
		$('.containerx').fadeIn(300)
		if(hidden){
			$('#custom4').prop('checked', false);
		}
		else{
			$('#custom4').prop('checked', true);
		}

		if(not.default){
			$('#custom1').prop('checked', true);
		}
		else{
			$('#custom1').prop('checked', false);
		}

		if(not.twitter){
			$('#custom2').prop('checked', true);
		}
		else{
			$('#custom2').prop('checked', false);
		}

		if(not.lspdn){
			$('#custom3').prop('checked', true);
		}
		else{
			$('#custom3').prop('checked', false);
		}

		if(cinemamode){
			$('#custom5').prop('checked', true);
		}
		else{
			$('#custom5').prop('checked', false);
		}
	}
	if (event.data.type == 'HELP') {
		if (event.data.action == 'SHOW') {
			$('#text').html(event.data.msg)
			$('#help').fadeIn(300)
		} else if (event.data.action == 'HIDE') {
			$('#help').fadeOut(300)
			setTimeout(function() {
				$('#text').html("")
			}, 300)
		}
	}
	if (event.data.type == 'TOGGLE_HUD') {
		if (toggled) {
			toggled = false
			$('.hud').animate({
				bottom: "-110px"
			}, 300)
			setTimeout(function () {
				if(!toggled) {
					$('.hud-collapse').animate({
						top: "110%"
					}, 300);
					if($('.radio').hasClass("mm_visible")) {
						$('.radio').removeClass("mm_visible");
						$('.radio').animate({
							left: "-60px"
						}, 300);
					}
				}
			}, 300)
		} else {
			toggled = true
			$('.hud-collapse').animate({
				top: "99%"
			}, 300)
			setTimeout(function () {
				if(toggled) {
					$('.hud').animate({
						bottom: "-200px"
					}, 300);
					if(radio_activated) {
						$('.radio').addClass("mm_visible");
						$('.radio').animate({
							left: "0px"
						}, 300);
					}
				}
			}, 300)
		}
		return
	}

	if (event.data.type == "UPDATE_VOICE") {
		if (event.data.isTalking) {
			if (event.data.mode == 'Car') {
				$('#grad7').html('<stop offset="0%" style="stop-color:rgb(38, 0, 255);stop-opacity:1" /><stop offset="25%" style="stop-color:rgba(255, 0, 221);stop-opacity:1"/><stop offset="25%" style="stop-color:rgb(255, 255, 255);stop-opacity:1"/>')
			} else if (event.data.mode == 'Whisper') {
				$('#grad7').html('<stop offset="0%" style="stop-color:rgb(38, 0, 255);stop-opacity:1" /><stop offset="50%" style="stop-color:rgba(255, 0, 221);stop-opacity:1"/><stop offset="50%" style="stop-color:rgb(255, 255, 255);stop-opacity:1"/>')
			} else if (event.data.mode == 'Normal') {
				$('#grad7').html('<stop offset="0%" style="stop-color:rgb(38, 0, 255);stop-opacity:1" /><stop offset="75%" style="stop-color:rgba(255, 0, 221);stop-opacity:1"/><stop offset="75%" style="stop-color:rgb(255, 255, 255);stop-opacity:1"/>')
			} else if (event.data.mode == 'Shouting') {
				$('#grad7').html('<stop offset="0%" style="stop-color:rgb(38, 0, 255);stop-opacity:1" /><stop offset="100%" style="stop-color:rgba(255, 0, 221);stop-opacity:1"/><stop offset="100%" style="stop-color:rgb(255, 255, 255);stop-opacity:1"/>')
			}
		} else {
			if (event.data.mode == 'Car') {
				$('#grad7').html('<stop offset="0%" style="stop-color:#2feaa8;stop-opacity:1" /><stop offset="25%" style="stop-color:#028cf3;stop-opacity:1"/><stop offset="25%" style="stop-color:rgb(255, 255, 255);stop-opacity:1"/>')
			} else if (event.data.mode == 'Whisper') {
				$('#grad7').html('<stop offset="0%" style="stop-color:#2feaa8;stop-opacity:1" /><stop offset="50%" style="stop-color:#028cf3;stop-opacity:1"/><stop offset="50%" style="stop-color:rgb(255, 255, 255);stop-opacity:1"/>')
			} else if (event.data.mode == 'Normal') {
				$('#grad7').html('<stop offset="0%" style="stop-color:#2feaa8;stop-opacity:1" /><stop offset="75%" style="stop-color:#028cf3;stop-opacity:1"/><stop offset="75%" style="stop-color:rgb(255, 255, 255);stop-opacity:1"/>')
			} else if (event.data.mode == 'Shouting') {
				$('#grad7').html('<stop offset="0%" style="stop-color:#2feaa8;stop-opacity:1" /><stop offset="100%" style="stop-color:#028cf3;stop-opacity:1"/><stop offset="100%" style="stop-color:rgb(255, 255, 255);stop-opacity:1"/>')
			}
		}
		return
	}
	if (event.data.type == 'UPDATE_HUD') {
		
		if (event.data.hunger) {
			var hungerlevel = Math.floor(event.data.hunger)
			$('#grad3').html('<stop offset="0%" style="stop-color:#2feaa8;stop-opacity:1" /><stop offset="' + hungerlevel + '%" style="stop-color:#028cf3;stop-opacity:1" /><stop offset="' + hungerlevel + '%" style="stop-color:rgb(255, 255, 255);stop-opacity:1"/>')
		}
		if (event.data.thirst) {
			var thirstlevel = Math.floor(event.data.thirst)
			$('#grad4').html('<stop offset="0%" style="stop-color:#2feaa8;stop-opacity:1" /><stop offset="' + thirstlevel + '%" style="stop-color:#028cf3;stop-opacity:1" /><stop offset="' + thirstlevel + '%" style="stop-color:rgb(255, 255, 255);stop-opacity:1"/>')
		}
		if (event.data.armor) {
			var armorlevel = Math.floor(event.data.armor)
			$('#grad2').html('<stop offset="0%" style="stop-color:#2feaa8;stop-opacity:1" /><stop offset="' + armorlevel + '%" style="stop-color:#028cf3;stop-opacity:1" /><stop offset="' + armorlevel + '%" style="stop-color:rgb(255, 255, 255);stop-opacity:1"/>')
		}
		if ((event.data.armor) <= 0) {
			$('#armor').fadeOut(1000);
		}
		if ((event.data.armor) > 0) {
			$('#armor').fadeIn(1000);
		}
		if (event.data.nurkowanie) {
			var oxygenlevel = Math.floor(event.data.nurkowanie)
			$('#grad5').html('<stop offset="0%" style="stop-color:#2feaa8;stop-opacity:1" /><stop offset="' + oxygenlevel + '%" style="stop-color:#028cf3;stop-opacity:1" /><stop offset="' + oxygenlevel + '%" style="stop-color:rgb(255, 255, 255);stop-opacity:1"/>')
		}
		if (event.data.inwater) {
			$('#oxygen').fadeIn(1000);
		}
		if (!event.data.inwater) {
			$('#oxygen').fadeOut(1000);
		}
		if ((event.data.stress) <= 1) {
			$('#stress').fadeOut(1000);
		}
		if ((event.data.stress) > 1) {
			$('#stress').fadeIn(1000);
		}
		// if (event.data.stress) {
		// 	var stress = Math.floor(event.data.stress / 10)
		// 	$('#grad6').html('<stop offset="' + stress + '%" style="stop-color:rgb(142, 84, 233);stop-opacity:1" /><stop offset="' + stress + '%" style="stop-color:rgb(255, 255, 255);stop-opacity:1"/>')
		// }
		if (event.data.zycie) {
			var hplevel = (Math.floor(event.data.zycie))
			$('#grad1').html('<stop offset="0%" style="stop-color:#2feaa8;stop-opacity:1" /><stop offset="' + hplevel + '%" style="stop-color:#028cf3;stop-opacity:1" /><stop offset="' + hplevel + '%" style="stop-color:rgb(255, 255, 255);stop-opacity:1"/>')
		}
		if (event.data.isdead) {
			$('#grad1').html('<stop offset="0%" style="stop-color:rgb(142, 84, 233);stop-opacity:1" /><stop offset="0%" style="stop-color:rgb(255, 255, 255);stop-opacity:1"/>')
		}
		return
	}
	if (event.data.showradio == true) {
		radio_activated = true;
	}
	if (event.data.hideradio == true) {
		radio_activated = false;
	}
	if (event.data.radionumber) {
		$(".radionumber").text(event.data.radionumber);
	}
	if (event.data.radiocount) {
		$(".radiopeople").text(event.data.radiocount);
	}
})

window.addEventListener('load', (event) => {
	$('#help').fadeOut(0)
});0