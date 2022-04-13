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
		<title>Lego: Set Checklist Creator - Set: ${set.num} - ${set.name} - Pieces</title>

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
			// Global boolean used to show if the list is displaying by spares or not
			var showSpares = false;
		
			// This is a global array used to store the dvi id of all pieces that are spares so they can be identified when filtering a list
			var sparePieceList = [];
		
			// This used to monitor when changes are made to the checklist without saving
			var changesMade = false;

			// This does setup for the page when it is first loaded
			function setup() {
				// This sets a minimum size the page will adpat to until it will just zoom out,
				// as going any smaller would affect elements in the page
				if (screen.width < 650) {
					document.getElementById("viewport").setAttribute("content", "width=650, initial-scale=0.5");
				}

				// If the model attribute importError is true, this highlights the import input box
				// so the user knows that was an error there, as well as unhiding the error alert
				// box that contains the error message for the returned error and finally this opens
				// the importModal to the user
				if ("${importError}" == "true") {
					document.getElementById("importFile").setAttribute("class", "form-control is-invalid");
					document.getElementById("importFileErrorHelp").setAttribute("class", "alert alert-danger mt-2s");
					$("#importModal").modal("show");
				}

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

				applySortVisuals()
				
				applyFiltersOnReload()

				// If the account logged in is not set, the login/SignUp link is displayed enabling users to log in
				// Otherwise the logout link is displayed allowing users to logout of their account
				if ("${accountLoggedIn}" == "") {
					document.getElementById("login/signUpLink").setAttribute("class", "nav-link");
				}
				else {
					document.getElementById("logoutLink").setAttribute("class", "nav-link");
					document.getElementById("saveLink").setAttribute("class", "nav-link");
				}

				// This sets the changesMade variable to true if it is parsed,
				// if it is parsed in as false this does nothing as it is preset
				// as false already
				if ("${changesMade}" == "true") {
					changesMade = true;
				}

				// This adds bootstrap styling to tooltips
				$('[data-bs-toggle="tooltip"]').tooltip();
			}
			
			// If sorts are applied to the page this adds visuals for the user so it is clear which columns are being filtered
			function applySortVisuals() {
				// If their is a sort this sets the correct column to the correct sort symbol
				if ("${sort}" == "pieceNumber") {
					document.getElementById("pieceNumberSortIcon").setAttribute("class", "fa fa-sort-numeric-asc");
				}
				else if ("${sort}" == "-pieceNumber") {
					document.getElementById("pieceNumberSortIcon").setAttribute("class", "fa fa-sort-numeric-desc");
				}
				else if ("${sort}" == "pieceName") {
					document.getElementById("pieceNameSortIcon").setAttribute("class", "fa fa-sort-alpha-asc");
				}
				else if ("${sort}" == "-pieceName") {
					document.getElementById("pieceNameSortIcon").setAttribute("class", "fa fa-sort-alpha-desc");
				}
				else if ("${sort}" == "colour") {
					document.getElementById("colourSortIcon").setAttribute("class", "fa fa-sort-alpha-asc");
				}
				else if ("${sort}" == "-colour") {
					document.getElementById("colourSortIcon").setAttribute("class", "fa fa-sort-alpha-desc");
				}
				else if ("${sort}" == "type") {
					document.getElementById("typeSortIcon").setAttribute("class", "fa fa-sort-alpha-asc");
				}
				else if ("${sort}" == "-type") {
					document.getElementById("typeSortIcon").setAttribute("class", "fa fa-sort-alpha-desc");
				}
				else if ("${sort}" == "quantity") {
					document.getElementById("quantitySortIcon").setAttribute("class", "fa fa-sort-amount-asc");
				}
				else if ("${sort}" == "-quantity") {
					document.getElementById("quantitySortIcon").setAttribute("class", "fa fa-sort-amount-desc");
				}
				else if ("${sort}" == "quantityFound") {
					document.getElementById("quantityFoundSortIcon").setAttribute("class", "fa fa-sort-amount-asc");
				}
				else if ("${sort}" == "-quantityFound") {
					document.getElementById("quantityFoundSortIcon").setAttribute("class", "fa fa-sort-amount-desc");
				}
			}

			// This reapplies any filters that where open when the page reloads
			function applyFiltersOnReload() {
				var coloursFiltered = [];
				var pieceTypesFiltered = [];
				
				var colourCheckboxes = document.getElementsByName("colourFilter");
				var pieceTypeCheckboxes = document.getElementsByName("pieceTypeFilter");
				
				// This sets the colour filter to none if no colours are being shown, displaying no pieces
				// Or displays the pieces in the list that match the colour it is being filtered by
				if ("${colourFilter}" == "none") {
					for (let i = 0; i < colourCheckboxes.length; i++) {
	                    	colourCheckboxes[i].checked = false;
					}
				}
				// If all colours are being filtered this will run, checking the checkboxes of those colours filtered
				else if ("${colourFilter}" == "All_Colours") {
					document.getElementById("All_Colours").checked = true;
					
					for (let i = 0; i < colourCheckboxes.length; i++) {
                    	colourCheckboxes[i].checked = true;
						coloursFiltered.push(colourCheckboxes[i].id);
					}
				}
				// If not none or all colour checkboxes should be checked, this checks every checkbox colour that the should list be filtered by
				else {
					<c:forEach items="${colourFilter}" var="colourName">
						for (let i = 0; i < "${num_items}"; i++) {
							if ("${colourName}" == "No Color Any Color") {
								document.getElementById("[No Color/Any Color]").checked = true;
								coloursFiltered.push("[No Color/Any Color]");
							}
							else {
								document.getElementById("${colourName}").checked = true;
								coloursFiltered.push("${colourName}");
							}
						}
					</c:forEach>
				}
				
				// This sets the piece type filter to none if no piece types are being shown, displaying no pieces
				// Or displays the pieces in the list that match the piece type it is being filtered by
				if ("${pieceTypeFilter}" == "none") {
					for (let i = 0; i < pieceTypeCheckboxes.length; i++) {
						pieceTypeCheckboxes[i].checked = false;
					}
				}
				// If all piece type are being filtered this will run, checking the checkboxes of those piece colours filtered
				else if ("${pieceTypeFilter}" == "All_PieceTypes") {
					document.getElementById("All_PieceTypes").checked = true;

					for (let i = 0; i < pieceTypeCheckboxes.length; i++) {
						pieceTypeCheckboxes[i].checked = true;
						pieceTypesFiltered.push(pieceTypeCheckboxes[i].id);
					}
				}
				// If not none or all piece types checkboxes should be checked, this checks every checkbox piece type that the should list be filtered by
				else {
					// This checks every checkbox piece type that the list is being filtered by
					<c:forEach items="${pieceTypeFilter}" var="pieceType">
						for (let i = 0; i < "${num_items}"; i++) {
							document.getElementById("${pieceType}").checked = true;
							pieceTypesFiltered.push("${pieceType}");
						}
					</c:forEach>
				}
				
				// This checks the hide pieces found checkbox if hidePiecesFound has been added to the model
				// so that pieces found are hidden
				if ("${hidePiecesFound}" == "true") {
					document.getElementById("hidePiecesFound").checked = true;
				}

				// This checks the hide pieces not found checkbox if hidePiecesNotFound has been added to the model
				// so that pieces not found are hidden
				if ("${hidePiecesNotFound}" == "true") {
					document.getElementById("hidePiecesNotFound").checked = true;
				}
				
				// This runs displaying only the pieces that match the piece types and colours selected
				for (let id = 0; id < "${num_items}"; id++) {
					var pieceColour = document.getElementById("colour_" + id).innerHTML;
					var pieceType = document.getElementById("pieceType_" + id).innerHTML;
					
					var quantity = document.getElementById("piece_quantity_checked_" + id).max;
					var quantityChecked = document.getElementById("piece_quantity_checked_" + id).value;
					
					// This will hide all pieces where their quantity and quantity found are equal if the hide pieces found checkbox
					// is clicked, or will hide all pieces where their quantity and quantity found are not equal if the hide pieces
					// not found checkbox is clicked, or if they are a spare piece (stored in the list of spare pieces) and spares
					// are not being shown.
					// Otherwise this shows pieces depending on if their piece type and colour are in lists storing the filters the
					// list is currently being sorted by
					if ((showSpares == false && sparePieceList.indexOf(id) > -1) || (document.getElementById("hidePiecesFound").checked == true && quantityChecked == quantity) || (document.getElementById("hidePiecesNotFound").checked == true && quantityChecked != quantity)) {
						document.getElementById("piece_" + id).style.display = "none";
					}
					else if (pieceTypesFiltered.indexOf(pieceType) > -1 && coloursFiltered.indexOf(pieceColour) > -1) {
						document.getElementById("piece_" + id).style.display = "block";
					}
					else {
						document.getElementById("piece_" + id).style.display = "none";
					}
				}
			}

			// This decreases the quantity of a piece found
			function decreaseQuantityChecked(id) {
				var quantity = document.getElementById("piece_quantity_checked_" + id).max;
				var quantityChecked = document.getElementById("piece_quantity_checked_" + id).value;
				quantityChecked --;
					
				changesMade = true;

				 if (quantityChecked == 0) {
					document.getElementById("decreaseQuantityCheckedButton_" + id).disabled = true;
				}

				// This hides the piece if its quantity is not max and hidePiecesNotFound is checked
				if ((quantityChecked != quantity) && (document.getElementById("hidePiecesNotFound").checked == true)) {
					document.getElementById("piece_" + id).style.display = "none";
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
				
				changesMade = true;

				 document.getElementById("decreaseQuantityCheckedButton_" + id).disabled = false;
				 if (quantityChecked == quantity) {
					document.getElementById("increaseQuantityCheckedButton_" + id).disabled = true;
					
					// This hides the piece if its quantity is max and hidePiecesFound is checked
					if (document.getElementById("hidePiecesFound").checked == true) {
						document.getElementById("piece_" + id).style.display = "none";
					}
				 }
				 
				 document.getElementById("piece_quantity_checked_" + id).value = quantityChecked;
				 
				 piecesFound();
			}
		
			// This calculates add displays the total quantity of a piece found
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
			
			// This sends a post request to controller to save all the changes to Piece quantity found to the database
			function saveProgress() {
				var array = getQuantityChecked();
				
				changesMade = false;

				$.post("/set/${set.num}/pieces/save/?" + "quantityChecked=" + array);

				// This displays an alert bar informing the user the checklist has been saved
				document.getElementById("checklistSavedAlert").setAttribute("class", "alert alert-info alert-dismissible fade show");
			}
			
			// This calls a controller to export the checklist as a csv file
			function exportList() {
				var array = getQuantityChecked();
				
				window.location = "/set/${set.num}/pieces/export/?quantityChecked=" + array;
			}
			
			// This calls the the controller setting the sort parameter as pieceNumber
			function pieceNumberSort() {
				var iconClass = document.getElementById("pieceNumberSortIcon").className;
				
				if (iconClass == "fa fa-sort" || iconClass == "fa fa-sort-numeric-desc") {
					sortBy("pieceNumber");
				}
				else if (iconClass == "fa fa-sort-numeric-asc") {
					sortBy("-pieceNumber");
				}
			}

			// This calls the the controller setting the sort parameter as pieceName
			function pieceNameSort() {
				var iconClass = document.getElementById("pieceNameSortIcon").className;
				
				if (iconClass == "fa fa-sort" || iconClass == "fa fa-sort-alpha-desc") {
					sortBy("pieceName");
				}
				else if (iconClass == "fa fa-sort-alpha-asc") {
					sortBy("-pieceName");
				}
			}

			// This calls the the controller setting the sort parameter as colourName
			function colourSort() {
				var iconClass = document.getElementById("colourSortIcon").className;
				
				if (iconClass == "fa fa-sort" || iconClass == "fa fa-sort-alpha-desc") {
					sortBy("colour");
				}
				else if (iconClass == "fa fa-sort-alpha-asc") {
					sortBy("-colour");
				}
			}

			// This calls the the controller setting the sort parameter as pieceCategory alphabetically
			function typeSort() {
				var iconClass = document.getElementById("typeSortIcon").className;
				
				if (iconClass == "fa fa-sort" || iconClass == "fa fa-sort-alpha-desc") {
					sortBy("type");
				}
				else if (iconClass == "fa fa-sort-alpha-asc") {
					sortBy("-type");
				}
			}
			
			// This calls the the controller setting the sort parameter as quantity
			function quantitySort() {
				var iconClass = document.getElementById("quantitySortIcon").className;
				
				if (iconClass == "fa fa-sort" || iconClass == "fa fa-sort-amount-desc") {
					sortBy("quantity");
				}
				else if (iconClass == "fa fa-sort-amount-asc") {
					sortBy("-quantity");
				}
			}

			// This calls the the controller setting the sort parameter as quantity
			function quantityFoundSort() {
				var iconClass = document.getElementById("quantityFoundSortIcon").className;

				if (iconClass == "fa fa-sort" || iconClass == "fa fa-sort-amount-desc") {
					sortBy("quantityFound");
				}
				else if (iconClass == "fa fa-sort-amount-asc") {
					sortBy("-quantityFound");
				}
			}

			// Adds the sort selected to the url so that it is sent to the controller so that it can be applied
			function sortBy(sort) {
				var array = getQuantityChecked();
				
				var colourFilter = getColourFilter();
				var pieceTypeFilter = getPieceTypeFilter();
				
				var hidePiecesFound = "";
				if (document.getElementById("hidePiecesFound").checked) {
					hidePiecesFound = "&hidePiecesFound=true";
				}

				var hidePiecesNotFound = "";
				if (document.getElementById("hidePiecesNotFound").checked) {
					hidePiecesNotFound = "&hidePiecesNotFound=true";
				}

				openLoader();

				window.location = "/set/${set_number}/pieces/?sort=" + sort + "&quantityChecked=" + array + colourFilter + pieceTypeFilter + hidePiecesFound + hidePiecesNotFound + "&changesMade=" + changesMade;
			}

			// This filters the list by piece types and colours the user would like to view
			// and also hides spares and hides piece found (if pieces found checkbox is checked)
			function filter(boxClicked) {
                
				// This goes through all the colour checkboxes and adds those checkbox ids of ones that are checked to a list
				// that is then used to know which colours to filter the list by
                var colourCheckboxes = document.getElementsByName("colourFilter");
				
             	// This goes through all the piece type checkboxes and adds those checkbox ids of ones that are checked to a list
				// that is then used to know which piece types to filter the list by
                var pieceTypeCheckboxes = document.getElementsByName("pieceTypeFilter");
				
             	// This runs if the All Colours checkbox has been clicked
				if (boxClicked.id == "All_Colours") {
					// This goes through all the colour checkboxes and checks or unchecks them all, depending on if the All Colours checkbox is checked or not
	                for (let i = 0; i < colourCheckboxes.length; i++) {
	                	if (document.getElementById("All_Colours").checked == true) {
	                    	colourCheckboxes[i].checked = true;
	                	}
	                	else {
	                    	colourCheckboxes[i].checked = false;
	                	}
	                }
				}
                // This checks if the All Piece Types checkbox has been checked
                else if (boxClicked.id == "All_PieceTypes") {
					// This goes through all the piece type checkboxes and checks or unchecks them all, depending on if the All Piece Types checkbox is checked or not
	                for (let i = 0; i < pieceTypeCheckboxes.length; i++) {
	                	if (document.getElementById("All_PieceTypes").checked == true) {
	                    	pieceTypeCheckboxes[i].checked = true;
	                	}
	                	else {
	                    	pieceTypeCheckboxes[i].checked = false;
	                	}
	                }
				}
                
				// This goes through all the colour checkboxes and adds those checkbox ids of ones that are checked to a list
				// that is then used to know which colours to filter the list by
                colourCheckboxes = document.getElementsByName("colourFilter");
                var coloursFiltered = [];
                for (let i = 0; i < colourCheckboxes.length; i++) {
					if (colourCheckboxes[i].checked) {
						coloursFiltered.push(colourCheckboxes[i].id);
                   }
                }
				
				// This goes through all the piece type checkboxes and adds those checkbox ids of ones that are checked to a list
				// that is then used to know which piece types to filter the list by
                pieceTypeCheckboxes = document.getElementsByName("pieceTypeFilter");
                var pieceTypesFiltered = [];
                for (let i = 0; i < pieceTypeCheckboxes.length; i++) {
					if (pieceTypeCheckboxes[i].checked) {
						pieceTypesFiltered.push(pieceTypeCheckboxes[i].id);
                   }
                }
                
             	// This runs if all the colours are checked and All Colours is not, and it checks All Colours checkbox
            	if (colourCheckboxes.length == coloursFiltered.length) {
					document.getElementById("All_Colours").checked = true;
				}
            	// This runs if all the colours are not checked, thic sets All Colours checkbox to unchecked
            	else {
					document.getElementById("All_Colours").checked = false;
            	}
                
               	// This runs if all the piece types are checked and All Piece Types is not, and it checks All Piece Types checkbox
               	if (pieceTypeCheckboxes.length == pieceTypesFiltered.length) {
   					document.getElementById("All_PieceTypes").checked = true;
   				}
               	// This runs if all the piece types are not checked, thic sets All Piece Types checkbox to unchecked
               	else {
					document.getElementById("All_PieceTypes").checked = false;
               	}
               	
               	// This runs displaying only the pieces that match the piece types and colours selected
				for (let id = 0; id < "${num_items}"; id++) {
					var pieceColour = document.getElementById("colour_" + id).innerHTML;
					var pieceType = document.getElementById("pieceType_" + id).innerHTML;
					
					var quantity = document.getElementById("piece_quantity_checked_" + id).max;
					var quantityChecked = document.getElementById("piece_quantity_checked_" + id).value;
					
					// This will hide all pieces where their quantity and quantity found are equal if the hide pieces found checkbox
					// is clicked, or will hide all pieces where their quantity and quantity found are not equal if the hide pieces
					// not found checkbox is clicked, or if they are a spare piece (stored in the list of spare pieces) and spares
					// are not being shown.
					// Otherwise this shows pieces depending on if their piece type and colour are in lists storing the filters the
					// list is currently being sorted by
					if ((showSpares == false && sparePieceList.indexOf(id) > -1) || (document.getElementById("hidePiecesFound").checked == true && quantityChecked == quantity) || (document.getElementById("hidePiecesNotFound").checked == true && quantityChecked != quantity)) {
						document.getElementById("piece_" + id).style.display = "none";
					}
					else if (pieceTypesFiltered.indexOf(pieceType) > -1 && coloursFiltered.indexOf(pieceColour) > -1) {
						document.getElementById("piece_" + id).style.display = "block";
					}
					else {
						document.getElementById("piece_" + id).style.display = "none";
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
							
							if (colourCheckboxes[i].id == "[No Color/Any Color]") {
								coloursFiltered.push("No Color Any Color");
							}
							else {	
								coloursFiltered.push(colourCheckboxes[i].id);
							}
	                   }
	                }
	                
	                if (coloursFiltered.length == 0) {
	                	colourFilter += "none";
	                }
	                else {
	                	for (let i = 0; i < coloursFiltered.length; i++) {
                			colourFilter += coloursFiltered[i] + ">";
		                }
	                }
				}
				
				return colourFilter;
			}
			
			// This returns a pieceType filter if there is one currently active, this is used when getting this information
			// to return to the controller
			function getPieceTypeFilter() {
				var pieceTypeFilter = "";
				
				if (document.getElementById("All_PieceTypes").checked == false) {
					pieceTypeFilter = "&pieceTypeFilter=";
					
	                // This goes through all the piece type checkboxes and adds those checkbox ids of ones that are checked to a list
	                // if it has no length the pieceTypeFilter string is set to equal none. Overwise the values are then added to the
	                // pieceTypeFilter string This string is to be sent to the controller so that the filters are not forgot when the
	                // page is reloaded
	                var pieceTypeCheckboxes = document.getElementsByName("pieceTypeFilter");
	                var pieceTypesFiltered = [];
	                for (let i = 0; i < pieceTypeCheckboxes.length; i++) {
						if (pieceTypeCheckboxes[i].checked) {
							pieceTypesFiltered.push(pieceTypeCheckboxes[i].id);
	                   }
	                }
	                
	                if (pieceTypesFiltered.length == 0) {
	                	pieceTypeFilter += "none";
	                }
	                else {
	                	for (let i = 0; i < pieceTypesFiltered.length; i++) {
	                		pieceTypeFilter += pieceTypesFiltered[i] + ">";
		                }
	                }
				}
				
				return pieceTypeFilter;
			}

			// This function will return the link to the search page with the same filters and sorts the user last had active
			// and if they haven't been to the search page, to the default unfilter and sorted page
			function backToSearch() {
				if ("${searchURL}" != "") {
					return "${searchURL}";
				}
				else {
					return "/search/text=/barOpen=/sort=/minYear=/maxYear=/minPieces=/maxPieces=/theme_id=/uri/";
				}
			}

			// This will check if the import file input box has a value, if it does have a value this will return the
			// file to the controller so that it can be imported. This also send the current pieces checked along with
			// the sort and filters active, so that if the import fails the user is returned to the exact same page.
			// and if it does not contain a file an error will be displayed
			function importCSVFile() {
				if (document.getElementById("importFile").value.length > 0) {

					var array = getQuantityChecked();
				
					var colourFilter = getColourFilter();
					var pieceTypeFilter = getPieceTypeFilter();
					
					var sort = "";
					
					if ("${sort}" != "") {
						sort = "sort=${sort}&"
					}
					
					var hidePiecesFound = "";
					if (document.getElementById("hidePiecesFound").checked == true) {
						hidePiecesFound = "&hidePiecesFound=true";
					}

					var hidePiecesNotFound = "";
					if (document.getElementById("hidePiecesNotFound").checked) {
						hidePiecesNotFound = "&hidePiecesNotFound=true";
					}
					
					var formActionURL = "/openImport/previousPage=Set_Pieces/?previous_set_number=${set.num}&" + sort + "quantityChecked=" + array + colourFilter + pieceTypeFilter + hidePiecesFound + hidePiecesNotFound;

					document.getElementById("importForm").setAttribute("action", formActionURL);

					openLoader();

					document.getElementById("importForm").submit();
				}
				else {
					document.getElementById("importFile").setAttribute("class", "form-control is-invalid");
        			document.getElementById("importFileNoneHelp").setAttribute("class", "alert alert-danger");
					document.getElementById("importFileErrorHelp").setAttribute("class", "d-none");
				}
			}

			// This starts the loading spinner so the user knows that a page is being loaded
			function openLoader() {
				$("#loadingModal").modal("show");
			}

			// This runs when a user tries to leave the page. If they are logged in and the list changes have
			// not been saved a popup opens asking if they want to leave without saving or save and leave
			function confirmLeavePage(link) {
				if("${accountLoggedIn}" == "" || changesMade == false) {
					exit(link);
				}
				else {
					document.getElementById("leaveWithoutSavingButton").setAttribute("onclick", "exit('" + link + "')");
					document.getElementById("saveAndLeaveButton").setAttribute("onclick", "saveProgress(), exit('" + link + "')");
	
					$("#leavePageModal").modal("show");
				}
			}

			// This opens the loader before using the inputed link
			function exit(link) {
				openLoader()
				window.location = link;
			}

			// When the user clicks the logout button this opens the loggout model
			// and depending on if there have been changes to the checklist information
			// about logging out without saving is displayed, otherwise it is hidden
			function logout() {
				if (changesMade == true) {
					document.getElementById("logoutWithOutSavingAlert").setAttribute("class", "alert alert-warning")
					document.getElementById("saveAndLogoutButton").setAttribute("class", "btn btn-secondary")
				}
				else {
					document.getElementById("logoutWithOutSavingAlert").setAttribute("class", "d-none")
					document.getElementById("saveAndLogoutButton").setAttribute("class", "d-none")
				}

				$("#logoutModal").modal("show");
			}

			// This runs when a user tries to import a checklist. If they are logged in and the list changes have
			// not been saved a popup opens asking if they want to import without saving or save and import
			function confirmImport() {
				if ("${accountLoggedIn}" == "" || changesMade == false) {
					importCSVFile();
				}
				else {
					$("#confirmImportModal").modal("show");
				}
			}

		</script>
	</head>

	<body onload="setup()">
	
		<!-- This uses bootstrap so that everything in this div stays at the top of the page when it's scrolled down -->
		<div class="sticky-top" data-toggle="affix">
		
			<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
				<div class="container-fluid">
					<a class="navbar-brand" style="cursor: pointer;" onclick="confirmLeavePage('/')" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Return to home page"> Lego: Set Checklist Creator </a>
	
					<div class="collapse navbar-collapse" id="navbar">
						<ul class="navbar-nav me-auto">
							<li class="nav-item mx-5">
								<a class="d-none" id="saveLink" style="cursor: pointer;" onclick="saveProgress()"> <i class="fa fa-save"></i> Save CheckList</a>
							</li>
							<li class="nav-item mx-5">
								<a class="nav-link" style="cursor: pointer;" onclick="exportList()"> <i class="fa fa-download"></i> Export Checklist</a>
							</li>
							<li class="nav-item mx-5">
								<a class="nav-link" style="cursor: pointer;" style="cursor: pointer;" data-bs-toggle="modal" data-bs-target="#importModal"> <i class="fa fa-upload"></i> Import Checklist</a>
							</li>
							<li class="nav-item mx-5">
								<a class="nav-link" style="cursor: pointer;" onclick="confirmLeavePage('/set?set_number=${set.num}')"> <i class="fa fa-arrow-left"></i> Return to Set View</a>
							</li>
						</ul>
						<ul class="navbar-nav">
							<li class="nav-item ms-5">
								<a class="d-none" id="login/signUpLink" href="/openLogin_SignUp_Modal" data-bs-toggle="tooltip" title="Got to Home Page to Login/SignUp"> <i class="fa fa-sign-in"></i> Login/SignUp</a>
							</li>
							<li class="nav-item ms-5">
								<a class="d-none" id="logoutLink" style="cursor: pointer;" onclick="logout()"> <i class="fa fa-sign-out"></i> Logout</a>
							</li>
						</ul>
					</div>

					<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
						<span class="navbar-toggler-icon"></span>
					</button>
				</div>
			</nav>
			
			<nav class="navbar navbar-expand-lg navbar-dark bg-secondary" id="filterNavBar">
				<div class="container-fluid">
					<label class="navbar-brand"> <i class="fa fa-filter"></i> Filter: </label>
	
					<div class="collapse navbar-collapse" id="filterBar">
						<!-- This creates a dropdown where users can enter details on how they would like to filter the list of pieces -->
						<ul class="navbar-nav">
							<li class="nav-item dropdown mx-5">
								<a class="nav-link dropdown-toggle active" id="navbarDropdownMenuLink" role="button" data-toggle="dropdown" aria-expanded="false">
									<i class="fa fa-filter"></i> Filter by Piece Colours
								</a>
								<ul class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
									<li class="dropdown-item form-check">
										<input type="checkbox" name="colourFilterAll" id="All_Colours" onclick="filter(this)">
										<label class="form-check-label" for="All_Colours"> All Colours </label>
									</li>
									<li><hr class="dropdown-divider"></li>
									<div style="max-height: 50vh; overflow-y: auto;">
										<!-- This creates a dropdown item using bootstrap, for every piece colour and displays a check box and the colour name -->
										<c:forEach items="${colours}" var="colour">
											<li class="dropdown-item form-check">
												<input type="checkbox" name="colourFilter" id="${colour}" onclick="filter(this)">
												<label class="form-check-label" for="${colour}"> ${colour} </label>
											</li>
										</c:forEach>
									</div>
								</ul>
							</li>
							<li class="nav-item dropdown mx-5">
								<a class="nav-link dropdown-toggle active" id="navbarDropdownMenuLink" role="button" data-toggle="dropdown" aria-expanded="false">
									<i class="fa fa-filter"></i> Filter by Piece Types
								</a>
								<ul class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
									<li class="dropdown-item form-check">
										<input type="checkbox" name="pieceTypeFilterAll" id="All_PieceTypes" onclick="filter(this)">
										<label class="form-check-label" for="All_PieceTypes"> All Piece Types </label>
									</li>
									<li><hr class="dropdown-divider"></li>
									<div style="max-height: 50vh; overflow-y: auto;">
										<!-- This creates a dropdown item using bootstrap, for every piece colour and displays a check box and the colour name -->
										<c:forEach items="${pieceTypes}" var="pieceType">
											<li class="dropdown-item form-check">
												<input type="checkbox" name="pieceTypeFilter" id="${pieceType}" onclick="filter(this)">
												<label class="form-check-label" for="${pieceType}"> ${pieceType} </label>
											</li>
										</c:forEach>
									</div>
								</ul>
							</li>
							<li class="nav-item mx-5 mt-2">
								<input type="checkbox" name="hidePiecesFound" id="hidePiecesFound" style="cursor: pointer;" onclick="filter(this)">
								<label class="form-check-label text-white" style="cursor: pointer;" for="hidePiecesFound"> Hide Pieces Found </label>
							</li>
							<li class="nav-item mx-5 mt-2">
								<input type="checkbox" name="hidePiecesNotFound" id="hidePiecesNotFound" style="cursor: pointer;" onclick="filter(this)">
								<label class="form-check-label text-white" style="cursor: pointer;" for="hidePiecesNotFound"> Hide Pieces Not Found </label>
							</li>
						</ul>
					</div>

					<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#filterBar" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
						<span class="navbar-toggler-icon"></span>
					</button>
				</div>
			</nav>

			<!-- This uses bootstrap to create a container which width will be maximum on screens of any size, with a border -->
			<div class="container-fluid border bg-white">
				<!-- This is the header for all the pieces in a Lego set, made using a bootstrap row and columns with column names -->
				<div class="row align-items-center my-1">
					<div class="col">
						<!-- The style width sets the percentage size the image will be on any screen -->
						<!-- When clicked this will display a Model with the image enlarged within -->
						<span data-bs-toggle="tooltip" data-bs-placement="right" title="Image of the Lego Set '${set.name}' (Click to enlarge)">
							<img class="img-thumbnail rounded m-2" src="${set.img_url}" alt="Image of the Lego Set: ${set.name}" style="cursor: pointer; max-height: 180px;" data-bs-toggle="modal" data-bs-target="#setModal">
						</span>
					</div>
					<div class="col">
						<h4>${set.name}</h4>
						<h5>${set.num}</h5>
					</div>
					<div class="col">
						<h5>Pieces Found: <label id="piecesFound">0</label> / <label id="piecesNeededTotal">${num_items}</label></h5>
					</div>
				</div>
			</div>

			<!-- This uses bootstrap to create a container which width will be maximum on screens of any size, with a border -->
			<div class="container-fluid border  bg-white">
				<!-- This is the header for all the pieces in a Lego set, made using a bootstrap row and columns with column names -->
				<div class="row align-items-center my-3">
					<div class="col">
						<h6>Piece Image:</h6>
					</div>
					<div class="col-1">
					</div>
					<div class="col">
						<h6 style="cursor: pointer;" onclick="pieceNumberSort()" data-bs-toggle="tooltip" title="Sort by Piece Number">Piece Number: <i id="pieceNumberSortIcon" class="fa fa-sort"></i></h6>
					</div>
					<div class="col">
						<h6 style="cursor: pointer;" onclick="pieceNameSort()" data-bs-toggle="tooltip" title="Sort by Piece Name">Piece Name: <i id="pieceNameSortIcon" class="fa fa-sort"></i></h6>
					</div>
					<div class="col">
						<h6 style="cursor: pointer;" onclick="colourSort()" data-bs-toggle="tooltip" title="Sort by Piece Colour">Piece Colour: <i id="colourSortIcon" class="fa fa-sort"></i></h6>
					</div>
					<div class="col">
						<h6 style="cursor: pointer;" onclick="typeSort()" data-bs-toggle="tooltip" title="Sort by Piece Type">Piece Type: <i id="typeSortIcon" class="fa fa-sort"></i></h6>
					</div>
					<div class="col">
						<h6 style="cursor: pointer;" onclick="quantitySort()" data-bs-toggle="tooltip" title="Sort by Quantity">Quantity: <i id="quantitySortIcon" class="fa fa-sort"></i></h6>
					</div>
					<div class="col">
						<h6 style="cursor: pointer;" onclick="quantityFoundSort()" data-bs-toggle="tooltip" title="Sort by Quantity Found">Quantity Found: <i id="quantityFoundSortIcon" class="fa fa-sort"></i></h6>
					</div>
				</div>
			</div>

			<!-- This alert will be display when a logged in user saves the checklist -->
			<div class="d-none" id="checklistSavedAlert" role="alert">
				<i class="fa fa-check-circle"></i> <strong>Saved</strong>
				<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
			</div>
		</div>

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

	    <div class="mb-5">
			<!-- This creates a container, using bootstrap, for every set in the pieces list and display the piece image, number, name, colour, quantity and the quantity found -->
			<c:forEach items="${set.piece_list}" var="piece" varStatus="loop">
				<!-- This uses bootstrap to create a container which width will be maximum on screens of any size, with a border -->
				<div id="piece_${loop.index}" class="container-fluid border">
					<div class="row align-items-center my-3">
						<div class="col" data-bs-toggle="tooltip" title="Image of the Lego Piece '${piece.name}' (Click to enlarge)">
							<!-- The style width sets the percentage size the image will be on any screen -->
							<!-- When clicked this will display a Model with the image enlarged within -->
							<img class="m-2" src="${piece.img_url}" alt="Image of the Lego Piece: ${piece.name}" style="width: 50%; cursor: pointer;" data-bs-toggle="modal" data-bs-target="#pieceModal_${piece.num}">
						</div>
						<div class="col-1">
							<!-- This displays a Shoping cart icon that when clicked opens a new tab to the Rebrickable website for that specific piece so the user can buy any missing Lego pieces there. -->
							<h2><a href="${piece.piece_url}/#buy_parts" target="_blank" data-bs-toggle="tooltip" title="Buy Missing Lego Piece"><i class="fa fa-shopping-cart"></i></a></h2>
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
							<label id="pieceType_${loop.index}">${piece.pieceType}</label>
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

				<!-- Lego Piece Modal Image Viewer -->
				<div class="modal fade" id="pieceModal_${piece.num}" tabindex="-1" aria-labelledby="pieceModalLabel_${piece.num}" aria-hidden="true">
					<div class="modal-dialog modal-dialog-centered">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title" id="pieceModalLabel_${piece.num}">Lego Piece: ${piece.name}</h5>
								<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
							</div>
							<div class="modal-body">
								<img src="${piece.img_url}" alt="Image of the Lego Piece: ${piece.name}" style="width: 100%">
							</div>
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
                        <h5>Are you sure you want to logout?</h5>

						<!-- This is only visable if the user made changes to the checklist without saving -->
						<div id="logoutWithOutSavingAlert" class="d-none"><i class="fa fa-warning"></i> Any Changes Not Saved will be lost</div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"> Cancel</button>
						<!-- This is only visable if the user made changes to the checklist without saving -->
						<button type="button" id="saveAndLogoutButton" class="d-none" style="cursor: pointer;" onclick="saveProgress(), exit('/logout')"><i class="fa fa-save"></i> Save & Logout</button>
						<button type="button" class="btn btn-primary" style="cursor: pointer;" onclick="exit('/logout')"><i class="fa fa-sign-out"></i> Logout</button>
                    </div>
                </div>
            </div>
        </div>

		<!-- Modal to confirm leaving the page -->
		<div class="modal fade" id="leavePageModal" data-bs-backdrop="static" tabindex="-1" aria-labelledby="leavePageModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Exit</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure you want to leave without saving your changes? </p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"> Cancel</button>
						<button type="button" class="btn btn-secondary" id="saveAndLeaveButton" style="cursor: pointer;"><i class="fa fa-save"></i> Save & Exit</button>
						<button type="button" class="btn btn-primary" id="leaveWithoutSavingButton" style="cursor: pointer;">Exit</button>
                    </div>
                </div>
            </div>
        </div>
		
		<!-- Modal to Import a Lego Checklist -->
		<div class="modal fade" id="importModal" data-bs-backdrop="static" tabindex="-1" aria-labelledby="importModalLabel" aria-hidden="true">
			<div class="modal-dialog modal-dialog-centered">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="importModalLabel">Import Lego Set Checklist</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<form method="POST" id="importForm" action="/openImport" enctype="multipart/form-data">
						<div class="modal-body">
							<div class="mb-3">
								<label for="importFile" class="form-label">Choose a CSV file containing a saved checklist to import</label>
								<input class="form-control" type="file" id="importFile" name="importFile" accept=".csv" required/>
							</div>

							<div id="importFileNoneHelp" class="d-none"><i class="fa fa-exclamation-circle"></i> Please select a CSV file to upload.</div>
							<div id="importFileErrorHelp" class="d-none"><i class="fa fa-exclamation-circle"></i> ${message}</div>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
							<button type="button" id="importFileButton" class="btn btn-primary" onclick="confirmImport()"> <i class="fa fa-upload"></i> Import </button>
						</div>
					</form>
				</div>
			</div>
		</div>

		<!-- Modal to ask the user if they want to save before importing -->
		<div class="modal fade" id="confirmImportModal" data-bs-backdrop="static" tabindex="-1" aria-labelledby="confirmImportModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Save Changes</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Do you want to save your changes before importing? </p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"> Cancel</button>
						<button type="button" class="btn btn-secondary" id="saveAndImportButton" style="cursor: pointer;" onclick="saveProgress(), importCSVFile()"><i class="fa fa-save"></i> Save & Import</button>
						<button type="button" class="btn btn-primary" id="importWithoutSavingButton" style="cursor: pointer;" onclick="importCSVFile()">Import</button>
                    </div>
                </div>
            </div>
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
	                <li class="breadcrumb-item"><a href="#" onclick="confirmLeavePage('/')">Home</a></li>
	                <li class="breadcrumb-item"><a href="#" onclick="confirmLeavePage(backToSearch())">Search</a></li>
	                <li class="breadcrumb-item"><a href="#" onclick="confirmLeavePage('/set?set_number=${set.num}')">Set</a></li>
	                <li class="breadcrumb-item text-white" aria-current="page">Pieces</li>
	            </ol>
		    </div>
        </nav>
	</body>
</html>