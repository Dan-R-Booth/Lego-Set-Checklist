<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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
		<title>Lego: Set Checklist Creator - Set Lists</title>

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
				
				// This adds the current min sets filter to its number box,
				// or if no min set number parsed it is set to 0
				if ("${minSets}" != "") {
					document.getElementById("minSetsBox").value = "${minSets}";
				}
				else {
					document.getElementById("minSetsBox").value = 0;
				}

				// This adds the current max sets filter to its number box
				document.getElementById("maxSetsBox").value = "${maxSets}";

				// This displays an alert bar informing the user if a set list has been created,
				// or it displays that if a set list has been deleted
				if ("${setListCreated}" == "true") {
					document.getElementById("setListCreatedAlert").setAttribute("class", "alert alert-success alert-dismissible fade show");
				}
				else if ("${setListDeleted}" == "true") {
					document.getElementById("setListDeletedAlert").setAttribute("class", "alert alert-primary alert-dismissible fade show");
				}

				// This adds bootstrap styling to tooltips
				$('[data-bs-toggle="tooltip"]').tooltip();
			}
			
			// If sorts are applied to the page this adds visuals for the user so it is clear which columns are being filtered
			function applySortVisuals() {
				// If their is a sort this sets the correct column to the correct sort symbol,
				// and if their isn't a sort or it's list name, it sorts it by list name
				if ("${sort1}" == "numSets") {
					document.getElementById("numSetsSortIcon").setAttribute("class", "fa fa-sort-amount-asc");
					document.getElementById("sortSelect1").value = "Number of Sets (asc)";
				}
				else if ("${sort1}" == "-numSets") {
					document.getElementById("numSetsSortIcon").setAttribute("class", "fa fa-sort-amount-desc");
					document.getElementById("sortSelect1").value = "Number of Sets (desc)";
				}
				else if ("${sort1}" == "-listName") {
					document.getElementById("nameSortIcon").setAttribute("class", "fa fa-sort-alpha-desc");
					document.getElementById("sortSelect1").value = "List Name (desc)";
				}
				else {
					document.getElementById("nameSortIcon").setAttribute("class", "fa fa-sort-alpha-asc");
					document.getElementById("sortSelect1").value = "List Name (asc)";
				}

				// If their is a second sort this sets the correct column to the correct sort symbol
				if ("${sort2}" == "numSets") {
					document.getElementById("numSetsSortIcon").setAttribute("class", "fa fa-sort-amount-asc");
					document.getElementById("sortSelect2").value = "Number of Sets (asc)";
				}
				else if ("${sort2}" == "-numSets") {
					document.getElementById("numSetsSortIcon").setAttribute("class", "fa fa-sort-amount-desc");
					document.getElementById("sortSelect2").value = "Number of Sets (desc)";
				}
				else if ("${sort2}" == "-listName") {
					document.getElementById("nameSortIcon").setAttribute("class", "fa fa-sort-alpha-desc");
					document.getElementById("sortSelect2").value = "List Name (desc)";
				}
				else if ("${sort2}" == "listName") {
					document.getElementById("nameSortIcon").setAttribute("class", "fa fa-sort-alpha-asc");
					document.getElementById("sortSelect2").value = "List Name (asc)";
				}
			}
		
			// This reapplies any filters that where open when the page reloads
			function applyFiltersOnReload() {
				var text = "${searchText}";
				var minSets = parseInt(${minSets});
				var maxSets = parseInt(${maxSets});
               	
               	// This runs displaying only the set lists that match the filters selected
				for (let id = 0; id < "${num_setLists}"; id++) {
                    var listName = document.getElementById("name_" + id).innerHTML;
                    var listNum_sets = parseInt(document.getElementById("num_sets_" + id).innerHTML);
					
					// This will hide all set lists that do not fall into the categories that the list is being filtered by
					if (((listName.toUpperCase().search(text.toUpperCase()) == -1) && (text.length != 0)) || ((listNum_sets < minSets) && (minSets.length != 0)) || ((listNum_sets > maxSets) && (maxSets.length != 0))) {
                        document.getElementById("setList_" + id).style.display = "none";
					}
					else {
						document.getElementById("setList_" + id).style.display = "block";
					}
				}
			}

			// This calls the the controller setting the sort parameter as name
			function nameSort() {
				var iconClass = document.getElementById("nameSortIcon").className;
				
				if (iconClass == "fa fa-sort" || iconClass == "fa fa-sort-alpha-desc") {
					sortBy("listName");
				}
				else if (iconClass == "fa fa-sort-alpha-asc") {
					sortBy("-listName");
				}
			}
			
			// This calls the the controller setting the sort parameter as num_pieces
			function numSetsSort() {
				var iconClass = document.getElementById("numSetsSortIcon").className;
				
				if (iconClass == "fa fa-sort" || iconClass == "fa fa-sort-amount-desc") {
					sortBy("numSets");
				}
				else if (iconClass == "fa fa-sort-amount-asc") {
					sortBy("-numSets");
				}
			}

			// Adds the sort selected to the url so that it is sent to the controller so that it can be applied
			function sortBy(sort) {
				
				var text = "";
				if (document.getElementById("text_search").value.length != 0) {
					text = "&searchText=" + document.getElementById("text_search").value;
				}

				var minSets = "";
				if (document.getElementById("minSetsBox").value.length != 0) {
					minSets = "&minSets=" + document.getElementById("minSetsBox").value;
				}

                var maxSets = "";
				if (document.getElementById("maxSetsBox").value.length != 0) {
					maxSets = "&maxSets=" + document.getElementById("maxSetsBox").value;
				}

				openLoader();

				window.location = "/set_lists/?sort=" + sort + "&barOpen=" + getBarOpen() + text + minSets + maxSets;
			}
			
			// This sorts a list of Lego sets depending on values assigned in the sortBar
			function sort() {
				var sort1 = document.getElementById("sortSelect1").value;
				var sort2 = document.getElementById("sortSelect2").value;
				
				var sort = sortValue(sort1);
				
				if (sort2 != "None") {
					sort += ", " + sortValue(sort2);
				}
				
				sortBy(sort);
			}

			// This gets the value needed to be added to the Rebrickable API uri request, to sort a list of Lego Sets, depending on the value selected
			function sortValue(sort) {
				if (sort == "List Name (asc)") {
					return "listName";
				}
				else if (sort == "List Name (desc)") {
					return "-listName";
				}
				else if (sort == "Number of Sets (asc)") {
					return "numSets";
				}
				else if (sort == "Number of Sets (desc)") {
					return "-numSets";
				}
			}
			
			// When a sort select box is changed this will update the folowing sort select boxes so they connot match that select box for previous ones
			// It also disables sort3 if sort2 is None
			function sortSelectChange() {
				var sort1 = document.getElementById("sortSelect1");
				var sort2 = document.getElementById("sortSelect2");

				var sortType = sort1.value.split(" (")[0];

				// If sort 2 is the same type of sort type (ascending or descending) as sort
				// 1 this sets sort 2 to none, as sort types cannot match
				if (sort2.value.match(sortType)) {
					sort2.value = "None";
				}

				// This disables the certain options on a select if the previous select has used that options asc or desc option
				if (sort1.value.match("List Name ")) {
					for (var i = 0; i < sort2.length; i++) {
						if (sort2.options[i].value.match("List Name ")) {
							sort2.options[i].disabled = true;
						}
						else {
							sort2.options[i].disabled = false;
						}
					}
				}
				else if (sort1.value.match("Number of Sets ")) {
					for (var i = 0; i < sort2.length; i++) {
						if (sort2.options[i].value.match("Number of Sets ")) {
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
				var minSets = document.getElementById("minSetsBox").value;
				var maxSets = document.getElementById("maxSetsBox").value;

				// This runs displaying only the set lists that match the filters selected
				for (let id = 0; id < "${num_setLists}"; id++) {
                    var listName = document.getElementById("name_" + id).innerHTML;
                    var listNum_sets = parseInt(document.getElementById("num_sets_" + id).innerHTML);
					
					// This will hide all set lists that do not fall into the categories that the list is being filtered by
					if (((listName.toUpperCase().search(text.toUpperCase()) == -1) && (text.length != 0)) || ((listNum_sets < minSets) && (minSets.length != 0)) || ((listNum_sets > maxSets) && (maxSets.length != 0))) {
                        document.getElementById("setList_" + id).style.display = "none";
					}
					else {
						document.getElementById("setList_" + id).style.display = "block";
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

			// This function is called everytime a change occurs in the listName textbox
			// to check if the user already has a list with entered list name
			function checkListName() {
				var setListName = document.getElementById("setListNameTextBox").value;
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
					document.getElementById("setListNameTextBox").setAttribute("class", "form-control is-invalid");
					document.getElementById("setListNameTextBox").setAttribute("title", "List name must be Unique");
					document.getElementById("addNewSetListHelp").setAttribute("class", "alert alert-danger");
					document.getElementById("addNewSetListButton").disabled = true;
				}
				// If the list name is not found, this highlights the textbox green to show the name is
				// valid, the tooltip is removed, the error alert box that contains the error message is
				// hidden and finally enabling the add new list button
				else {
					document.getElementById("setListNameTextBox").setAttribute("class", "form-control is-valid");
					document.getElementById("setListNameTextBox").removeAttribute("title");
					document.getElementById("addNewSetListHelp").setAttribute("class", "d-none");
					document.getElementById("addNewSetListButton").disabled = false;
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
							<li class="nav-item mx-5">
								<a class="nav-link" style="cursor: pointer;" data-bs-toggle="modal" data-bs-target="#addNewSetListModel"> <i class="fa fa-plus"></i> Add New Set List</a>
							</li>
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
								<form class="d-flex row" style="display: inline;">
									<div class="col-auto form-floating mt-1">
										<input id="text_search" class="form-control" name="text_search" type="text" placeholder="Search for Lego Set"/>
										<label class="text-secondary" for="text_search"> Search Text </label>
									</div>
									<div class="col-auto">
										<label class="text-white" for="minSetsBox"> Minimum Number of Sets: </label>
										<input id="minSetsBox" class="form-control col-xs-1" name="minSetsBox" type="number" min=0 max="9999"/>
									</div>
									<div class="col-auto">
										<label class="text-white" for="maxSetsBox"> Maximum Number of Sets: </label>
										<input id="maxSetsBox" class="form-control" name="maxSetsBox" type="number" min=0 max="9999"/>
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
											<option selected> List Name (asc) </option>
											<option> List Name (desc) </option>
											<option> Number of Sets (asc) </option>
											<option> Number of Sets (desc) </option>
										</select>
									</div>
									<div class="col-auto">
										<label class="text-white mt-2"> Then By: </label>
									</div>
									<div class="col-auto mt-1">
										<select class="form-select" id="sortSelect2" style="cursor: pointer;" onchange="sortSelectChange()">
											<option selected> None </option>
											<option> List Name (asc) </option>
											<option> List Name (desc) </option>
											<option> Number of Sets (asc) </option>
											<option> Number of Sets (desc) </option>
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
		
			<!-- This alert will be display when a new set list is created -->
			<div class="d-none" id="setListCreatedAlert" role="alert">
				<i class="fa fa-check-circle"></i> <strong>Added New Set List: "<a href="/set_list=${newSetListName}" onclick="openLoader()" data-bs-toggle="tooltip" title="View Set List">${newSetListName}</a>"</strong>
				<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
			</div>

			<!-- This alert will be display when a set list is deleted -->
			<div class="d-none" id="setListDeletedAlert" role="alert">
				<i class="fa fa-trash-o"></i> <strong>Deleted Set List: "${deletedSetListName}"</strong>
				<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
			</div>

			<!-- This uses bootstrap to create a container which width will be maximum on screens of any size, with a border -->
			<div class="container-fluid border bg-white">
				<!-- This is the header for all the Lego sets, made using a bootstrap row and columns with column names -->
				<div class="row align-items-center my-3">
					<div class="col">
						<h6 style="cursor: pointer;" onclick="nameSort()"><span data-bs-toggle="tooltip" data-bs-placement="left" title="Sort by List Name"> List name: <i id="nameSortIcon" class="fa fa-sort"></i></span></h6>
					</div>
					<div class="col">
						<h6 style="cursor: pointer;" onclick="numSetsSort()" data-bs-toggle="tooltip" data-bs-placement="left" title="Sort by Number of Sets">Number of Sets: <i id="numSetsSortIcon" class="fa fa-sort"></i></h6>
					</div>
					<div class="col-1">
					</div>
				</div>
			</div>
		</div>
	    
		<div class="mb-5" id="set_lists">
			<!-- This creates a container using bootstrap, for every set in the set list and display the set image, number, name, year, theme and number of pieces -->
			<c:forEach items="${set_lists}" var="set_list" varStatus="loop">
				<!-- This uses bootstrap to create a container which width will be maximum on screens of any size, with a border -->
				<div id="setList_${loop.index}" class="container-fluid border">
					<!-- This is the header for all the pieces in a Lego set, made using a bootstrap row and columns with piece attributes -->
					<div class="row align-items-center my-3">
						<div class="col">
							<a id="name_${loop.index}" href="/set_list=${set_list.listName}" onclick="openLoader()" data-bs-toggle="tooltip" title="View Set List">${set_list.listName}</a>
						</div>
						<div class="col">
							<label id="num_sets_${loop.index}">${set_list.totalSets}</label>
						</div>
						<div class="col-1">
							<i class="fa fa-edit fa-lg mx-1" id="editLink_${set_list.setListId}" style="cursor: pointer;" onclick="editSetList()"></i>
							<i class="fa fa-trash fa-lg" id="deleteLink_${set_list.setListId}" style="cursor: pointer;" data-bs-toggle="modal" data-bs-target="#deleteSetListModal_${set_list.setListId}"></i>
						</div>
					</div>
				</div>

				<!-- Modal to confirm setlist deletion-->
				<div class="modal fade" id="deleteSetListModal_${set_list.setListId}" data-bs-backdrop="static" tabindex="-1" aria-labelledby="deleteSetListModalLabel_${set_list.setListId}" aria-hidden="true">
					<div class="modal-dialog modal-dialog-centered">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title"><i class="fa fa-sign-out"></i> Delete Set List: "${set_list.listName}"</h5>
								<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
							</div>
							<div class="modal-body">
								<p>Are you sure you want to delete the set list: "<a href="/set_list=${set_list.listName}" onclick="openLoader()" data-bs-toggle="tooltip" title="View Set List">${set_list.listName}</a>"? </p>
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-secondary" data-bs-dismiss="modal"> Cancel</button>
								<button type="button" class="btn btn-primary" onclick="window.location = '/set_list=${set_list.listName}/delete/${set_list.setListId}'"><i class="fa fa-trash"></i> Delete</button>
							</div>
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

		<!-- Modal to Create a New Set List -->
		<div class="modal fade" id="addNewSetListModel" data-bs-backdrop="static" tabindex="-1" aria-labelledby="addNewSetListModelLabel" aria-hidden="true">
			<div class="modal-dialog modal-dialog-centered">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="addNewSetListModelLabel">Create a New Lego Set List</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<form method="POST" id="addNewSetListForm" action="/addNewSetList/previousPage=set_lists">
						<div class="modal-body">
							<div class="mb-3">
								<h5> Set List: </h5>
								<div class="form-floating mb-3">
									<input id="setListNameTextBox" class="form-control" name="setListName" type="text" oninput="checkListName()" placeholder="Input Unique List Name">
									<label class="text-secondary" for="setListNameTextBox"> Input Unique List Name </label>
								</div>
								
								<div id="addNewSetListHelp" class="d-none"><i class="fa fa-exclamation-circle"></i> You already have a set list with the name entered, <br> Please enter a unique name</div>
								
							</div>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
							<button type="submit" id="addNewSetListButton" class="btn btn-primary" disabled><i class="fa fa-plus"></i> Create List</button>
						</div>
					</form>
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

		<nav class="navbar navbar-expand-md navbar-dark bg-dark fixed-bottom">
			<div class="container-fluid">
	            <ol class="breadcrumb bg-dark">
	                <li class="breadcrumb-item"><a href="/">Home</a></li>
	                <li class="breadcrumb-item text-white" aria-current="page">Set Lists</li>
	            </ol>
		    </div>
        </nav>
	</body>
</html>