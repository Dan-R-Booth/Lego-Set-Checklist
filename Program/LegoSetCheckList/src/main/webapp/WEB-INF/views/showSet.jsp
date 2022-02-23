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
		<title>Lego: Set Checklist Creator - Set: ${set.num} - ${set.name}</title>

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

			// This resizes the page so it fits different screen and window sizes
			function resize() {
				var width = $(window).width();

				// This removes the columns and puts all the content in one line if the screen size is below a certain width
				if (width <= 815) {
					document.getElementById("imageDiv").setAttribute("class", "m-3");
					document.getElementById("textDiv").setAttribute("class", "m-3");
				}
				else if (width > 815) {
					document.getElementById("imageDiv").setAttribute("class", "col-6 m-3");
					document.getElementById("textDiv").setAttribute("class", "col-5 m-3");
				}

				// This sets a minimum size the page will adpat to until it will just zoom out,
				// as going any smaller would affect elements in the page
				if (width < 350) {
					document.getElementById("viewport").setAttribute("content","width=350");
				}
			}

			// This resizes the page when the screen or window size is changed
			window.onresize = function() {
				resize();
			}

			// This does setup for the page when it is first loaded
			function setup() {
				// This sets the page to the correct size when the page is first loaded
				resize();

				var set_num = "${set.num}";
				
				const set_numArray = set_num.split("-");
				
				document.getElementById("set_number").value = set_numArray[0];
				document.getElementById("set_variant").value = set_numArray[1];
			}
		
			// This will take the users to the set page for the Lego Set that matches the entered set number and variant
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

			// This function will return the user to the search page with the same filters and sorts they last had active
			// and if they haven't been to the search page, to the default unfilter and sorted page
			function backToSearch() {
				if ("${searchURL}" != "") {
					window.location = "${searchURL}";
				}
				else {
					window.location = "/search/text=/barOpen=/sort=/minYear=/maxYear=/minPieces=/maxPieces=/theme_id=/uri/";
				}
			}
			
		</script>
	</head>
	
	<body onload="setup()">
		<!-- This uses bootstrap so that everything in this div stays at the top of the page when it's scrolled down -->
		<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
			<div class="container-fluid">
				<a class="navbar-brand" href="/"> Lego: Set Checklist Creator </a>

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
							<input id="set_variant" class="form-control col-xs-1" name="set_variant" type="number" value="1" min="1" max="99" data-bs-toggle="tooltip" data-bs-placement="top" title="Set Variant Number"/>
						</div>
						<div class="col-auto">
							<button class="btn btn-primary" type="button" onclick="findSet()" data-bs-toggle="tooltip" data-bs-placement="top" title="Find a Lego Set by Entering a Set Number"> <i class="fa fa-search"></i> Find Set </button>
						</div>
					</form>
				</div>
			</div>
		</nav>
	
		<div class="container-fluid row mb-5">
			<div id="imageDiv" class="col-6 m-3">
				<!-- The style width sets the percentage size the image will be on any screen -->
				<!-- When clicked this will display a Model with the image enlarged within -->
				<img src="${set.img_url}" alt="Image of the Lego Set: ${set.name}" style="width: 80%" class="row img-fluid img-thumbnail rounded" data-bs-toggle="modal" data-bs-target="#setModal">

				<!-- Lego Set Modal Image Viewer -->
				<div class="modal fade" id="setModal" tabindex="-1" aria-labelledby="setModalLabel" aria-hidden="true">
					<div class="modal-dialog modal-dialog-centered">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title" id="setModalLabel">Lego Set: ${set.name}</h5>
								<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
							</div>
							<div class="modal-body">
								<img src="${set.img_url}" alt="Image of the Lego Set: ${set.name}" style="width: 100%">
							</div>
						</div>
					</div>
				</div>

				<button class="row btn btn-outline-secondary btn-dark text-white" type="button" onclick="backToSearch()" style="width: 80%;"> BACK TO SEARCH </button>
			</div>
			<div id="textDiv" class="col-5 m-3">
				<h1>${set.name}</h1>
				<h3>${set.num}</h3>
				<br>
				<h4>
					<dl class="row">
						<dt class="col-sm-6">Year Released:</dt>
						<dd class="col-sm-5">${set.year}</dd>
						<hr>
						<dt class="col-sm-6">Theme:</dt>
						<dd class="col-sm-5">${set.theme}</dd>
						<hr>
						<dt class="col-sm-6">Number of pieces:</dt>
						<dd class="col-sm-5">${set.num_pieces}</dd>
					</dl>
					<br>
					<a href="/set/${set.num}/pieces">View Piece Checklist</a>
				</h4>
				<br>
				<br>
				<h3>Lego Set Instructions:</h3>
				<h4>
					<!-- This displays all instruction booklets for the Lego Set in Bootstrap list group, that when clicked on opens the instruction book in a new tab -->
					<div class="list-group">
						<c:forEach items="${instructions}" var="instructionBook">
							<a href="${instructionBook[0]}" target="_blank" class="list-group-item list-group-item-action">${instructionBook[1]}</a>
						</c:forEach>
					</div>
				</h4>
			</div>
			
		</div>
		
		<nav class="navbar navbar-expand-md navbar-dark bg-dark fixed-bottom">
			<div class="container-fluid">
	            <ol class="breadcrumb bg-dark">
	                <li class="breadcrumb-item"><a href="/">Home</a></li>
	                <li class="breadcrumb-item"><a href="#" onclick="backToSearch()">Search</a></li>
	                <li class="breadcrumb-item text-white" aria-current="page">Set</li>
	            </ol>
		    </div>
		</nav>
	</body>
</html>