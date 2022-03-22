<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

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
		<title>Lego: Set Checklist Creator</title>

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
				if (screen.width < 350) {
					document.getElementById("viewport").setAttribute("content", "width=350");
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

			// This asks the user to confirm they want logout and if they do the user is sent to the database controller to do this 
			function logout() {
                alert("You have been successfully logged out")
                window.location = "/logout";
			}

		</script>

	</head>
	<body onload="setup()">
		<!-- This uses bootstrap so that everything in this div stays at the top of the page when it's scrolled down -->
		<div class="sticky-top" data-toggle="affix">
			<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
				<div class="container-fluid">
					<a class="navbar-brand" href="/" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Return to home page"> Lego: Set Checklist Creator </a>

					<div class="collapse navbar-collapse" id="navbar">
						<ul class="navbar-nav me-auto">
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
										<button id="findSetButton" class="btn btn-primary" type="button" onclick="findSet()" data-bs-toggle="tooltip" data-bs-placement="top" title="Find a Lego Set by Entering a Set Number"> <i class="fa fa-search"></i> Find Set </button>
									</div>
								</form>
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

			<nav class="navbar navbar-expand-lg navbar-dark bg-secondary" id="optionsNavBar">
				<div class="container-fluid">

					<div class="collapse navbar-collapse" id="optionsBar">
						<ul class="navbar-nav">
							<li class="nav-item mx-5">
								<a class="nav-link active" href="/search/text=/barOpen=/sort=/minYear=/maxYear=/minPieces=/maxPieces=/theme_id=/uri/"> <i class="fa fa-search"></i> Search for a Lego Set</a>
							</li>
							<li class="nav-item ms-5">
								<a class="nav-link active" id="viewSetListsLink" href="set_lists"> <i class="fa fa-list"></i> View Set Lists</a>
							</li>
							<li class="nav-item ms-5">
								<a class="nav-link active" id="viewSetsInProgressLink" href="setsInProgress"> <i class="fa fa-list"></i> View Sets In Progress</a>
							</li>
						</ul>
					</div>

					<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#optionsBar" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
						<span class="navbar-toggler-icon"></span>
					</button>
				</div>
			</nav>
		</div>
		
		<div class="container-fluid my-5">

            <div id="textDiv" class="col-auto m-3">
                <h4>
                    <dl class="row">
                        <dt class="col-sm-4">Email:</dt>
                        <dd class="col-sm-4"><input  class="form-control" type="email" value="${accountLoggedIn.email}" style="width: 80%;" disabled readonly/></dd>
                        <dd class="col-sm-4"> <a style="cursor: pointer;" data-bs-toggle="tooltip" title="Change Email Address"><i class="fa fa-edit"></i> Change Email </a></dd>
                        <br>
                        <br>
                        <dt class="col-sm-4">Password:</dt>
                        <dd class="col-sm-4"> Set</dd>
                        <dd class="col-sm-4"> <a style="cursor: pointer;" data-bs-toggle="tooltip" title="Change Password"><i class="fa fa-edit"></i> Change Password </a></dd>
                        <br>
                        <br>
                        <dt class="col-sm-4">Google Account Linked:</dt>
                        <dd class="col-sm-4"> Not Linked</dd>
                        <dd class="col-sm-4"> <a href="#">Link Account</a></dd>
                        <br>
                    </dl>
                </h4>
                <hr>
                <u class="text-danger" onclick="deleteAccount()" style="cursor: pointer;"> Delete your account</u>
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
                            <button type="button" class="btn btn-primary" style="cursor: pointer;" onclick="logout()"><i class="fa fa-sign-out"></i> Logout</button>
                        </div>
                    </div>
                </div>
            </div>
		</div>
		
		<nav class="navbar navbar-expand-md navbar-dark bg-dark fixed-bottom">
			<div class="container-fluid">
	            <ol class="breadcrumb bg-dark">
	                <li class="breadcrumb-item"><a href="/">Home</a></li>
	                <li class="breadcrumb-item text-white" aria-current="page">Profile</li>
	            </ol>
		    </div>
		</nav>
	</body>
</html>