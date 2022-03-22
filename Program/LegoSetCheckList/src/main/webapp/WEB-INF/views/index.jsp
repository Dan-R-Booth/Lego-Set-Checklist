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
				
				// If the model attribute importError is true, this highlights the import input box
				// so the user knows that was an error there, as well as unhiding the error alert
				// box that contains the error message for the returned error and finally this opens
				// the importModal to the user
				if ("${importError}" == "true") {
					document.getElementById("importFile").setAttribute("class", "form-control is-invalid");
					document.getElementById("importFileErrorHelp").setAttribute("class", "alert alert-danger mt-2s");
					$("#importModal").modal("show");
				}

				// If the user successfully created an account a popup informs the user of this
				// It then opens the login form so the user can log into their account
				if ("${accountCreated}" == "true") {
					document.getElementById("accountCreatedAlert").setAttribute("class", "alert alert-success alert-dismissible fade show");
					
					// This opens the login_SignUp_Modal
					$("#login_SignUp_Modal").modal("show");
				}
				
				// If the user successfully logged into their account a popup informs the user of this
				if ("${loggedIn}" == "true") {
					alert("You have been logged in");
				}
				
				// As there was an error in login or signUp the appropriate function is run
				if ("${login_signUpErrors}" == "login") {
					LoginErrors();
				}
				else if ("${login_signUpErrors}" == "signUp") {
					SignUpErrors();
				}

				// If the account logged in is not set, the login/SignUp link is displayed enabling users to log in
				// Otherwise the logout link is displayed allowing users to logout of their account, along with
				// information only for logged in users
				if("${accountLoggedIn}" == "") {
					document.getElementById("login/signUpLink").setAttribute("class", "nav-link");
					
					//This displays the main div in body for users not logged in
					document.getElementById("loggedOutDiv").setAttribute("class", "");
				}
				else {
					document.getElementById("logoutLink").setAttribute("class", "nav-link");

					// This displays navlinks for logged in users
					document.getElementById("viewSetListsLink").setAttribute("class", "nav-link active");
					document.getElementById("viewSetsInProgressLink").setAttribute("class", "nav-link active");
					document.getElementById("profileLink").setAttribute("class", "nav-link active");

					//This displays the main div in body for users logged in
					document.getElementById("loggedInDiv").setAttribute("class", "");
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
			
			// This will check if the import file input box has a value, if it does have a value this will return the
			// file to the controller so that it can be imported.
			// and if it does not contain a file an error will be displayed
			function importCSVFile() {
				if (document.getElementById("importFile").value.length > 0) {
					var formActionURL = "/openImport/previousPage=index";

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

			// This clicks the button login-tab to switch to the login tab 
			function loginTab() {
				document.getElementById("login-tab").click();
			}

			// This clicks the button login-tab to switch to the login tab 
			function signUpTab() {
				document.getElementById("signUp-tab").click();
			}

			// This function is called everytime a change occurs in the password textboxes to check if the entered passwords match
			function passwordsMatchCheck() {
				var password = document.getElementById("passwordTextBox_SignUp").value;
				var confirmedPassword = document.getElementById("confirmedPasswordTextBox_SignUp").value;

				// This checks if the entered passwords match
				// If they don't match, this highlights the sign-up password textboxes so the user knows
				// that the passwords don't match, as well as adding this error message to these textbox's
				// tooltips, unhiding the error alert box that contains the error message and finally disabling
				// the signUp button
				if (password != confirmedPassword) {
					document.getElementById("passwordTextBox_SignUp").setAttribute("class", "form-control is-invalid");
					document.getElementById("passwordTextBox_SignUp").setAttribute("title", "Passwords must match");
					document.getElementById("confirmedPasswordTextBox_SignUp").setAttribute("class", "form-control is-invalid");
					document.getElementById("confirmedPasswordTextBox_SignUp").setAttribute("title", "Passwords must match");
					document.getElementById("passwordMatchHelp").setAttribute("class", "alert alert-danger");
					document.getElementById("submitSignUp").disabled = true;
				}
				// If the passwords do match, this highlights the sign-up password textboxes are highlighted
				// green to show the passwords do match, the error alert box that contains the error message
				// "Passwords don't match" is set to hidden and finally enabling the signUp button
				else {
					document.getElementById("passwordTextBox_SignUp").setAttribute("class", "form-control is-valid");
					document.getElementById("passwordTextBox_SignUp").setAttribute("title", "Enter a Password");
					document.getElementById("confirmedPasswordTextBox_SignUp").setAttribute("class", "form-control is-valid");
					document.getElementById("confirmedPasswordTextBox_SignUp").setAttribute("title", "Re-enter Password");
					document.getElementById("passwordMatchHelp").setAttribute("class", "d-none");
					document.getElementById("submitSignUp").disabled = false;
				}
			}

			// These will display any errors returned by the AccountValidator when validating a user login attempt
			function LoginErrors() {
				// If there is an error returned to do with the entered email address, this highlights the login email
				// textbox so the user knows that an error has been entered there, as well as adding the error message
				// to the textbox tooltip, unhiding the error alert box that contains the message and finally displaying
				// this message in a popup box
				if ("${emailValid_Login}" == "false") {
					document.getElementById("emailTextBox_Login").setAttribute("class", "form-control is-invalid");
					document.getElementById("emailTextBox_Login").setAttribute("title", "${emailErrorMessage_Login}");
					document.getElementById("emailErrorHelp_Login").setAttribute("class", "alert alert-danger");
				}
				
				// If there is an error returned to do with the entered password, this highlights the login password
				// textbox so the user knows that an error has been entered there, as well as adding the error message
				// to the textbox tooltip, unhiding the error alert box that contains the message and finally displaying
				// this message in a popup box
				if ("${passwordValid_Login}" == "false") {
					document.getElementById("passwordTextBox_Login").setAttribute("class", "form-control is-invalid");
					document.getElementById("passwordTextBox_Login").setAttribute("title", "${passwordErrorMessage_Login}");
					document.getElementById("passwordErrorHelp_Login").setAttribute("class", "alert alert-danger");
				}

				// If there is an error returned as the email address doesn't exist or the entered password is wrong,
				// this highlights the login email and password textboxes so the user knows that one or both of these
				// boxes conatin an error, as well as adding the error message to both textbox tooltips, unhiding the
				// error alert box that contains this error message and finally displaying this message in a popup box
				if("${email_passwordValid}" == "false") {
					document.getElementById("emailTextBox_Login").setAttribute("class", "form-control is-invalid");
					document.getElementById("emailTextBox_Login").setAttribute("title", "${email_passwordErrorMessage}");
					
					document.getElementById("passwordTextBox_Login").setAttribute("class", "form-control is-invalid");
					document.getElementById("passwordTextBox_Login").setAttribute("title", "${email_passwordErrorMessage}");
					
					document.getElementById("loginHelp").setAttribute("class", "alert alert-danger");
				}
				
				// This opens the login_SignUpModal
				$("#login_SignUp_Modal").modal("show");
			}

			// These will display any errors returned by the AccountValidator when validating a user Sign Up attempt
			function SignUpErrors() {
				//If there is an error but its not with the email address, the sign-up email textbox is highlighted
				// green to show it is valid.
				if ("${emailValid_SignUp}" == "true") {
					document.getElementById("emailTextBox_SignUp").setAttribute("class", "form-control is-valid");
				}
				// Otherwise if there is an error to do with the entered email address, this highlights the sign-up email
				// textbox so the user knows that an error has been entered there, as well as adding the error message
				// to the textbox tooltip, unhiding the error alert box that contains the message and finally displaying
				// this message in a popup box
				else if ("${emailValid_SignUp}" == "false") {
					document.getElementById("emailTextBox_SignUp").setAttribute("class", "form-control is-invalid");
					document.getElementById("emailTextBox_SignUp").setAttribute("title", "${emailErrorMessage_SignUp}");
					document.getElementById("emailErrorHelp_SignUp").setAttribute("class", "alert alert-danger");
				}
				
				//If there is an error but its not with the password, the sign-up password textboxes are highlighted
				// green to show it is valid.
				if ("${passwordValid_SignUp}" == "true") {
					document.getElementById("passwordTextBox_SignUp").setAttribute("class", "form-control is-valid");
					document.getElementById("confirmedPasswordTextBox_SignUp").setAttribute("class", "form-control is-valid");
				}
				// Otherwise if there is an error to do with the entered password, this highlights the sign-up password
				// textboxes so the user knows that an error has been entered there, as well as adding the error message
				// to these textbox's tooltip, unhiding the error alert box that contains the message and finally displaying
				// this message in a popup box
				else if ("${passwordValid_SignUp}" == "false") {
					document.getElementById("passwordTextBox_SignUp").setAttribute("class", "form-control is-invalid");
					document.getElementById("passwordTextBox_SignUp").setAttribute("title", "${passwordErrorMessage_SignUp}");
					document.getElementById("confirmedPasswordTextBox_SignUp").setAttribute("class", "form-control is-invalid");
					document.getElementById("confirmedPasswordTextBox_SignUp").setAttribute("title", "${passwordErrorMessage_SignUp}");
					document.getElementById("passwordErrorHelp_SignUp").setAttribute("class", "alert alert-danger");
				}

				// This opens the login_SignUpModal
				$("#login_SignUp_Modal").modal("show");
				
				// This switches to the signUp tab
				signUpTab();
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
					<a class="navbar-brand"> Lego: Set Checklist Creator </a>

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
								<a class="d-none" id="login/signUpLink" style="cursor: pointer;" data-bs-toggle="modal" data-bs-target="#login_SignUp_Modal"> <i class="fa fa-sign-in"></i> Login/SignUp</a>
							</li>
							<li class="nav-item ms-5">
								<a class="d-none" id="logoutLink" style="cursor: pointer;" data-bs-toggle="modal" data-bs-target="#logoutModal"> <i class="fa fa-sign-out"></i> Logout</a>
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
								<a class="nav-link active" style="cursor: pointer;" data-bs-toggle="modal" data-bs-target="#importModal"> <i class="fa fa-upload"></i> Import Checklist</a>
							</li>
							<li class="nav-item ms-5">
								<a class="d-none" id="viewSetListsLink" href="set_lists"> <i class="fa fa-list"></i> View Set Lists</a>
							</li>
							<li class="nav-item ms-5">
								<a class="d-none" id="viewSetsInProgressLink" href="setsInProgress"> <i class="fa fa-list"></i> View Sets In Progress</a>
							</li>
							<li class="nav-item ms-5">
								<a class="d-none" id="profileLink" href="profile"> <i class="fa fa-user"></i> Profile</a>
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
			<div id="loggedOutDiv" class="d-none">
				hi
			</div>

			<div id="loggedInDiv" class="d-none">
				Hi ${accountLoggedIn.email}
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
								<button type="button" id="importFileButton" class="btn btn-primary" onclick="importCSVFile()"> <i class="fa fa-upload"></i> Import </button>
							</div>
						</form>
					</div>
				</div>
			</div>
			
			<!-- Modal to Login or Sign Up -->
			<div class="modal fade" id="login_SignUp_Modal" data-bs-backdrop="static" tabindex="-1" aria-labelledby="login_SignUp_ModalLabel" aria-hidden="true">
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
							<!-- Tab that displays the login form to the user, so they can login to their account -->
							<div class="tab-pane fade show active" id="login" role="tabpanel" aria-labelledby="login-tab">
								<form:form id="login_form" action="/login" modelAttribute="account">
									<div class="modal-body">
										<!-- This alert will be display when an account has just been created -->
										<div class="d-none" id="accountCreatedAlert" role="alert">
											<i class="fa fa-check-circle"></i> <strong>Account Successfully Created</strong>
											<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
										</div>
										<div class="text-center">
											<button type="button" class="btn btn-outline-dark">Continue With Google</button>
										</div>
										<div class="container-fluid">
											<hr>
											<div class="mb-3">
												<label>Email:</label>
												<form:input type="email" class="form-control" id="emailTextBox_Login" placeholder="Enter Email" data-bs-toggle="tooltip" data-bs-placement="top" title="Enter your Email Address" path="email"/>
											</div>
												
											<!-- This will output the error message returned to the user -->
											<div id="emailErrorHelp_Login" class="d-none"><i class="fa fa-exclamation-circle"></i> ${emailErrorMessage_Login}</div>

											<div class="mb-3">
												<label>Password:</label>
												<form:input type="password" class="form-control" id="passwordTextBox_Login" placeholder="Enter Password" data-bs-toggle="tooltip" data-bs-placement="top" title="Enter your Password" path="password"/>
											</div>
	
											<!-- This will output the error message returned to the user -->
											<div id="passwordErrorHelp_Login" class="d-none"><i class="fa fa-exclamation-circle"></i> ${passwordErrorMessage_Login}</div>

											<!-- This will output the error message returned to the user -->
											<div id="loginHelp" class="d-none"><i class="fa fa-exclamation-circle"></i> ${email_passwordErrorMessage}</div>

											<button type="submit" value="Login" id="submitLogin" class="btn btn-primary" style="width: 100%"> <i class="fa fa-sign-in"></i> Login</button>
											<hr>
											<div class="text-center">
												<!-- This calls a function to switch to the sign-up tab -->
												Don't have an account? <a style="display: inline-block" href="#" onclick="signUpTab()">Sign Up</a>
											</div>
										</div>
									</div>
								</form:form>
							</div>
							<!-- Tab that displays the sign-up form to the user, so they can create an account -->
							<div class="tab-pane fade" id="signUp" role="tabpanel" aria-labelledby="signUp-tab">
								<form:form id="signUp_form" action="/signUp" modelAttribute="account">
									<div class="modal-body">
										<div class="text-center">
											<button type="button" class="btn btn-outline-dark">Continue With Google</button>
										</div>
										<div class="container-fluid">
											<hr>
											<div class="mb-3">
												<label>Email:</label>
												<form:input type="email" class="form-control" id="emailTextBox_SignUp" placeholder="Enter Email" data-bs-toggle="tooltip" data-bs-placement="top" title="Enter your Email Address" path="email"/>
											</div>

											<div id="emailErrorHelp_SignUp" class="d-none"><i class="fa fa-exclamation-circle"></i> ${emailErrorMessage_SignUp}</div>
							
											<div class="mb-3">
												<label>Password:</label>
												<form:input oninput="passwordsMatchCheck()" type="password" class="form-control" id="passwordTextBox_SignUp" placeholder="Enter Password" data-bs-toggle="tooltip" data-bs-placement="top" title="Enter a Password" path="password"/>
											</div>
											<div class="mb-3">
												<label>Confirm Password:</label>
												<input oninput="passwordsMatchCheck()" type="password" class="form-control" id="confirmedPasswordTextBox_SignUp" placeholder="Confirm Password" data-bs-toggle="tooltip" data-bs-placement="top" title="Re-enter Password"/>  
											</div>
											
											<!-- This is hidden and will be displayed to the user via the signUp function if the entered passwords don't match -->
											<div id="passwordMatchHelp" class="d-none"><i class="fa fa-exclamation-circle"></i> Passwords must match</div>
											<div id="passwordErrorHelp_SignUp" class="d-none"><i class="fa fa-exclamation-circle"></i> ${passwordErrorMessage_SignUp}</div>
							
											<button type="submit" value="SignUp" id="submitSignUp" class="btn btn-primary" style="width: 100%"> <i class="fa fa-user-plus"></i> Create an Account</button>
											<hr>
											<div class="text-center">
												<!-- This calls a function to switch to the login tab -->
												Already have an account? <a style="display: inline-block" href="#" onclick="loginTab()">Login</a>
											</div>
										</div>
									</div>
								</form:form>
							</div>
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

			<!-- Modal to confirm logout-->
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
	                <li class="breadcrumb-item text-white" aria-current="page">Home</li>
	            </ol>
		    </div>
		</nav>
	</body>
</html>