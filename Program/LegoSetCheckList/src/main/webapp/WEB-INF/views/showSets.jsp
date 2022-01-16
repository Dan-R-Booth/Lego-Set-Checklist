<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8" content="text/html; charset=UTF-8">
		
		<!--Bootstrap style sheet, used for page styling, as well as helping to resize page for different screen sizes -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

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
				if ("${sort}" == "theme_id") {
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
				
				// These add the current min year and max year filters to their number boxes
				document.getElementById("minYearBox").value = "${minYear}";
				document.getElementById("maxYearBox").value = "${maxYear}";
			}
			
			// The following two functions call the api with the either the previous or next page uri
			function previousPage() {
				var previous = "${previousPage}";
				
				window.location = "/sets/page/text=${searchText}/sort=${sort}/minYear=${minYear}/maxYear=${maxYear}/theme_id=${theme_id}/uri/" + previous;
			}
			
			function nextPage() {
				var next = "${nextPage}";
				
				window.location = "/sets/page/text=${searchText}/sort=${sort}/minYear=${minYear}/maxYear=${maxYear}/theme_id=${theme_id}/uri/" + next;
			}
			
			// This checks if text has been inputted to the search box, and if it has then sends this text to a controller
			// if not it will display an error to the user
			function textSearch() {
				var text = document.getElementById("text_search").value;
				
				if (text == "") {
					document.getElementById("text_search").setAttribute("class", "form-control mr-sm-2 is-invalid");
					document.getElementById("text_search").setAttribute("data-bs-toggle","tooltip");
					document.getElementById("text_search").setAttribute("title","Cannot be Empty");
					document.getElementById("text_searchEmptyHelp").setAttribute("class", "alert alert-danger");
				}
				else {					
					window.location = "/sets/page/text=" + text + "/sort=${sort}/minYear=${minYear}/maxYear=${maxYear}/theme_id=${theme_id}/uri/";
				}
			}
			
			// This calls the the controller setting the sort parametre as year
			function yearSort() {
				var iconClass = document.getElementById("yearSortIcon").className;
				
				if (iconClass == "fa fa-sort" || iconClass == "fa fa-sort-numeric-desc") {
					window.location = "/sets/page/text=${searchText}/sort=year/minYear=${minYear}/maxYear=${maxYear}/theme_id=${theme_id}/uri/";
				}
				else if (iconClass == "fa fa-sort-numeric-asc") {
					window.location = "/sets/page/text=${searchText}/sort=-year/minYear=${minYear}/maxYear=${maxYear}/theme_id=${theme_id}/uri/";
				}
			}
			
			// This calls the the controller setting the sort parametre as theme_id
			function themeSort() {
				var iconClass = document.getElementById("themeSortIcon").className;
				
				if (iconClass == "fa fa-sort" || iconClass == "fa fa-sort-up") {
					window.location = "/sets/page/text=${searchText}/sort=theme_id/minYear=${minYear}/maxYear=${maxYear}/theme_id=${theme_id}/uri/";
				}
				else if (iconClass == "fa fa-sort-down") {
					window.location = "/sets/page/text=${searchText}/sort=-theme_id/minYear=${minYear}/maxYear=${maxYear}/theme_id=${theme_id}/uri/";
				}
			}
			
			// This calls the controller with all the filters that the user wants to apply to the list
			function filter() {
				var minYear = document.getElementById("minYearBox").value;
				var maxYear = document.getElementById("maxYearBox").value;
				
				var themeFilter = document.querySelector('input[name="themeFilter"]:checked');
				var theme_id = "";
				if (themeFilter.value != "All") {
					theme_id = themeFilter.value;
				}
				
				window.location = "/sets/page/text=${searchText}/sort=${sort}/minYear=" + minYear + "/maxYear=" + maxYear + "/theme_id=" + theme_id + "/uri/";
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
						
					</div>
				</div>
			</nav>
			<nav class="navbar navbar-expand-md navbar-dark bg-secondary">
				<div class="container-fluid">
					<label class="navbar-brand"> <i class="fa fa-filter"></i> Filter: </label>
	
					<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
						<span class="navbar-toggler-icon"></span>
					</button>
	
					<div class="collapse navbar-collapse" id="navbar">
						<!-- This creates a text box where users can enter text to search and a button to display the Lego sets that match this search -->
						<form class="container-fluid">
							<div>
								<label class="text-white" for="text_search"> Text: </label>
								<input id="text_search" class="form-control mr-sm-2" name="text_search" type="text" placeholder="Search for Lego Set"/>
							</div>
							<ul class="navbar-nav">
								<li class="nav-item dropdown">
									<a class="nav-link dropdown-toggle active" id="navbarDropdownMenuLink" role="button" data-toggle="dropdown" aria-expanded="false">
										<i class="fa fa-filter"></i> Filter by Theme
									</a>
									<ul class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
										<li class="dropdown-item form-check">
											<input type="radio" name="themeFilter" id="All" checked>
											<label class="form-check-label" for="0"> All Themes </label>
										</li>
										<li><hr class="dropdown-divider"></li>
										<div style="max-height: 50vh; overflow-y: auto;">
											<!-- This creates a dropdown item using bootstrap, for every Lego theme and displays a radio button and the theme name -->
											<c:forEach items="${themeList}" var="theme" varStatus="themeLoop">
												<li class="dropdown-item form-check">
													<input type="radio" name="themeFilter" id="${themeLoop.index}" value="${theme.id}">
													<label class="form-check-label" for="${themeLoop.index}"> ${theme.name} </label>
												</li>
											</c:forEach>
										</div>
									</ul>
								</li>
							</ul>
							<div>
								<label class="text-white" for="minYearBox">	Minimum Year: </label>
								<input id="minYearBox" class="form-control mr-sm-2" name="minYearBox" type="number" min=0 max="9999"/>
							</div>
							<div>
								<label class="text-white" for="maxYearBox">	Maximum Year: </label>
								<input id="maxYearBox" class="form-control mr-sm-2" name="maxYearBox" type="number" min=0 max="9999"/>
							</div>
							<div>
								<label class="text-white" for="minPieceBox"> Minimum Number of Pieces: </label>
								<input id="minPieceBox" class="form-control mr-sm-2" name="minPieceBox" type="number" min=0 max="9999"/>
							</div>
							<div>
								<label class="text-white" for="maxPieceBox">	Maximum Number of Pieces: </label>
								<input id="maxPieceBox" class="form-control mr-sm-2" name="maxPieceBox" type="number" min=0 max="9999"/>
							</div>
							<button class="btn btn-primary" type="button" onclick="filter()"> <i class="fa fa-filter"></i> Filter </button>
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
						<p class="h6">Set Number: <i class="fa fa-sort"></i></p>
					</div>
					<div class="col">
						<p class="h6">Set Name: <i class="fa fa-sort"></i></p>
					</div>
					<div class="col">
						<p class="h6" onclick="yearSort()" data-bs-toggle="tooltip" title="Sort by Year">Year Released: <i id="yearSortIcon" class="fa fa-sort"></i></p>
					</div>
					<div class="col">
						<p class="h6" onclick="themeSort()" data-bs-toggle="tooltip" title="Sort by Theme">Theme: <i id="themeSortIcon" class="fa fa-sort"></i></p>
					</div>
					<div class="col">
						<p class="h6">Number of pieces: <i class="fa fa-sort"></i></p>
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