var animating = false;

function toggleMapUI(visable) {

    if (visable) {
        $(".outline").fadeIn();
        $(".speed").fadeIn();
    } else {
        $(".outline").fadeOut();
        $(".speed").fadeOut();
    }

}

$(document).ready(function () {

    $("#main_container").hide();
});

window.addEventListener('message', function (event) {


    var edata = event.data;

    if (edata.type == "Init") {


        $("#main_container").show();


    } else if (edata.type == "closeMapUI") {
        toggleMapUI(false);
    } else if (edata.type == "openMapUI") {
        toggleMapUI(true);
    } else if (edata.type == "hideUI") {
        $("#main_container").hide();
    } else if (edata.type == "showUI") {
        $("#main_container").show();
    } 


});