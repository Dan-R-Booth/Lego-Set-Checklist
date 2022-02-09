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
		
		<!-- This is font awesome used for icons for buttons and links -->
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
		
		<script type="text/javascript">
			// This does setup for the page when it is first loaded
			function setup() {
				if (screen.width < 550) {
					document.getElementById("viewport").setAttribute("content","width=550, initial-scale=0.5");
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
				
				// If their is a sort this sets the correct column to the correct sort symbol,
				// and if their isn't a sort or it's set number, it sorts it by set number 
				if ("${sort1}" == "name") {
					document.getElementById("nameSortIcon").setAttribute("class","fa fa-sort-alpha-asc");
					document.getElementById("sortSelect1").value = "Set Name (asc)";
				}
				else if ("${sort1}" == "-name") {
					document.getElementById("nameSortIcon").setAttribute("class","fa fa-sort-alpha-desc");
					document.getElementById("sortSelect1").value = "Set Name (desc)";
				}
				else if ("${sort1}" == "theme_id") {
					document.getElementById("themeSortIcon").setAttribute("class","fa fa-sort-down");
					document.getElementById("sortSelect1").value = "Theme (asc)";
				}
				else if ("${sort1}" == "-theme_id") {
					document.getElementById("themeSortIcon").setAttribute("class","fa fa-sort-up");
					document.getElementById("sortSelect1").value = "Theme (desc)";
				}
				else if ("${sort1}" == "year") {
					document.getElementById("yearSortIcon").setAttribute("class","fa fa-sort-numeric-asc");
					document.getElementById("sortSelect1").value = "Year Released (asc)";
				}
				else if ("${sort1}" == "-year") {
					document.getElementById("yearSortIcon").setAttribute("class","fa fa-sort-numeric-desc");
					document.getElementById("sortSelect1").value = "Year Released (desc)";
				}
				else if ("${sort1}" == "num_parts") {
					document.getElementById("numPiecesSortIcon").setAttribute("class","fa fa-sort-amount-asc");
					document.getElementById("sortSelect1").value = "Number of Pieces (asc)";
				}
				else if ("${sort1}" == "-num_parts") {
					document.getElementById("numPiecesSortIcon").setAttribute("class","fa fa-sort-amount-desc");
					document.getElementById("sortSelect1").value = "Number of Pieces (desc)";
				}
				else if ("${sort1}" == "-set_num") {
					document.getElementById("numSortIcon").setAttribute("class","fa fa-sort-numeric-desc");
					document.getElementById("sortSelect1").value = "Set Number (desc)";
				}
				else {
					document.getElementById("numSortIcon").setAttribute("class","fa fa-sort-numeric-asc");
					document.getElementById("sortSelect1").value = "Set Number (asc)";
				}
				
				// If their is a sort this sets the correct column to the correct sort symbol,
				// and if their isn't a sort or it's set number, it sorts it by set number
				if ("${sort2}" == "name") {
					document.getElementById("nameSortIcon").setAttribute("class","fa fa-sort-alpha-asc");
					document.getElementById("sortSelect2").value = "Set Name (asc)";
				}
				else if ("${sort2}" == "-name") {
					document.getElementById("nameSortIcon").setAttribute("class","fa fa-sort-alpha-desc");
					document.getElementById("sortSelect2").value = "Set Name (desc)";
				}
				else if ("${sort2}" == "theme_id") {
					document.getElementById("themeSortIcon").setAttribute("class","fa fa-sort-down");
					document.getElementById("sortSelect2").value = "Theme (asc)";
				}
				else if ("${sort2}" == "-theme_id") {
					document.getElementById("themeSortIcon").setAttribute("class","fa fa-sort-up");
					document.getElementById("sortSelect2").value = "Theme (desc)";
				}
				else if ("${sort2}" == "year") {
					document.getElementById("yearSortIcon").setAttribute("class","fa fa-sort-numeric-asc");
					document.getElementById("sortSelect2").value = "Year Released (asc)";
				}
				else if ("${sort2}" == "-year") {
					document.getElementById("yearSortIcon").setAttribute("class","fa fa-sort-numeric-desc");
					document.getElementById("sortSelect2").value = "Year Released (desc)";
				}
				else if ("${sort2}" == "num_parts") {
					document.getElementById("numPiecesSortIcon").setAttribute("class","fa fa-sort-amount-asc");
					document.getElementById("sortSelect2").value = "Number of Pieces (asc)";
				}
				else if ("${sort2}" == "-num_parts") {
					document.getElementById("numPiecesSortIcon").setAttribute("class","fa fa-sort-amount-desc");
					document.getElementById("sortSelect2").value = "Number of Pieces (desc)";
				}
				else if ("${sort2}" == "-set_num") {
					document.getElementById("numSortIcon").setAttribute("class","fa fa-sort-numeric-desc");
					document.getElementById("sortSelect2").value = "Set Number (desc)";
				}
				
				// If their is a sort this sets the correct column to the correct sort symbol,
				// and if their isn't a sort or it's set number, it sorts it by set number
				if ("${sort3}" == "name") {
					document.getElementById("nameSortIcon").setAttribute("class","fa fa-sort-alpha-asc");
					document.getElementById("sortSelect3").value = "Set Name (asc)";
				}
				else if ("${sort3}" == "-name") {
					document.getElementById("nameSortIcon").setAttribute("class","fa fa-sort-alpha-desc");
					document.getElementById("sortSelect3").value = "Set Name (desc)";
				}
				else if ("${sort3}" == "theme_id") {
					document.getElementById("themeSortIcon").setAttribute("class","fa fa-sort-down");
					document.getElementById("sortSelect3").value = "Theme (asc)";
				}
				else if ("${sort3}" == "-theme_id") {
					document.getElementById("themeSortIcon").setAttribute("class","fa fa-sort-up");
					document.getElementById("sortSelect3").value = "Theme (desc)";
				}
				else if ("${sort3}" == "year") {
					document.getElementById("yearSortIcon").setAttribute("class","fa fa-sort-numeric-asc");
					document.getElementById("sortSelect3").value = "Year Released (asc)";
				}
				else if ("${sort3}" == "-year") {
					document.getElementById("yearSortIcon").setAttribute("class","fa fa-sort-numeric-desc");
					document.getElementById("sortSelect3").value = "Year Released (desc)";
				}
				else if ("${sort3}" == "num_parts") {
					document.getElementById("numPiecesSortIcon").setAttribute("class","fa fa-sort-amount-asc");
					document.getElementById("sortSelect3").value = "Number of Pieces (asc)";
				}
				else if ("${sort3}" == "-num_parts") {
					document.getElementById("numPiecesSortIcon").setAttribute("class","fa fa-sort-amount-desc");
					document.getElementById("sortSelect3").value = "Number of Pieces (desc)";
				}
				else if ("${sort3}" == "-set_num") {
					document.getElementById("numSortIcon").setAttribute("class","fa fa-sort-numeric-desc");
					document.getElementById("sortSelect3").value = "Set Number (desc)";
				}
				
				sortSelectChange();

				// These add the current min year and max year filters to their number boxes
				document.getElementById("minYearBox").value = "${minYear}";
				document.getElementById("maxYearBox").value = "${maxYear}";
				
				// These add the current min pieces and max pieces filters to their number boxes
				document.getElementById("minPiecesBox").value = "${minPieces}";
				document.getElementById("maxPiecesBox").value = "${maxPieces}";
				
				// This selects the correct theme_id radio button for the current theme being filtered, or selects all themes if none are being filtered
				if ("${theme_id}" == "") {
					document.getElementById("All").checked = true;
				}
				else {
					document.getElementById("${theme_id}").checked = true;
				}
			}
			
			// The following two functions call the api with the either the previous or next page uri
			function previousPage() {
				var previous = "${previousPage}";
				
				window.location = "/search/text=${searchText}/sort=${sort}/minYear=${minYear}/maxYear=${maxYear}/minPieces=${minPieces}/maxPieces=${maxPieces}/theme_id=${theme_id}/uri/" + previous;
			}
			
			function nextPage() {
				var next = "${nextPage}";
				
				window.location = "/search/text=${searchText}/sort=${sort}/minYear=${minYear}/maxYear=${maxYear}/minPieces=${minPieces}/maxPieces=${maxPieces}/theme_id=${theme_id}/uri/" + next;
			}

			function findSet() {
				var set_number = document.getElementById("set_number").value;
				var set_variant = document.getElementById("set_variant").value;
				
				if (set_number.length == 0) {
					document.getElementById("set_number").setAttribute("class", "form-control col-md-3 is-invalid");
					document.getElementById("set_number").setAttribute("title","Set Number Cannot be Empty");
				}
				else {					
					window.location = "/set/?set_number=" + set_number + "&set_variant=" + set_variant;
				}
			}

			// This calls the the controller setting the sort parameter as name
			function numSort() {
				var iconClass = document.getElementById("numSortIcon").className;
				
				if (iconClass == "fa fa-sort" || iconClass == "fa fa-sort-numeric-desc") {
					window.location = "/search/text=${searchText}/sort=set_num/minYear=${minYear}/maxYear=${maxYear}/minPieces=${minPieces}/maxPieces=${maxPieces}/theme_id=${theme_id}/uri/";
				}
				else if (iconClass == "fa fa-sort-numeric-asc") {
					window.location = "/search/text=${searchText}/sort=-set_num/minYear=${minYear}/maxYear=${maxYear}/minPieces=${minPieces}/maxPieces=${maxPieces}/theme_id=${theme_id}/uri/";
				}
			}
			
			// This calls the the controller setting the sort parameter as name
			function nameSort() {
				var iconClass = document.getElementById("nameSortIcon").className;
				
				if (iconClass == "fa fa-sort" || iconClass == "fa fa-sort-alpha-desc") {
					window.location = "/search/text=${searchText}/sort=name/minYear=${minYear}/maxYear=${maxYear}/minPieces=${minPieces}/maxPieces=${maxPieces}/theme_id=${theme_id}/uri/";
				}
				else if (iconClass == "fa fa-sort-alpha-asc") {
					window.location = "/search/text=${searchText}/sort=-name/minYear=${minYear}/maxYear=${maxYear}/minPieces=${minPieces}/maxPieces=${maxPieces}/theme_id=${theme_id}/uri/";
				}
			}
			
			// This calls the the controller setting the sort parameter as theme_id
			function themeSort() {
				var iconClass = document.getElementById("themeSortIcon").className;
				
				if (iconClass == "fa fa-sort" || iconClass == "fa fa-sort-up") {
					window.location = "/search/text=${searchText}/sort=theme_id/minYear=${minYear}/maxYear=${maxYear}/minPieces=${minPieces}/maxPieces=${maxPieces}/theme_id=${theme_id}/uri/";
				}
				else if (iconClass == "fa fa-sort-down") {
					window.location = "/search/text=${searchText}/sort=-theme_id/minYear=${minYear}/maxYear=${maxYear}/minPieces=${minPieces}/maxPieces=${maxPieces}/theme_id=${theme_id}/uri/";
				}
			}
			
			// This calls the the controller setting the sort parameter as year
			function yearSort() {
				var iconClass = document.getElementById("yearSortIcon").className;
				
				if (iconClass == "fa fa-sort" || iconClass == "fa fa-sort-numeric-desc") {
					window.location = "/search/text=${searchText}/sort=year/minYear=${minYear}/maxYear=${maxYear}/minPieces=${minPieces}/maxPieces=${maxPieces}/theme_id=${theme_id}/uri/";
				}
				else if (iconClass == "fa fa-sort-numeric-asc") {
					window.location = "/search/text=${searchText}/sort=-year/minYear=${minYear}/maxYear=${maxYear}/minPieces=${minPieces}/maxPieces=${maxPieces}/theme_id=${theme_id}/uri/";
				}
			}
			
			// This calls the the controller setting the sort parameter as num_pieces
			function numPiecesSort() {
				var iconClass = document.getElementById("numPiecesSortIcon").className;
				
				if (iconClass == "fa fa-sort" || iconClass == "fa fa-sort-amount-desc") {
					window.location = "/search/text=${searchText}/sort=num_parts/minYear=${minYear}/maxYear=${maxYear}/minPieces=${minPieces}/maxPieces=${maxPieces}/theme_id=${theme_id}/uri/";
				}
				else if (iconClass == "fa fa-sort-amount-asc") {
					window.location = "/search/text=${searchText}/sort=-num_parts/minYear=${minYear}/maxYear=${maxYear}/minPieces=${minPieces}/maxPieces=${maxPieces}/theme_id=${theme_id}/uri/";
				}
			}
			
			// This sorts a list of Lego sets depending on values assigned in the sortBar
			function sort() {
				var sort1 = document.getElementById("sortSelect1").value;
				var sort2 = document.getElementById("sortSelect2").value;
				var sort3 = document.getElementById("sortSelect3").value;
				
				var sort = sortValue(sort1);
				
				if (sort2 != "None") {
					sort += "," + sortValue(sort2);
				}
				
				if (sort3 != "None") {
					sort += "," + sortValue(sort3);
				}
				
				window.location = "/search/text=${searchText}/sort=" + sort + "/minYear=${minYear}/maxYear=${maxYear}/minPieces=${minPieces}/maxPieces=${maxPieces}/theme_id=${theme_id}/uri/";
			}

			// This gets the value needed to be added to the Rebrickable API uri request, to sort a list of Lego Sets, depending on the value selected
			function sortValue(sort) {
				if (sort == "Set Number (asc)") {
					return "set_num";
				}
				if (sort == "Set Number (desc)") {
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
				
				var themeFilter = document.querySelector('input[name="themeFilter"]:checked');
				var theme_id = "";
				if (themeFilter.id != "All") {
					theme_id = themeFilter.id;
				}
				
				window.location = "/search/text=" + text + "/sort=${sort}/minYear=" + minYear + "/maxYear=" + maxYear + "/minPieces=" + minPieces + "/maxPieces=" + maxPieces + "/theme_id=" + theme_id + "/uri/";
			}
			
			// This will minimise or maximise the filter bar, and if the sort bar is maximised this will also minimise it
			function minimiseFilterBar() {
				var navbar = document.getElementById("filterBar").style.display;

				if (navbar == "none") {
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
				var navbar = document.getElementById("sortBar").style.display;

				if (navbar == "none") {
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
			
		</script>
		
	</head>

	<body onload="setup()">
	
		<!-- This uses bootstrap so that everything in this div stays at the top of the page when it's scrolled down -->
		<div class="sticky-top" data-toggle="affix">
		
			<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
				<div class="container-fluid">
					<label class="navbar-brand"> Lego: Set Checklist Creator </label>
	
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
						<!-- This creates number boxes where users can enter a Lego set number and variant number (at least 1) and a button to find the Lego set -->
						<form class="d-flex row">
							<div class="col-auto">
								<label class="text-white mt-2"> Set Number: </label>
							</div>
							<div class="col-auto">
								<input id="set_number" class="form-control col-xs-1" name="set_number" type="number" data-bs-toggle="tooltip" data-bs-placement="top" title="Set Number"/>
							</div>
							<div class="col-auto">
								<label class="text-white mt-2">-</label>
							</div>
							<div class="col-auto">
								<input id="set_variant" class="form-control col-xs-1" name="set_variant" type="number" value="1" min="1" max="99" data-bs-toggle="tooltip" data-bs-placement="top" title="Set Variant Number"/>
							</div>
							<div class="col-auto">
								<button class="btn btn-primary" type="button" onclick="findSet()" data-bs-toggle="tooltip" data-bs-placement="top" title="Find a Lego Set by Entering a Set Number"> <i class="fa fa-search"></i> Find Set </button>
							</div>
						</form>
					</div>
					
					
					<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
						<span class="navbar-toggler-icon"></span>
					</button>
				</div>
			</nav>
			
			<nav class="navbar navbar-expand-md navbar-dark bg-secondary" id="filterBar" style="display: none;">
				<div class="container-fluid">
					<label class="navbar-brand"> <i class="fa fa-filter"></i> Filter: </label>
	
					<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#filterBar" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
						<span class="navbar-toggler-icon"></span>
					</button>
	
					<div class="collapse navbar-collapse" id="filterBar">
						<!-- This creates a form where users can enter details on how they would like to filter the list of Lego sets and a button to display those that match this search -->
						<form class="container-fluid d-flex row">
							<div class="col-auto form-floating">
								<input id="text_search" class="form-control" name="text_search" type="text" placeholder="Search for Lego Set"/>
								<label class="text-secondary" for="text_search"> Search Text </label>
							</div>
							<div class="col-auto mt-2">
								<ul class="navbar-nav">
									<li class="nav-item dropdown">
										<a class="nav-link dropdown-toggle active" id="navbarDropdownMenuLink" role="button" data-toggle="dropdown" aria-expanded="false">
											<i class="fa fa-filter"></i> Filter by Theme
										</a>
										<ul class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
											<li class="dropdown-item form-check">
												<input type="radio" name="themeFilter" id="All">
												<label class="form-check-label" for="All"> All Themes </label>
											</li>
											<li><hr class="dropdown-divider"></li>
											<div style="max-height: 50vh; overflow-y: auto;">
												<!-- This creates a dropdown item using bootstrap, for every Lego theme and displays a radio button and the theme name -->
												<c:forEach items="${themeList}" var="theme">
													<li class="dropdown-item form-check">
														<input type="radio" name="themeFilter" id="${theme.id}">
														<label class="form-check-label" for="${theme.id}"> ${theme.name} </label>
													</li>
												</c:forEach>
											</div>
										</ul>
									</li>
								</ul>
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
								<button class="btn btn-primary mt-3" type="button" onclick="filter()"> <i class="fa fa-filter"></i> Filter </button>
							</div>
						</form>
					</div>
				</div>
			</nav>

			<nav class="navbar navbar-expand-md navbar-dark bg-secondary" id="sortBar" style="display: none;">
				<div class="container-fluid">
					<label class="navbar-brand"> <i class="fa fa-sort"></i> Sort: </label>
	
					<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#sortBar" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
						<span class="navbar-toggler-icon"></span>
					</button>
	
					<div class="collapse navbar-collapse" id="sortBar">
						<!-- This creates a form where users can enter details on how they would like to sort the list of Lego sets and a button to display that sort on the list -->
						<form class="container-fluid d-flex row">
							<div class="col-auto">
								<label class="text-white mt-2"> Sort By: </label>
							</div>
							<div class="col-auto mt-1">
								<select class="form-select" id="sortSelect1" onchange="sortSelectChange()">
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
								<select class="form-select" id="sortSelect2" onchange="sortSelectChange()">
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
								<select class="form-select" id="sortSelect3" onchange="sortSelectChange()" disabled>
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
					</div>
				</div>
			</nav>
		
			<!-- This uses bootstrap to create a container which width will be maximum on screens of any size, with a border -->
			<div class="container-fluid border bg-white">
				<!-- This is the header for all the Lego sets, made using a bootstrap row and columns with column names -->
				<div class="row align-items-center my-3">
					<div class="col">
						<h6>Set Image:</h6>
					</div>
					<div class="col">
						<h6 onclick="numSort()" data-bs-toggle="tooltip" title="Sort by Set Number">Set Number: <i id="numSortIcon" class="fa fa-sort"></i></h6>
					</div>
					<div class="col">
						<h6 onclick="nameSort()" data-bs-toggle="tooltip" title="Sort by Name">Set Name: <i id="nameSortIcon" class="fa fa-sort"></i></h6>
					</div>
					<div class="col">
						<h6 onclick="yearSort()" data-bs-toggle="tooltip" title="Sort by Year">Year Released: <i id="yearSortIcon" class="fa fa-sort"></i></h6>
					</div>
					<div class="col">
						<h6 onclick="themeSort()" data-bs-toggle="tooltip" title="Sort by Theme">Theme: <i id="themeSortIcon" class="fa fa-sort"></i></h6>
					</div>
					<div class="col">
						<h6 onclick="numPiecesSort()" data-bs-toggle="tooltip" title="Sort by Number of Pieces">Number of Pieces: <i id="numPiecesSortIcon" class="fa fa-sort"></i></h6>
					</div>
				</div>
			</div>
		</div>
	    
		<div class="mb-5">
			<!-- This creates a container using bootstrap, for every set in the set list and display the set image, number, name, year, theme and number of pieces -->
			<c:forEach items="${sets}" var="set" varStatus="loop">
				<!-- This uses bootstrap to create a container which width will be maximum on screens of any size, with a border -->
				<div id="set_${loop.index}" class="container-fluid border">
					<!-- This is the header for all the pieces in a Lego set, made using a bootstrap row and columns with piece attributes -->
					<div class="row align-items-center my-3">
						<div class="col">
							<!-- The style width sets the percentage size the image will be on any screen -->
							<img src="${set.img_url}" alt="Image of the Lego Set ${set.name}" style="width: 100%" class="m-2">
						</div>
						<div class="col">
							<a href="/set?set_number=${set.num}">${set.num}</a>
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
					</div>
				</div>
			</c:forEach>
		</div>

		<nav class="navbar navbar-expand-md navbar-dark bg-dark fixed-bottom">
			<div class="container-fluid">
	            <ol class="breadcrumb bg-dark">
	                <li class="breadcrumb-item"><a href="/">Home</a></li>
	                <li class="breadcrumb-item text-white" aria-current="page">Search</li>
	            </ol>
				<div class="mx-2 my-2">
					<button id="previousPageButton" type="button" class="btn btn-primary btn-sm" onclick="previousPage()"> Previous </button>
					<button id="nextPageButton" type="button" class="btn btn-primary btn-sm" onclick="nextPage()"> Next </button>
				</div>
		    </div>
        </nav>
	</body>
	
</html>