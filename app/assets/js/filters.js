var platform = new H.service.Platform({
    'apikey': 'tsfTRvQK_fj7o7rS-8jw0jODSSm-g-5mUSnmEA80skw'
});

// Get an instance of the geocoding service:
var service = platform.getSearchService();

function searchPlaces() {
    const query = document.getElementById("searchPlacesInput").value;
    const list = document.getElementById("selectSpecificPlace");
    list.innerHTML = "";
    service.geocode(
        {
            q: query
        },
        (result) => {
            result.items.forEach(
                (item) => {
                    list.innerHTML += `<option data-cords="${item.position.lat},${item.position.lng}">${item.address.label}</option>`
                });
        },
        () => { });
}

function verifyDate() {
    $("#startDate").removeClass("is-invalid");
    $("#startDate").removeClass("is-valid");
    $("#endingDate").removeClass("is-invalid");
    $("#endingDate").removeClass("is-valid");
    if ($("#startDate").val() == "") {
        $("#startDate").addClass("is-invalid");
        return false;
    }
    if ($("#endingDate").val() == "" || $("#startDate").val() > $("#endingDate").val()) {
        $("#endingDate").addClass("is-invalid");
        return false;
    }
    $("#startDate").addClass("is-valid");
    $("#endingDate").addClass("is-valid");
    return true;
}

function addFilters() {
    const sliceAt = location.href.indexOf('?') + 1;
    const address = location.href.slice(0, sliceAt);
    var params = location.href.slice(sliceAt).split('&').filter(val => val.includes('gl=') || val.includes('q='));

    const place = document.getElementById("selectSpecificPlace");
    const dateStart = document.getElementById("startDate").value;
    const dateEnd = document.getElementById("endingDate").value;
    if (place.options[place.selectedIndex] != undefined) {
        const cords = place.options[place.selectedIndex].getAttribute("data-cords");
        const placeLabel = encodeURIComponent(place.options[place.selectedIndex].innerHTML);
        params = params.concat([`w=${cords}`, `p=${placeLabel}`])
    }
    if (dateEnd != undefined || dateStart != undefined) {
        if (!verifyDate())
            return;
        params = params.concat([`es=${dateStart}`, `ee=${dateEnd}`])
    }
    location.href = address + params.reduce((acc, val) => acc + "&" + val);
}

function clearFilters() {
    const sliceAt = location.href.indexOf('?') + 1;
    const address = location.href.slice(0, sliceAt);
    var params = location.href.slice(sliceAt).split('&');
    if (params.length <= 2) {
        $("#startDate").val("");
        $("#endingDate").val("");
        $("#searchPlacesInput").val("");
        $("#selectSpecificPlace").html("");
        $("#startDate").removeClass("is-invalid");
        $("#startDate").removeClass("is-valid");
        $("#endingDate").removeClass("is-invalid");
        $("#endingDate").removeClass("is-valid");
    }
    else
        location.href = address + params.filter(val => val.includes('gl=') || val.includes('q=')).reduce((acc, val) => acc + "&" + val);
}
