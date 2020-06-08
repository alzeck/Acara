async function launchIframeModal(str) {
    console.log(str);
    const response = await fetch(str);
    const data = await response.text();
    var parser = new DOMParser();
    var htmlDoc = parser.parseFromString(data, 'text/html');

    document.getElementById("modalComm").getElementsByClassName("modal-body")[0].innerHTML = htmlDoc.getElementById("pageContent").innerHTML;

    $('#modalComm').modal('toggle');
}