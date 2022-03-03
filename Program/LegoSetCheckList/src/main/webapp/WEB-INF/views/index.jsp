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
					document.getElementById("viewport").setAttribute("content","width=350");
				}
				
				if ("${error}" == "true") {
					document.getElementById("importFile").setAttribute("class", "form-control is-invalid");
					document.getElementById("importFileErrorHelp").setAttribute("class", "alert alert-danger mt-2s");
					var importModal = new bootstrap.Modal(document.getElementById("importModal"));
					importModal.show();
				}
			}

			// This will take the users to the set page for the Lego Set that matches the entered set number and variant
			// Or will inform them if the set number or set variant box is empty
			function findSet() {
				var set_number = document.getElementById("set_number").value;
				var set_variant = document.getElementById("set_variant").value;
				
				if (set_number.length == 0) {
					document.getElementById("set_number").setAttribute("class", "form-control col-xs-1 is-invalid");
					document.getElementById("set_number").setAttribute("title","Set Number Cannot be Empty");
					alert("Set Number Cannot be Empty");
				}
				else {
					document.getElementById("set_number").setAttribute("class", "form-control col-xs-1 is-valid");
					document.getElementById("set_number").setAttribute("title","Set Number Cannot be Empty");
				}
				
				if (set_variant.length == 0) {
					document.getElementById("set_variant").setAttribute("class", "form-control col-xs-1 is-invalid");
					document.getElementById("set_variant").setAttribute("title","Set Variant Cannot be Empty");
					alert("Set Variant Cannot be Empty");
				}
				else {
					document.getElementById("set_variant").setAttribute("class", "form-control col-xs-1 is-valid");
					document.getElementById("set_variant").setAttribute("title","Set Variant Cannot be Empty");
				}
				
				if ((set_number.length != 0) && (set_variant.length != 0)) {					
					window.location = "/set/?set_number=" + set_number + "&set_variant=" + set_variant;
				}
			}
			
			// This will check if the import file input box has a value, if it does have a value this will return the
			// file to the controller so that it can be imported.
			// and if it does not contain a file an error will be displayed
			function importCSVFile() {
				if (document.getElementById("importFile").value.length > 0) {
					var formActionURL = "/openImport/previousPage=index";

					document.getElementById("importForm").setAttribute("action", formActionURL);
					document.getElementById("importForm").submit();
				}
				else {
					document.getElementById("importFile").setAttribute("class", "form-control is-invalid");
        			document.getElementById("importFileNoneHelp").setAttribute("class", "alert alert-danger");
					document.getElementById("importFileErrorHelp").setAttribute("class", "d-none");
				}
			}

			function loginTab() {
				document.getElementById("login-tab").click();
			}

			function signUpTab() {
				document.getElementById("signUp-tab").click();
			}
			
		</script>

	</head>
	<body onload="setup()">
		<!-- This uses bootstrap so that everything in this div stays at the top of the page when it's scrolled down -->
		<div class="sticky-top" data-toggle="affix">
			<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
				<div class="container-fluid">
					<a class="navbar-brand" href="/"> Lego: Set Checklist Creator </a>

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
							<li class="nav-item mx-5">
								<a class="nav-link active" href="#" data-bs-toggle="modal" data-bs-target="#importModal"> <i class="fa fa-upload"></i> Import Checklist</a>
							</li>
						</ul>
					</div>

					<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#optionsBar" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
						<span class="navbar-toggler-icon"></span>
					</button>
				</div>
			</nav>
		</div>
		
		<div class="container-fluid mb-5">
			
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
									<input class="form-control" type="file" id="importFile" name="importFile" accept=".csv" required>
								</div>

								<div id="importFileNoneHelp" class="d-none"><i class="fa fa-exclamation-circle"></i> Please select a CSV file to upload.</div>
								<div id="importFileErrorHelp" class="d-none"><i class="fa fa-exclamation-circle"></i> ${message}</div>
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
								<button type="button" id="importFileButton" class="btn btn-primary" onclick="importCSVFile()"> <i class="fa fa-upload"></i> Import </button>
							</div>
						</form>
					</div>
				</div>
			</div>
			
			<!-- Button trigger modal -->
			<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#login-signUp-Modal">
				Login/Logout
			</button>
			
			<!-- Modal to Login or Sign Up -->
			<div class="modal fade" id="login-signUp-Modal" data-bs-backdrop="static" tabindex="-1" aria-labelledby="login-signUp-Modal" aria-hidden="true">
				<div class="modal-dialog modal-dialog-centered">
					<div class="modal-content">
						<div class="modal-header">
							<ul class="nav nav-tabs" id="Login-SignUp-Tabs" role="tablist">
								<li class="nav-item" role="presentation">
							    	<button class="nav-link active" id="login-tab" data-bs-toggle="tab" data-bs-target="#login" type="button" role="tab" aria-controls="login" aria-selected="true">Login</button>
								</li>
							 	<li class="nav-item" role="presentation">
							   		<button class="nav-link" id="signUp-tab" data-bs-toggle="tab" data-bs-target="#signUp" type="button" role="tab" aria-controls="signUp" aria-selected="false">Sign Up</button>
							  	</li>
							</ul>
							<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
						</div>
						<div class="tab-content" id="login-signUp-tabContent">
							<!-- Tab to display login information -->
							<div class="tab-pane fade show active" id="login" role="tabpanel" aria-labelledby="login-tab">
								<form id="login_form_id" method="post" name="login_form">
									<div class="modal-body">
										<div class="text-center">
											<button type="button" class="btn btn-outline-dark">Continue With Google</button>
										</div>
										<hr>
										<div class="container-fluid">
											<div class="mb-3">
												<label>Email:</label>
												<input type="text" class="form-control" id="emailTextBox-Login" aria-describedby="usernameHelp" placeholder="Enter Email">
											</div>
							
											<div class="mb-3">
												<label>Password:</label>
												<input type="password" class="form-control" id="passwordTextBox-Login" placeholder="Enter Password"></input>
											</div>
											
											<div id="loginHelp" class="d-none"><i class="fa fa-exclamation-circle"></i> Username and/or Password incorrect</div>

											<button type="button" value="Login" id="submitLogin" onclick="validate()" class="btn btn-primary"> <i class="fa fa-sign-in"></i> Login</button>
										</div>
										<hr>
										<div class="text-center">
											Don't have an account? <a style="display: inline-block" href="#" onclick="signUpTab()">Sign Up</a>
										</div>
									</div>
								</form>
							</div>
							<!-- Tab to display sign-up information -->
							<div class="tab-pane fade" id="signUp" role="tabpanel" aria-labelledby="signUp-tab">
								<form id="signUp_form_id" method="post" name="signUp_form">
									<div class="modal-body">
										<div class="text-center">
											<button type="button" class="btn btn-outline-dark">Continue With Google</button>
										</div>
										<hr>
										<div class="container-fluid">
											<div class="mb-3">
												<label>Email:</label>
												<input type="text" class="form-control" id="emailTextBox-SignUp" aria-describedby="usernameHelp" placeholder="Enter username">
											</div>
							
											<div id="usernameTakenHelp" class="d-none"><i class="fa fa-exclamation-circle"></i> Username must be unique</div>
											<div id="usernameBlankHelp" class="d-none"><i class="fa fa-exclamation-circle"></i> Username connot be blank</div>
											<div id="usernameSpacesHelp" class="d-none"><i class="fa fa-exclamation-circle"></i> Username connot contain spaces</div>
							
											<div class="mb-3">
												<label>Password:</label>
												<input type="password" class="form-control" id="passwordTextBox1-SignUp" placeholder="Enter password">
											</div>
											<div class="mb-3">
												<label>Confirm Password:</label>
												<input type="password" class="form-control" id="passwordTextBox2-SignUp" placeholder="Re-enter password">  
											</div>
											
											<div id="passwordMatchHelp" class="d-none"><i class="fa fa-exclamation-circle"></i> Passwords must match</div>
											<div id="passwordBlankHelp" class="d-none"><i class="fa fa-exclamation-circle"></i> Passwords cannot be blank</div>
											<div id="passwordSpacesHelp" class="d-none"><i class="fa fa-exclamation-circle"></i> Password cannot contain spaces</div>
							
											<button type="button" value="SignUp" id="submitSignUp" onclick="validate()" class="btn btn-primary"> <i class="fa fa-user-plus"></i> Sign Up</button>
											<hr>
											<div class="text-center">
												Already have an account? <a class="" style="display: inline-block" href="#" onclick="loginTab()">Login</a>
											</div>
										</div>
									</div>
								</form>
							</div>
						</div>
					</div>
				</div>
			</div>

		</div>
		
		<nav class="navbar navbar-expand-md navbar-dark bg-dark fixed-bottom">
			<div class="container-fluid">
	            <ol class="breadcrumb bg-dark">
	                <li class="breadcrumb-item text-white" aria-current="page">Home</li>
	            </ol>
		    </div>
		</nav>
	</body>
</html>