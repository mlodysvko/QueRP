var play = true
var muzyka = document.getElementById('music')
var resname = 'fc-load'
var readyx = false

function hidels() {
    $.post('http://' + resname + '/hidels', JSON.stringify({}));
}

window.addEventListener('message', (event) => {
    let data = event.data
    if (data.stop == true){
        hidels()
    }
})