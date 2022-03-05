package lego.checklist.validator;

import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import lego.checklist.domain.Account;
import lego.checklist.repository.AccountRepository;

public class AccountValidator implements Validator {

	private AccountRepository repo;

	public AccountValidator(AccountRepository repo) {
		this.repo = repo;
	}

	@Override
	public boolean supports(Class<?> clazz) {
		return Account.class.equals(clazz);
	}

	@Override
	// This function is used to validate a user sign-up request
	public void validate(Object target, Errors errors) {
		Account account = (Account) target;
		String email = account.getEmail();
		String password = account.getPassword();

		// This confirms if the entered email is blank or not and if it is an error message is added
		// to the instance of the Errors class errors
		ValidationUtils.rejectIfEmpty(errors, "email", "email", "Email address connot be blank");

		// These check that the email address contains no spaces, that it is in a valid format and
		// that an account does not already exist with the entered email.
		// If any of these are wrong an error message is added to the instance of the Errors class errors
		if (email.contains(" ")) {
			errors.rejectValue("email", "email", "Email address connot contain spaces");
		}
		// Using RFC 5322
		else if (email.equals("^[a-zA-Z0-9_!#$%&'*+/=?`{|}~^.-]+@[a-zA-Z0-9.-]+$")) {
			errors.rejectValue("email", "email", "Email address is invalid");
		}
		else if (repo.findByEmail(account.getEmail()) != null) {
			errors.rejectValue("email", "email", "Email address already in use");
		}

		// This confirms if the entered password is blank or not and if it is returns an error message
		ValidationUtils.rejectIfEmpty(errors, "password", "password", "Password cannot be blank");
		
		// This checks that the password contains no spaces, and if it does an error message is
		// added to the instance of the Errors class errors
		if (password.contains(" ")) {
			errors.rejectValue("password", "password", "Password cannot contain spaces");
		}
	}
	
	// This function is used to validate a user login request
	public void validateLogin(Object target, Errors errors) {
		Account account = (Account) target;
		String email = account.getEmail();
		String password = account.getPassword();

		// This confirms if the entered email is blank or not and if it is returns an error message
		ValidationUtils.rejectIfEmpty(errors, "email", "email", "Email address connot be blank");
		
		// These check that the email address contains no space, that it is in a valid format.
		// If any of these are wrong an error message is added to the instance of the Errors class errors
		if (email.contains(" ")) {
			errors.rejectValue("email", "email", "Email address connot contain spaces");
		}
		// Using RFC 5322
		else if (email.equals("^[a-zA-Z0-9_!#$%&'*+/=?`{|}~^.-]+@[a-zA-Z0-9.-]+$")) {
			errors.rejectValue("email", "email", "Email address is invalid");
		}

		// This confirms if the entered password is blank or not and if it is returns an error message
		ValidationUtils.rejectIfEmpty(errors, "password", "password", "Password cannot be blank");
		
		
		// If no errors have currently been found the following will run
		if (errors.getAllErrors().isEmpty()) {
		
			// This checks if the email entered matches an existing account, and if it does not an error
			// message telling the user their was a problem logging in is added to the instance of the
			// Errors class errors
			if (repo.findByEmail(account.getEmail()) == null) {
				errors.rejectValue("email", "email", "Email address or/and Password incorrect");
				errors.rejectValue("password", "password", "Email address or/and Password incorrect");
			}
			// Otherwise if there ia an account with that email address, the entered password and the
			// accounts password are compared. If the passwords don't match an error message telling
			// the user their was a problem logging in is added to the instance of the Errors class errors
			else {
				Account accountFound = repo.findByEmail(account.getEmail());
				
				if (!accountFound.getPassword().equals(password)) {
					errors.rejectValue("email", "email_password", "Email address and/or Password incorrect");
					errors.rejectValue("password", "email_password", "Email address and/or Password incorrect");
				}
			}
		}
	}
}