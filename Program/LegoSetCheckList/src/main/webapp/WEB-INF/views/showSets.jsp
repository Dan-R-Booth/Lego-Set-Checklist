<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8" content="text/html; charset=UTF-8">
		
		<!--Bootstrap style sheet, used for page styling, as well as helping to resize page for different screen sizes -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
		
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
		
		<script type="text/javascript">
			// This does setup for the page when it is first loaded
			function setup() {
				var previous = "${previousPage}";
				var next = "${nextPage}";
				
				if (previous == "") {	
					document.getElementById("previousPageButton").disabled = true;
				}
				
				if (next == "") {
					document.getElementById("previousPageButton").disabled = true;
				}
			}
			
			function previousPage() {
				var previous = "${previousPage}";
				
				window.location = "/sets/page/" + previous;
			}
			
			function nextPage() {
				var next = "${nextPage}";
				
				window.location = "/sets/page/" + next;
			}
			
		</script>
		
	</head>

	<body class="m-2" onload="setup()">
	
		<!-- This uses bootstrap so that everything in this div stays at the top of the page when it's scrolled down -->
		<div class="sticky-top" data-toggle="affix">
		<!--
			<nav class="navbar navbar-expand-md navbar-dark bg-dark">
				<div class="container">
					<label class="navbar-brand mr-5 pr-5">Lego: Set Checklist Creator</label>
	
					<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
						<span class="navbar-toggler-icon"></span>
					</button>
	
					<div class="collapse navbar-collapse" id="navbar">
						<ul class="navbar-nav">
							<li class="nav-item mx-5">
								<a class="nav-link" onclick="saveProgress()"> <i class="fa fa-save"></i> Save CheckList</a>
							</li>
							<li class="nav-item mx-5">
								<a class="nav-link" onclick="exportList()"> <i class="fa fa-download"></i> Export</a>
							</li>
						</ul>
					</div>
				</div>
			</nav>
		-->
			<!-- This uses bootstrap to create a container which width will be maximum on screens of any size, with a border -->
			<div class="container-fluid border  bg-white">
				<!-- This is the header for all the Lego sets, made using a bootstrap row and columns with column names -->
				<div class="row align-items-center my-3">
					<div class="col">
						<p class="h6">Set Image:</p>
					</div>
					<div class="col">
						<p class="h6">Set Number:</p>
					</div>
					<div class="col">
						<p class="h6">Set Name:</p>
					</div>
					<div class="col">
						<p class="h6">Year Released:</p>
					</div>
					<div class="col">
						<p class="h6">Theme:</p>
					</div>
					<div class="col">
						<p class="h6">Number of pieces:</p>
					</div>
				</div>
			</div>
		</div>
	    
		<!-- This creates a container using bootstrap, for every set in the pieces list and display the piece image, number, name, colour, quantity and the quantity found -->
		<c:forEach items="${sets}" var="set" varStatus="loop">
			<!-- This uses bootstrap to create a container which width will be maximum on screens of any size, with a border -->
			<div id="piece_${loop.index}" class="container-fluid border">
				<!-- This is the header for all the pieces in a Lego set, made using a bootstrap row and columns with piece attributes -->
				<div class="row align-items-center my-3">
				    <div class="col">
				        <!-- The style width sets the percentage size the image will be on any screen -->
						<img src="${set.img_url}" alt="Image of the Lego Set ${set.name}" style="width: 100%" class="m-2">
				    </div>
				    <div class="col">
				    	${set.num}
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