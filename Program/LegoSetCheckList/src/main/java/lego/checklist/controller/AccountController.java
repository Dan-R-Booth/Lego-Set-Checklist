package lego.checklist.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lego.checklist.domain.Account;
import lego.checklist.domain.SetInSetList;
import lego.checklist.domain.Set_list;
import lego.checklist.domain.SetsOwnedList;
import lego.checklist.repository.AccountRepository;
import lego.checklist.repository.Set_listRepository;
import lego.checklist.repository.SetsOwnedListRepository;
import lego.checklist.validator.AccountValidator;

@Controller
@SessionAttributes({"accountLoggedIn", "set_lists"})
public class AccountController {

	@Autowired
	private AccountRepository accountRepo;

	@Autowired
	private SetsOwnedListRepository setsOwnedListRepo;
	
	@Autowired
	private Set_listRepository set_listRepo;
	
	// This will create an new account for a user, as long as the entered details are valid
	@PostMapping("/signUp")
	public String signUp(@ModelAttribute Account account, BindingResult result, Model model, RedirectAttributes redirectAttributes) {
		// This creates an instance of the AccountValidator and calls the validate function
		// with an Account generated using values entered in the signUp form. This function
		// then checks if there are any errors with the accounts details and if there are
		// adds these to the BindingResult result
		AccountValidator accountValidator = new AccountValidator(accountRepo);
		accountValidator.validate(account, result);
		
		// This function will run if there are any errors returned by the AccountValidator class
		if (result.hasErrors()) {			
			// This are used and added to the model so the JSP knows where the error occurs
			boolean emailValid = true;
			boolean passwordValid = true;
			
			// This loop goes through all the errors comparing their error code with the certain
			// error codes, so that the boolean values can be updated to show there is an error
			// and adding this errors message to the model of that error code type 
			for (ObjectError error : result.getAllErrors()) {
				if (error.getCode().equals("email")) {
					emailValid = false;
					model.addAttribute("emailErrorMessage_SignUp", error.getDefaultMessage());
				}
				else if (error.getCode().equals("password")) {
					passwordValid = false;
					System.out.println(error.getDefaultMessage());
					model.addAttribute("passwordErrorMessage_SignUp", error.getDefaultMessage());
				}
			}
			
			model.addAttribute("emailValid_SignUp", emailValid);
			model.addAttribute("passwordValid_SignUp", passwordValid);
			
			// This is used so that the index page knows that the sign-up returned errors
			model.addAttribute("login_signUpErrors", "signUp");
			
			return "index";
		}
		// This adds the created account to the database table Accounts
		accountRepo.save(account);
		
		// This creates a set_list called setsOwnedList for the new user with
		// an empty list of sets and saves list to the database table SetLists
		List<SetInSetList> setsInSetList = new ArrayList<>();
		Set_list set_list = new Set_list(account, "Sets Owned List", setsInSetList, setsInSetList.size());
		set_listRepo.save(set_list);
		
		// This then creates a setsOwnedList with the new set_list
		// and saves this to the database table setsOwnedLists
		SetsOwnedList setsOwnedList = new SetsOwnedList(set_list, account);
		setsOwnedListRepo.save(setsOwnedList);
		
		// This is used so the JSP page knows to inform the user that they have successfully created
		// an account and is added to redirectAttributes so it stays after the page redirect
		redirectAttributes.addFlashAttribute("accountCreated", true);
				
		// This redirects the user back to the index page
		return "redirect:/";
	}
	
	// This will sign a user into their account, as long as the entered details are valid
	@PostMapping("/login")
	public String login(@ModelAttribute Account account, BindingResult result, Model model, RedirectAttributes redirectAttributes) {
		// This creates an instance of the AccountValidator and calls the validateLogin function
		// with an Account generated using values entered in the login form. This function
		// then checks if there are any errors with the accounts details and if there are
		// adds these to the BindingResult result
		AccountValidator accountValidator = new AccountValidator(accountRepo);
		accountValidator.validateLogin(account, result);
		
		// This function will run if there are any errors returned by the AccountValidator class
		if (result.hasErrors()) {
			// This are used and added to the model so the JSP knows where the error occurs
			boolean emailValid = true;
			boolean passwordValid = true;
			boolean email_passwordValid = true;
			
			// This loop goes through all the errors comparing their error code with the certain
			// error codes, so that the boolean values can be updated to show there is an error
			// and adding this errors message to the model of that error code type 
			for (ObjectError error : result.getAllErrors()) {
				if (error.getCode().equals("email")) {
					emailValid = false;
					model.addAttribute("emailErrorMessage_Login", error.getDefaultMessage());
				}
				else if (error.getCode().equals("password")) {
					passwordValid = false;
					model.addAttribute("passwordErrorMessage_Login", error.getDefaultMessage());
				}
				else if (error.getCode().equals("email_password")) {
					email_passwordValid = false;
					model.addAttribute("email_passwordErrorMessage", error.getDefaultMessage());
				}
			}
			
			model.addAttribute("emailValid_Login", emailValid);
			model.addAttribute("passwordValid_Login", passwordValid);
			model.addAttribute("email_passwordValid", email_passwordValid);
			
			// This is used so that the index page knows that the login returned errors
			model.addAttribute("login_signUpErrors", "login");
			
			return "index";
		}
		
		// This is used so the JSP page knows to inform the user that they have been
		// logged in and is added to redirectAttributes so it stays after the page redirect
		redirectAttributes.addFlashAttribute("loggedIn", true);
		
		model.addAttribute("accountLoggedIn", account);
		
		// This gets a list of sets belong to the logged in user, and adds these to the model
		List<Set_list> set_lists = set_listRepo.findByAccount(account);
    	model.addAttribute("set_lists", set_lists);
		
		// This redirects the user back to the index page
		return "redirect:/";
	}
	
	// This logs the user out of their account and returns them to the index page
	@GetMapping("/logout")
	public String logout(SessionStatus status) {
		// This removes the Session attributes accountLogedIn, and Set_lists thus logging the user out of their account
		status.setComplete();
		
		// This redirects the user back to the index page
		return "redirect:/";
	}
	
	@GetMapping("/profile")
	public String viewProfile() {
		return "profile";
	}
}
