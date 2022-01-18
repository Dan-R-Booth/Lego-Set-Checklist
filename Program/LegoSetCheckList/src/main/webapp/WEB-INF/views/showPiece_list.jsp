<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8" content="text/html; charset=UTF-8">
		
		<!--Bootstrap style sheet, used for page styling, as well as helping to resize page for different screen sizes -->
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css">
		
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
		
		<script type="text/javascript">
		
			// This does setup for the page when it is first loaded
			function setup() {
				const num_items = "${num_items}";
				
				// This sets the quantity checked buttons for each piece to be disabled if can't decresse quantity further or increased any further
				var element = "piece_quantity_checked_";
				for (let id = 0; id < num_items; id++) {
					var quantity = document.getElementById("piece_quantity_checked_" + id).max;
					var quantityChecked = document.getElementById("piece_quantity_checked_" + id).value;
					if (quantityChecked == 0) {
						document.getElementById("decreaseQuantityCheckedButton_" + id).disabled = true;
						document.getElementById("increaseQuantityCheckedButton_" + id).disabled = false;
					}
					else if (quantityChecked == quantity) {
						document.getElementById("decreaseQuantityCheckedButton_" + id).disabled = false;
						document.getElementById("increaseQuantityCheckedButton_" + id).disabled = true;
					}
				}
				
				piecesFound();
				
				// If their is a sort this sets the correct column to the correct sort symbol
				if ("${sort}" == "colour") {
					document.getElementById("colourSortIcon").setAttribute("class","fa fa-sort-alpha-asc");
				}
				else if ("${sort}" == "-colour") {
					document.getElementById("colourSortIcon").setAttribute("class","fa fa-sort-alpha-desc");
				}
			}
			
			// This decreases the quantity of a piece found
			function decreaseQuantityChecked(id) {
				var quantityChecked = document.getElementById("piece_quantity_checked_" + id).value;
				quantityChecked --;
					
				 if (quantityChecked == 0) {
					document.getElementById("decreaseQuantityCheckedButton_" + id).disabled = true;
				 }
				 document.getElementById("increaseQuantityCheckedButton_" + id).disabled = false;
				 
				 document.getElementById("piece_quantity_checked_" + id).value = quantityChecked;
				 
				 piecesFound();
			}
		
			// This increases the quantity of a piece found
			function increaseQuantityChecked(id) {
				var quantity = document.getElementById("piece_quantity_checked_" + id).max;
				var quantityChecked = document.getElementById("piece_quantity_checked_" + id).value;
				quantityChecked ++;
				
				 document.getElementById("decreaseQuantityCheckedButton_" + id).disabled = false;
				 if (quantityChecked == quantity) {
					document.getElementById("increaseQuantityCheckedButton_" + id).disabled = true;
				 }
				 
				 document.getElementById("piece_quantity_checked_" + id).value = quantityChecked;
				 
				 piecesFound();
			}
		
			// This calculates add displays the total quanity of a piece found
			function piecesFound() {
				var total = 0;
				const num_items = "${num_items}";
				
				var element = "piece_quantity_checked_";
				for (let id = 0; id < num_items; id++) {
					var quantity = document.getElementById("piece_quantity_checked_" + id).max;
					var quantityChecked = document.getElementById("piece_quantity_checked_" + id).value;
					
					if (quantityChecked == quantity) {
						total += 1;
					}
				}
				
				document.getElementById("piecesFound").innerText = total;
			}
			
			// This hides spare pieces any pieces that are classed as spare pieces for the Lego set and are therefore not needed to build the set
		    // And hides from the total number of pieces needed
			function sparePiece(loopIndex) {
				document.getElementById("piece_" + loopIndex).style.display = "none";
				var piecesNeededTotal = document.getElementById("piecesNeededTotal").innerText;
				piecesNeededTotal --;
				document.getElementById("piecesNeededTotal").innerText = piecesNeededTotal;
			}
			
			// This gets the total quantity of all pieces checked (only counting pieces where the total quantity has been found)
			function getQuantityChecked() {
				const array = [];
				
				var element = "piece_quantity_checked_";
				for (let id = 0; id < "${num_items}"; id++) {
					var quantityChecked = document.getElementById("piece_quantity_checked_" + id).value;
					array[id] = quantityChecked;
				}
				
				return array;
			}
			
			// This saves all the changes to Piece quantity found to the class
			function saveProgress() {
				var array = getQuantityChecked();
				
				window.location = "/set/${set.num}/pieces/save/?quantityChecked=" + array;
			}
			
			// This calls a controller to export the checklist as a csv file
			function exportList() {
				var array = getQuantityChecked();
				
				window.location = "/set/${set.num}/pieces/export/?quantityChecked=" + array;
			}
			
			// This calls the the controller setting the sort parameter as colourName
			function colourSort() {
				var array = getQuantityChecked();
				var iconClass = document.getElementById("colourSortIcon").className;
				
				if (iconClass == "fa fa-sort" || iconClass == "fa fa-sort-alpha-desc") {
					window.location = "/set/${set_number}/pieces/?sort=colour";
				}
				else if (iconClass == "fa fa-sort-alpha-asc") {
					window.location = "/set/${set_number}/pieces/?sort=-colour";
				}
			}
		</script>
		
	</head>

	<body class="m-2" onload="setup()">
	
		<!-- This uses bootstrap so that everything in this div stays at the top of the page when it's scrolled down -->
		<div class="sticky-top" data-toggle="affix">
		
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

			<!-- This uses bootstrap to create a container which width will be maximum on screens of any size, with a border -->
			<div class="container-fluid border  bg-white">
				<!-- This is the header for all the pieces in a Lego set, made using a bootstrap row and columns with column names -->
				<div class="row align-items-center my-1 ">
					<div class="col">
						<!-- The style width sets the percentage size the image will be on any screen -->
						<img src="${set.img_url}" alt="Image of the Lego Set: ${set.name}" style="width: 50%" class="m-2">
					</div>
					<div class="col">
						<p class="h4">${set.name}</p>
						<p class="h5">${set.num}</p>
					</div>
					<div class="col">
						<p class="h5">Pieces Found: <label id="piecesFound">0</label> / <label id="piecesNeededTotal">${num_items}</label></p>
					</div>
				</div>
			</div>
		
			<!-- This uses bootstrap to create a container which width will be maximum on screens of any size, with a border -->
			<div class="container-fluid border  bg-white">
				<!-- This is the header for all the pieces in a Lego set, made using a bootstrap row and columns with column names -->
				<div class="row align-items-center my-3">
					<div class="col">
						<p class="h6">Piece Image:</p>
					</div>
					<div class="col">
						<p class="h6">Piece Number:</p>
					</div>
					<div class="col">
						<p class="h6">Piece Name:</p>
					</div>
					<div class="col">
						<p class="h6" onclick="colourSort()" data-bs-toggle="tooltip" title="Sort by Theme">Piece Colour: <i id="colourSortIcon" class="fa fa-sort"></i></p>
					</div>
					<div class="col">
						<p class="h6">Piece Category Type:</p>
					</div>
					<div class="col">
						<p class="h6">Quantity:</p>
					</div>
					<div class="col">
						<p class="h6">Quantity Found:</p>
					</div>
				</div>
			</div>
		</div>
	    
		<!-- This creates a container using bootstrap, for every set in the pieces list and display the piece image, number, name, colour, quantity and the quantity found -->
		<c:forEach items="${set.piece_list}" var="piece" varStatus="loop">
			<!-- This uses bootstrap to create a container which width will be maximum on screens of any size, with a border -->
			<div id="piece_${loop.index}" class="container-fluid border">
				<!-- This is the header for all the pieces in a Lego set, made using a bootstrap row and columns with piece attributes -->
				<div class="row align-items-center my-3">
				    <div class="col">
				        <!-- The style width sets the percentage size the image will be on any screen -->
						<img src="${piece.img_url}" alt="Image of the Lego Piece: ${piece.name}" style="width: 40%" class="m-2">
				    </div>
				    <div class="col">
				    	${piece.num}
				    </div>
				    <div class="col">
				     	${piece.name}
				    </div>
				    <div class="col">
				    	${piece.colour_name}
				    </div>
				    <div class="col">
				    	${piece.pieceCategory}
				    </div>
				    <div class="col">
				       ${piece.quantity}
				    </div>
				    <div class="col">
				    	<button id="decreaseQuantityCheckedButton_${loop.index}" name="${loop.index}" type="button" class="btn btn-primary btn-sm" onclick="decreaseQuantityChecked(this.name)"> <i class="fa fa-minus"></i></button>
						<!-- Displays the quantity found and is disabled so the value can only be changed by the buttons -->
					    <input id="piece_quantity_checked_${loop.index}" type="number" value="${piece.quantity_checked}" min=0 max="${piece.quantity}" disabled />
				    	<button id="increaseQuantityCheckedButton_${loop.index}" name="${loop.index}" type="button" class="btn btn-primary btn-sm" onclick="increaseQuantityChecked(this.name)"> <i class="fa fa-plus"></i></button>
				    </div>
				</div>
		    </div>
			<!-- This calls a JavaSript function hides spare pieces -->
			<c:if test="${piece.spare eq true}">
				<script type="text/javascript">
					sparePiece(${loop.index});
				</script>
			</c:if>
		</c:forEach>
		
		<div class="my-5">
			<button type="button" id="save" onclick="saveProgress()" class="btn btn-primary"> <i class="fa fa-save"></i> Save CheckList</button>
			<button type="button" id="export" onclick="exportList()" class="btn btn-secondary"> <i class="fa fa-download"></i> Export</button>
        </div>

	</body>
	
</html>