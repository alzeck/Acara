async function fetchfollows(url) {
    const response = await fetch(url);
    const data = await response.text();
    var parser = new DOMParser();
    var htmlDoc = parser.parseFromString(data, 'text/html');

    $("#modalComm-body").html(htmlDoc.getElementById("pageContent").innerHTML);
}

async function openFollowers(url, toggle) {
    await fetchfollows(url);

    $(`#pills-${toggle}-tab`).tab("show");

    $('#modalComm').modal('show');
}