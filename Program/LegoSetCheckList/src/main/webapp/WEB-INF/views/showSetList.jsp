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

				// The following disables the previous button if their is not a previous page of results
				// and the next button if their is not another page of results				
				if ("${previousPage}" == "") {	
					document.getElementById("previousPageButton").disabled = true;
				}
				
				if ("${nextPage}" == "") {
					document.getElementById("nextPageButton").disabled = true;
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

				applySortVisuals()
				
				sortSelectChange();

				// These add the current min year and max year filters to their number boxes
				document.getElementById("minYearBox").value = "${minYear}";
				document.getElementById("maxYearBox").value = "${maxYear}";
				
				// These add the current min pieces and max pieces filters to their number boxes
				document.getElementById("minPiecesBox").value = "${minPieces}";
				document.getElementById("maxPiecesBox").value = "${maxPieces}";

				// If a Lego set has just been added to a list, this will open an alert bar to inform the user of this
				if("${setAdded}" == "true") {
					document.getElementById("setAddedToListAlert").setAttribute("class", "alert alert-success alert-dismissible fade show");
				}

				// If the account logged in is not set, the login/SignUp link is displayed enabling users to log in
				if("${setAddedError}" == "true") {
					document.getElementById("selectList_${set_number}").setAttribute("class", "form-select is-invalid");
					document.getElementById("addSetToListHelp_${set_number}").setAttribute("class", "alert alert-danger mt-2s");
					
					document.getElementById("selectList_${set_number}").value = "${set_list.setListId}";

					// This opens the addSetToListModal
					$("#addSetToListModal_${set_number}").modal("show");
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
				else if ("${sort1}" == "theme_id") {
					document.getElementById("themeSortIcon").setAttribute("class", "fa fa-sort-down");
					document.getElementById("sortSelect1").value = "Theme (asc)";
				}
				else if ("${sort1}" == "-theme_id") {
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
				else if ("${sort1}" == "num_parts") {
					document.getElementById("numPiecesSortIcon").setAttribute("class", "fa fa-sort-amount-asc");
					document.getElementById("sortSelect1").value = "Number of Pieces (asc)";
				}
				else if ("${sort1}" == "-num_parts") {
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
				
				// If their is a sort this sets the correct column to the correct sort symbol,
				// and if their isn't a sort or it's set number, it sorts it by set number
				if ("${sort2}" == "name") {
					document.getElementById("nameSortIcon").setAttribute("class", "fa fa-sort-alpha-asc");
					document.getElementById("sortSelect2").value = "Set Name (asc)";
				}
				else if ("${sort2}" == "-name") {
					document.getElementById("nameSortIcon").setAttribute("class", "fa fa-sort-alpha-desc");
					document.getElementById("sortSelect2").value = "Set Name (desc)";
				}
				else if ("${sort2}" == "theme_id") {
					document.getElementById("themeSortIcon").setAttribute("class", "fa fa-sort-down");
					document.getElementById("sortSelect2").value = "Theme (asc)";
				}
				else if ("${sort2}" == "-theme_id") {
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
				else if ("${sort2}" == "num_parts") {
					document.getElementById("numPiecesSortIcon").setAttribute("class", "fa fa-sort-amount-asc");
					document.getElementById("sortSelect2").value = "Number of Pieces (asc)";
				}
				else if ("${sort2}" == "-num_parts") {
					document.getElementById("numPiecesSortIcon").setAttribute("class", "fa fa-sort-amount-desc");
					document.getElementById("sortSelect2").value = "Number of Pieces (desc)";
				}
				else if ("${sort2}" == "-set_num") {
					document.getElementById("numSortIcon").setAttribute("class", "fa fa-sort-numeric-desc");
					document.getElementById("sortSelect2").value = "Set Number (desc)";
				}
				
				// If their is a sort this sets the correct column to the correct sort symbol,
				// and if their isn't a sort or it's set number, it sorts it by set number
				if ("${sort3}" == "name") {
					document.getElementById("nameSortIcon").setAttribute("class", "fa fa-sort-alpha-asc");
					document.getElementById("sortSelect3").value = "Set Name (asc)";
				}
				else if ("${sort3}" == "-name") {
					document.getElementById("nameSortIcon").setAttribute("class", "fa fa-sort-alpha-desc");
					document.getElementById("sortSelect3").value = "Set Name (desc)";
				}
				else if ("${sort3}" == "theme_id") {
					document.getElementById("themeSortIcon").setAttribute("class", "fa fa-sort-down");
					document.getElementById("sortSelect3").value = "Theme (asc)";
				}
				else if ("${sort3}" == "-theme_id") {
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
				else if ("${sort3}" == "num_parts") {
					document.getElementById("numPiecesSortIcon").setAttribute("class", "fa fa-sort-amount-asc");
					document.getElementById("sortSelect3").value = "Number of Pieces (asc)";
				}
				else if ("${sort3}" == "-num_parts") {
					document.getElementById("numPiecesSortIcon").setAttribute("class", "fa fa-sort-amount-desc");
					document.getElementById("sortSelect3").value = "Number of Pieces (desc)";
				}
				else if ("${sort3}" == "-set_num") {
					document.getElementById("numSortIcon").setAttribute("class", "fa fa-sort-numeric-desc");
					document.getElementById("sortSelect3").value = "Set Number (desc)";
				}
			}

			// The following two functions call the api with the either the previous or next page uri
			function previousPage() {
				var previous = "${previousPage}";
				
				window.location = "/search/text=${searchText}" + "/barOpen=" + getBarOpen() + "/sort=${sort}/minYear=${minYear}/maxYear=${maxYear}/minPieces=${minPieces}/maxPieces=${maxPieces}/theme_id=${theme_id}/uri/" + previous;
			}
			
			function nextPage() {
				var next = "${nextPage}";
				
				window.location = "/search/text=${searchText}" + "/barOpen=" + getBarOpen() + "/sort=${sort}/minYear=${minYear}/maxYear=${maxYear}/minPieces=${minPieces}/maxPieces=${maxPieces}/theme_id=${theme_id}/uri/" + next;
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

			// This calls the the controller setting the sort parameter as name
			function numSort() {
				var iconClass = document.getElementById("numSortIcon").className;
				
				if (iconClass == "fa fa-sort" || iconClass == "fa fa-sort-numeric-desc") {
					sortBy("set_num");
				}
				else if (iconClass == "fa fa-sort-numeric-asc") {
					sortBy("-set_num");
				}
			}
			
			// This calls the the controller setting the sort parameter as name
			function nameSort() {
				var iconClass = document.getElementById("nameSortIcon").className;
				
				if (iconClass == "fa fa-sort" || iconClass == "fa fa-sort-alpha-desc") {
					sortBy("name");
				}
				else if (iconClass == "fa fa-sort-alpha-asc") {
					sortBy("-name");
				}
			}
			
			// This calls the the controller setting the sort parameter as theme_id
			function themeSort() {
				var iconClass = document.getElementById("themeSortIcon").className;
				
				if (iconClass == "fa fa-sort" || iconClass == "fa fa-sort-up") {
					sortBy("theme_id");
				}
				else if (iconClass == "fa fa-sort-down") {
					sortBy("-theme_id");
				}
			}
			
			// This calls the the controller setting the sort parameter as year
			function yearSort() {
				var iconClass = document.getElementById("yearSortIcon").className;
				
				if (iconClass == "fa fa-sort" || iconClass == "fa fa-sort-numeric-desc") {
					sortBy("year");
				}
				else if (iconClass == "fa fa-sort-numeric-asc") {
					sortBy("-year");
				}
			}
			
			// This calls the the controller setting the sort parameter as num_pieces
			function numPiecesSort() {
				var iconClass = document.getElementById("numPiecesSortIcon").className;
				
				if (iconClass == "fa fa-sort" || iconClass == "fa fa-sort-amount-desc") {
					sortBy("num_parts");
				}
				else if (iconClass == "fa fa-sort-amount-asc") {
					sortBy("-num_parts");
				}
			}

			// Adds the sort selected to the url so that it is sent to the controller so that it can be applied
			function sortBy(sort) {
				window.location = "/search/text=${searchText}" + "/barOpen=" + getBarOpen() + "/sort=" + sort + "/minYear=${minYear}/maxYear=${maxYear}/minPieces=${minPieces}/maxPieces=${maxPieces}/theme_id=${theme_id}/uri/";
			}
			
			// This sorts a list of Lego sets depending on values assigned in the sortBar
			function sort() {
				var sort1 = document.getElementById("sortSelect1").value;
				var sort2 = document.getElementById("sortSelect2").value;
				var sort3 = document.getElementById("sortSelect3").value;
				
				var sort = sortValue(sort1);
				
				if (sort2 != "None") {
					sort += ", " + sortValue(sort2);
				}
				
				if (sort3 != "None") {
					sort += ", " + sortValue(sort3);
				}
				
				window.location = "/search/text=${searchText}" + "/barOpen=" + getBarOpen() + "/sort=" + sort + "/minYear=${minYear}/maxYear=${maxYear}/minPieces=${minPieces}/maxPieces=${maxPieces}/theme_id=${theme_id}/uri/";
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
					return "theme_id";
				}
				else if (sort == "Theme (desc)") {
					return "-theme_id";
				}
				else if (sort == "Number of Pieces (asc)") {
					return "num_parts";
				}
				else if (sort == "Number of Pieces (desc)") {
					return "-num_parts";
				}
			}
			
			// When a sort select box is changed this will update the folowing sort select boxes so they connot match that select box for previous ones
			// It also disables sort3 if sort2 is None
			function sortSelectChange() {
				var sort1 = document.getElementById("sortSelect1");
				var sort2 = document.getElementById("sortSelect2");
				var sort3 = document.getElementById("sortSelect3");

				if (sort1.value == sort2.value) {
					sort2.value = "None";
					sort3.value = "None";
					sort3.disabled = true;
				}
				else if (sort1.value == sort3.value) {
					sort3.value = "None";
				}

				sortDisableSelectedSortOptions(sort1, sort2);
				
				if (sort2.value == "None") {
					sort3.value = "None";
					sort3.disabled = true;
				}
				else {
					sort3.disabled = false;

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

			// This calls the controller with all the filters that the user wants to apply to the list
			function filter() {
				var text = document.getElementById("text_search").value;
				var minYear = document.getElementById("minYearBox").value;
				var maxYear = document.getElementById("maxYearBox").value;
				var minPieces = document.getElementById("minPiecesBox").value;
				var maxPieces = document.getElementById("maxPiecesBox").value;
				
				var theme_id = document.getElementById("themeFilter").value;
				
				window.location = "/search/text=" + text + "/barOpen=" + getBarOpen() + "/sort=${sort}/minYear=" + minYear + "/maxYear=" + maxYear + "/minPieces=" + minPieces + "/maxPieces=" + maxPieces + "/theme_id=" + theme_id + "/uri/";
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
					return "filter";
				}
				else if (sortBar != "none") {
					return "sort";
				}
				else {
					return "none";
				}
			}

			// This starts the loading spinner so the user knows that a page is being loaded
			function openLoader() {
				$("#loadingModal").modal("show");
			}

			// This asks the user to confirm they want logout and if they do the user is sent to the database controller to do this 
			function logout() {
				if (confirm("Are you sure you want to logout")) {
					alert("You have been successfully logged out")
					window.location = "/logout";
				}
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
								<a class="nav-link" id="editLink" style="cursor: pointer;" data-bs-toggle="modal" data-bs-target="#login_SignUp_Modal"> <i class="fa fa-edit"></i> Edit</a>
							</li>
							<li class="nav-item ms-5">
								<a class="nav-link" id="deleteLink" style="cursor: pointer;" onclick="logout()"> <i class="fa fa-trash"></i> Delete</a>
							</li>
						</ul>
						<ul class="navbar-nav">
							<li class="nav-item ms-5">
								<a class="nav-link" id="logoutLink" style="cursor: pointer;" onclick="logout()"> <i class="fa fa-sign-out"></i> Logout</a>
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
													<c:when test="${theme.id == theme_id}">
														<option class="form-check-label" value="${theme.id}" data-tokens="${theme.name}" selected> ${theme.name} </option>
													</c:when>
													<c:otherwise>
														<option class="form-check-label" value="${theme.id}" data-tokens="${theme.name}"> ${theme.name} </option>
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
										<button class="btn btn-primary mt-1" type="button" onclick="sort()"> <i class="fa fa-sort"></i> Sort </button>
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
					<!-- This code will only display this button if the user is logged in -->
					<c:if test="${not empty accountLoggedIn}">
						<div class="col-1">
						</div>
					</c:if>
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
				<i class="fa fa-check-circle"></i> <strong>Set: "<a href="/set?set_number=${set_number}" onclick="openLoader()" data-bs-toggle="tooltip" title="View Lego Set">${set_number}</a>" added to list: "<a href="/set_list=${set_list.listName}" onclick="openLoader()" data-bs-toggle="tooltip" title="View Set List">${set_list.listName}</a>"</strong>
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
						<!-- This code will only display this button if the user is logged in -->
						<c:if test="${not empty accountLoggedIn}">
							<div class="col-1">
								<i class="fa fa-plus fa-lg" id="addSetToListModelButton_${set.num}" style="cursor: pointer;" data-bs-toggle="modal" data-bs-target="#addSetToListModal_${set.num}" data-bs-toggle="tooltip" title="Add Lego Set: '${set.name}' to a List"></i>
							</div>
							<script>
								// This adds bootstrap styling to this tooltip, as because its in a c:if it is not added with the other tooltips
								$(document).ready(function(){ 
									$('#addSetToListModelButton_${set.num}').tooltip();
								});
							</script>
						</c:if>
						<div class="col">
							<a href="/set?set_number=${set.num}" onclick="openLoader()" data-bs-toggle="tooltip" title="View Lego Set">${set.num}</a>
						</div>
						<div class="col">
							${set.name}
						</div>
						<div class="col">
							${set.year}
						</div>
						<div class="col">
							${set.theme}
						</div>
						<div class="col">
							${set.num_pieces}
						</div>
                        <div class="col-1">
							<i class="fa fa-trash fa-lg" id="deleteLink_${set_list.setListId}" style="cursor: pointer;" onclick="deleteSetList()"></i>
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
                            <form method="POST" id="addSetToListForm_${set.num}" action="/addSetToList/previousPage=set_list">
                                <div class="modal-body">
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
                                            <button id="newListButton_${set.num}" type="button" class="btn btn-secondary"><i class="fa fa-plus"></i>  New List</button>
                                        </div>
                                        
                                        <div id="addSetToListHelp_${set.num}" class="d-none"><i class="fa fa-exclamation-circle"></i> Set already in list: "${set_list.listName}"</div>

                                        <!-- This is a hidden input that adds the set number of the set selected to the form -->
                                        <input type="hidden" id="inputSetNum_${set.num}" name="set_number" value="${set.num}"/>

                                        <!-- This is a hidden input that adds the set number of the set selected to the form -->
                                        <input type="hidden" id="inputSetListName_${set.num}" name="setListName" value="${set_list.listName}"/>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                    <button type="submit" id="addSetToListButton_${set.num}" class="btn btn-primary"><i class="fa fa-plus"></i> Add Set</button>
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

		<nav class="navbar navbar-expand-md navbar-dark bg-dark fixed-bottom">
			<div class="container-fluid">
	            <ol class="breadcrumb bg-dark">
	                <li class="breadcrumb-item"><a href="/">Home</a></li>
                    <li class="breadcrumb-item"><a href="/set_lists">Set Lists</a></li>
	                <li class="breadcrumb-item text-white" aria-current="page">Set List</li>
	            </ol>
				<div class="mx-2 my-2">
					<button id="previousPageButton" type="button" class="btn btn-primary btn-sm" onclick="previousPage()"> <i class="fa fa-arrow-left"></i> Previous </button>
					<button id="nextPageButton" type="button" class="btn btn-primary btn-sm" onclick="nextPage()"> Next <i class="fa fa-arrow-right"></i> </button>
				</div>
		    </div>
        </nav>
	</body>
</html>