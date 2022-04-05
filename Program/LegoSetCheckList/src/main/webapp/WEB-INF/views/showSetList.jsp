<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- Bootstrap [1] is a CSS and JavaScript framework, used for page styling, and useful for creating interactive pages that resize for different screen sizes. -->
<!-- Font awesome [2] contains free icons that I am using in my UI to help user recognition, when using the website. -->

<!-- References:
[1]		"https://getbootstrap.com/docs/5.0/getting-started/introduction/",
		Getbootstrap.com. [Online].
		Available: https://getbootstrap.com/docs/5.0/. [Accessed: 03- Feb- 2022]
[2] 	"Font Awesome Intro",
		W3schools.com. [Online].
		Available: https://www.w3schools.com/icons/fontawesome_icons_intro.asp. [Accessed: 04- Feb- 2022]
-->

<!DOCTYPE html>
<html lang="en">
	<head>
		<title>Lego: Set Checklist Creator - Search</title>

		<meta charset="UTF-8" content="text/html; charset=UTF-8">

		<meta id="viewport" name="viewport" content="width=device-width, initial-scale=1">
		
		<!--Bootstrap style sheet, used for page styling, as well as helping to resize page for different screen sizes -->
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">

		<!-- jQuery library, needed for Bootstrap JavaScript -->
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

		<!-- Bootstrap JavaScript for page styling -->
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
		
		<!-- Bootstrap js bundle -->
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
		
		<!-- This is font awesome used for icons for buttons and links -->
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

		<script type="text/javascript">
			// This does setup for the page when it is first loaded
			function setup() {
				// This sets a minimum size the page will adpat to until it will just zoom out,
				// as going any smaller would affect elements in the page
				if (screen.width < 550) {
					document.getElementById("viewport").setAttribute("content", "width=550, initial-scale=0.5");
				}
				
				// This adds the previously adds the text search previously entered to the search box
				document.getElementById("text_search").value = "${searchText}";
				
				// This sets the filter or sort bar open or leaves both hidden, so they are the same as they where on
				// the previous page. Otherwise if the user wasn't on the search page and this is empty then the filter bar starts off open
				if ("${barOpen}" == "" || "${barOpen}" == "filter") {
					document.getElementById("filterBarDropdownLink").className = "nav-link dropdown-toggle active";

					document.getElementById("filterBar").style.display = "block";
				}
				else if ("${barOpen}" == "sort") {
					document.getElementById("sortBarDropdownLink").className = "nav-link dropdown-toggle active";

					document.getElementById("sortBar").style.display = "block";
				}

				applySortVisuals();
				
				sortSelectChange();

				applyFiltersOnReload();

				// These add the current min year and max year filters to their number boxes
				document.getElementById("minYearBox").value = "${minYear}";
				document.getElementById("maxYearBox").value = "${maxYear}";

				// This adds the current min pieces filter to its number box,
				// or if no min set number parsed it is set to 0
				if ("${minPieces}" != "") {
					document.getElementById("minPiecesBox").value = "${minPieces}";
				}
				else {
					document.getElementById("minPiecesBox").value = 0;
				}

				// This adds the current max pieces filter to its number box
				document.getElementById("maxPiecesBox").value = "${maxPieces}";

				// If a Lego set has just been added to a list, this will open an alert bar to inform the user of this
				if("${setAdded}" == "true") {
					document.getElementById("setAddedToListAlert").setAttribute("class", "alert alert-success alert-dismissible fade show");
				}
				
				// If there was an error adding the set this will display this to the user
				if("${setAddedError}" == "true") {
					document.getElementById("selectList_${set_number}").setAttribute("class", "form-select is-invalid");
					document.getElementById("addSetToListHelp_${set_number}").setAttribute("class", "alert alert-danger mt-2s");
					
					document.getElementById("selectList_${set_number}").value = "${set_listSelected.setListId}";

					// This opens the addSetToListModal
					$("#addSetToListModal_${set_number}").modal("show");
				}
				
				// This displays an alert bar informing the user if a set list has been
				// created and is shown on the addSetToListModal, which is also opened
				if ("${setListCreated}" == "true") {
					document.getElementById("setListCreatedAlert_${set_number}").setAttribute("class", "alert alert-success alert-dismissible fade show");

					document.getElementById("selectList_${set_number}").value = "${newSetList.setListId}";

					// This opens the addSetToListModal
					$("#addSetToListModal_${set_number}").modal("show");
				}
				
				// This displays that if a set has been deleted from the list
				if ("${setDeleted}" == "true") {
					document.getElementById("setDeletedAlert").setAttribute("class", "alert alert-primary alert-dismissible fade show");
				}

				// If a Lego set has just been edited, this will open an alert bar to inform the user of this
				if("${setListEdited}" == "true") {
					document.getElementById("setListEditedAlert").setAttribute("class", "alert alert-success alert-dismissible fade show");
				}

				// This adds bootstrap styling to tooltips
				$('[data-bs-toggle="tooltip"]').tooltip();
			}
			
			// If sorts are applied to the page this adds visuals for the user so it is clear which columns are being filtered
			function applySortVisuals() {
				// If their is a sort this sets the correct column to the correct sort symbol,
				// and if their isn't a sort or it's set number, it sorts it by set number 
				if ("${sort1}" == "name") {
					document.getElementById("nameSortIcon").setAttribute("class", "fa fa-sort-alpha-asc");
					document.getElementById("sortSelect1").value = "Set Name (asc)";
				}
				else if ("${sort1}" == "-name") {
					document.getElementById("nameSortIcon").setAttribute("class", "fa fa-sort-alpha-desc");
					document.getElementById("sortSelect1").value = "Set Name (desc)";
				}
				else if ("${sort1}" == "theme") {
					document.getElementById("themeSortIcon").setAttribute("class", "fa fa-sort-down");
					document.getElementById("sortSelect1").value = "Theme (asc)";
				}
				else if ("${sort1}" == "-theme") {
					document.getElementById("themeSortIcon").setAttribute("class", "fa fa-sort-up");
					document.getElementById("sortSelect1").value = "Theme (desc)";
				}
				else if ("${sort1}" == "year") {
					document.getElementById("yearSortIcon").setAttribute("class", "fa fa-sort-numeric-asc");
					document.getElementById("sortSelect1").value = "Year Released (asc)";
				}
				else if ("${sort1}" == "-year") {
					document.getElementById("yearSortIcon").setAttribute("class", "fa fa-sort-numeric-desc");
					document.getElementById("sortSelect1").value = "Year Released (desc)";
				}
				else if ("${sort1}" == "numPieces") {
					document.getElementById("numPiecesSortIcon").setAttribute("class", "fa fa-sort-amount-asc");
					document.getElementById("sortSelect1").value = "Number of Pieces (asc)";
				}
				else if ("${sort1}" == "-numPieces") {
					document.getElementById("numPiecesSortIcon").setAttribute("class", "fa fa-sort-amount-desc");
					document.getElementById("sortSelect1").value = "Number of Pieces (desc)";
				}
				else if ("${sort1}" == "-set_num") {
					document.getElementById("numSortIcon").setAttribute("class", "fa fa-sort-numeric-desc");
					document.getElementById("sortSelect1").value = "Set Number (desc)";
				}
				else {
					document.getElementById("numSortIcon").setAttribute("class", "fa fa-sort-numeric-asc");
					document.getElementById("sortSelect1").value = "Set Number (asc)";
				}

				// If their is a second sort this sets the correct column to the correct sort symbol
				if ("${sort2}" == "name") {
					document.getElementById("nameSortIcon").setAttribute("class", "fa fa-sort-alpha-asc");
					document.getElementById("sortSelect2").value = "Set Name (asc)";
				}
				else if ("${sort2}" == "-name") {
					document.getElementById("nameSortIcon").setAttribute("class", "fa fa-sort-alpha-desc");
					document.getElementById("sortSelect2").value = "Set Name (desc)";
				}
				else if ("${sort2}" == "theme") {
					document.getElementById("themeSortIcon").setAttribute("class", "fa fa-sort-down");
					document.getElementById("sortSelect2").value = "Theme (asc)";
				}
				else if ("${sort2}" == "-theme") {
					document.getElementById("themeSortIcon").setAttribute("class", "fa fa-sort-up");
					document.getElementById("sortSelect2").value = "Theme (desc)";
				}
				else if ("${sort2}" == "year") {
					document.getElementById("yearSortIcon").setAttribute("class", "fa fa-sort-numeric-asc");
					document.getElementById("sortSelect2").value = "Year Released (asc)";
				}
				else if ("${sort2}" == "-year") {
					document.getElementById("yearSortIcon").setAttribute("class", "fa fa-sort-numeric-desc");
					document.getElementById("sortSelect2").value = "Year Released (desc)";
				}
				else if ("${sort2}" == "numPieces") {
					document.getElementById("numPiecesSortIcon").setAttribute("class", "fa fa-sort-amount-asc");
					document.getElementById("sortSelect2").value = "Number of Pieces (asc)";
				}
				else if ("${sort2}" == "-numPieces") {
					document.getElementById("numPiecesSortIcon").setAttribute("class", "fa fa-sort-amount-desc");
					document.getElementById("sortSelect2").value = "Number of Pieces (desc)";
				}
				else if ("${sort2}" == "-set_num") {
					document.getElementById("numSortIcon").setAttribute("class", "fa fa-sort-numeric-desc");
					document.getElementById("sortSelect2").value = "Set Number (desc)";
				}
				else if ("${sort2}" == "set_num") {
					document.getElementById("numSortIcon").setAttribute("class", "fa fa-sort-numeric-asc");
					document.getElementById("sortSelect2").value = "Set Number (asc)";
				}
				
				// If their is a second sort this sets the correct column to the correct sort symbol
				if ("${sort3}" == "name") {
					document.getElementById("nameSortIcon").setAttribute("class", "fa fa-sort-alpha-asc");
					document.getElementById("sortSelect3").value = "Set Name (asc)";
				}
				else if ("${sort3}" == "-name") {
					document.getElementById("nameSortIcon").setAttribute("class", "fa fa-sort-alpha-desc");
					document.getElementById("sortSelect3").value = "Set Name (desc)";
				}
				else if ("${sort3}" == "theme") {
					document.getElementById("themeSortIcon").setAttribute("class", "fa fa-sort-down");
					document.getElementById("sortSelect3").value = "Theme (asc)";
				}
				else if ("${sort3}" == "-theme") {
					document.getElementById("themeSortIcon").setAttribute("class", "fa fa-sort-up");
					document.getElementById("sortSelect3").value = "Theme (desc)";
				}
				else if ("${sort3}" == "year") {
					document.getElementById("yearSortIcon").setAttribute("class", "fa fa-sort-numeric-asc");
					document.getElementById("sortSelect3").value = "Year Released (asc)";
				}
				else if ("${sort3}" == "-year") {
					document.getElementById("yearSortIcon").setAttribute("class", "fa fa-sort-numeric-desc");
					document.getElementById("sortSelect3").value = "Year Released (desc)";
				}
				else if ("${sort3}" == "numPieces") {
					document.getElementById("numPiecesSortIcon").setAttribute("class", "fa fa-sort-amount-asc");
					document.getElementById("sortSelect3").value = "Number of Pieces (asc)";
				}
				else if ("${sort3}" == "-numPieces") {
					document.getElementById("numPiecesSortIcon").setAttribute("class", "fa fa-sort-amount-desc");
					document.getElementById("sortSelect3").value = "Number of Pieces (desc)";
				}
				else if ("${sort3}" == "-set_num") {
					document.getElementById("numSortIcon").setAttribute("class", "fa fa-sort-numeric-desc");
					document.getElementById("sortSelect3").value = "Set Number (desc)";
				}
				else if ("${sort3}" == "set_num") {
					document.getElementById("numSortIcon").setAttribute("class", "fa fa-sort-numeric-asc");
					document.getElementById("sortSelect3").value = "Set Number (asc)";
				}
			}

			// This reapplies any filters that where open when the page reloads
			function applyFiltersOnReload() {
				var text = "${searchText}";
				var minYear = parseInt(${minYear});
				var maxYear = parseInt(${maxYear});
				var minPieces = parseInt(${minPieces});
				var maxPieces = parseInt(${maxPieces});

				var themeName = "";
				if ("${theme_name}" != "") {
					themeName = "${theme_name}";
				}
				else {
					themeName = "All Themes";
				}
               	
               	// This runs displaying only the sets that match the filters selected
				for (let id = 0; id < "${num_sets}"; id++) {
                    var setName = document.getElementById("name_" + id).innerHTML;
					var setYear = parseInt(document.getElementById("year_" + id).innerHTML);
					var setTheme = document.getElementById("theme_" + id).innerText;
                    var setNum_pieces = parseInt(document.getElementById("num_pieces_" + id).innerHTML);
					
					// This will hide all sets that do not fall into the categories that the list is being filtered by
					if (((setName.toUpperCase().search(text.toUpperCase()) == -1) && (text.length != 0)) || ((setYear < minYear) && (minYear.length != 0)) || ((setYear > maxYear) && (maxYear.length != 0)) || ((setTheme != themeName) && (themeName != "All Themes")) || ((setNum_pieces < minPieces) && (minPieces.length != 0))  || ((setNum_pieces > maxPieces) && (maxPieces.length != 0))) {
                        document.getElementById("set_" + id).style.display = "none";
					}
					else {
							document.getElementById("set_" + id).style.display = "block";
					}
				}
			}

			// This will take the users to the set page for the Lego Set that matches the entered set number and variant
			// Or will inform them if the set number or set variant box is empty
			function findSet() {
				var set_number = document.getElementById("set_number").value;
				var set_variant = document.getElementById("set_variant").value;
				
				if (set_number.length == 0) {
					document.getElementById("set_number").setAttribute("class", "form-control col-xs-1 is-invalid");
					document.getElementById("set_number").setAttribute("title", "Set Number Cannot be Empty");
					alert("Set Number Cannot be Empty");
				}
				else {
					document.getElementById("set_number").setAttribute("class", "form-control col-xs-1 is-valid");
					document.getElementById("set_number").setAttribute("title", "Set Number");
				}
				
				if (set_variant.length == 0) {
					document.getElementById("set_variant").setAttribute("class", "form-control col-xs-1 is-invalid");
					document.getElementById("set_variant").setAttribute("title", "Set Variant Number Cannot be Empty");
					alert("Set Variant Cannot be Empty");
				}
				else {
					document.getElementById("set_variant").setAttribute("class", "form-control col-xs-1 is-valid");
					document.getElementById("set_variant").setAttribute("title", "Set Variant Number");
				}
				
				if ((set_number.length != 0) && (set_variant.length != 0)) {
					// This starts the loading spinner so the user knows that the Lego Set is being loaded
					openLoader();
					
					window.location = "/set/?set_number=" + set_number + "&set_variant=" + set_variant;
				}
			}

			// This calls the the controller setting the sort parameter as set number
			function numSort() {
				var iconClass = document.getElementById("numSortIcon").className;
				
				if (iconClass == "fa fa-sort" || iconClass == "fa fa-sort-numeric-desc") {
					sortBy("sort=set_num");
				}
				else if (iconClass == "fa fa-sort-numeric-asc") {
					sortBy("sort=-set_num");
				}
			}
			
			// This calls the the controller setting the sort parameter as name
			function nameSort() {
				var iconClass = document.getElementById("nameSortIcon").className;
				
				if (iconClass == "fa fa-sort" || iconClass == "fa fa-sort-alpha-desc") {
					sortBy("sort=name");
				}
				else if (iconClass == "fa fa-sort-alpha-asc") {
					sortBy("sort=-name");
				}
			}
			
			// This calls the the controller setting the sort parameter as theme
			function themeSort() {
				var iconClass = document.getElementById("themeSortIcon").className;
				
				if (iconClass == "fa fa-sort" || iconClass == "fa fa-sort-up") {
					sortBy("sort=theme");
				}
				else if (iconClass == "fa fa-sort-down") {
					sortBy("sort=-theme");
				}
			}
			
			// This calls the the controller setting the sort parameter as year
			function yearSort() {
				var iconClass = document.getElementById("yearSortIcon").className;
				
				if (iconClass == "fa fa-sort" || iconClass == "fa fa-sort-numeric-desc") {
					sortBy("sort=year");
				}
				else if (iconClass == "fa fa-sort-numeric-asc") {
					sortBy("sort=-year");
				}
			}
			
			// This calls the the controller setting the sort parameter as number of pieces
			function numPiecesSort() {
				var iconClass = document.getElementById("numPiecesSortIcon").className;
				
				if (iconClass == "fa fa-sort" || iconClass == "fa fa-sort-amount-desc") {
					sortBy("sort=numPieces");
				}
				else if (iconClass == "fa fa-sort-amount-asc") {
					sortBy("sort=-numPieces");
				}
			}

			// Adds the sort selected to the url so that it is sent to the controller so that it can be applied
			function sortBy(sort) {
				openLoader();

				window.location = "/set_list=${set_list.listName}/?" + sort + "&" + getBarOpen() + getFilters();
			}
			
			// This sorts a list of Lego sets depending on values assigned in the sortBar
			function multi_sort() {
				sortBy(getMulti_SortValues());
			}

			// This gets all multi-sort values
			function getMulti_SortValues() {
				var sort1 = document.getElementById("sortSelect1").value;
				var sort2 = document.getElementById("sortSelect2").value;
				var sort3 = document.getElementById("sortSelect3").value;
				
				var sort = "sort=" + sortValue(sort1);
				
				if (sort2 != "None") {
					sort += "," + sortValue(sort2);
				}
				
				if (sort3 != "None") {
					sort += "," + sortValue(sort3);
				}

				return sort;
			}

			// This gets the value needed to be added to the Rebrickable API uri request, to sort a list of Lego Sets, depending on the value selected
			function sortValue(sort) {
				if (sort == "Set Number (asc)") {
					return "set_num";
				}
				else if (sort == "Set Number (desc)") {
					return "-set_num";
				}
				else if (sort == "Set Name (asc)") {
					return "name";
				}
				else if (sort == "Set Name (desc)") {
					return "-name";
				}
				else if (sort == "Year Released (asc)") {
					return "year";
				}
				else if (sort == "Year Released (desc)") {
					return "-year";
				}
				else if (sort == "Theme (asc)") {
					return "theme";
				}
				else if (sort == "Theme (desc)") {
					return "-theme";
				}
				else if (sort == "Number of Pieces (asc)") {
					return "numPieces";
				}
				else if (sort == "Number of Pieces (desc)") {
					return "-numPieces";
				}
			}
			
			// When a sort select box is changed this will update the folowing sort select boxes so they connot match that select box for previous ones
			// It also disables sort3 if sort2 is None
			function sortSelectChange() {
				var sort1 = document.getElementById("sortSelect1");
				var sort2 = document.getElementById("sortSelect2");
				var sort3 = document.getElementById("sortSelect3");

				var sortType = sort1.value.split(" (")[0];

				// If sort 2 is the same sort type (ascending or descending) as sort
				// 1 this sets sort 2 and sort 3 to none, as sort types cannot match
				// similarly if sort 3 is the same sort type it is set to none
				if (sort2.value.match(sortType)) {
					sort2.value = "None";
					sort3.value = "None";
					sort3.disabled = true;
				}
				else if (sort3.value.match(sortType)) {
					sort3.value = "None";
				}

				sortDisableSelectedSortOptions(sort1, sort2);
				
				if (sort2.value == "None") {
					sort3.value = "None";
					sort3.disabled = true;
				}
				else {
					sort3.disabled = false;

					var sortType = sort2.value.split(" (")[0];

					// If sort 3 is the same type of sort type (ascending or descending) as sort
					// 2 this sets sort 3 to none, as sort types cannot match
					if (sort3.value.match(sortType)) {
						sort3.value = "None";
					}

					sortDisableSelectedSortOptions(sort2, sort3);

					// This disables the same otions that have already been disabled for sort2
					for (var i = 0; i < sort2.length; i++) {
						if (sort2.options[i].disabled == true) {
							sort3.options[i].disabled = true;
						}
					}
				}
			}
			
			// This disables the certain options on a select if the previous select has used that options asc or desc option
			function sortDisableSelectedSortOptions(sort1, sort2) {
				if (sort1.value.match("Set Name ")) {
					for (var i = 0; i < sort2.length; i++) {
						if (sort2.options[i].value.match("Set Name ")) {
							sort2.options[i].disabled = true;
						}
						else {
							sort2.options[i].disabled = false;
						}
					}
				}
				else if (sort1.value.match("Set Number ")) {
					for (var i = 0; i < sort2.length; i++) {
						if (sort2.options[i].value.match("Set Number ")) {
							sort2.options[i].disabled = true;
						}
						else {
							sort2.options[i].disabled = false;
						}
					}
				}
				else if (sort1.value.match("Year Released ")) {
					for (var i = 0; i < sort2.length; i++) {
						if (sort2.options[i].value.match("Year Released ")) {
							sort2.options[i].disabled = true;
						}
						else {
							sort2.options[i].disabled = false;
						}
					}
				}
				else if (sort1.value.match("Theme ")) {
					for (var i = 0; i < sort2.length; i++) {
						if (sort2.options[i].value.match("Theme ")) {
							sort2.options[i].disabled = true;
						}
						else {
							sort2.options[i].disabled = false;
						}
					}
				}
				else if (sort1.value.match("Number of Pieces ")) {
					for (var i = 0; i < sort2.length; i++) {
						if (sort2.options[i].value.match("Number of Pieces ")) {
							sort2.options[i].disabled = true;
						}
						else {
							sort2.options[i].disabled = false;
						}
					}
				}
			}

            // This filters the list by filters selected
			function filter() {
                var text = document.getElementById("text_search").value;
				var minYear = document.getElementById("minYearBox").value;
				var maxYear = document.getElementById("maxYearBox").value;
				var themeName = document.getElementById("themeFilter").value;
				var minPieces = document.getElementById("minPiecesBox").value;
				var maxPieces = document.getElementById("maxPiecesBox").value;
               	
               	// This runs displaying only the sets that match the filters selected
				for (let id = 0; id < "${num_sets}"; id++) {
                    var setName = document.getElementById("name_" + id).innerHTML;
					var setYear = parseInt(document.getElementById("year_" + id).innerHTML);
					var setTheme = document.getElementById("theme_" + id).innerText;
                    var setNum_pieces = parseInt(document.getElementById("num_pieces_" + id).innerHTML);

					// This will hide all sets that do not fall into the categories that the list is being filtered by
					if (((setName.toUpperCase().search(text.toUpperCase()) == -1) && (text.length != 0)) || ((setYear < minYear) && (minYear.length != 0)) || ((setYear > maxYear) && (maxYear.length != 0)) || ((setTheme != themeName) && (themeName != "All Themes")) || ((setNum_pieces < minPieces) && (minPieces.length != 0))  || ((setNum_pieces > maxPieces) && (maxPieces.length != 0))) {
						document.getElementById("set_" + id).style.display = "none";
					}
					else {
						document.getElementById("set_" + id).style.display = "block";
					}
				}
			}
			
			// This will minimise or maximise the filter bar, and if the sort bar is maximised this will also minimise it
			function minimiseFilterBar() {
				var filterBar = document.getElementById("filterBar").style.display;

				if (filterBar == "none") {
					document.getElementById("filterBarDropdownLink").className = "nav-link dropdown-toggle active";
					document.getElementById("sortBarDropdownLink").className = "nav-link dropdown-toggle";

					document.getElementById("filterBar").style.display = "block";
					document.getElementById("sortBar").style.display = "none";
				}
				else {
					document.getElementById("filterBarDropdownLink").className = "nav-link dropdown-toggle";

					document.getElementById("filterBar").style.display = "none";
				}
			}

			// This will minimise or maximise the sort bar, and if the filter bar is maximised this will also minimise it
			function minimiseSortBar() {
				var sortBar = document.getElementById("sortBar").style.display;

				if (sortBar == "none") {
					document.getElementById("sortBarDropdownLink").className = "nav-link dropdown-toggle active";
					document.getElementById("filterBarDropdownLink").className = "nav-link dropdown-toggle";

					document.getElementById("sortBar").style.display = "block";
					document.getElementById("filterBar").style.display = "none";
				}
				else {
					document.getElementById("sortBarDropdownLink").className = "nav-link dropdown-toggle";

					document.getElementById("sortBar").style.display = "none";
				}
			}

			// This returns if eithier the filter bar or sort bar are open 
			function getBarOpen() {
				var filterBar = document.getElementById("filterBar").style.display;
				var sortBar = document.getElementById("sortBar").style.display;

				if (filterBar != "none") {
					return "barOpen=filter";
				}
				else if (sortBar != "none") {
					return "barOpen=sort";
				}
				else {
					return "barOpen=none";
				}
			}

			// This starts the loading spinner so the user knows that a page is being loaded
			function openLoader() {
				$("#loadingModal").modal("show");
			}

			// This asks the user to confirm they want logout and if they do the user is sent to the database controller to do this 
			function logout() {
                alert("You have been successfully logged out")
                window.location = "/logout";
			}

			// This adds the sorts and filters active to a URL, that along with the
			// set number and name of a set to be deleted to sent to the controller
			function deleteSet(set_num, set_name) {
				window.location = "/set_list=${set_list.listName}/delete/${set_list.setListId}/set=" + set_num + "/" + set_name + "/?" + getMulti_SortValues() + "&" + getBarOpen() + getFilters();
			}

			// This gets all the filters active and adds returns them all as a string 
			function getFilters() {
				var filters = "";

				if (document.getElementById("text_search").value.length != 0) {
					filters += "&searchText=" + document.getElementById("text_search").value;
				}

				if (document.getElementById("minYearBox").value.length != 0) {
					filters += "&minYear=" + document.getElementById("minYearBox").value;
				}

				if (document.getElementById("maxYearBox").value.length != 0) {
					filters += "&maxYear=" + document.getElementById("maxYearBox").value;
				}

				if (document.getElementById("minPiecesBox").value.length != 0 && document.getElementById("minPiecesBox").value != 0) {
					filters += "&minPieces=" + document.getElementById("minPiecesBox").value;
				}

				if (document.getElementById("maxPiecesBox").value.length != 0) {
					filters += "&maxPieces=" + document.getElementById("maxPiecesBox").value;
				}

                var themeName = document.getElementById("themeFilter").value;
				if (themeName != "All Themes") {
					filters += "&theme_name=" + themeName;
				}

				return filters;
			}

			// This calls the controller to add a set to a set list
			function addSetToList(set_num) {
				var setListId = document.getElementById("selectList_" + set_num).value;

				window.location = "/addSetToList/previousPage=set_list/?setListId=" + setListId + "&set_number=" + set_num + "&setListName=${set_list.listName}&" + getMulti_SortValues() + "&" + getBarOpen() + getFilters();
			}

			// This function is called everytime a change occurs in the listName textbox
			// to check if the user already has a list with entered list name
			function checkListName(setNumber) {
				var setListName = document.getElementById("setListNameTextBox_" + setNumber).value;
				var listNameFound = false;

				// This checks if there is already a set list with the entered list name
				<c:forEach items="${set_lists}" var="set_list" varStatus="loop">
					if ("${set_list.listName}" == setListName) {
						listNameFound = true;
					}
				</c:forEach>

				// If the list name has been found (meaning a list with that name already exists), the
				// setListNameTextBox will be highlighted red to show there is an error, a tooltip will
				// be added informing the user that the name is already in use along with an error alert
				// box also containg this error message  and finally disabling the add new list button
				if (listNameFound == true) {
					document.getElementById("setListNameTextBox_" + setNumber).setAttribute("class", "form-control is-invalid");
					document.getElementById("setListNameTextBox_" + setNumber).setAttribute("title", "List name must be Unique");
					document.getElementById("addNewSetListHelp_" + setNumber).setAttribute("class", "alert alert-danger");
					document.getElementById("addNewSetListButton_" + setNumber).disabled = true;
				}
				// If the list name is not found, this highlights the textbox green to show the name is
				// valid, the tooltip is removed, the error alert box that contains the error message is
				// hidden and finally enabling the add new list button
				else {
					document.getElementById("setListNameTextBox_" + setNumber).setAttribute("class", "form-control is-valid");
					document.getElementById("setListNameTextBox_" + setNumber).removeAttribute("title");
					document.getElementById("addNewSetListHelp_" + setNumber).setAttribute("class", "d-none");
					document.getElementById("addNewSetListButton_" + setNumber).disabled = false;
				}
			}

			// This calls the controller to create a new set list
			function createNewSetList(set_num) {
				var setListName = document.getElementById("setListNameTextBox_" + set_num).value;

				window.location = "/addNewSetList/previousPage=set_list/?setListName=" + setListName + "&set_number=" + set_num + "&currentSetListName=${set_list.listName}&" + getMulti_SortValues() + "&" + getBarOpen() + getFilters();
			}

			// This function is called everytime a change occurs in the edit listName textbox
			// to check if the user already has a list with entered list name and when the confirm
			// change list name check box clicked
			function checkEditListName() {
				var setListName = document.getElementById("newSetListNameTextBox").value;
				var listNameFound = false;

				// This checks if there is already a set list with the entered list name
				<c:forEach items="${set_lists}" var="set_list" varStatus="loop">
					if ("${set_list.listName}" == setListName) {
						listNameFound = true;
					}
				</c:forEach>

				// If the list name has been found (meaning a list with that name already exists), the
				// setListNameTextBox will be highlighted red to show there is an error, a tooltip will
				// be added informing the user that the name is already in use along with an error alert
				// box also containg this error message  and finally disabling the add new list button
				if (listNameFound == true) {
					document.getElementById("newSetListNameTextBox").setAttribute("class", "form-control is-invalid");
					document.getElementById("newSetListNameTextBox").setAttribute("title", "List name must be Unique");
					document.getElementById("editSetListHelp").setAttribute("class", "alert alert-danger");
					document.getElementById("editSetListButton").disabled = true;
				}
				// If the list name is not found, this highlights the textbox green to show the name is
				// valid, the tooltip is removed, the error alert box that contains the error message is
				// hidden and finally enabling the add new list button if the user has confirmed they want
				// to change the set name
				else {
					document.getElementById("newSetListNameTextBox").setAttribute("class", "form-control is-valid");
					document.getElementById("newSetListNameTextBox").removeAttribute("title");
					document.getElementById("editSetListHelp").setAttribute("class", "d-none");

					if (document.getElementById("confirmListNameChange").checked == false) {
						document.getElementById("editSetListButton").disabled = true;
					}
					else {
						document.getElementById("editSetListButton").disabled = false;
					}
				}
			}

			// This calls the controller to change the set list name
			function editSetList() {
				var newSetListName = document.getElementById("newSetListNameTextBox").value;

				window.location = "/editSetList/previousPage=set_list/?setListId=${set_list.setListId}&newSetListName=" + newSetListName + "&" + getMulti_SortValues() + "&" + getBarOpen() + getFilters();
			}
		</script>
		
	</head>

	<body onload="setup()">
	
		<!-- This uses bootstrap so that everything in this div stays at the top of the page when it's scrolled down -->
		<div class="sticky-top" data-toggle="affix">
		
			<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
				<div class="container-fluid">
					<a class="navbar-brand" href="/" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Return to home page"> Lego: Set Checklist Creator </a>
                    <span class="navbar-text text-white"> List Name: ${set_list.listName} </span>

					<ul class="navbar-nav">
						<li class="nav-item dropdown">
							<a class="nav-link dropdown-toggle" id="filterBarDropdownLink" role="button" data-toggle="dropdown" aria-expanded="false" onclick="minimiseFilterBar()">
								<i class="fa fa-filter"></i> Filter
							</a>
						</li>
						<li class="nav-item dropdown">
							<a class="nav-link dropdown-toggle" id="sortBarDropdownLink" role="button" data-toggle="dropdown" aria-expanded="false" onclick="minimiseSortBar()">
								<i class="fa fa-sort"></i> Sort
							</a>
						</li>
					</ul>
					
					<div class="collapse navbar-collapse" id="navbar">
						<ul class="navbar-nav me-auto">
							<li class="nav-item ms-5">
								<a class="nav-link" id="editLink" style="cursor: pointer;" data-bs-toggle="modal" data-bs-target="#editSetListModel" title="Edit the name of Set List: '${set_list.listName}'"> <i class="fa fa-edit"></i> Edit</a>
							</li>
							<li class="nav-item ms-5">
								<a class="nav-link" id="deleteLink" style="cursor: pointer;" data-bs-toggle="modal" data-bs-target="#deleteSetListModal" title="Delete Set List: '${set_list.listName}'"> <i class="fa fa-trash"></i> Delete</a>
							</li>
							<script>
								// This adds bootstrap styling to the tooltips for the edit and delete links, because their data-bs-toggle is being used for their modal
								$(document).ready(function(){ 
									$("#editLink").tooltip();
									$("#deleteLink").tooltip();
								});
							</script>
						</ul>
						<ul class="navbar-nav">
							<li class="nav-item ms-5">
								<a class="nav-link" id="logoutLink" style="cursor: pointer;" data-bs-toggle="modal" data-bs-target="#logoutModal"> <i class="fa fa-sign-out"></i> Logout</a>
							</li>
						</ul>
					</div>
					
					<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
						<span class="navbar-toggler-icon"></span>
					</button>
				</div>
			</nav>
			
			<nav class="navbar navbar-expand-lg navbar-dark bg-secondary" id="filterBar" style="display: none">
				<div class="container-fluid">
					<label class="navbar-brand"> <i class="fa fa-filter"></i> Filter: </label>
					
					<div class="collapse navbar-collapse" id="filterBar">
						<ul class="navbar-nav">
							<li class="nav-item mx-5">
								<!-- This creates a form where users can enter details on how they would like to filter the list of Lego sets and a button to display those that match this search -->
								<form class="d-flex row">
									<div class="col-auto form-floating mt-1">
										<input id="text_search" class="form-control" name="text_search" type="text" placeholder="Search for Lego Set"/>
										<label class="text-secondary" for="text_search"> Search Text </label>
									</div>
									<div class="col-auto">
										<label class="text-white" for="themeSelect"> <i class="fa fa-filter"></i> Filter by Theme: </label>
										<!-- This creates a select box using bootstrap, for every Lego theme -->
										<select class="form-select" id="themeFilter" style="max-height: 50vh; overflow-y: auto; cursor: pointer;">
											<c:forEach items="${themeList}" var="theme">
												<c:choose>
													<c:when test="${theme.name == theme_name}">
														<option class="form-check-label" value="${theme.name}" data-tokens="${theme.name}" selected> ${theme.name} </option>
													</c:when>
													<c:otherwise>
														<option class="form-check-label" value="${theme.name}" data-tokens="${theme.name}"> ${theme.name} </option>
													</c:otherwise>
												</c:choose>
											</c:forEach>
										</select>
									</div>
									<div class="col-auto">
										<label class="text-white" for="minYearBox">	Minimum Year: </label>
										<input id="minYearBox" class="form-control" name="minYearBox" type="number" min=0 max="9999"/>
									</div>
									<div class="col-auto">
										<label class="text-white" for="maxYearBox">	Maximum Year: </label>
										<input id="maxYearBox" class="form-control col-xs-1" name="maxYearBox" type="number" min=0 max="9999"/>
									</div>
									<div class="col-auto">
										<label class="text-white" for="minPiecesBox"> Minimum Pieces: </label>
										<input id="minPiecesBox" class="form-control col-xs-1" name="minPiecesBox" type="number" min=0 max="9999"/>
									</div>
									<div class="col-auto">
										<label class="text-white" for="maxPiecesBox"> Maximum Pieces: </label>
										<input id="maxPiecesBox" class="form-control" name="maxPiecesBox" type="number" min=0 max="9999"/>
									</div>
									<div class="col-auto">
										<button class="btn btn-primary mt-4" type="button" onclick="filter()"> <i class="fa fa-filter"></i> Filter </button>
									</div>
								</form>
							</li>
						</ul>
					</div>

					<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#filterBar" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
						<span class="navbar-toggler-icon"></span>
					</button>
				</div>
			</nav>

			<nav class="navbar navbar-expand-lg navbar-dark bg-secondary" id="sortBar" style="display: none">
				<div class="container-fluid">
					<label class="navbar-brand"> <i class="fa fa-sort"></i> Sort: </label>
	
					<div class="collapse navbar-collapse" id="sortBar">
						<ul class="navbar-nav">
							<li class="nav-item mx-5">
								<!-- This creates a form where users can enter details on how they would like to sort the list of Lego sets and a button to display that sort on the list -->
								<form class="d-flex row">
									<div class="col-auto">
										<label class="text-white mt-2"> Sort By: </label>
									</div>
									<div class="col-auto mt-1">
										<select class="form-select" id="sortSelect1" style="cursor: pointer;" onchange="sortSelectChange()">
											<option selected> Set Number (asc) </option>
											<option> Set Number (desc) </option>
											<option> Set Name (asc) </option>
											<option> Set Name (desc) </option>
											<option> Year Released (asc) </option>
											<option> Year Released (desc) </option>
											<option> Theme (asc) </option>
											<option> Theme (desc) </option>
											<option> Number of Pieces (asc) </option>
											<option> Number of Pieces (desc) </option>
										</select>
									</div>
									<div class="col-auto">
										<label class="text-white mt-2"> Then By: </label>
									</div>
									<div class="col-auto mt-1">
										<select class="form-select" id="sortSelect2" style="cursor: pointer;" onchange="sortSelectChange()">
											<option selected> None </option>
											<option> Set Number (asc) </option>
											<option> Set Number (desc) </option>
											<option> Set Name (asc) </option>
											<option> Set Name (desc) </option>
											<option> Year Released (asc) </option>
											<option> Year Released (desc) </option>
											<option> Theme (asc) </option>
											<option> Theme (desc) </option>
											<option> Number of Pieces (asc) </option>
											<option> Number of Pieces (desc) </option>
										</select>
									</div>
									<div class="col-auto">
										<label class="text-white mt-2"> Then By: </label>
									</div>
									<div class="col-auto mt-1">
										<select class="form-select" id="sortSelect3" style="cursor: pointer;" onchange="sortSelectChange()" disabled>
											<option selected> None </option>
											<option> Set Number (asc) </option>
											<option> Set Number (desc) </option>
											<option> Set Name (asc) </option>
											<option> Set Name (desc) </option>
											<option> Year Released (asc) </option>
											<option> Year Released (desc) </option>
											<option> Theme (asc) </option>
											<option> Theme (desc) </option>
											<option> Number of Pieces (asc) </option>
											<option> Number of Pieces (desc) </option>
										</select>
									</div>
									<div class="col-auto">
										<button class="btn btn-primary mt-1" type="button" onclick="multi_sort()"> <i class="fa fa-sort"></i> Sort </button>
									</div>
								</form>
							</li>
						</ul>
					</div>

					<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#sortBar" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
						<span class="navbar-toggler-icon"></span>
					</button>
				</div>
			</nav>
		
			<!-- This uses bootstrap to create a container which width will be maximum on screens of any size, with a border -->
			<div class="container-fluid border bg-white">
				<!-- This is the header for all the Lego sets, made using a bootstrap row and columns with column names -->
				<div class="row align-items-center my-3">
					<div class="col">
						<h6>Set Image:</h6>
					</div>
					<div class="col-1">
					</div>
					<div class="col">
						<h6 style="cursor: pointer;" onclick="numSort()" data-bs-toggle="tooltip" data-bs-placement="left" title="Sort by Set Number">Set Number: <i id="numSortIcon" class="fa fa-sort"></i></h6>
					</div>
					<div class="col">
						<h6 style="cursor: pointer;" onclick="nameSort()" data-bs-toggle="tooltip" data-bs-placement="left" title="Sort by Set Name">Set Name: <i id="nameSortIcon" class="fa fa-sort"></i></h6>
					</div>
					<div class="col">
						<h6 style="cursor: pointer;" onclick="yearSort()" data-bs-toggle="tooltip" data-bs-placement="left" title="Sort by Year Released">Year Released: <i id="yearSortIcon" class="fa fa-sort"></i></h6>
					</div>
					<div class="col">
						<h6 style="cursor: pointer;" onclick="themeSort()" data-bs-toggle="tooltip" data-bs-placement="left" title="Sort by Theme">Theme: <i id="themeSortIcon" class="fa fa-sort"></i></h6>
					</div>
					<div class="col">
						<h6 style="cursor: pointer;" onclick="numPiecesSort()" data-bs-toggle="tooltip" data-bs-placement="left" title="Sort by Number of Pieces">Number of Pieces: <i id="numPiecesSortIcon" class="fa fa-sort"></i></h6>
					</div>
                    <div class="col-1">
                    </div>
				</div>
			</div>

            <!-- This alert will be display when a set is added to a set list -->
			<div class="d-none" id="setAddedToListAlert" role="alert">
				<i class="fa fa-check-circle"></i> <strong>Set: "<a href="/set?set_number=${set_number}" onclick="openLoader()" data-bs-toggle="tooltip" title="View Lego Set">${set_number}</a>" added to list: "<a href="/set_list=${set_listSelected.listName}" onclick="openLoader()" data-bs-toggle="tooltip" title="View Set List">${set_listSelected.listName}</a>"</strong>
				<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
			</div>

			<!-- This alert will be display when a set is deleted from the list -->
			<div class="d-none" id="setDeletedAlert" role="alert">
				<i class="fa fa-trash-o"></i> <strong>Deleted Set: "<a href="/set?set_number=${deletedSetNumber}" onclick="openLoader()" data-bs-toggle="tooltip" title="View Lego Set">${deletedSetName}</a>"</strong>
				<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
			</div>

			<!-- This alert will be display when a set list has been edited -->
			<div class="d-none" id="setListEditedAlert" role="alert">
				<i class="fa fa-check-circle"></i> <strong>Set List Name Changed to: "<i>${set_list.listName}</i>"</strong>
				<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
			</div>
		</div>
	    
		<div class="mb-5" id="sets">
			<!-- This creates a container using bootstrap, for every set in the set list and display the set image, number, name, year, theme and number of pieces -->
			<c:forEach items="${sets}" var="set" varStatus="loop">
				<!-- This uses bootstrap to create a container which width will be maximum on screens of any size, with a border -->
				<div id="set_${loop.index}" class="container-fluid border">
					<!-- This is the header for all the pieces in a Lego set, made using a bootstrap row and columns with piece attributes -->
					<div class="row align-items-center my-3">
						<div class="col" data-bs-toggle="tooltip" title="Image of the Lego Set '${set.name}' (Click to enlarge)">
							<!-- The style width sets the percentage size the image will be on any screen -->
							<!-- When clicked this will display a Model with the image enlarged within -->
							<img class="m-2" src="${set.img_url}" alt="Image of the Lego Set ${set.name}" style="width: 80%; cursor: pointer;" data-bs-toggle="modal" data-bs-target="#setModal_${set.num}">
						</div>
						<div class="col-1">
							<i class="fa fa-plus fa-lg" id="addSetToListModelButton_${set.num}" style="cursor: pointer;" data-bs-toggle="modal" data-bs-target="#addSetToListModal_${set.num}" title="Add Lego Set: '${set.name}' to a List"></i>
						</div>
						<div class="col">
							<a id="set_num_${loop.index}" href="/set?set_number=${set.num}" onclick="openLoader()" data-bs-toggle="tooltip" title="View Lego Set">${set.num}</a>
						</div>
						<div class="col">
                            <label id="name_${loop.index}">${set.name}</label>
						</div>
						<div class="col">
                            <label id="year_${loop.index}">${set.year}</label>
						</div>
						<div class="col">
                            <label id="theme_${loop.index}">${set.theme}</label>
						</div>
						<div class="col">
                            <label id="num_pieces_${loop.index}">${set.num_pieces}</label>
						</div>
                        <div class="col-1">
							<i class="fa fa-trash fa-lg" id="deleteButton_${set.num}" style="cursor: pointer;"  data-bs-toggle="modal" data-bs-target="#deleteSetFromListModal_${set.num}" title="Delete Lego Set: '${set.name}' from the List"></i>
						</div>
						<script>
							// This adds bootstrap styling to the tooltips for the add and delete buttons, because their data-bs-toggle is being used for their modal
							$(document).ready(function(){ 
								$("#addSetToListModelButton_${set.num}").tooltip();
								$("#deleteButton_${set.num}").tooltip();
							});
						</script>
					</div>

					<!-- Modal to confirm set deletion from list -->
					<div class="modal fade" id="deleteSetFromListModal_${set.num}" data-bs-backdrop="static" tabindex="-1" aria-labelledby="deleteSetFromListModalLabel_${set.num}" aria-hidden="true">
						<div class="modal-dialog modal-dialog-centered">
							<div class="modal-content">
								<div class="modal-header">
									<h5 class="modal-title"><i class="fa fa-trash"></i> Delete Set: "${set.name}"</h5>
									<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
								</div>
								<div class="modal-body">
									<p>Are you sure you want to delete the Lego Set: "<a href="/set?set_number=${set.num}" onclick="openLoader()" data-bs-toggle="tooltip" title="View Lego Set">${set.name}</a>" from the Set List: <a href="/set_list=${set_list.listName}" onclick="openLoader()" data-bs-toggle="tooltip" title="View Set List">${set_list.listName}</a>? </p>
								</div>
								<div class="modal-footer">
									<button type="button" class="btn btn-secondary" data-bs-dismiss="modal"> Cancel</button>
									<button type="button" class="btn btn-primary" onclick="deleteSet('${set.num}', '${set.name}')"><i class="fa fa-trash"></i> Delete</button>
								</div>
							</div>
						</div>
					</div>
				</div>

				<!-- Lego Set Modal Image Viewer -->
				<div class="modal fade" id="setModal_${set.num}" tabindex="-1" aria-labelledby="setModalLabel_${set.num}" aria-hidden="true">
					<div class="modal-dialog modal-dialog-centered">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title" id="setModalLabel_${set.num}">Lego Set: ${set.name}</h5>
								<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
							</div>
							<div class="modal-body">
								<img src="${set.img_url}" alt="Image of the Lego Set: ${set.name}" style="width: 100%">
							</div>
						</div>
					</div>
				</div>

                <!-- Modal to Add a Lego Set to a List -->
                <div class="modal fade" id="addSetToListModal_${set.num}" data-bs-backdrop="static" tabindex="-1" aria-labelledby="addSetToListModelLabel_${set.num}" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="addSetToListModalLabel_${set.num}">Add Set to a List</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <form method="POST" id="addSetToListForm_${set.num}">
                                <div class="modal-body">
									<!-- This alert will be display when a new set list is created -->
									<div class="d-none" id="setListCreatedAlert_${set.num}" role="alert">
										<i class="fa fa-check-circle"></i> <strong>Added New Set List: "<a href="/set_list=${newSetList.listName}" onclick="openLoader()" data-bs-toggle="tooltip" title="View Set List">${newSetList.listName}</a>"</strong>
										<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
									</div>
                                    <div class="mb-3">
                                        <label class="form-label">Add Set: "${set.num}/${set.name}" to a list</label>
                                        <br>
                                        <h5> Set List: </h5>
                                        <div class="input-group mb-3">
                                            <!-- This creates a select box using bootstrap, for every List of Lego Sets belonging to the logged in user -->
                                            <select class="form-select" id="selectList_${set.num}" name="setListId" style="max-height: 50vh; overflow-y: auto;" aria-label="Default select example" aria-describedby="newListButton_${set.num}"  data-bs-toggle="tooltip" title="Select a list to add the set to">
                                                <c:forEach items="${set_lists}" var="set_list">
                                                    <option class="form-check-label" value="${set_list.setListId}" data-tokens="${set_list.listName}"> ${set_list.listName} </option>
                                                </c:forEach>
                                            </select>
                                            <button id="newListButton_${set.num}" type="button" class="btn btn-secondary" data-bs-toggle="modal" data-bs-target="#addNewSetListModel_${set.num}"><i class="fa fa-plus"></i>  New List</button>
                                        </div>
                                        
                                        <div id="addSetToListHelp_${set.num}" class="d-none"><i class="fa fa-exclamation-circle"></i> Set already in list: "${set_listSelected.listName}"</div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                    <button type="button" id="addSetToListButton_${set.num}" class="btn btn-primary" onclick="addSetToList('${set.num}')"><i class="fa fa-plus"></i> Add Set</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

				<!-- Modal to Create a New Set List -->
				<div class="modal fade" id="addNewSetListModel_${set.num}" data-bs-backdrop="static" tabindex="-1" aria-labelledby="addNewSetListModelLabel_${set.num}" aria-hidden="true">
					<div class="modal-dialog modal-dialog-centered">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title" id="addNewSetListModelLabel_${set.num}">Create a New Lego Set List</h5>
								<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
							</div>
							<form method="POST" id="addNewSetListForm_${set.num}">
								<div class="modal-body">
									<div class="mb-3">
										<h5> Set List: </h5>
										<div class="form-floating mb-3">
											<input id="setListNameTextBox_${set.num}" class="form-control" name="setListName" type="text" oninput="checkListName('${set.num}')" placeholder="Input Unique List Name">
											<label class="text-secondary" for="setListNameTextBox"> Input Unique List Name </label>
										</div>
										
										<div id="addNewSetListHelp_${set.num}" class="d-none"><i class="fa fa-exclamation-circle"></i> You already have a set list with the name entered, <br> Please enter a unique name</div>
									</div>
								</div>
								<div class="modal-footer">
									<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
									<button type="button" id="addNewSetListButton_${set.num}" class="btn btn-primary" onclick="createNewSetList('${set.num}')" disabled><i class="fa fa-plus"></i> Create List</button>
								</div>
							</form>
						</div>
					</div>
				</div>
			</c:forEach>
		</div>

		<!-- Modal to show loading -->
		<div class="modal fade" id="loadingModal" data-bs-backdrop="static" tabindex="-1" aria-labelledby="loadingModalLabel" aria-hidden="true">
			<div class="modal-dialog modal-dialog-centered">
				<div class="modal-content">
					<div class="modal-body">
						<div class="d-flex align-items-center">
							<strong>Loading...</strong>
							<div class="spinner-border ms-auto" role="status" aria-hidden="true"></div>
						</div>
					</div>
				</div>
			</div>
		</div>

        <!-- Modal to confirm logout -->
        <div class="modal fade" id="logoutModal" data-bs-backdrop="static" tabindex="-1" aria-labelledby="logoutModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title"><i class="fa fa-sign-out"></i> Logout</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure you want to logout? </p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"> Cancel</button>
                        <button type="button" class="btn btn-primary" style="cursor: pointer;" onclick="window.location.href='/logout'"><i class="fa fa-sign-out"></i> Logout</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal to confirm setlist deletion -->
        <div class="modal fade" id="deleteSetListModal" data-bs-backdrop="static" tabindex="-1" aria-labelledby="deleteSetListModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title"><i class="fa fa-trash"></i> Delete Set List: "${set_list.listName}"</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure you want to delete the set list: "${set_list.listName}"? </p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"> Cancel</button>
						<button type="button" class="btn btn-primary" onclick="window.location = '/set_list=${set_list.listName}/delete/${set_list.setListId}'"><i class="fa fa-trash"></i> Delete</button>
                    </div>
                </div>
            </div>
        </div>

		<!-- Modal Edit List Name -->
		<div class="modal fade" id="editSetListModel" data-bs-backdrop="static" tabindex="-1" aria-labelledby="editSetListModelLabel" aria-hidden="true">
			<div class="modal-dialog modal-dialog-centered">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="editSetListModelLabel">Edit Lego Set List Name</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<form method="POST" id="editSetListModel">
						<div class="modal-body">
							<div class="mb-3">
								<h5> Set List: </h5>
								<div class="form-floating mb-3">
									<input id="newSetListNameTextBox" class="form-control" name="setListName" type="text" oninput="checkEditListName()" placeholder="Change List Name" value="${set_list.listName}">
									<label class="text-secondary" for="setListNameTextBox"> Edit List Name </label>
								</div>
								
								<!-- This is used so the user has to confirm the changes they are making -->
								<div class="form-check">
									<input class="form-check-input" type="checkbox" id="confirmListNameChange" onclick="checkEditListName()">
									<label class="form-check-label" for="confirmListNameChange">I want to change the name of the Set List: '${set_list.listName}'</label>
								</div>

								<div id="editSetListHelp" class="d-none"><i class="fa fa-exclamation-circle"></i> You already have a set list with the name entered, <br> Please enter a unique name</div>
							</div>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
							<button type="button" id="editSetListButton" class="btn btn-primary" onclick="editSetList()" disabled><i class="fa fa-plus"></i> Change List Name</button>
						</div>
					</form>
				</div>
			</div>
		</div>

		<nav class="navbar navbar-expand-md navbar-dark bg-dark fixed-bottom">
			<div class="container-fluid">
	            <ol class="breadcrumb bg-dark">
	                <li class="breadcrumb-item"><a href="/">Home</a></li>
                    <li class="breadcrumb-item"><a href="/set_lists">Set Lists</a></li>
	                <li class="breadcrumb-item text-white" aria-current="page">Set List</li>
	            </ol>
		    </div>
        </nav>
	</body>
</html>