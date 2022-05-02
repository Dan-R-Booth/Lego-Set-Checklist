package lego.checklist.validator;

import java.security.spec.KeySpec;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import lego.checklist.domain.Account;
import lego.checklist.repository.AccountRepository;

/* References:
* [1]	S. Millington, "Hashing a Password in Java", Baeldung,
* 		2022. [Online].
* 		Available: https://www.baeldung.com/java-password-hashing. [Accessed: 10- Apr- 2022]
* [2]	L. Gupta, "Java - Create a Secure Password Hash - HowToDoInJava",
* 		HowToDoInJava, 2022. [Online].
* 		Available: https://howtodoinjava.com/java/java-security/how-to-generate-secure-password-hash-md5-sha-pbkdf2-bcrypt-examples/. [Accessed: 10- Apr- 2022]
*/

// This is used to check a user's entered email and password to create an account, and the entered email and password to login to an account. 
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
		if (email.isEmpty()) {
			ValidationUtils.rejectIfEmpty(errors, "email", "email", "Email address connot be blank");
		}

		// These check that an account does not already exist with the entered email. If the email
		// is in use an error message is added to the instance of the Errors class errors
		if (repo.findByEmail(account.getEmail()) != null) {
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
	public void validateLogin(Object target, Errors errors) throws Exception {
		Account account = (Account) target;
		String email = account.getEmail();
		String password = account.getPassword();
		
		// This confirms if the entered email is blank or not and if it is returns an error message
		if (email.isEmpty()) {
			ValidationUtils.rejectIfEmpty(errors, "email", "email", "Email address connot be blank");
		}

		// This confirms if the entered password is blank or not and if it is returns an error message
		if (password.isEmpty()) {
			ValidationUtils.rejectIfEmpty(errors, "password", "password", "Password cannot be blank");
		}
		
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
				String accountPassword = accountFound.getPassword();
				
				
				/*
				 * From here until the end of the function I have used code from the websites [1] and [2].
				 */
				
				// This uses code from website [2] to retrieve the saved password hash and salt from the data base.
				String[] parts = accountPassword.split(":");

				byte[] storedPasswordHash = fromHex(parts[0]);
				byte[] salt = fromHex(parts[1]);
				
				/*
				 * Here I have used code from the website [1] to hash and salt the inputed password,
				 * using a PBKDF2 hash and the salt saved in the database
				 */
				KeySpec spec = new PBEKeySpec(password.toCharArray(), salt, 65536, 128);
				SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
				
				byte[] hash = factory.generateSecret(spec).getEncoded();
				
				/*
				 * Here I have used code from this website [2] to compare the saved hashed
				 * password in the database to the hashed inputed password
				 */
				int diff = storedPasswordHash.length ^ hash.length;
			    for(int i = 0; i < storedPasswordHash.length && i < hash.length; i++)
			    {
			        diff |= storedPasswordHash[i] ^ hash[i];
			    }
				
			    if (diff != 0) {
					errors.rejectValue("email", "email_password", "Email address and/or Password incorrect");
					errors.rejectValue("password", "email_password", "Email address and/or Password incorrect");
				}
			}
		}
	}

	/*
	 * Here I have used code from the website [2] to turn hex into byte array,
	 * as this was not vital to the main function of the program but need for
	 * being able to retrieve the hash and salt stored in the database.
	 */
	private static byte[] fromHex(String hex) {
	    byte[] bytes = new byte[hex.length() / 2];
	    for(int i = 0; i < bytes.length ;i++)
	    {
	        bytes[i] = (byte)Integer.parseInt(hex.substring(2 * i, 2 * i + 2), 16);
	    }
	    return bytes;
	}
}