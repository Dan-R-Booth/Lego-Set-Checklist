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

			// Global boolean used to show if the list is displaying by spares or not
			var showSpares = false;
		
			// This is a global array used to store the dvi id of all pieces that are spares so they can be identified when filtering a list
			var sparePieceList = [];
		
			// This does setup for the page when it is first loaded
			function setup() {

				// This sets the quantity checked buttons for each piece to be disabled if can't decresse quantity further or increased any further
				var element = "piece_quantity_checked_";
				for (let id = 0; id < "${num_items}"; id++) {
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
				else if ("${sort}" == "type") {
					document.getElementById("typeSortIcon").setAttribute("class","fa fa-sort-alpha-asc");
				}
				else if ("${sort}" == "-type") {
					document.getElementById("typeSortIcon").setAttribute("class","fa fa-sort-alpha-desc");
				}

				// This sets the theme filter to none if no colours are being shown, displaying no pieces
				// Or displays the pieces in the list that match the colour it is being filtered by
				if ("${colourFilter}" == "none") {
					var colourCheckboxes = document.getElementsByName("colourFilter");
					
					for (let i = 0; i < colourCheckboxes.length; i++) {
	                    	colourCheckboxes[i].checked = false;
					}
					
					for (let id = 0; id < "${num_items}"; id++) {
						document.getElementById("piece_" + id).style.display = "none";
					}
				}
				// The following is used to set the current colour filter applied to the list if the page is reloaded
				else {
					// If not all colours are being filtered this will run, checking the checkboxes of those colours filtered,
					// and display those colours that match this.
					if ("${colourFilter}" != "All_Colours") {
						var coloursFiltered = [];
		
						// This checks every checkbox colour that the list is being filtered by
						<c:forEach items="${colourFilter}" var="colourName">
							for (let i = 0; i < "${num_items}"; i++) {
								document.getElementById("${colourName}").checked = true;
								coloursFiltered.push("${colourName}");
							}
						</c:forEach>
						
						for (let id = 0; id < "${num_items}"; id++) {
							
							// This hides or shows all pieces as long as they are not a spare piece and therefore stored in the list of spare pieces
							if (sparePieceList.indexOf(id) <= -1) {
								var pieceColour = document.getElementById("colour_" + id).innerHTML;
								
								if (coloursFiltered.indexOf(pieceColour) > -1) {
									document.getElementById("piece_" + id).style.display = "block";
								}
								else {
									document.getElementById("piece_" + id).style.display = "none";
								}
							}
						}
					}
					// If the list is to be filtered by all colours this will check all the colour checkboxes
					// and display all the pieces in the set
					else {
						document.getElementById("All_Colours").checked = true;
						
						var colourCheckboxes = document.getElementsByName("colourFilter");
						
						for (let i = 0; i < colourCheckboxes.length; i++) {
		                    	colourCheckboxes[i].checked = true;
						}
						
						for (let id = 0; id < "${num_items}"; id++) {
							// This shows all pieces as long as they are not a spare piece and therefore stored in the list of spare pieces
							if (sparePieceList.indexOf(id) <= -1) {
								document.getElementById("piece_" + id).style.display = "block";
							}
						}
					}
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
				
				var element = "piece_quantity_checked_";
				for (let id = 0; id < "${num_items}"; id++) {
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
				// This adds the id of spare pieces to a list so that they can be identifed in other functions
				sparePieceList.push(loopIndex);
				
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
				
				var colourFilter = getColourFilter();
				
				var sort = "";
				
				if ("${sort}" != "") {
					sort = "sort=${sort}&"
				}
				
				window.location = "/set/${set.num}/pieces/?" + sort + "quantityChecked=" + array + colourFilter;
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
					var colourFilter = getColourFilter();
					
					window.location = "/set/${set_number}/pieces/?sort=colour&quantityChecked=" + array + colourFilter;
				}
				else if (iconClass == "fa fa-sort-alpha-asc") {
					var colourFilter = getColourFilter();
					
					window.location = "/set/${set_number}/pieces/?sort=-colour&quantityChecked=" + array + colourFilter;
				}
			}
			
			// This calls the the controller setting the sort parameter as pieceCategory alphabetically
			function typeSort() {
				var array = getQuantityChecked();
				var iconClass = document.getElementById("typeSortIcon").className;
				
				if (iconClass == "fa fa-sort" || iconClass == "fa fa-sort-alpha-desc") {
					var colourFilter = getColourFilter();
					
					window.location = "/set/${set_number}/pieces/?sort=type&quantityChecked=" + array + colourFilter;
				}
				else if (iconClass == "fa fa-sort-alpha-asc") {
					var colourFilter = getColourFilter();
					
					window.location = "/set/${set_number}/pieces/?sort=-type&quantityChecked=" + array + colourFilter;
				}
			}
			
			// This filters the list by colours the user would like to view
			function filterByColour(boxClicked) {
                
				// This goes through all the colour checkboxes and adds those checkbox ids of ones that are checked to a list
				// that is then used to know which colours to filter the list by
                var colourCheckboxes = document.getElementsByName("colourFilter");
                var coloursFiltered = [];
                for (let i = 0; i < colourCheckboxes.length; i++) {
					if (colourCheckboxes[i].checked) {
						coloursFiltered.push(colourCheckboxes[i].id);
                   }
                }
                
                // This checks if the All Colours checkbox has been checked
                if (boxClicked.id != "All_Colours") {
                	// This runs if all the colours are checked and All Colours is not, and it checks All Colours and displays all pieces
                	if (colourCheckboxes.length == coloursFiltered.length) {
    					document.getElementById("All_Colours").checked = true;
    					
    					for (let id = 0; id < "${num_items}"; id++) {
    						document.getElementById("piece_" + id).style.display = "block";
    					}
    				}
                	// This runs displaying only the pieces that match the colours selected, and unchecks the All Colours checkbox
                	else {
						document.getElementById("All_Colours").checked = false;
						
						for (let id = 0; id < "${num_items}"; id++) {
							// This hides or shows all pieces as long as they are not a spare piece and therefore stored in the list of spare pieces
							if (sparePieceList.indexOf(id) <= -1) {
							
								var pieceColour = document.getElementById("colour_" + id).innerHTML;
								
								if (coloursFiltered.indexOf(pieceColour) > -1) {
									document.getElementById("piece_" + id).style.display = "block";
								}
								else {
									document.getElementById("piece_" + id).style.display = "none";
								}
							}
						}
                	}
				}
                // This runs if the All Colours checkbox has been clicked
				else {
					// This goes through all the colour checkboxes and checks or unchecks them all, depending on if the All Colours checkbox is checked or not
	                for (let i = 0; i < colourCheckboxes.length; i++) {
	                	if (document.getElementById("All_Colours").checked == true) {
	                    	colourCheckboxes[i].checked = true;
	                    	
	                    	display = "block";
	                	}
	                	else {
	                    	colourCheckboxes[i].checked = false;
	                    	
	                    	var display = "none";
	                	}
	                }
					
		            // This either displays or hides all the pieces, depending on if the All Colours checkbox is checked or not
					for (let id = 0; id < "${num_items}"; id++) {
		             	// This hides or shows all pieces as long as they are not a spare piece and therefore stored in the list of spare pieces
						if (sparePieceList.indexOf(id) <= -1) {
							document.getElementById("piece_" + id).style.display = display;
						}
					}
				}
			}
			
			// This returns a colour filter if there is one currently active, this is used when getting this information
			// to return to the controller
			function getColourFilter() {
				var colourFilter = "";
				
				if (document.getElementById("All_Colours").checked == false) {
					colourFilter = "&colourFilter=";
					
	                // This goes through all the colour checkboxes and adds those checkbox ids of ones that are checked to a list
	                // if it has no length the colourFilter string is set to equal none. Overwise the values are then added to the
	                // colourFilter string This string is to be sent to the controller so that the filters are not forgot when the
	                // page is reloaded
	                var colourCheckboxes = document.getElementsByName("colourFilter");
	                var coloursFiltered = [];
	                for (let i = 0; i < colourCheckboxes.length; i++) {
						if (colourCheckboxes[i].checked) {
							coloursFiltered.push(colourCheckboxes[i].id);
	                   }
	                }
	                
	                if (coloursFiltered.length == 0) {
	                	colourFilter += "none";
	                }
	                else {
	                	for (let i = 0; i < coloursFiltered.length; i++) {
                			colourFilter += coloursFiltered[i] + ",";
		                }
	                }
				}
				
				return colourFilter;
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
			
			<nav class="navbar navbar-expand-md navbar-dark bg-secondary" id="filterNavBar" style="display: block;">
				<div class="container-fluid">
					<label class="navbar-brand"> <i class="fa fa-filter"></i> Filter: </label>
	
					<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#filterBar" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
						<span class="navbar-toggler-icon"></span>
					</button>
	
					<div class="collapse navbar-collapse" id="filterBar">
						<!-- This creates a dropdown where users can enter details on how they would like to filter the list of pieces -->
						<div class="col-auto">
							<ul class="navbar-nav">
								<li class="nav-item dropdown">
									<a class="nav-link dropdown-toggle active" id="navbarDropdownMenuLink" role="button" data-toggle="dropdown" aria-expanded="false">
										<i class="fa fa-filter"></i> Filter by Piece Colours
									</a>
									<ul class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
										<li class="dropdown-item form-check">
											<input type="checkbox" name="colourFilterAll" id="All_Colours" onclick="filterByColour(this)">
											<label class="form-check-label" for="All_Colours"> All Colours </label>
										</li>
										<li><hr class="dropdown-divider"></li>
										<div style="max-height: 50vh; overflow-y: auto;">
											<!-- This creates a dropdown item using bootstrap, for every piece colour and displays a check box and the colour name -->
											<c:forEach items="${colours}" var="colour">
												<li class="dropdown-item form-check">
													<input type="checkbox" name="colourFilter" id="${colour}" onclick="filterByColour(this)">
													<label class="form-check-label" for="${colour}"> ${colour} </label>
												</li>
											</c:forEach>
										</div>
									</ul>
								</li>
								<li class="nav-item dropdown">
									<a class="nav-link dropdown-toggle active" id="navbarDropdownMenuLink" role="button" data-toggle="dropdown" aria-expanded="false">
										<i class="fa fa-filter"></i> Filter by Piece Types
									</a>
									<ul class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
										<li class="dropdown-item form-check">
											<input type="checkbox" name="pieceTypeFilterAll" id="All_PieceTypes" onclick="filterByPieceType(this)">
											<label class="form-check-label" for="All_PieceTypes"> All Piece Types </label>
										</li>
										<li><hr class="dropdown-divider"></li>
										<div style="max-height: 50vh; overflow-y: auto;">
											<!-- This creates a dropdown item using bootstrap, for every piece colour and displays a check box and the colour name -->
											<c:forEach items="${pieceTypes}" var="pieceType">
												<li class="dropdown-item form-check">
													<input type="checkbox" name="pieceTypesFilter" id="${pieceType}" onclick="filterByPieceType(this)">
													<label class="form-check-label" for="${pieceType}"> ${pieceType} </label>
												</li>
											</c:forEach>
										</div>
									</ul>
								</li>
							</ul>
						</div>
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
						<p class="h6" onclick="typeSort()" data-bs-toggle="tooltip" title="Sort by Piece Type">Piece Type: <i id="typeSortIcon" class="fa fa-sort"></i></p>
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
				    	<label id="colour_${loop.index}">${piece.colour_name}</label>
				    </div>
				    <div class="col">
				    	${piece.pieceType}
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