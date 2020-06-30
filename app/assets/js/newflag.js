function check(e) {   
    const status = e.detail[0].status
    if(status == 200){
        document.getElementById("modalFlag-body").innerHTML = "<p>You're flag has been succesfully sended, one of our admins will check and report on you the situation.</p> <p>Thank you for making Acara a safer place <3</p>"
    }
    else if(status == 400) {
        var parser = new DOMParser();
        var doc = parser.parseFromString(e.detail[0].response, 'text/html');
        document.getElementById("modalFlag-body").innerHTML = doc.getElementById("modalFlag-body").innerHTML;
        $("#new_flag").on("ajax:complete", check);
    }
    else {
        document.getElementById("modalFlag-body").innerHTML = "<p> There was an error processing your request try later on </p>"
    }
}


async function flag(type, id) {
    const response = await fetch(`/flags/new?type=${type}&id=${id}`);
    const data = await response.text();
    var parser = new DOMParser();
    var htmlDoc = parser.parseFromString(data, 'text/html');

    const old = document.getElementById("modalFlag")
    if (old != undefined)
        old.remove()
    document.body.innerHTML += htmlDoc.getElementById("pageContent").innerHTML;
    $("#modalFlag").modal('show');
    
    $("#new_flag").on("ajax:complete", check);

}