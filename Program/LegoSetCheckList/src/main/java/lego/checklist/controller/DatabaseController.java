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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lego.checklist.domain.Account;
import lego.checklist.domain.Piece;
import lego.checklist.domain.PieceFound;
import lego.checklist.domain.Set;
import lego.checklist.domain.SetInProgress;
import lego.checklist.domain.Set_list;
import lego.checklist.domain.SetsOwnedList;
import lego.checklist.repository.AccountRepository;
import lego.checklist.repository.PieceFoundRepository;
import lego.checklist.repository.SetInProgressRepository;
import lego.checklist.repository.SetInSetListRepository;
import lego.checklist.repository.Set_listRepository;
import lego.checklist.repository.SetsOwnedListRepository;
import lego.checklist.validator.AccountValidator;

@Controller
@SessionAttributes("accountLoggedIn")
public class DatabaseController {
	
	@Autowired
	private AccountRepository accountRepo;

	@Autowired
	private SetsOwnedListRepository setsOwnedListRepo;
	
	@Autowired
	private Set_listRepository set_listRepo;

	@Autowired
	private SetInSetListRepository setRepo;

	@Autowired
	private SetInProgressRepository setInProgessRepo;
	
	@Autowired
	private PieceFoundRepository pieceFoundRepo;
	
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
		List<Set> sets = new ArrayList<>();
		Set_list set_list = new Set_list(account, "Sets Owned List", sets);
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
		
		// This redirects the user back to the index page
		return "redirect:/";
	}
	
	// This logs the user out of their account and returns them to the index page
	@GetMapping("/logout")
	public String logout(SessionStatus status) {
		// This removs the the the Session attribute accountLogedIn thus logging the user out
		status.setComplete();
		
		// This redirects the user back to the index page
		return "redirect:/";
	}
	
	// This gets a set list and checks if it contains a Lego Set with the same set number,
	// if the list does contains the set it is added to the set list
	@PostMapping("/addSetToList/previousPage={previousPage}")
	public String addSetToList(@SessionAttribute(value = "accountLoggedIn", required = true) Account account, @SessionAttribute("searchURL") String searchURL, @PathVariable("previousPage") String previousPage, @RequestParam(required = true) int setListId, @RequestParam(required = true) String set_number, RestTemplate restTemplate, RedirectAttributes redirectAttributes) {
		
		// This gets a list of sets belong to the logged in user
		Set_list set_list = set_listRepo.findByAccountAndSetListId(account, setListId);
		
		// These are used so the JSP page knows the set and set list selected
		// and is added to redirectAttributes so it stays after the page redirect
		// so that the user can be informed that their set was added to which list
		// or to display that the set was not found
		redirectAttributes.addFlashAttribute("set_number", set_number);
		redirectAttributes.addFlashAttribute("set_list", set_list);
		
      	// This checks if the Lego set is already in the set list
		if (set_list.contains(set_number)) {
			// This is used so the JSP page knows to inform the user that there was an error adding the
			// Lego Set to a list and is added to redirectAttributes so it stays after the page redirect
			redirectAttributes.addFlashAttribute("setAddedError", true);
		}
		else {
			// This creates a Set that is added to the set_lists List of sets
        	Set set = new Set(set_number);
        	set_list.addSet(set);
        	
        	// This saves the Lego set to the database table SetsInSetList
        	setRepo.save(set);
        	
        	// This then saves the updated set_list to the database table SetLists
        	set_listRepo.save(set_list);
        	
        	// This is used so the JSP page knows to inform the user that they have added the Lego
        	// Set to a list and is added to redirectAttributes so it stays after the page redirect
        	redirectAttributes.addFlashAttribute("setAdded", true);
        }
		
		// These returns the user back to the page that the user called the controller from
		if (previousPage.equals("search")) {
			return "redirect:" + searchURL;
		}
		else {
			return "redirect:/set/?set_number=" + set_number;
		}
	}

	// This saves the progress on a set piece checklist to the database
	@PostMapping("/set/{set_number}/pieces/save")
	@ResponseBody
	public void saveChecklist(@SessionAttribute(value = "accountLoggedIn", required = true) Account account, @PathVariable String set_number, @SessionAttribute("set") Set set, @RequestParam("quantityChecked") List<Integer> quantityChecked, RedirectAttributes redirectAttributes) {
		// This gets all the pieces in a Lego Set
		List<Piece> piece_list = set.getPiece_list();
    	
    	// This updates the quantity checked for each piece in the Lego set
    	for (int i = 0; i < piece_list.size(); i++) {
    		Piece piece = piece_list.get(i);
    		piece.setQuantity_checked(quantityChecked.get(i));
    	}
    	
    	// This then creates a setsOwnedList with the new set_list
		// and saves this to the database table setsOwnedLists
    	SetInProgress setInProgress = new SetInProgress(account, set_number);
    	
    	// If the user already has saved the set to the database, this sets the set saved
    	// in the database table to setInProgress, and then deletes all the pieces saved
    	// in the database so that these can then be replaced with the new updated pieces
    	// Otherwise a new setInProgress is saved to the database
    	if (setInProgessRepo.findByAccountAndSetNumber(account, set_number) != null) {
    		setInProgress = setInProgessRepo.findByAccountAndSetNumber(account, set_number);
    		pieceFoundRepo.deleteBySetInProgress(setInProgress);
    	}
    	else {
	    	setInProgessRepo.save(setInProgress);
    	}
    	
    	// For each piece in the Lego set if its quantity is above zero, this adds a piece's number, colour name
		// and if its a spare as a line to the database with the setInProgress, as these values uniquely identity
    	// each Lego piece and which setInProgress they belong to and thus user
    	for (Piece piece : piece_list) {
    		if (piece.getQuantity_checked() != 0) {
    			PieceFound pieceFound = new PieceFound(setInProgress, piece.getNum(), piece.getColour_name(), piece.isSpare(), piece.getQuantity_checked());
    			pieceFoundRepo.save(pieceFound);
    		}
    	}
	}
}
