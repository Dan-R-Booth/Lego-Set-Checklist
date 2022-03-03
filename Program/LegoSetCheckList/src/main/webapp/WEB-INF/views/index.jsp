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
					document.getElementById("viewport").setAttribute("content", "width=350");
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
					$("#spinnerModal").modal("show");
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

			// This clicks the button login-tab to switch to the login tab 
			function loginTab() {
				document.getElementById("login-tab").click();
			}

			// This clicks the button login-tab to switch to the login tab 
			function signUpTab() {
				document.getElementById("signUp-tab").click();
			}

			// This will check for basic errors with the entered email and passwords needed to create an account
			// If there are no errors these are then sent to the Account Controller
			function signUp() {
				var email = document.getElementById("emailTextBox-SignUp").value;
				var password1 = document.getElementById("password1TextBox-SignUp").value;
				var password2 = document.getElementById("password2TextBox-SignUp").value;

				var fail = false;

				// This performs error handling for errors with the entered email address
				if (email.search(" ") != -1) {
					document.getElementById("emailTextBox-SignUp").setAttribute("class", "form-control is-invalid");
					document.getElementById("emailTextBox-SignUp").setAttribute("title", "Email cannot contain spaces");
					document.getElementById("emailSpacesHelp").setAttribute("class", "alert alert-danger");
					document.getElementById("emailBlankHelp").setAttribute("class", "d-none");
					document.getElementById("emailTakenHelp").setAttribute("class", "d-none");
					document.getElementById("emailInvalid").setAttribute("class", "d-none");
					alert("Email cannot contain spaces");
					fail = true;
				}
				else if (email == "") {
					document.getElementById("emailTextBox-SignUp").setAttribute("class", "form-control is-invalid");
					document.getElementById("emailTextBox-SignUp").setAttribute("title", "Email cannot be blank");
					document.getElementById("emailBlankHelp").setAttribute("class", "alert alert-danger");
					document.getElementById("emailSpacesHelp").setAttribute("class", "d-none");
					document.getElementById("emailTakenHelp").setAttribute("class", "d-none");
					document.getElementById("emailInvalid").setAttribute("class", "d-none");
					alert("Email cannot be blank");
					fail = true;
				}
				else if (!email.includes("@")) {
					document.getElementById("emailTextBox-SignUp").setAttribute("class", "form-control is-invalid");
					document.getElementById("emailTextBox-SignUp").setAttribute("title", "Email requires '@' Symbol");
					document.getElementById("emailInvalid").setAttribute("class", "alert alert-danger");
					document.getElementById("emailBlankHelp").setAttribute("class", "d-none");
					document.getElementById("emailSpacesHelp").setAttribute("class", "d-none");
					document.getElementById("emailTakenHelp").setAttribute("class", "d-none");
					alert("Email Address is not Valid, it requires the '@' Symbol");
					fail = true;
				}
				else {
					document.getElementById("emailTextBox-SignUp").setAttribute("class", "form-control is-valid");
					document.getElementById("emailTextBox-SignUp").setAttribute("title", "Enter your Email Address");
					document.getElementById("emailSpacesHelp").setAttribute("class", "d-none");
					document.getElementById("emailBlankHelp").setAttribute("class", "d-none");
					document.getElementById("emailTakenHelp").setAttribute("class", "d-none");
					document.getElementById("emailInvalid").setAttribute("class", "d-none");
				}

				// This performs error handling for errors with the entered password
				if (password1 == "" || password2 == "") {

					if (password1 == "") {
						document.getElementById("password1TextBox-SignUp").setAttribute("class", "form-control is-invalid");
						document.getElementById("password1TextBox-SignUp").setAttribute("title", "Password cannot be blank");
					}

					if (password2 == "") {
						document.getElementById("password2TextBox-SignUp").setAttribute("class", "form-control is-invalid");
						document.getElementById("password2TextBox-SignUp").setAttribute("title", "Password cannot be blank");
					}

					document.getElementById("passwordBlankHelp").setAttribute("class", "alert alert-danger");
					document.getElementById("passwordMatchHelp").setAttribute("class", "d-none");
					document.getElementById("passwordSpacesHelp").setAttribute("class", "d-none");
					alert("Password cannot be blank");
					fail = true;
				}
				else if (password1 != password2) {
					document.getElementById("password1TextBox-SignUp").setAttribute("class", "form-control is-invalid");
					document.getElementById("password1TextBox-SignUp").setAttribute("title", "Passwords must match");
					document.getElementById("password2TextBox-SignUp").setAttribute("class", "form-control is-invalid");
					document.getElementById("password2TextBox-SignUp").setAttribute("title", "Passwords must match");
					document.getElementById("passwordMatchHelp").setAttribute("class", "alert alert-danger");
					document.getElementById("passwordBlankHelp").setAttribute("class", "d-none");
					document.getElementById("passwordSpacesHelp").setAttribute("class", "d-none");
					alert("Passwords do not match");
					fail = true;
				}
				else if ((password1.search(" ") != -1) || (password2.search(" ") != -1)) {
					document.getElementById("password1TextBox-SignUp").setAttribute("class", "form-control is-invalid");
					document.getElementById("password1TextBox-SignUp").setAttribute("title", "Password cannot contain spaces");
					document.getElementById("password2TextBox-SignUp").setAttribute("class", "form-control is-invalid");
					document.getElementById("password2TextBox-SignUp").setAttribute("title", "Password cannot contain spaces");
					document.getElementById("passwordSpacesHelp").setAttribute("class", "alert alert-danger");
					document.getElementById("passwordMatchHelp").setAttribute("class", "d-none");
					document.getElementById("passwordBlankHelp").setAttribute("class", "d-none");
					alert("Password cannot contain spaces");
					fail = true;
				}
				else {
					document.getElementById("password1TextBox-SignUp").setAttribute("class", "form-control is-valid");
					document.getElementById("password1TextBox-SignUp").setAttribute("title", "Enter a Password");
					document.getElementById("password2TextBox-SignUp").setAttribute("class", "form-control is-valid");
					document.getElementById("password2TextBox-SignUp").setAttribute("title", "Re-enter Password");
					document.getElementById("passwordMatchHelp").setAttribute("class", "d-none");
					document.getElementById("passwordBlankHelp").setAttribute("class", "d-none");
					document.getElementById("passwordSpacesHelp").setAttribute("class", "d-none");
				}

				if (fail == false) {
					
					alert("Account Successfully Created");
					window.location = "/SignUp/?email=" + email + "&password=" + password1;
				}
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
										<button class="btn btn-primary" type="button" onclick="findSet()" data-bs-toggle="tooltip" data-bs-placement="top" title="Find a Lego Set by Entering a Set Number"> <i class="fa fa-search"></i> Find Set </button>
									</div>
								</form>
							</li>
						</ul>
						<ul class="navbar-nav">
							<li class="nav-item mx-5">
								<a class="nav-link" href="#" data-bs-toggle="modal" data-bs-target="#login-signUp-Modal"> <i class="fa fa-sign-in"></i> Login/SignUp</a>
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
			
			<!-- Modal to Login or Sign Up -->
			<div class="modal fade" id="login-signUp-Modal" data-bs-backdrop="static" tabindex="-1" aria-labelledby="login-signUp-ModalLabel" aria-hidden="true">
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
												<input type="text" class="form-control" id="emailTextBox-Login" aria-describedby="emailHelp" placeholder="Enter Email" data-bs-toggle="tooltip" data-bs-placement="top" title="Enter your Email Address"/>
											</div>
							
											<div class="mb-3">
												<label>Password:</label>
												<input type="password" class="form-control" id="passwordTextBox-Login" placeholder="Enter Password" data-bs-toggle="tooltip" data-bs-placement="top" title="Enter your Password"/>
											</div>
											
											<div id="loginHelp" class="d-none"><i class="fa fa-exclamation-circle"></i> Email and/or Password incorrect</div>

											<button type="button" value="Login" id="submitLogin" onclick="login()" class="btn btn-primary" style="width: 100%"> <i class="fa fa-sign-in"></i> Login</button>
										</div>
										<hr>
										<div class="text-center">
											<!-- This calls a function to switch to the sign-up tab -->
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
										<hr style="width: 70%">
										<div class="container-fluid">
											<div class="mb-3">
												<label>Email:</label>
												<input type="text" class="form-control" id="emailTextBox-SignUp" aria-describedby="emailHelp" placeholder="Enter Email" data-bs-toggle="tooltip" data-bs-placement="top" title="Enter your Email Address"/>
											</div>
							
											<div id="emailInvalid" class="d-none"><i class="fa fa-exclamation-circle"></i> Email is Invalid</div>
											<div id="emailTakenHelp" class="d-none"><i class="fa fa-exclamation-circle"></i> Email must be unique</div>
											<div id="emailBlankHelp" class="d-none"><i class="fa fa-exclamation-circle"></i> Email connot be blank</div>
											<div id="emailSpacesHelp" class="d-none"><i class="fa fa-exclamation-circle"></i> Email connot contain spaces</div>
							
											<div class="mb-3">
												<label>Password:</label>
												<input type="password" class="form-control" id="password1TextBox-SignUp" placeholder="Enter Password" data-bs-toggle="tooltip" data-bs-placement="top" title="Enter a Password"/>
											</div>
											<div class="mb-3">
												<label>Confirm Password:</label>
												<input type="password" class="form-control" id="password2TextBox-SignUp" placeholder="Confirm Password" data-bs-toggle="tooltip" data-bs-placement="top" title="Re-enter Password"/>  
											</div>
											
											<div id="passwordMatchHelp" class="d-none"><i class="fa fa-exclamation-circle"></i> Passwords must match</div>
											<div id="passwordBlankHelp" class="d-none"><i class="fa fa-exclamation-circle"></i> Passwords cannot be blank</div>
											<div id="passwordSpacesHelp" class="d-none"><i class="fa fa-exclamation-circle"></i> Password cannot contain spaces</div>
							
											<button type="button" value="SignUp" id="submitSignUp" onclick="signUp()" class="btn btn-primary" style="width: 100%"> <i class="fa fa-user-plus"></i> Create an Account</button>
											<hr>
											<div class="text-center">
												<!-- This calls a function to switch to the login tab -->
												Already have an account? <a style="display: inline-block" href="#" onclick="loginTab()">Login</a>
											</div>
										</div>
									</div>
								</form>
							</div>
						</div>
					</div>
				</div>
			</div>

			<!-- Modal to Import a Lego Checklist -->
			<div class="modal fade" id="spinnerModal" data-bs-backdrop="static" tabindex="-1" aria-labelledby="spinnerModalLabel" aria-hidden="true">
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