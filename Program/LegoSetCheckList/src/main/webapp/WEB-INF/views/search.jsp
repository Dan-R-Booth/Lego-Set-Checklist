<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8" content="text/html; charset=UTF-8">
		
		<!--Bootstrap style sheet, used for page styling, as well as helping to resize page for different screen sizes -->
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css">

		<!-- jQuery library, needed for Bootstrap JavaScript -->
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

		<!-- Bootstrap JavaScript for page styling -->
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
		
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
		
		<script type="text/javascript">
			// This does setup for the page when it is first loaded
			function setup() {
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
				
				// If their is a sort this sets the correct column to the correct sort symbol
				if ("${sort}" == "set_num") {
					document.getElementById("numSortIcon").setAttribute("class","fa fa-sort-numeric-asc");
				}
				else if ("${sort}" == "-set_num") {
					document.getElementById("numSortIcon").setAttribute("class","fa fa-sort-numeric-desc");
				}
				else if ("${sort}" == "name") {
					document.getElementById("nameSortIcon").setAttribute("class","fa fa-sort-alpha-asc");
				}
				else if ("${sort}" == "-name") {
					document.getElementById("nameSortIcon").setAttribute("class","fa fa-sort-alpha-desc");
				}
				else if ("${sort}" == "theme_id") {
					document.getElementById("themeSortIcon").setAttribute("class","fa fa-sort-down");
				}
				else if ("${sort}" == "-theme_id") {
					document.getElementById("themeSortIcon").setAttribute("class","fa fa-sort-up");
				}
				else if ("${sort}" == "year") {
					document.getElementById("yearSortIcon").setAttribute("class","fa fa-sort-numeric-asc");
				}
				else if ("${sort}" == "-year") {
					document.getElementById("yearSortIcon").setAttribute("class","fa fa-sort-numeric-desc");
				}
				else if ("${sort}" == "num_parts") {
					document.getElementById("numPiecesSortIcon").setAttribute("class","fa fa-sort-amount-asc");
				}
				else if ("${sort}" == "-num_parts") {
					document.getElementById("numPiecesSortIcon").setAttribute("class","fa fa-sort-amount-desc");
				}
				
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
			
		</script>
		
	</head>

	<body class="m-2" onload="setup()">
	
		<!-- This uses bootstrap so that everything in this div stays at the top of the page when it's scrolled down -->
		<div class="sticky-top" data-toggle="affix">
		
			<nav class="navbar navbar-expand-md navbar-dark bg-dark">
				<div class="container-fluid">
					<label class="navbar-brand"> Lego: Set Checklist Creator </label>
	
					<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
						<span class="navbar-toggler-icon"></span>
					</button>
	
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
								<input id="set_variant" class="form-control col-xs-1" name="set_variant" type="number" value="1" min="1" max="10" data-bs-toggle="tooltip" data-bs-placement="top" title="Set Variant Number"/>
							</div>
							<div class="col-auto">
								<button class="btn btn-primary" type="button" onclick="findSet()" data-bs-toggle="tooltip" data-bs-placement="top" title="Find a Lego Set by Entering a Set Number"> <i class="fa fa-search"></i> Find Set </button>
							</div>
						</form>
					</div>
				</div>
			</nav>
			
			<nav class="navbar navbar-expand-md navbar-dark bg-secondary">
				<div class="container-fluid">
					<label class="navbar-brand"> <i class="fa fa-filter"></i> Filter: </label>
	
					<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#filterBar" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
						<span class="navbar-toggler-icon"></span>
					</button>
	
					<div class="collapse navbar-collapse" id="filterBar">
						<!-- This creates a text box where users can enter text to search and a button to display the Lego sets that match this search -->
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
												<label class="form-check-label" for="0"> All Themes </label>
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
		
			<!-- This uses bootstrap to create a container which width will be maximum on screens of any size, with a border -->
			<div class="container-fluid border  bg-white">
				<!-- This is the header for all the Lego sets, made using a bootstrap row and columns with column names -->
				<div class="row align-items-center my-3">
					<div class="col">
						<p class="h6">Set Image:</p>
					</div>
					<div class="col">
						<p class="h6" onclick="numSort()" data-bs-toggle="tooltip" title="Sort by Set Number">Set Number: <i id="numSortIcon" class="fa fa-sort"></i></p>
					</div>
					<div class="col">
						<p class="h6" onclick="nameSort()" data-bs-toggle="tooltip" title="Sort by Name">Set Name: <i id="nameSortIcon" class="fa fa-sort"></i></p>
					</div>
					<div class="col">
						<p class="h6" onclick="yearSort()" data-bs-toggle="tooltip" title="Sort by Year">Year Released: <i id="yearSortIcon" class="fa fa-sort"></i></p>
					</div>
					<div class="col">
						<p class="h6" onclick="themeSort()" data-bs-toggle="tooltip" title="Sort by Theme">Theme: <i id="themeSortIcon" class="fa fa-sort"></i></p>
					</div>
					<div class="col">
						<p class="h6" onclick="numPiecesSort()" data-bs-toggle="tooltip" title="Sort by Number of Pieces">Number of Pieces: <i id="numPiecesSortIcon" class="fa fa-sort"></i></p>
					</div>
				</div>
			</div>
		</div>
	    
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

		<button id="previousPageButton" type="button" class="btn btn-primary btn-sm" onclick="previousPage()"> Previous </button>
		<button id="nextPageButton" type="button" class="btn btn-primary btn-sm" onclick="nextPage()"> Next </button>
	</body>
	
</html>