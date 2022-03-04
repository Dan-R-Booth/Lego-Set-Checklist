package lego.checklist.validator;

import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import lego.checklist.domain.Account;
import lego.checklist.repository.AccountRepository;

public class AccountValidator  implements Validator {

	private AccountRepository repo;

	public AccountValidator(AccountRepository repo) {
		this.repo = repo;
	}

	@Override
	public boolean supports(Class<?> clazz) {
		return Account.class.equals(clazz);
	}

	@Override
	public void validate(Object target, Errors errors) {
		Account account = (Account) target;
		String email = account.getEmail();
		String password = account.getPassword();

		ValidationUtils.rejectIfEmpty(errors, "email", "email", "Email address connot be blank");
		
		if (email.contains(" ")) {
			errors.rejectValue("email", "email", "Email address connot contain spaces");
		}
		else if (repo.findByEmail(account.getEmail()) != null) {
			errors.rejectValue("email", "email", "Email address already in use");
		}
		// Using RFC 5322
		else if (email.equals("^[a-zA-Z0-9_!#$%&'*+/=?`{|}~^.-]+@[a-zA-Z0-9.-]+$")) {
			errors.rejectValue("email", "email", "Email address is invalid");
		}

		ValidationUtils.rejectIfEmpty(errors, "password", "password", "Password cannot be blank");
		
		if (password.contains(" ")) {
			errors.rejectValue("password", "password", "Password cannot contain spaces");
		}

	}
}