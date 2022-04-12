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

				// This displays that if a set has been deleted from the list
				if ("${passwordIncorrect_DeleteAccount}" == "true") {
					document.getElementById("passwordTextBox_DeleteAccount").setAttribute("class", "form-control is-invalid");
					document.getElementById("passwordTextBox_DeleteAccount").setAttribute("title", "${passwordErrorMessage_DeleteAccount}");
					document.getElementById("passwordErrorHelp_DeleteAccount").setAttribute("class", "alert alert-danger");

					// This opens the deleteAccountModal
					$("#deleteAccountModal").modal("show");
				}

				// As this runs a function if there was an error changing the user's email address
				if ("${emailChangedFailed}" == "true") {
					changeEmailErrors();
				}

				// This displays to the user their email address has been changed
				if ("${emailChanged}" == "true") {
					document.getElementById("emailChangedAlert").setAttribute("class", "alert alert-success alert-dismissible fade show");
				}

				// As this runs a function if there was an error changing the user's password
				if ("${passwordChangedFailed}" == "true") {
					changePasswordErrors();
				}

				// This displays to the user their password has been changed
				if ("${passwordChanged}" == "true") {
					document.getElementById("passwordChangedAlert").setAttribute("class", "alert alert-success alert-dismissible fade show");
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
            
			// This function is called everytime a change occurs in the password textboxes to check if the entered passwords match
			function passwordsMatchCheck() {
				var password = document.getElementById("newPasswordTextBox").value;
				var confirmedPassword = document.getElementById("confirmedNewPasswordTextBox").value;

				// This checks if the entered passwords match
				// If they don't match, this highlights the sign-up password textboxes so the user knows
				// that the passwords don't match, as well as adding this error message to these textbox's
				// tooltips, unhiding the error alert box that contains the error message and finally disabling
				// the signUp button
				if (password != confirmedPassword) {
					document.getElementById("newPasswordTextBox").setAttribute("class", "form-control is-invalid");
					document.getElementById("newPasswordTextBox").setAttribute("title", "Passwords must match");
					document.getElementById("confirmedNewPasswordTextBox").setAttribute("class", "form-control is-invalid");
					document.getElementById("confirmedNewPasswordTextBox").setAttribute("title", "Passwords must match");
					document.getElementById("passwordMatchHelp").setAttribute("class", "alert alert-danger");
					document.getElementById("changePasswordButton").disabled = true;
				}
				// If the passwords do match, this highlights the sign-up password textboxes are highlighted
				// green to show the passwords do match, the error alert box that contains the error message
				// "Passwords don't match" is set to hidden and finally enabling the signUp button
				else {
					document.getElementById("newPasswordTextBox").setAttribute("class", "form-control is-valid");
					document.getElementById("newPasswordTextBox").setAttribute("title", "Enter a Password");
					document.getElementById("confirmedNewPasswordTextBox").setAttribute("class", "form-control is-valid");
					document.getElementById("confirmedNewPasswordTextBox").setAttribute("title", "Re-enter Password");
					document.getElementById("passwordMatchHelp").setAttribute("class", "d-none");
					document.getElementById("changePasswordButton").disabled = false;
				}
			}
			
			// This calls the database controller with the user's email, password and new email entered to change the users email address
			function changeEmail() {
				var newEmail = document.getElementById("newEmailTextBox").value;
				var password = document.getElementById("passwordTextBox_ChangeEmail").value;
				
				window.location = "/changeEmail/?oldEmail=${accountLoggedIn.email}&newEmail=" + newEmail + "&password=" + password;
			}
			
			// This calls the database controller with the user's email, old password and new password entered to change the users password
			function changePassword() {
				var oldPassword = document.getElementById("oldPasswordTextBox").value;
				var newPassword = document.getElementById("newPasswordTextBox").value;
				
				window.location = "/changePassword/?email=${accountLoggedIn.email}&oldPassword=" + oldPassword + "&newPassword=" + newPassword;
			}

			// These will display any errors returned by the controller when changing a users email address
			function changeEmailErrors() {
				// This displays that if the password entered was incorrect
				if ("${passwordIncorrect_ChangeEmail}" == "true") {
					document.getElementById("passwordTextBox_ChangeEmail").setAttribute("class", "form-control is-invalid");
					document.getElementById("passwordTextBox_ChangeEmail").setAttribute("title", "${passwordErrorMessage_ChangeEmail}");
					document.getElementById("passwordErrorHelp_ChangeEmail").setAttribute("class", "alert alert-danger");
				}

				// This displays that if there is a problem with the new email entered
				if ("${newEmailIncorrect}" == "true") {
					document.getElementById("newEmailTextBox").setAttribute("class", "form-control is-invalid");
					document.getElementById("newEmailTextBox").setAttribute("title", "${newEmailErrorMessage}");
					document.getElementById("newEmailErrorHelp").setAttribute("class", "alert alert-danger");
				}

				// This opens the changeEmailModal
				$("#changeEmailModal").modal("show");
			}

			// These will display any errors returned by the controller when changing a users password
			function changePasswordErrors() {
				// This displays that if the old password entered was incorrect
				if ("${oldPasswordIncorrect}" == "true") {
					document.getElementById("oldPasswordTextBox").setAttribute("class", "form-control is-invalid");
					document.getElementById("oldPasswordTextBox").setAttribute("title", "${oldPasswordErrorMessage}");
					document.getElementById("oldPasswordErrorHelp").setAttribute("class", "alert alert-danger");
				}

				// This displays that if there is a problem with the new password entered
				if ("${newPasswordIncorrect}" == "true") {
					document.getElementById("newPasswordTextBox").setAttribute("class", "form-control is-invalid");
					document.getElementById("newPasswordTextBox").setAttribute("title", "${newPasswordErrorMessage}");
					document.getElementById("confirmedNewPasswordTextBox").setAttribute("class", "form-control is-invalid");
					document.getElementById("confirmedNewPasswordTextBox").setAttribute("title", "${newPasswordErrorMessage}");
					document.getElementById("newPasswordErrorHelp").setAttribute("class", "alert alert-danger");
				}

				// This opens the changePasswordModal
				$("#changePasswordModal").modal("show");
			}

			// This function is called everytime the delete account check box is clicked,
			// and it disables and enables the deleteAccountButton depending on this
			function checkDeleteAccount() {
				if (document.getElementById("confirmDeleteAccount").checked == false) {
					document.getElementById("deleteAccountButton").disabled = true;
				}
				else {
					document.getElementById("deleteAccountButton").disabled = false;
				}
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
								<a class="nav-link active" style="cursor: pointer;" onclick="backToSearch()"> <i class="fa fa-search"></i> Search for a Lego Set</a>
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

			<!-- This alert will be display when a email address is changed -->
			<div class="d-none" id="emailChangedAlert" role="alert">
				<i class="fa fa-check-circle"></i> <strong>Email Address Changed Successfully</strong>
				<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
			</div>

			<!-- This alert will be display when a password is changed -->
			<div class="d-none" id="passwordChangedAlert" role="alert">
				<i class="fa fa-check-circle"></i> <strong>Password Changed Successfully</strong>
				<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
			</div>
		</div>
		
		<div class="container-fluid my-5">

            <div id="textDiv" class="col-auto m-3">
                <h4>
                    <dl class="row">
                        <dt class="col-sm-4">Email:</dt>
                        <dd class="col-sm-4"><input  class="form-control" type="email" value="${accountLoggedIn.email}" style="width: 80%;" disabled readonly/></dd>
                        <dd class="col-sm-4" data-bs-toggle="modal" data-bs-target="#changeEmailModal"> <a style="cursor: pointer;" data-bs-toggle="tooltip" title="Change Email Address"><i class="fa fa-edit"></i> Change Email </a></dd>
                        <br>
                        <br>
                        <dt class="col-sm-4">Password:</dt>
                        <dd class="col-sm-4"></dd>
                        <dd class="col-sm-4" data-bs-toggle="modal" data-bs-target="#changePasswordModal"> <a style="cursor: pointer;" data-bs-toggle="tooltip" title="Change Password"><i class="fa fa-edit"></i> Change Password </a></dd>
                        <br>
                    </dl>
                </h4>
                <hr>
                <h5><u class="text-danger" style="cursor: pointer;" data-bs-toggle="modal" data-bs-target="#deleteAccountModal"> Delete your account</u></h5>
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
							<button type="button" class="btn btn-primary" style="cursor: pointer;" onclick="window.location.href='/logout'"><i class="fa fa-sign-out"></i> Logout</button>
                        </div>
                    </div>
                </div>
            </div>

			<!-- Modal to Change Email -->
			<div class="modal fade" id="changeEmailModal" data-bs-backdrop="static" tabindex="-1" aria-labelledby="changeEmailModalLabel" aria-hidden="true">
				<div class="modal-dialog modal-dialog-centered">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="changeEmailModalLabel">Change Email</h5>
							<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
						</div>
						<form method="POST" id="changeEmailForm">
							<div class="modal-body">
								<div class="mb-3">
									<!-- This is a hidden input that adds the users account to the form -->
									<input type="hidden" id="emailInput_ChangeEmail" name="email" value="${accountLoggedIn.email}" path="email"/>

									<div class="mb-3">
										<label>Password:</label>
										<input type="password" class="form-control" id="passwordTextBox_ChangeEmail" placeholder="Enter Password" data-bs-toggle="tooltip" data-bs-placement="top" title="Enter your Password"/>
									</div>
									
									<!-- This will output the error message returned to the user -->
									<div id="passwordErrorHelp_ChangeEmail" class="d-none"><i class="fa fa-exclamation-circle"></i> ${passwordErrorMessage_ChangeEmail}</div>
									
									<div class="mb-3">
										<label>New Email:</label>
										<input value="${emailChangedEntered}" type="email" class="form-control" id="newEmailTextBox" placeholder="Enter Email" data-bs-toggle="tooltip" data-bs-placement="top" title="Enter your Email Address"/>
									</div>

									<!-- This will output the error message returned to the user -->
									<div id="newEmailErrorHelp" class="d-none"><i class="fa fa-exclamation-circle"></i> ${newEmailErrorMessage}</div>

								</div>
								<button type="button" id="changeEmailButton" class="btn btn-primary" style="width: 100%" onclick="changeEmail()"> Change Email</button>
							</div>
						</form>
					</div>
				</div>
			</div>

			<!-- Modal to Change Password -->
			<div class="modal fade" id="changePasswordModal" data-bs-backdrop="static" tabindex="-1" aria-labelledby="changePasswordModalLabel" aria-hidden="true">
				<div class="modal-dialog modal-dialog-centered">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="changePasswordModalLabel">Change Password</h5>
							<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
						</div>
						<form method="POST" id="changePasswordForm">
							<div class="modal-body">
								<div class="mb-3">
									<!-- This is a hidden input that adds the users account to the form -->
									<input type="hidden" id="emailInput_ChangePassword" name="email" value="${accountLoggedIn.email}" path="email"/>

									<div class="mb-3">
										<label>Password:</label>
										<input type="password" class="form-control" id="oldPasswordTextBox" placeholder="Enter Password" data-bs-toggle="tooltip" data-bs-placement="top" title="Enter your Password"/>
									</div>
									
									<!-- This will output the error message returned to the user -->
									<div id="oldPasswordErrorHelp" class="d-none"><i class="fa fa-exclamation-circle"></i> ${oldPasswordErrorMessage}</div>
									
									<div class="mb-3">
										<label>New Password:</label>
										<input oninput="passwordsMatchCheck()" type="password" class="form-control" id="newPasswordTextBox" placeholder="Enter New Password" data-bs-toggle="tooltip" data-bs-placement="top" title="Enter a Password"/>
									</div>
									<div class="mb-3">
										<label>Confirm Password:</label>
										<input oninput="passwordsMatchCheck()" type="password" class="form-control" id="confirmedNewPasswordTextBox" placeholder="Confirm New Password" data-bs-toggle="tooltip" data-bs-placement="top" title="Re-enter Password"/>  
									</div>
									
									<!-- This is hidden and will be displayed to the user via the passwordsMatchCheck function if the entered passwords don't match -->
									<div id="passwordMatchHelp" class="d-none"><i class="fa fa-exclamation-circle"></i> Passwords must match</div>

									<!-- This will output the error message returned to the user -->
									<div id="newPasswordErrorHelp" class="d-none"><i class="fa fa-exclamation-circle"></i> ${newPasswordErrorMessage}</div>

								</div>
								<button type="button" id="changePasswordButton" class="btn btn-primary" style="width: 100%" onclick="changePassword()"> Change Password</button>
							</div>
						</form>
					</div>
				</div>
			</div>

			<!-- Modal Delete Account -->
			<div class="modal fade" id="deleteAccountModal" data-bs-backdrop="static" tabindex="-1" aria-labelledby="deleteAccountModalLabel" aria-hidden="true">
				<div class="modal-dialog modal-dialog-centered">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="deleteAccountModalLabel">Delete Account</h5>
						</div>
						<form:form method="POST" id="deleteAccountForm" action="/deleteAccount" modelAttribute="account">
							<div class="modal-body">
								<div class="mb-3">
									<h5><i class="fa fa-warning"></i> Are you sure you want to delete your account?</h5>
									Once you delete your account it can not be recovered
									<br>
									<br>
									<!-- This is a hidden input that adds the users account to the form -->
									<form:input type="hidden" id="emailInput_DeleteAccount" name="email" value="${accountLoggedIn.email}" path="email"/>

									<div class="mb-3">
										<label>Password:</label>
										<form:input type="password" class="form-control" id="passwordTextBox_DeleteAccount" placeholder="Enter Password" data-bs-toggle="tooltip" data-bs-placement="top" title="Enter your Password" path="password"/>
									</div>

									<!-- This will output the error message returned to the user -->
									<div id="passwordErrorHelp_DeleteAccount" class="d-none"><i class="fa fa-exclamation-circle"></i> ${passwordErrorMessage_DeleteAccount}</div>
									<br>
									<!-- This is used so the user has to confirm they want to delete their account -->
									<div class="form-check fw-bold">
										<input class="form-check-input" type="checkbox" id="confirmDeleteAccount" onclick="checkDeleteAccount()">
										<label class="form-check-label" for="confirmDeleteAccount">Ticking this box I understand that in deleting my account none of my data can be recovered</label>
									</div>
								</div>
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
								<button type="submit" id="deleteAccountButton" class="btn btn-primary" disabled><i class="fa fa-trash"></i> Delete Account</button>
							</div>
						</form:form>
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
		    </div