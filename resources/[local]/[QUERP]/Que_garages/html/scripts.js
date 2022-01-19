function searchFunction() {
	var input, filter, ul, li, a, i, txtValue;
	input = document.getElementById("searchCar");
	filter = input.value.toUpperCase();
	ul = document.getElementById("cars");
	li = ul.getElementsByTagName("li");
	for (i = 0; i < li.length; i++) {
		a = li[i].getElementsByTagName("span")[0];
		txtValue = a.textContent || a.innerText;
		if (txtValue.toUpperCase().indexOf(filter) > -1) {
			li[i].style.display = "flex";
		} else {
			li[i].style.display = "none";
		}
	}
}

$(document).ready(function(){
	
  var number = 0;
  var number2 = 0;
  var number3 = 0;
  
  function closeMain() {
    $(".home").css("display", "none");
  }
  function openMain() {
    $(".home").css("display", "block");
  }
  function openContainer() {
	$(".searchCar").val("");
    $(".garages").css("display", "block");
  }
  function closeContainer() {
	$(".searchCar").val("");
    $(".garages").css("display", "none");
  }
  
  window.addEventListener('message', function(event){
    var item = event.data;
	
    if(item.openGarage == true) {
      openContainer();
      openMain();
    }
    if(item.openGarage == false) {
      closeContainer();
      closeMain();
    }

    if(item.clearme == true) {
	  for(var i=1; i<=number; i++) {
		var id = document.getElementById("btnCar" + i);
		if (!id) {
			if(!$("#btnCar" + i).hasClass('btnCar')) { $("#btnCar" + number).addClass('btnCar');}
		}
	  }
	  number = 0;
    }
	
	if(item.clearimp == true) {
	  for(var i=1; i<=number2; i++) {
		if(!$("#impCar" + i).hasClass('impCar')) { $("#impCar" + number).addClass('impCar');}
	  }
	  number2 = 0;
    }
	
	if(item.clearpolice == true) {
	  for(var i=1; i<=number3; i++) {
		if(!$("#policeCar" + i).hasClass('policeCar')) { $("#policeCar" + number).addClass('policeCar');}
	  }
	  number3 = 0;
    }
	
    if(item.addcar == true) {
		var id = document.getElementById("btnCar" + item.number);
		if (!id) {
			var car = `
			<li style="pointer-events: auto;" id="btnCar` + item.number + `" class="btnCar">
				<div style="pointer-events: none;" class="left">
					<div class="main">
						<i class="fas fa-car hover-logo"></i>
					</div>
					<div class="info">
						<h2 class="title">
							`+ item.name +`
						</h2>
						<div class="stats">
						
						</div>
					</div>
				</div>					
			</li>`;
		$("#cars").append(car);
		$("#btnCar" + item.number).attr('model', item.model);
		number = number + 1;
		}
    }
	
	if(item.impcar == true) {
		var car = `
		<li style="pointer-events: auto;" id="impCar` + item.number + `">
			<div style="pointer-events: none;" class="left">
				<div class="main">
					<i class="fas fa-car hover-logo"></i>
				</div>
				<div class="info">
					<h2 class="title">
						`+ item.name +`
					</h2>
					<span class="subtitle">
						`+ item.model +`
					</span>
					<div class="stats">
					
					</div>
				</div>
			</div>
			</div>
		</li>`;
	  $("#cars").append(car);
      $("#impCar" + item.number).attr('model', item.model);
	  number2 = number2 + 1;
    }
	
	if(item.policecar == true) {
		var car = `
		<li id="policeCar` + item.number + `">
			<div style="pointer-events: none;" class="left">
				<div class="main">
					<i class="fas fa-car hover-logo"></i>
				</div>
				<div class="info">
					<h2 class="title">
						`+ item.name +`
					</h2>
					<span class="subtitle">
						`+ item.model +`
					</span>
					<div class="stats">
					
					</div>
				</div>
			</div>
			<div style="pointer-events: none;" class="right">
				<div data-tippy-content="Silnik: `+item.health+`%">
					<svg xmlns="http://www.w3.org/2000/svg" width="45" height="45" viewBox="0 0 49 40.22">
						<defs>
							<linearGradient id="linear" x1="0%" y1="0%" x2="100%" y2="0%">
							  <stop offset="0%"   stop-color="#2feaa8"/>
							  <stop offset="100%" stop-color="#028cf3"/>
							</linearGradient>
						  </defs>
						<path id="progressbar-bar-line-none" class="progress-bar-line" fill-opacity="0" stroke-width="4" d="M1048.02,1119.34a22.5,22.5,0,1,1,37.15-.28" transform="translate(-1042 -1082)" style="stroke: #25282b;fill: none;stroke-linecap: round;fill-rule: evenodd;"></path>
						<path id="progressbar_server-table-947" class="progress-bar-line" fill-opacity="0" stroke-width="4" stroke="url(#linear)" d="M1048.02,1119.34a22.5,22.5,0,1,1,37.15-.28" transform="translate(-1042 -1082)" style="stroke-dasharray: calc(97.6754 + `+item.health+`), calc(97.6754 + `+item.health+`);stroke-dashoffset: 97.6754;fill: none;stroke-linecap: round;fill-rule: evenodd;"></path>
					</svg>
					<div class="svg">
						<h2>
						`+item.health+`%
						</h2>
					</div>
				</div>
				
				<div data-tippy-content="Karoseria: `+item.bodyHealth+`%">
					<svg xmlns="http://www.w3.org/2000/svg" width="45" height="45" viewBox="0 0 49 40.22">
						<defs>
							<linearGradient id="linear" x1="0%" y1="0%" x2="100%" y2="0%">
							  <stop offset="0%"   stop-color="#2feaa8"/>
							  <stop offset="100%" stop-color="#028cf3"/>
							</linearGradient>
						  </defs>
						<path id="progressbar-bar-line-none" class="progress-bar-line" fill-opacity="0" stroke-width="4" d="M1048.02,1119.34a22.5,22.5,0,1,1,37.15-.28" transform="translate(-1042 -1082)" style="stroke: #25282b;fill: none;stroke-linecap: round;fill-rule: evenodd;"></path>
						<path id="progressbar_server-table-947" class="progress-bar-line" fill-opacity="0" stroke-width="4" stroke="url(#linear)" d="M1048.02,1119.34a22.5,22.5,0,1,1,37.15-.28" transform="translate(-1042 -1082)" style="stroke-dasharray: calc(97.6754 + `+item.bodyHealth+`), calc(97.6754 + `+item.bodyHealth+`);stroke-dashoffset: 97.6754;fill: none;stroke-linecap: round;fill-rule: evenodd;"></path>
					</svg>
					<div class="svg">
						<h2>
						`+item.bodyHealth+`%
						</h2>
					</div>
				</div>
			</div>
		</li>`;
	  $("#cars").append(car);
      $("#policeCar" + item.number).attr('model', item.model);
	  number3 = number3 + 1;
    }
  });
  
  document.onkeyup = function (data) {
    if (data.which == 27 ) {
      $.post('http://Que_garages/close', JSON.stringify({}));
		closeContainer()
		$("#cars").html("");
    }
  };
  
  document.addEventListener('click',function(e){
	  console.log(number)
	for (var i=1; i<=number; i++) {
		if(e.target && e.target.id == 'btnCar' + i){
			var model = $("#btnCar" + i).attr('model');
			$.post('http://Que_garages/pullCar',  JSON.stringify({ model: $("#btnCar" + i).attr('model') }));
			$("#cars").html("");
		}
	}
  });
  
  document.addEventListener('click',function(e){
	for (var i=1; i<=number2; i++) {
		if(e.target && e.target.id == 'impCar' + i){
			var model = $("#impCar" + i).attr('model');
			$.post('http://Que_garages/towCar',  JSON.stringify({ model: $("#impCar" + i).attr('model') }));
			$("#cars").html("");
		}
	}
  });
  
  document.addEventListener('click',function(e){
	for (var i=1; i<=number3; i++) {
		if(e.target && e.target.id == 'policeCar' + i){
			var model = $("#policeCar" + i).attr('model');
			$.post('http://Que_garages/impoundCar',  JSON.stringify({ model: $("#policeCar" + i).attr('model') }));
			$("#cars").html("");
		}
	}
  });

  document.addEventListener('click',function(e){
	if(e.target && e.target.id == 'close-button'){
		closeContainer()
		$.post('http://Que_garages/close', JSON.stringify({}));
		$("#cars").html("");
	}
  });
});