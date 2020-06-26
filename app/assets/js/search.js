function search(inputId, listId, itemclass, nameClass) { 
    // Declare variables
    var input, filter, list, items, a, i, txtValue;
    input = document.getElementById(inputId);
    filter = input.value.toUpperCase();
    list = document.getElementById(listId);
    items = list.getElementsByClassName(itemclass);

    // Loop through all list items, and hide those who don't match the search query
    for (i = 0; i < items.length; i++) {
        a = items[i].getElementsByClassName(nameClass)[0];
        txtValue = a.textContent || a.innerText;
        if (txtValue.toUpperCase().indexOf(filter) > -1) {
            items[i].style.display = "";
        } else {
            items[i].style.display = "none";
        }
    }
}