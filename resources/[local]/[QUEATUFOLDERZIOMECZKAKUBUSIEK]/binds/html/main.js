function Clear(){
	$("#pl1").empty()
	$("#pl2").empty()
	$("#pl3").empty()
	$("#pl4").empty()
	$("#pl5").empty()
}

$(function(){
	window.addEventListener('message', (event) => {

		if (event.data.action == "img1"){
			$('#img1').html('<img width="52" src='+event.data.img1+'>');
		}

		if (event.data.action == "img2"){
			$('#img2').html('<img width="52" src='+event.data.img2+'>');
		}

		if (event.data.action == "img3"){
			$('#img3').html('<img width="52" src='+event.data.img3+'>');
		}

		if (event.data.action == "img4"){
			$('#img4').html('<img width="52" src='+event.data.img4+'>');
		}

		if (event.data.action == "img5"){
			$('#img5').html('<img width="52" src='+event.data.img5+'>');
		}

		if (event.data.action == "delimg1"){
			$("#img1").empty()
		}

		if (event.data.action == "delimg2"){
			$("#img2").empty()
		}

		if (event.data.action == "delimg3"){
			$("#img3").empty()
		}

		if (event.data.action == "delimg4"){
			$("#img4").empty()
		}

		if (event.data.action == "delimg5"){
			$("#img5").empty()
		}

		var item = event.data;
		if (item !== undefined && item.type === "open") {
			if (item.display === true) {

				$("#bodybox").show();
			} else{
				Clear()
				$("#bodybox").hide();
			}
		}

	})
});

