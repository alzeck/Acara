function openNav() {
    document.getElementById("sideBar").style.display = "block";
    $("#chatCol").css("display", "none");
    $("#chatCol").removeClass("d-flex");
}

function closeNav() {
    document.getElementById("sideBar").style.display = "none";
    document.getElementById("chatCol").style.display = "";
    $("#chatCol").addClass("d-flex");
}


window.addEventListener("resize",
    () => {
        document.getElementById("sideBar").style.display = "";
        document.getElementById("chatCol").style.display = "";
        $("#chatCol").addClass("d-flex");
    }
);