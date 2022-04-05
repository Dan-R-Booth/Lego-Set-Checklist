<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>

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
					document.getElementById("viewport").setAttribute("content", "width=350");
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

				var set_num = "${set_number}";
				
				const set_numArray = set_num.split("-");
				
				document.getElementById("set_number").value = set_numArray[0];
				document.getElementById("set_variant").value = set_numArray[1];

				// If the API returns a 404 error not found, the container to inform the user of this is shown
				// Otherwise the container containing details of the Lego Set is shown
				if ("${notFound}" == "true") {
					document.getElementById("setNotFound_Container").setAttribute("class", "container-fluid");
				}
				else {
					document.getElementById("setFound_Container").setAttribute("class", "container-fluid row mb-5");
				}

				// If the account logged in is not set, the login/SignUp link is displayed enabling users to log in
				// Otherwise the logout link is displayed allowing users to logout of their account
				if("${accountLoggedIn}" == "") {
					document.getElementById("login/signUpLink").setAttribute("class", "nav-link");
				}
				else {
					document.getElementById("logoutLink").setAttribute("class", "nav-link");
				}
				
				// If a Lego set has just been added to a list, this will open an alert bar to inform the user of this
				if("${setAdded}" == "true") {
					document.getElementById("setAddedToListAlert").setAttribute("class", "alert alert-success alert-dismissible fade show");
				}

				// If the account logged in is not set, the login/SignUp link is displayed enabling users to log in
				if("${setAddedError}" == "true") {
					document.getElementById("selectList_${set_number}").setAttribute("class", "form-select is-invalid");
					document.getElementById("addSetToListHelp_${set_number}").setAttribute("class", "alert alert-danger mt-2s");
					
					document.getElementById("selectList_${set_number}").value = "${set_listSelected.setListId}";

					// This opens the addSetToListModal
					$("#addSetToListModal_${set_number}").modal("show");
				}

				// This displays an alert bar informing the user if a set list has been
				// created and is shown on the addSetToListModal, which is also opened
				if ("${setListCreated}" == "true") {
					document.getElementById("setListCreatedAlert").setAttribute("class", "alert alert-success alert-dismissible fade show");

					document.getElementById("selectList_${set_number}").value = "${newSetList.setListId}";
					
					// This opens the addSetToListModal
					$("#addSetToListModal_${set_number}").modal("show");
				}

				// This adds bootstrap styling to tooltips
				$('[data-bs-toggle="tooltip"]').tooltip();
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

			// This starts the loading spinner so the user knows that a page is being loaded
			function openLoader() {
				$("#loadingModal").modal("show");
			}

			// This function will return the user to the search page with the same filters and sorts they last had active
			// and if they haven't been to the search page, to the default unfilter and sorted page
			function backToSearch() {
				openLoader();

				if ("${searchURL}" != "") {
					window.location = "${searchURL}";
				}
				else {
					window.location = "/search/text=/barOpen=/sort=/minYear=/maxYear=/minPieces=/maxPieces=/theme_id=/uri/";
				}
			}
			
			// This clicks the button login-tab to switch to the login tab 
			function loginTab() {
				document.getElementById("login-tab").click();
			}

			// This clicks the button login-tab to switch to the login tab 
			function signUpTab() {
				document.getElementById("signUp-tab").click();
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

					<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
						<span class="navbar-toggler-icon"></span>
					</button>

					<div class="collapse navbar-collapse" id="navbar">
						<ul class="navbar-nav  me-auto">
							<li class="nav-item mx-5">
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
							</li>
						</ul>
						<ul class="navbar-nav">
							<li class="nav-item ms-5">
								<a class="d-none" id="login/signUpLink" style="cursor: pointer;" data-bs-toggle="modal" data-bs-target="#login_SignUp_Modal"> <i class="fa fa-sign-in"></i> Login/SignUp</a>
							</li>
							<li class="nav-item ms-5">
								<a class="d-none" id="logoutLink" style="cursor: pointer;" data-bs-toggle="modal" data-bs-target="#logoutModal"> <i class="fa fa-sign-out"></i> Logout</a>
							</li>
						</ul>
					</div>
				</div>
			</nav>

			<!-- This alert will be display when a set is added to a set list -->
			<div class="d-none" id="setAddedToListAlert" role="alert">
				<i class="fa fa-check-circle"></i> <strong>Set: "${set_number}" added to list: "<a href="/set_list=${set_listSelected.listName}" onclick="openLoader()" data-bs-toggle="tooltip" title="View Set List">${set_listSelected.listName}</a>"</strong>
				<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
			</div>
		</div>
	
		<div class="d-none" id="setFound_Container">
			<div id="imageDiv" class="col-6 m-3">
				<!-- The style width sets the percentage size the image will be on any screen -->
				<!-- When clicked this will display a Model with the image enlarged within -->
				<div data-bs-toggle="tooltip" title="Image of the Lego Set '${set.name}' (Click to enlarge)" style="width: 80%;">
					<img class="row img-fluid img-thumbnail rounded" src="${set.img_url}" alt="Image of the Lego Set: ${set.name}" style="cursor: pointer;" data-bs-toggle="modal" data-bs-target="#setModal">
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

				<button class="row btn btn-outline-secondary btn-dark text-white" type="button" onclick="backToSearch()" style="width: 80%"> BACK TO SEARCH </button>
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
				<c:choose>
				    <c:when test="${fn:length(instructions) != 0}">
						<h4>
							<!-- This displays all instruction booklets for the Lego Set in Bootstrap list group, that when clicked on opens the instruction book in a new tab -->
							<div class="list-group">
								<c:forEach items="${instructions}" var="instructionBook">
									<a href="${instructionBook[0]}" target="_blank" class="list-group-item list-group-item-action" data-bs-toggle="tooltip" title="Click to open instruction book">${instructionBook[1]}</a>
								</c:forEach>
							</div>
						</h4>
				    </c:when>    
				    <c:otherwise>
				        <h4 class="text-warning"><i class="fa fa-warning"></i> No Instructions Found</h4>
				    </c:otherwise>
				</c:choose>
				<br>
				<!-- This code will only display this button if the user is logged in -->
				<c:if test="${not empty accountLoggedIn}">
					<button class="btn btn-secondary" style="width: 100%;" data-bs-toggle="modal" data-bs-target="#addSetToListModal_${set.num}"><i class="fa fa-plus"></i> Add Set to a List</button>
				</c:if>
			</div>
		</div>
		
		<!-- If there was an error finding a Lego Set using the Set Number entered it is shown here -->
		<div class="d-none" id="setNotFound_Container">
			<div class="col-8 m-5">
				<h3 class="text-danger"><i class="fa fa-exclamation-circle"></i> Lego Set with Set Number: '<i class="text-dark">${set_number}</i>' Not Found</h3>
				<button class="btn btn-outline-secondary btn-dark text-white" type="button" onclick="backToSearch()" style="width: 75%"> BACK TO SEARCH </button>
			</div>
		</div>
		
		<!-- Modal to Login or Sign Up -->
		
		<!-- This code will only be run if the user is logged in -->
		<c:if test="${not empty accountLoggedIn}">
			<!-- Modal to Add a Lego Set to a List -->
			<div class="modal fade" id="addSetToListModal_${set.num}" data-bs-backdrop="static" tabindex="-1" aria-labelledby="addSetToListModelLabel_${set.num}" aria-hidden="true">
				<div class="modal-dialog modal-dialog-centered">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="addSetToListModalLabel_${set.num}">Add Set to a List</h5>
							<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
						</div>
						<form method="POST" id="addSetToListForm_${set.num}" action="/addSetToList/previousPage=set">
							<div class="modal-body">
								<!-- This alert will be display when a new set list is created -->
								<div class="d-none" id="setListCreatedAlert" role="alert">
									<i class="fa fa-check-circle"></i> <strong>Added New Set List: "<a href="/set_list=${newSetList.listName}" onclick="openLoader()" data-bs-toggle="tooltip" title="View Set List">${newSetList.listName}</a>"</strong>
									<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
								</div>
								<div class="mb-3">
									<label class="form-label">Add Set: "${set.num}/${set.name}" to a list</label>
									<br>
									<h5> Set List: </h5>
									<div class="input-group mb-3">
										<!-- This creates a select box using bootstrap, for every List of Lego Sets belonging to the logged in user -->
										<select class="form-select" id="selectList_${set.num}" name="setListId" style="max-height: 50vh; overflow-y: auto;" aria-label="Default select example" aria-describedby="newListButton_${set.num}">
											<c:forEach items="${set_lists}" var="set_list">
												<option class="form-check-label" value="${set_list.setListId}" data-tokens="${set_list.listName}" > ${set_list.listName} </option>
											</c:forEach>
										</select>
										<button id="newListButton_${set.num}" type="button" class="btn btn-secondary" data-bs-toggle="modal" data-bs-target="#addNewSetListModel"><i class="fa fa-plus"></i>  New List</button>
									</div>
									
									<div id="addSetToListHelp_${set.num}" class="d-none"><i class="fa fa-exclamation-circle"></i> Set already in list: "${set_listSelected.listName}"</div>

									<!-- This is a hidden input that adds the set number of the set selected to the form -->
									<input type="hidden" id="inputSetNum_${set.num}" name="set_number" value="${set.num}"/>
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
		</c:if>

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
					<form method="POST" id="addNewSetListForm" action="/addNewSetList/previousPage=set">
						<div class="modal-body">
							<div class="mb-3">
								<h5> Set List: </h5>
								<div class="form-floating mb-3">
									<input id="setListNameTextBox" class="form-control" name="setListName" type="text" oninput="checkListName()" placeholder="Input Unique List Name">
									<label class="text-secondary" for="setListNameTextBox"> Input Unique List Name </label>
								</div>
								
								<div id="addNewSetListHelp" class="d-none"><i class="fa fa-exclamation-circle"></i> You already have a set list with the name entered, <br> Please enter a unique name</div>
								
								<!-- This is a hidden input that adds the set number of the set selected to the form -->
								<input type="hidden" id="inputSetNum_${set.num}" name="set_number" value="${set.num}"/>
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
	                <li class="breadcrumb-item"><a href="#" onclick="backToSearch()">Search</a></li>
	                <li class="breadcrumb-item text-white" aria-current="page">Set</li>
	            </ol>
		    </div>
		</nav>
	</body>
</html>